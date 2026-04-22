// rolodex-screens.jsx — Home / Present / Add / Onboarding, theme-aware

function themeColors(dark) {
  return dark ? {
    bg: '#000',
    bgGrad: 'radial-gradient(700px 500px at 50% 0%, rgba(255,200,150,0.04), transparent 60%), #000',
    fg: '#fff',
    muted: 'rgba(255,255,255,0.6)',
    mutedSoft: 'rgba(255,255,255,0.4)',
    border: 'rgba(255,255,255,0.06)',
    surface: 'rgba(255,255,255,0.06)',
    surfaceHi: 'rgba(255,255,255,0.1)',
    statusBar: true,
  } : {
    bg: '#F2F0EB',
    bgGrad: 'radial-gradient(700px 500px at 50% 0%, rgba(255,220,180,0.5), transparent 60%), #F2F0EB',
    fg: '#0A0A0B',
    muted: 'rgba(10,10,11,0.6)',
    mutedSoft: 'rgba(10,10,11,0.45)',
    border: 'rgba(10,10,11,0.08)',
    surface: 'rgba(10,10,11,0.04)',
    surfaceHi: 'rgba(10,10,11,0.08)',
    statusBar: false,
  };
}

function HomeScreen({ cards, activeIdx, setActiveIdx, onPresent, onAdd, onSettings, user, darkMode, setDarkMode }) {
  const t = themeColors(darkMode);
  return (
    <div style={{
      height: '100%', display: 'flex', flexDirection: 'column',
      position: 'relative', background: t.bgGrad,
    }}>
      <div style={{ position: 'absolute', top: 0, left: 0, right: 0, zIndex: 10 }}>
        <IOSStatusBar dark={t.statusBar}/>
      </div>

      <div style={{
        padding: '62px 22px 10px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <div style={{ minWidth: 0, flex: 1, paddingRight: 12 }}>
          <div style={{
            fontFamily: '"JetBrains Mono", ui-monospace, monospace',
            fontSize: 10, letterSpacing: 0.2, textTransform: 'uppercase',
            color: t.mutedSoft,
            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
          }}>Rolodex · {user.name}</div>
          <div style={{
            fontFamily: '"Instrument Serif", serif',
            fontSize: 36, letterSpacing: -0.01, lineHeight: 1, marginTop: 4, color: t.fg,
          }}>{cards.length} <em style={{ fontStyle: 'italic', color: t.mutedSoft }}>cards</em></div>
        </div>
        <div style={{ display: 'flex', gap: 8 }}>
          <CircleBtn t={t} onClick={() => setDarkMode(!darkMode)}>
            {darkMode ? (
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none">
                <path d="M20 14A8 8 0 119 3a7 7 0 0011 11z" stroke={t.fg} strokeWidth="1.6" strokeLinejoin="round"/>
              </svg>
            ) : (
              <svg viewBox="0 0 24 24" width="18" height="18" fill="none">
                <circle cx="12" cy="12" r="4" stroke={t.fg} strokeWidth="1.8"/>
                <path d="M12 3v2M12 19v2M3 12h2M19 12h2M5.6 5.6l1.4 1.4M17 17l1.4 1.4M5.6 18.4L7 17M17 7l1.4-1.4" stroke={t.fg} strokeWidth="1.6" strokeLinecap="round"/>
              </svg>
            )}
          </CircleBtn>
          <CircleBtn t={t} onClick={onSettings}>
            <svg viewBox="0 0 24 24" width="18" height="18" fill="none">
              <circle cx="5" cy="12" r="1.6" fill={t.fg}/>
              <circle cx="12" cy="12" r="1.6" fill={t.fg}/>
              <circle cx="19" cy="12" r="1.6" fill={t.fg}/>
            </svg>
          </CircleBtn>
          <CircleBtn t={t} onClick={onAdd}>
            <svg viewBox="0 0 24 24" width="20" height="20" fill="none">
              <path d="M12 5v14M5 12h14" stroke={t.fg} strokeWidth="2" strokeLinecap="round"/>
            </svg>
          </CircleBtn>
        </div>
      </div>

      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', marginTop: -20 }}>
        <CardStack cards={cards} activeIdx={activeIdx}
          onSelect={setActiveIdx} onPresent={onPresent} width={320} dark={darkMode}/>
      </div>

      <div style={{ padding: '0 22px 18px' }}>
        <div style={{
          display: 'flex', justifyContent: 'center', alignItems: 'center',
          gap: 6, marginBottom: 20,
        }}>
          {cards.map((c, i) => (
            <button key={c.id}
              onClick={() => setActiveIdx(i)}
              style={{
                width: i === activeIdx ? 28 : 6, height: 6, borderRadius: 4, border: 'none',
                background: i === activeIdx ? t.fg : t.surfaceHi,
                transition: 'all 0.35s cubic-bezier(0.2,0.9,0.3,1)',
                cursor: 'pointer', padding: 0,
              }}/>
          ))}
        </div>

        <div style={{ display: 'flex', gap: 10, marginBottom: 14 }}>
          <FooterTile t={t}
            icon={<svg viewBox="0 0 24 24" width="20" height="20" fill="none"><path d="M5 12h14M13 6l6 6-6 6" stroke={t.fg} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>}
            label="Present" sub="Full screen"
            onClick={() => onPresent(activeIdx)}/>
          <FooterTile t={t}
            icon={<svg viewBox="0 0 24 24" width="20" height="20" fill="none"><path d="M12 3v13M7 8l5-5 5 5M5 21h14" stroke={t.fg} strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/></svg>}
            label="Share" sub="AirDrop · vCard"/>
          <FooterTile t={t}
            icon={<svg viewBox="0 0 24 24" width="20" height="20" fill="none"><path d="M8 2v4M16 2v4M4 9h16M5 5h14a1 1 0 011 1v14a1 1 0 01-1 1H5a1 1 0 01-1-1V6a1 1 0 011-1z" stroke={t.fg} strokeWidth="1.6"/></svg>}
            label="Stats" sub={cards[activeIdx].scans + ' scans'}/>
        </div>

        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, letterSpacing: 0.15, textTransform: 'uppercase',
          color: t.mutedSoft, textAlign: 'center',
        }}>tap card to present · swipe · hold camera control</div>
      </div>
    </div>
  );
}

