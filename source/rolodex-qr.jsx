// rolodex-qr.jsx — colored/dotted QR with center logo badge, Instagram-style

function QRCanvas({ value, size = 240, dark = '#000', light = '#fff', dots = true, centerLogo = null, centerColor = '#fff' }) {
  const ref = React.useRef(null);
  React.useEffect(() => {
    if (!ref.current || !window.qrcode) return;
    const canvas = ref.current;
    const ctx = canvas.getContext('2d');
    const qr = window.qrcode(0, 'H');
    qr.addData(value || 'https://example.com');
    qr.make();
    const modules = qr.getModuleCount();
    const margin = 2;
    const totalModules = modules + margin * 2;
    const dpr = window.devicePixelRatio || 1;
    canvas.width = size * dpr;
    canvas.height = size * dpr;
    canvas.style.width = size + 'px';
    canvas.style.height = size + 'px';
    ctx.scale(dpr, dpr);
    const cell = size / totalModules;

    ctx.fillStyle = light;
    ctx.fillRect(0, 0, size, size);

    const centerPad = Math.floor(modules * 0.14);
    const cMid = modules / 2;

    const isFinder = (r, c) => (
      (r < 7 && c < 7) ||
      (r < 7 && c >= modules - 7) ||
      (r >= modules - 7 && c < 7)
    );

    const isCenter = (r, c) => (
      Math.abs(r - cMid + 0.5) < centerPad && Math.abs(c - cMid + 0.5) < centerPad
    );

    const drawFinder = (cx, cy) => {
      const x = (cx + margin) * cell;
      const y = (cy + margin) * cell;
      const size7 = 7 * cell;
      ctx.fillStyle = dark;
      roundRect(ctx, x, y, size7, size7, cell * 1.6);
      ctx.fill();
      ctx.fillStyle = light;
      roundRect(ctx, x + cell, y + cell, size7 - 2*cell, size7 - 2*cell, cell * 1.1);
      ctx.fill();
      ctx.fillStyle = dark;
      roundRect(ctx, x + 2*cell, y + 2*cell, size7 - 4*cell, size7 - 4*cell, cell * 0.7);
      ctx.fill();
    };

    ctx.fillStyle = dark;
    for (let r = 0; r < modules; r++) {
      for (let c = 0; c < modules; c++) {
        if (!qr.isDark(r, c)) continue;
        if (isFinder(r, c)) continue;
        if (isCenter(r, c)) continue;
        const x = (c + margin) * cell + cell / 2;
        const y = (r + margin) * cell + cell / 2;
        if (dots) {
          ctx.beginPath();
          ctx.arc(x, y, cell * 0.42, 0, Math.PI * 2);
          ctx.fill();
        } else {
          ctx.fillRect((c + margin) * cell, (r + margin) * cell, cell + 0.5, cell + 0.5);
        }
      }
    }

    drawFinder(0, 0);
    drawFinder(0, modules - 7);
    drawFinder(modules - 7, 0);
  }, [value, size, dark, light, dots]);

  const logoSize = size * 0.22;
  return (
    <div style={{ position: 'relative', width: size, height: size }}>
      <canvas ref={ref} style={{ width: size, height: size, display: 'block' }} />
      {centerLogo && (
        <div style={{
          position: 'absolute', left: '50%', top: '50%',
          transform: 'translate(-50%, -50%)',
          width: logoSize, height: logoSize,
          background: centerColor, borderRadius: logoSize * 0.24,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          padding: logoSize * 0.12, boxSizing: 'border-box',
        }}>
          {centerLogo}
        </div>
      )}
    </div>
  );
}

function roundRect(ctx, x, y, w, h, r) {
  ctx.beginPath();
  ctx.moveTo(x + r, y);
  ctx.lineTo(x + w - r, y);
  ctx.quadraticCurveTo(x + w, y, x + w, y + r);
  ctx.lineTo(x + w, y + h - r);
  ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
  ctx.lineTo(x + r, y + h);
  ctx.quadraticCurveTo(x, y + h, x, y + h - r);
  ctx.lineTo(x, y + r);
  ctx.quadraticCurveTo(x, y, x + r, y);
  ctx.closePath();
}

Object.assign(window, { QRCanvas });
