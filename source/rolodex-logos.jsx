// rolodex-logos.jsx — recognizable glyphs for each platform (original drawings)
// Kept simple/iconographic — not pixel reproductions of trademark assets.

function Logo({ kind, size = 24, color }) {
  const s = { width: size, height: size, display: 'block' };
  const c = color || 'currentColor';
  switch (kind) {
    case 'instagram':
      return (
        <svg viewBox="0 0 24 24" style={s} fill="none">
          <rect x="2.5" y="2.5" width="19" height="19" rx="5.5" stroke={c} strokeWidth="1.8"/>
          <circle cx="12" cy="12" r="4.5" stroke={c} strokeWidth="1.8"/>
          <circle cx="17.5" cy="6.5" r="1.2" fill={c}/>
        </svg>
      );
    case 'tiktok':
      return (
        <svg viewBox="0 0 24 24" style={s} fill="none">
          <path d="M14 3v11.5a3 3 0 11-3-3" stroke={c} strokeWidth="1.9" strokeLinecap="round" strokeLinejoin="round"/>
          <path d="M14 3c0 2.8 2.2 5 5 5" stroke={c} strokeWidth="1.9" strokeLinecap="round"/>
        </svg>
      );
    case 'twitter':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <path d="M17.5 3h3.2l-7 8 8.3 10h-6.5l-5-6.5L4.7 21H1.5l7.5-8.6L1 3h6.6l4.6 6zm-1.1 16h1.8L7.8 4.9H5.9z"/>
        </svg>
      );
    case 'linkedin':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <rect x="2" y="2" width="20" height="20" rx="3"/>
          <rect x="5" y="9" width="3" height="10" fill="#fff"/>
          <circle cx="6.5" cy="6" r="1.7" fill="#fff"/>
          <path d="M11 9h3v1.4c.6-.9 1.6-1.6 3-1.6 2.5 0 4 1.5 4 4.5V19h-3v-5c0-1.5-.6-2.3-1.8-2.3S14 12.5 14 14v5h-3V9z" fill="#fff"/>
        </svg>
      );
    case 'whatsapp':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <path d="M12 2a10 10 0 00-8.7 15l-1.3 5 5.1-1.3A10 10 0 1012 2zm5.3 14.3c-.2.6-1.3 1.2-1.8 1.2-.5.1-1.1.1-1.8-.1-.4-.1-.9-.3-1.6-.6a10.6 10.6 0 01-4.2-3.7c-.3-.5-1-1.3-1-2.5s.6-1.8.9-2c.2-.2.5-.3.7-.3h.5c.2 0 .4 0 .6.4l.9 2c.1.2.1.4 0 .6l-.3.5-.4.4c-.1.2-.3.3-.1.6.2.4.8 1.4 1.8 2.3 1.2 1 2.3 1.4 2.6 1.5.3.1.5 0 .6-.1l.9-1c.2-.2.3-.2.5-.1l1.9.9c.2.1.4.2.4.3 0 .1 0 .6-.1 1z"/>
        </svg>
      );
    case 'facebook':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <path d="M22 12a10 10 0 10-11.6 9.9v-7H7.9V12h2.5V9.8c0-2.5 1.5-3.9 3.8-3.9 1.1 0 2.2.2 2.2.2v2.5h-1.3c-1.2 0-1.6.8-1.6 1.6V12h2.8l-.5 2.9h-2.3v7A10 10 0 0022 12z"/>
        </svg>
      );
    case 'snapchat':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <path d="M12 2.5c3.5 0 5.5 2.8 5.6 6 0 .7 0 2.2-.1 2.6.3.1.8 0 1.3-.2.4-.2.8.2.7.6-.2.6-.6 1-1.6 1.3-.4.1-.7.2-.6.5.2.6 1.1 1.9 3 2.4.3.1.4.4.2.6-.4.7-2 1-2.7 1.2-.2 0-.4.3-.3.5l.2 1c0 .3-.2.5-.5.4-1-.1-2.2-.2-3.5.2-.9.3-1.8 1.7-3.7 1.7s-2.8-1.4-3.7-1.7c-1.3-.4-2.5-.3-3.5-.2-.3 0-.5-.2-.5-.4l.2-1c0-.2-.1-.4-.3-.5-.7-.2-2.3-.5-2.7-1.2-.1-.2 0-.5.3-.6 1.9-.5 2.8-1.8 3-2.4 0-.3-.2-.4-.6-.5-1-.3-1.4-.7-1.6-1.3-.1-.4.3-.8.7-.6.5.2 1 .3 1.3.2-.1-.4-.1-1.9-.1-2.6.1-3.2 2.1-6 5.6-6z"/>
        </svg>
      );
    case 'discord':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <path d="M19.8 5.3A18 18 0 0015.6 4l-.3.4c1.6.3 3 1 4.2 1.8a15.2 15.2 0 00-14.8 0c1.2-.8 2.6-1.5 4.2-1.8L8.6 4a18 18 0 00-4.2 1.3C1.6 9.5 1 13.6 1.3 17.7c1.7 1.3 3.4 2 5 2.5l.4-.5a10 10 0 01-3-1.5l.6-.4a12.7 12.7 0 0011.4 0l.6.4a10 10 0 01-3 1.5l.4.5c1.6-.5 3.3-1.2 5-2.5.4-4.7-.5-8.8-3.1-12.4zM8.5 15.4c-1 0-1.8-.9-1.8-2s.8-2 1.8-2c1 0 1.8.9 1.8 2s-.8 2-1.8 2zm7 0c-1 0-1.8-.9-1.8-2s.8-2 1.8-2c1 0 1.8.9 1.8 2s-.8 2-1.8 2z"/>
        </svg>
      );
    case 'telegram':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <circle cx="12" cy="12" r="10"/>
          <path d="M16.6 8.1l-1.7 8c-.1.6-.5.7-1 .4l-2.8-2-1.3 1.3c-.2.2-.3.3-.5.3l.2-2.7 5-4.5c.2-.2 0-.3-.3-.1l-6.2 3.9-2.6-.8c-.6-.2-.6-.6.1-.9l10.4-4c.5-.2.9.1.7.9z" fill="#fff"/>
        </svg>
      );
    case 'venmo':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <rect x="2" y="2" width="20" height="20" rx="3.5"/>
          <path d="M16.7 6c.5 1 .8 2 .8 3.2 0 3.7-3.1 8.5-5.6 11.8H7.1L5 7.3l4.5-.4 1 8.3c1.1-1.7 2.4-4.3 2.4-6.1 0-1-.2-1.6-.4-2.2L16.7 6z" fill="#fff"/>
        </svg>
      );
    case 'cashapp':
      return (
        <svg viewBox="0 0 24 24" style={s} fill={c}>
          <rect x="2" y="2" width="20" height="20" rx="5.5"/>
          <path d="M15.7 9c-.3-.3-.8-.3-1 0l-.6.6a.5.5 0 01-.7 0 3.7 3.7 0 00-2.7-1c-1.2 0-2 .5-2 1.3 0 .9.9 1.2 2.3 1.7 2 .6 3.6 1.4 3.6 3.4 0 2-1.5 3.2-3.6 3.5l-.1.9a.8.8 0 01-.8.7H9a.6.6 0 01-.6-.7l.2-1c-.8-.2-1.6-.5-2.3-1.1-.3-.3-.3-.8 0-1l.6-.6a.5.5 0 01.7 0c.8.8 1.8 1.2 3 1.2 1.2 0 2-.5 2-1.5s-.9-1.3-2.7-1.9c-1.5-.6-3.1-1.3-3.1-3.3 0-2 1.5-3 3.4-3.3l.1-.9c0-.4.4-.7.8-.7H12c.4 0 .7.3.6.7l-.2 1c.8.2 1.4.5 2 1 .3.3.4.8.1 1L14 9c-.3.3-.8.3-1.1 0z" fill="#fff"/>
        </svg>
      );
    case 'website':
      return (
        <svg viewBox="0 0 24 24" style={s} fill="none">
          <circle cx="12" cy="12" r="9" stroke={c} strokeWidth="1.8"/>
          <ellipse cx="12" cy="12" rx="4" ry="9" stroke={c} strokeWidth="1.8"/>
          <path d="M3 12h18" stroke={c} strokeWidth="1.8"/>
        </svg>
      );
    default:
      return <div style={{ width: size, height: size, borderRadius: 6, background: c }}/>;
  }
}

Object.assign(window, { Logo });