function CircleBtn({ children, onClick, t }) {
  return (
    <button onClick={onClick} style={{
      width: 38, height: 38, borderRadius: 19,
      background: t.surface, border: '1px solid ' + t.border,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      cursor: 'pointer', padding: 0,
    }}>{children}</button>
  );
}

function FooterTile({ icon, label, sub, onClick, t }) {
  return (
    <button onClick={onClick} style={{
      flex: 1, padding: '14px 12px', borderRadius: 16,
      background: t.surface, border: '1px solid ' + t.border,
      color: t.fg, cursor: 'pointer', textAlign: 'left',
      display: 'flex', flexDirection: 'column', gap: 6, fontFamily: 'inherit',
    }}>
      {icon}
      <div style={{ fontSize: 13, fontWeight: 600, marginTop: 8 }}>{label}</div>
      <div style={{
        fontFamily: '"JetBrains Mono", ui-monospace, monospace',
        fontSize: 9, letterSpacing: 0.15, textTransform: 'uppercase', color: t.mutedSoft,
      }}>{sub}</div>
    </button>
  );
}

// PRESENT — full-bleed branded screen, huge colored QR
function PresentScreen({ card, onClose, onPrev, onNext }) {
  const p = PLATFORMS[card.platform];
  const url = p.deepLink(card.handle);
  const displayHandle = (p.prefix || '') + card.handle;
  const onOpenApp = () => window.open(url, '_blank');
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 100,
      background: p.bg, color: p.text,
      display: 'flex', flexDirection: 'column',
      padding: '0 22px 30px',
    }}>
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(700px 400px at 80% -10%, rgba(255,255,255,0.2), transparent 60%)',
        mixBlendMode: 'overlay',
      }}/>

      <IOSStatusBar dark={p.text === '#fff'}/>

      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '14px 0', position: 'relative', zIndex: 2,
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 34, height: 34, borderRadius: 10,
            background: 'rgba(255,255,255,0.2)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            backdropFilter: 'blur(10px)',
          }}>
            <Logo kind={card.platform} size={20} color={p.text}/>
          </div>
          <div>
            <div style={{ fontSize: 11, opacity: 0.65, fontFamily: '"JetBrains Mono", ui-monospace, monospace', textTransform: 'uppercase', letterSpacing: 0.15 }}>Scan me</div>
            <div style={{ fontSize: 15, fontWeight: 600, fontFamily: p.handleFont }}>{p.name}</div>
          </div>
        </div>
        <button onClick={onClose} style={{
          width: 36, height: 36, borderRadius: 18, border: 'none',
          background: 'rgba(0,0,0,0.2)', color: p.text,
          display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
          backdropFilter: 'blur(10px)',
        }}>
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none">
            <path d="M6 6l12 12M18 6L6 18" stroke={p.text} strokeWidth="2" strokeLinecap="round"/>
          </svg>
        </button>
      </div>

      <div style={{ flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', position: 'relative', zIndex: 2 }}>
        <div style={{
          padding: 22, borderRadius: 32, background: '#fff',
          boxShadow: '0 30px 60px rgba(0,0,0,0.35), 0 0 0 1px rgba(0,0,0,0.04)',
        }}>
          <QRCanvas value={url} size={280} dark={p.qrColor} light="#ffffff" dots={true}
            centerLogo={<Logo kind={card.platform} size={280 * 0.15} color={p.qrColor}/>}
            centerColor="#fff"/>
        </div>
      </div>

      <div style={{ textAlign: 'center', position: 'relative', zIndex: 2 }}>
        <div style={{
          fontFamily: p.handleFont, fontWeight: p.handleWeight,
          fontSize: 38, lineHeight: 1, letterSpacing: -0.02, marginBottom: 6,
        }}>{displayHandle}</div>
        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, textTransform: 'uppercase', letterSpacing: 0.15, opacity: 0.65, marginBottom: 18,
        }}>{p.format(card.handle)}</div>

        <button onClick={onOpenApp} style={{
          width: '100%', padding: '14px 16px', borderRadius: 14, border: 'none',
          background: 'rgba(0,0,0,0.18)', color: p.text, cursor: 'pointer',
          fontSize: 15, fontWeight: 600, fontFamily: p.handleFont,
          backdropFilter: 'blur(10px)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
          marginBottom: 14,
        }}>
          Open in {p.name}
          <svg viewBox="0 0 24 24" width="14" height="14" fill="none">
            <path d="M7 17L17 7M9 7h8v8" stroke={p.text} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
          </svg>
        </button>

        <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 16 }}>
          <IconCircle onClick={onPrev} color={p.text}>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none"><path d="M15 6l-6 6 6 6" stroke={p.text} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
          </IconCircle>
          <div style={{
            fontFamily: '"JetBrains Mono", ui-monospace, monospace',
            fontSize: 11, opacity: 0.75, letterSpacing: 0.1,
          }}>{card.scans} scans</div>
          <IconCircle onClick={onNext} color={p.text}>
            <svg viewBox="0 0 24 24" width="14" height="14" fill="none"><path d="M9 6l6 6-6 6" stroke={p.text} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/></svg>
          </IconCircle>
        </div>
      </div>
    </div>
  );
}

