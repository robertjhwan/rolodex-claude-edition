// rolodex-app.jsx — root app, wiring screens + Tweaks

function App() {
  const [cards, setCards] = React.useState(DEFAULT_CARDS);
  const [activeIdx, setActiveIdx] = React.useState(() => Number(localStorage.getItem('rlx.idx') || 1));
  const [view, setView] = React.useState(() => localStorage.getItem('rlx.view') || 'home');
  const [darkMode, setDarkMode] = React.useState(() => {
    const v = localStorage.getItem('rlx.dark'); return v === null ? true : v === '1';
  });
  const [tweaks, setTweaks] = React.useState(TWEAK_DEFAULTS);
  const [tweaksVisible, setTweaksVisible] = React.useState(false);
  const user = { name: 'Robert Wan' };

  React.useEffect(() => { localStorage.setItem('rlx.idx', String(activeIdx)); }, [activeIdx]);
  React.useEffect(() => { localStorage.setItem('rlx.view', view); }, [view]);
  React.useEffect(() => { localStorage.setItem('rlx.dark', darkMode ? '1' : '0'); }, [darkMode]);

  // Tweaks protocol
  React.useEffect(() => {
    const handler = (e) => {
      if (e.data?.type === '__activate_edit_mode') setTweaksVisible(true);
      if (e.data?.type === '__deactivate_edit_mode') setTweaksVisible(false);
    };
    window.addEventListener('message', handler);
    window.parent.postMessage({ type: '__edit_mode_available' }, '*');
    return () => window.removeEventListener('message', handler);
  }, []);

  const updateTweak = (key, value) => {
    const next = { ...tweaks, [key]: value };
    setTweaks(next);
    window.parent.postMessage({ type: '__edit_mode_set_keys', edits: { [key]: value } }, '*');
  };

  const sortedCards = React.useMemo(() => {
    if (tweaks.sort === 'favorites') {
      return [...cards].sort((a, b) => (b.favorite ? 1 : 0) - (a.favorite ? 1 : 0));
    }
    if (tweaks.sort === 'scans') {
      return [...cards].sort((a, b) => b.scans - a.scans);
    }
    return cards;
  }, [cards, tweaks.sort]);

  const go = (v) => setView(v);
  const present = (i) => { setActiveIdx(i); setView('present'); };

  const activeCard = sortedCards[activeIdx] || sortedCards[0];

  return (
    <div className="stage">
      {/* left — hero copy */}
      <div className="intro">
        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 11, letterSpacing: 0.2, textTransform: 'uppercase',
          color: 'rgba(255,255,255,0.45)', marginBottom: 18,
        }}>Rolodex · by Rob · v0.1 prototype</div>
        <h1 className="hero">Every handle,<br/><em>one swipe.</em></h1>
        <p>A native iPhone rolodex for the QR codes you actually hand out — Instagram, LinkedIn, WhatsApp, Venmo. Generated from live deep links, so when your handle changes, the code doesn’t.</p>
        <p>Hold Camera Control. The right card is already there.</p>
        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, letterSpacing: 0.15, textTransform: 'uppercase',
          color: 'rgba(255,255,255,0.3)', marginTop: 32,
        }}>
          TRY IT → tap a card to present · + to add · swipe dots to browse<br/>
          ───────<br/>
          <button onClick={() => setView('onboarding')} style={{
            background: 'none', border: '1px solid rgba(255,255,255,0.15)',
            color: 'rgba(255,255,255,0.7)', padding: '8px 14px', borderRadius: 20,
            fontFamily: 'inherit', fontSize: 10, letterSpacing: 0.15, textTransform: 'uppercase',
            cursor: 'pointer', marginTop: 16,
          }}>Replay onboarding</button>
        </div>
      </div>

      {/* right — device */}
      <div className="device-wrap">
        <div style={{
          width: 402, height: 874, borderRadius: 48,
          position: 'relative', overflow: 'hidden',
          background: darkMode ? '#000' : '#F2F0EB',
          boxShadow: darkMode
            ? '0 40px 80px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.08)'
            : '0 40px 80px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.08)',
        }}>
          {/* dynamic island */}
          <div style={{
            position: 'absolute', top: 11, left: '50%', transform: 'translateX(-50%)',
            width: 126, height: 37, borderRadius: 24, background: '#000', zIndex: 50,
          }}/>
          {view === 'home' && (
            <HomeScreen cards={sortedCards} activeIdx={activeIdx}
              setActiveIdx={setActiveIdx}
              onPresent={present}
              onAdd={() => go('add')}
              onSettings={() => go('onboarding')}
              user={user}
              darkMode={darkMode} setDarkMode={setDarkMode}/>
          )}
          {view === 'present' && activeCard && (
            <PresentScreen card={activeCard}
              onClose={() => go('home')}
              onPrev={() => setActiveIdx((activeIdx - 1 + sortedCards.length) % sortedCards.length)}
              onNext={() => setActiveIdx((activeIdx + 1) % sortedCards.length)}/>
          )}
          {view === 'add' && (
            <AddScreen onCancel={() => go('home')} darkMode={darkMode}
              onSave={({ platform, handle }) => {
                setCards([...cards, { id: 'c' + Date.now(), platform, handle, scans: 0, favorite: false }]);
                go('home');
              }}/>
          )}
          {view === 'onboarding' && (
            <OnboardingScreen onDone={() => go('home')}/>
          )}

          {/* home indicator */}
          <div style={{
            position: 'absolute', bottom: 0, left: 0, right: 0, zIndex: 200,
            height: 34, display: 'flex', justifyContent: 'center', alignItems: 'flex-end',
            paddingBottom: 8, pointerEvents: 'none',
          }}>
            <div style={{ width: 139, height: 5, borderRadius: 100, background: darkMode ? 'rgba(255,255,255,0.7)' : 'rgba(0,0,0,0.3)' }}/>
          </div>
        </div>
        <div className="caption">iPhone 16 Pro · {view.toUpperCase()}</div>
      </div>

      {/* Tweaks */}
      <div id="tweaks" style={{ display: tweaksVisible ? 'block' : 'none' }}>
        <h3>Tweaks</h3>
        <div className="row">
          <label>Theme</label>
          <select value={darkMode ? 'dark' : 'light'} onChange={e => setDarkMode(e.target.value === 'dark')}>
            <option value="dark">Dark</option>
            <option value="light">Light</option>
          </select>
        </div>
        <div className="row">
          <label>Screen</label>
          <select value={view} onChange={e => setView(e.target.value)}>
            <option value="home">Home · stack</option>
            <option value="present">Present</option>
            <option value="add">Add card</option>
            <option value="onboarding">Onboarding</option>
          </select>
        </div>
        <div className="row">
          <label>Sort</label>
          <select value={tweaks.sort} onChange={e => updateTweak('sort', e.target.value)}>
            <option value="manual">Manual</option>
            <option value="favorites">Favorites first</option>
            <option value="scans">Most scanned</option>
          </select>
        </div>
        <div className="row">
          <label>Active card</label>
          <select value={activeIdx} onChange={e => setActiveIdx(Number(e.target.value))}>
            {sortedCards.map((c, i) => (
              <option key={c.id} value={i}>{PLATFORMS[c.platform].name} — @{c.handle.slice(0,14)}</option>
            ))}
          </select>
        </div>
        <div style={{
          marginTop: 12, padding: 10, borderRadius: 10,
          background: 'rgba(255,255,255,0.04)', fontSize: 11, color: 'rgba(255,255,255,0.55)',
          lineHeight: 1.5,
        }}>
          Tap a card on the stack to present it. The handle drives a live deep link → QR, so renaming doesn’t break the code.
        </div>
      </div>
    </div>
  );
}

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "sort": "manual"
}/*EDITMODE-END*/;

ReactDOM.createRoot(document.getElementById('root')).render(<App/>);
