// rolodex-cards.jsx — branded card with colored QR + center logo + platform font

function BrandCard({ card, platform, width = 340, height = 480, qrSize = 220, dark: isDark = true }) {
  const p = platform;
  const url = p.deepLink(card.handle);
  const displayHandle = (p.prefix || '') + card.handle;

  return (
    <div style={{
      width, height, borderRadius: 28,
      background: p.bg,
      color: p.text,
      position: 'relative',
      overflow: 'hidden',
      boxShadow: isDark
        ? '0 30px 60px rgba(0,0,0,0.5), 0 0 0 1px rgba(255,255,255,0.08), inset 0 1px 0 rgba(255,255,255,0.12)'
        : '0 20px 50px rgba(0,0,0,0.18), 0 0 0 1px rgba(0,0,0,0.04), inset 0 1px 0 rgba(255,255,255,0.15)',
      fontFamily: '-apple-system, system-ui',
    }}>
      <div style={{
        position: 'absolute', inset: 0, pointerEvents: 'none',
        background: 'radial-gradient(600px 400px at 80% -10%, rgba(255,255,255,0.18), transparent 60%)',
        mixBlendMode: 'overlay',
      }}/>

      {/* top — logo + name */}
      <div style={{
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
        padding: '22px 22px 0',
      }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
          <div style={{
            width: 34, height: 34, borderRadius: 9,
            background: 'rgba(255,255,255,0.22)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            backdropFilter: 'blur(10px)',
          }}>
            <Logo kind={card.platform} size={20} color={p.text}/>
          </div>
          <div style={{
            fontSize: 14, fontWeight: 600, letterSpacing: -0.1, opacity: 0.95,
            fontFamily: p.handleFont,
          }}>{p.name}</div>
        </div>
        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, letterSpacing: 0.1, opacity: 0.6, textTransform: 'uppercase',
        }}>#{String(Math.abs(hash(card.id)) % 9999).padStart(4, '0')}</div>
      </div>

      {/* QR — colored dots on white, center logo badge */}
      <div style={{
        position: 'absolute', left: '50%', top: '50%',
        transform: 'translate(-50%, -50%)',
        padding: 18, borderRadius: 26, background: '#fff',
        boxShadow: '0 10px 30px rgba(0,0,0,0.25), 0 0 0 1px rgba(0,0,0,0.04)',
      }}>
        <QRCanvas value={url} size={qrSize} dark={p.qrColor} light="#ffffff" dots={true}
          centerLogo={<Logo kind={card.platform} size={qrSize * 0.15} color={p.qrColor}/>}
          centerColor="#fff"/>
      </div>

      {/* bottom — handle in brand font */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        padding: '0 22px 22px',
      }}>
        <div style={{
          fontFamily: p.handleFont,
          fontWeight: p.handleWeight,
          fontSize: 26, letterSpacing: -0.02,
          lineHeight: 1.05, marginBottom: 5,
        }}>{displayHandle}</div>
        <div style={{
          fontFamily: '"JetBrains Mono", ui-monospace, monospace',
          fontSize: 10, letterSpacing: 0.12, opacity: 0.65, textTransform: 'uppercase',
        }}>{p.format(card.handle)}</div>
      </div>
    </div>
  );
}

function hash(s) {
  let h = 0; for (let i = 0; i < s.length; i++) h = ((h << 5) - h) + s.charCodeAt(i) | 0;
  return h;
}

function CardStack({ cards, activeIdx, onSelect, onPresent, width = 340, dark: isDark = true }) {
  const cardH = 480;
  const cardW = width;
  return (
    <div style={{
      position: 'relative', width: cardW, height: cardH + 40,
      perspective: 1600, margin: '0 auto',
    }}>
      {cards.map((c, i) => {
        const delta = i - activeIdx;
        const abs = Math.abs(delta);
        if (abs > 3) return null;
        const p = PLATFORMS[c.platform];
        const y = delta === 0 ? 0 : 10 + abs * 8;
        const scale = 1 - abs * 0.05;
        const rotateX = delta === 0 ? 0 : -delta * 2;
        const opacity = abs === 0 ? 1 : 1 - abs * 0.2;
        const z = 100 - abs;
        return (
          <div key={c.id}
            onClick={() => { if (delta === 0) onPresent(i); else onSelect(i); }}
            style={{
              position: 'absolute', left: 0, right: 0, top: y,
              display: 'flex', justifyContent: 'center',
              transform: `translateZ(${-abs * 30}px) scale(${scale}) rotateX(${rotateX}deg)`,
              transformOrigin: 'center top',
              opacity, zIndex: z,
              transition: 'transform 0.45s cubic-bezier(0.2,0.9,0.3,1), top 0.45s cubic-bezier(0.2,0.9,0.3,1), opacity 0.4s',
              cursor: 'pointer',
              filter: abs === 0 ? 'none' : `blur(${abs * 0.5}px)`,
            }}>
            <BrandCard card={c} platform={p} width={cardW} height={cardH} qrSize={210} dark={isDark}/>
          </div>
        );
      })}
    </div>
  );
}

Object.assign(window, { BrandCard, CardStack });