function IconCircle({ children, onClick, color }) {
  return (
    <button onClick={onClick} style={{
      width: 40, height: 40, borderRadius: 20, border: 'none',
      background: 'rgba(0,0,0,0.15)', color,
      display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer',
      backdropFilter: 'blur(10px)',
    }}>{children}</button>
  );
}

function AddScreen({ onCancel, onSave, darkMode }) {
  const t = themeColors(darkMode);
  const [picked, setPicked] = React.useState(null);
  const [handle, setHandle] = React.useState('');
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 90, background: t.bg, color: t.fg,
      display: 'flex', flexDirection: 'column', paddingTop: 56,
    }}>
      <IOSStatusBar dark={t.statusBar}/>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '12px 20px' }}>
        <button onClick={onCancel} style={{ background: 'none', border: 'none', color: t.muted, fontSize: 15, cursor: 'pointer', padding: 0 }}>Cancel</button>
        <div style={{ fontSize: 15, fontWeight: 600 }}>New Card</div>
        <button disabled={!picked || !handle}
          onClick={() => onSave({ platform: picked, handle })}
          style={{
            background: 'none', border: 'none',
            color: (!picked || !handle) ? t.mutedSoft : t.fg,
            fontSize: 15, fontWeight: 600, cursor: 'pointer', padding: 0,
          }}>Add</button>
      </div>

      <div style={{
        fontFamily: '"Instrument Serif", serif', fontSize: 36, letterSpacing: -0.01,
        padding: '28px 22px 4px',
      }}>Pick a <em style={{ fontStyle: 'italic', color: t.mutedSoft }}>platform</em></div>
      <div style={{ padding: '0 22px 14px', fontSize: 13, color: t.muted }}>Your QR is generated live from a deep link — rename freely.</div>

      <div style={{
        flex: 1, overflow: 'auto', padding: '8px 16px',
        display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 10,
      }}>
        {Object.entries(PLATFORMS).map(([k, p]) => (
          <button key={k} onClick={() => setPicked(k)} style={{
            padding: 14, borderRadius: 16,
            background: picked === k ? p.solid : t.surface,
            border: picked === k ? '1px solid rgba(255,255,255,0.2)' : '1px solid ' + t.border,
            color: picked === k ? p.text : t.fg,
            cursor: 'pointer', display: 'flex', flexDirection: 'column', alignItems: 'flex-start', gap: 10,
            fontFamily: 'inherit', transition: 'all 0.2s',
          }}>
            <Logo kind={k} size={22} color={picked === k ? p.text : t.fg}/>
            <div style={{ fontSize: 12, fontWeight: 600, textAlign: 'left' }}>{p.name}</div>
          </button>
        ))}
      </div>

      {picked && (
        <div style={{ padding: '14px 22px 28px', borderTop: '1px solid ' + t.border }}>
          <div style={{
            fontFamily: '"JetBrains Mono", ui-monospace, monospace',
            fontSize: 10, letterSpacing: 0.15, textTransform: 'uppercase',
            color: t.mutedSoft, marginBottom: 8,
          }}>Handle</div>
          <input autoFocus value={handle} onChange={(e) => setHandle(e.target.value)}
            placeholder={PLATFORMS[picked].placeholder}
            style={{
              width: '100%', background: t.surface, border: '1px solid ' + t.border, color: t.fg,
              borderRadius: 12, padding: '12px 14px', fontSize: 16, fontFamily: 'inherit', outline: 'none',
            }}/>
          {handle && (
            <div style={{ marginTop: 10,
              fontFamily: '"JetBrains Mono", ui-monospace, monospace',
              fontSize: 11, color: t.muted,
            }}>→ {PLATFORMS[picked].format(handle)}</div>
          )}
        </div>
      )}
    </div>
  );
}

// Real iPhone Camera Control visual — side view of phone edge with the CC button
function CameraControlButton({ pressed = false }) {
  return (
    <div style={{
      position: 'relative', width: 280, height: 140,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
    }}>
      {/* phone body edge — horizontal slab */}
      <div style={{
        position: 'absolute', inset: '30px 0',
        borderRadius: 36,
        background: 'linear-gradient(180deg, #4a4a4c 0%, #2a2a2c 30%, #1a1a1c 70%, #3a3a3c 100%)',
        boxShadow: '0 30px 60px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.12), inset 0 -1px 0 rgba(0,0,0,0.4)',
      }}/>
      {/* glossy highlight strip */}
      <div style={{
        position: 'absolute', left: 16, right: 16, top: 34, height: 20,
        borderRadius: 20,
        background: 'linear-gradient(180deg, rgba(255,255,255,0.14) 0%, transparent 100%)',
        filter: 'blur(4px)', pointerEvents: 'none',
      }}/>

      {/* The Camera Control button — recessed oval with sapphire inset */}
      <div style={{
        position: 'relative', width: 90, height: 36, borderRadius: 18,
        background: pressed
          ? 'linear-gradient(180deg, #0a0a0c 0%, #1a1a1c 100%)'
          : 'linear-gradient(180deg, #151517 0%, #0a0a0c 45%, #1f1f21 100%)',
        boxShadow: pressed
          ? 'inset 0 3px 6px rgba(0,0,0,0.8), 0 0 0 1.5px rgba(255,255,255,0.04)'
          : 'inset 0 2px 4px rgba(0,0,0,0.8), inset 0 -1px 0 rgba(255,255,255,0.06), 0 0 0 1.5px rgba(255,255,255,0.04)',
        transition: 'all 0.2s',
      }}>
        {/* shutter glyph — a subtle circle */}
        <div style={{
          position: 'absolute', top: '50%', left: '50%', transform: 'translate(-50%, -50%)',
          width: 12, height: 12, borderRadius: 6,
          border: '1.5px solid rgba(255,255,255,0.3)',
          boxShadow: '0 0 8px rgba(255,180,100,0.15)',
        }}/>
        {/* shine on top edge */}
        <div style={{
          position: 'absolute', top: 1, left: 14, right: 14, height: 1,
          background: 'linear-gradient(90deg, transparent, rgba(255,255,255,0.25), transparent)',
        }}/>
      </div>

      {/* pulsing ring to indicate press */}
      {!pressed && (
        <>
          <div style={{
            position: 'absolute', width: 110, height: 54, borderRadius: 27,
            border: '1.5px solid rgba(255,200,150,0.35)',
            animation: 'ccpulse 2s ease-out infinite',
          }}/>
          <style>{`
            @keyframes ccpulse {
              0% { transform: scale(0.95); opacity: 1; }
              100% { transform: scale(1.5); opacity: 0; }
            }
          `}</style>
        </>
      )}
    </div>
  );
}

function OnboardingScreen({ onDone }) {
  const [step, setStep] = React.useState(0);
  const steps = [
    {
      eyebrow: 'Welcome',
      title: <>Your socials,<br/><em>one stack.</em></>,
      body: 'No more scrambling through 5 different apps. Everyone you meet, one swipe away.',
      visual: 'cards',
    },
    {
      eyebrow: 'The Rolodex Button',
      title: <>Squeeze<br/><em>Camera Control.</em></>,
      body: 'Assign Rolodex to your iPhone\u2019s Camera Control button. Squeeze anywhere — even on the lock screen — and your top card is ready.',
      visual: 'camera-control',
    },
    {
      eyebrow: 'Ready',
      title: <>Build your<br/><em>first cards.</em></>,
      body: 'Add Instagram, LinkedIn, WhatsApp — or all twelve. Each QR is generated live from a deep link, so usernames can change without rescreenshotting.',
      visual: 'cards',
    },
  ];
  const s = steps[step];
  return (
    <div style={{
      position: 'absolute', inset: 0, zIndex: 95, background: '#000',
      display: 'flex', flexDirection: 'column', padding: '56px 28px 40px', color: '#fff',
    }}>
      <IOSStatusBar dark={true}/>

      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', justifyContent: 'center' }}>
        {s.visual === 'camera-control' ? (
          <div style={{ marginBottom: 40 }}><CameraControlButton/></div>
        ) : (
          <div style={{
            width: 220, height: 220, margin: '0 auto 40px', position: 'relative',
          }}>
            {[
              { bg: 'linear-gradient(135deg, #515BD4 0%, #DD2A7B 60%, #F58529 100%)', kind: 'instagram', rot: -10, x: -24 },
              { bg: 'linear-gradient(165deg, #0A66C2 0%, #004182 100%)', kind: 'linkedin', rot: 0, x: 0 },
              { bg: 'linear-gradient(165deg, #25D366 0%, #128C7E 100%)', kind: 'whatsapp', rot: 12, x: 24 },
            ].map((c, i) => (
              <div key={i} style={{
                position: 'absolute', left: '50%', top: '50%',
                width: 140, height: 180, borderRadius: 20, background: c.bg,
                transform: `translate(-50%, -50%) translate(${c.x}px, ${i * -4}px) rotate(${c.rot}deg)`,
                boxShadow: '0 18px 40px rgba(0,0,0,0.4), 0 0 0 1px rgba(255,255,255,0.08)',
                display: 'flex', alignItems: 'flex-end', padding: 12, zIndex: 3 - Math.abs(i - 1),
              }}>
                <Logo kind={c.kind} size={26} color="#fff"/>
              </div>
            ))}
          </div>
        )}

        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, letterSpacing: 0.2, textTransform: 'uppercase',
          color: 'rgba(255,255,255,0.45)', textAlign: 'center', marginBottom: 14,
        }}>{s.eyebrow}</div>
        <div style={{
          fontFamily: '"Instrument Serif", serif',
          fontSize: 44, lineHeight: 1.05, letterSpacing: -0.015, textAlign: 'center',
        }}>{s.title}</div>
        <div style={{
          fontSize: 15, lineHeight: 1.5, color: 'rgba(255,255,255,0.65)',
          textAlign: 'center', maxWidth: 320, margin: '18px auto 0',
        }}>{s.body}</div>
      </div>

      <div>
        <div style={{ display: 'flex', justifyContent: 'center', gap: 6, marginBottom: 18 }}>
          {steps.map((_, i) => (
            <div key={i} style={{
              width: i === step ? 24 : 6, height: 6, borderRadius: 4,
              background: i === step ? '#fff' : 'rgba(255,255,255,0.18)',
              transition: 'all 0.35s',
            }}/>
          ))}
        </div>
        <button
          onClick={() => step < steps.length - 1 ? setStep(step + 1) : onDone()}
          style={{
            width: '100%', padding: 16, borderRadius: 16, border: 'none',
            background: '#fff', color: '#000', fontSize: 16, fontWeight: 600,
            cursor: 'pointer', fontFamily: 'inherit',
          }}>
          {step === 1 ? 'Assign Rolodex →' : step < steps.length - 1 ? 'Continue' : 'Get started'}
        </button>
        <button onClick={onDone} style={{
          width: '100%', padding: 12, background: 'none', border: 'none',
          color: 'rgba(255,255,255,0.5)', fontSize: 13, cursor: 'pointer', marginTop: 6,
        }}>{step < steps.length - 1 ? 'Skip' : ''}</button>
      </div>
    </div>
  );
}

Object.assign(window, { HomeScreen, PresentScreen, AddScreen, OnboardingScreen });
