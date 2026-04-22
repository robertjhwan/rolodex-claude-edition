# Handoff: Rolodex by Rob — QR Code Organizer iOS App

## Overview

**Rolodex** is a personal-brand QR code organizer for networking events. The problem: pulling up your Instagram/LinkedIn/WhatsApp/etc. QR code takes 5–10 taps inside each app, the codes live in inconsistent places (profile, settings, menu), and screenshotting them to your lock screen looks janky. Rolodex stores all your social QR codes in one flip-through deck — tap, present, scan, next.

Key UX pillars:
1. **One-thumb present mode** — tap a card, it fills the screen with a branded QR + name.
2. **Branded QRs** — each QR uses the platform's brand color and a center logo badge (Instagram gradient, LinkedIn blue, etc.) so the code is *recognizable from 3 feet away*.
3. **iPhone Camera Control shortcut** — onboarding prompts the user to wire the iPhone 16 Camera Control button to launch the app, turning Rolodex into a one-squeeze physical action.
4. **No regeneration churn** — QRs point to deep-link URLs (`instagram.com/rob.wan`, `t.me/robwan`, etc.), so changing a username updates the target without regenerating a new code/screenshot.

## About the Design Files

The files in `source/` are **design references created in HTML/React/Babel** — prototypes showing intended look and behavior, not production code to ship directly. They use inline Babel transpilation, `window.*` globals between files, and placeholder QR renderings (styled dots — not scannable).

Your task is to **recreate these designs in a production environment**. Since the target is iOS-native-feeling with Camera Control integration, the recommended stack is:

- **SwiftUI (iOS 17+, deployment target iOS 18 for Camera Control API)** — best fit; only Swift can access the `AVCaptureEventInteraction` / Camera Control system shortcut.
- **Alternative: React Native + Expo** — viable, but Camera Control support requires a native module.
- **Fallback: Next.js PWA** — works if Camera Control is dropped; loses native keychain and share-sheet depth.

Pick SwiftUI unless the target repo dictates otherwise.

## Fidelity

**High-fidelity.** Colors, spacing, typography, and motion are final. Recreate pixel-perfectly with the target codebase's primitives (SwiftUI `View` + `.background()`/`.font()`, or equivalent). The HTML is the spec.

---

## Screens / Views

The prototype has 5 primary screens plus onboarding. All screens render inside an iPhone 16 Pro frame (393×852 pt viewport). The app supports **light** and **dark** mode; cards retain their brand colors in both.

### 1. Home — Card Deck

**Purpose:** User's rolodex — all QR cards visible as a vertically-scrollable stack. Tap a card to present it.

**Layout:**
- Full-screen scroll view inside iPhone safe area.
- Top bar (sticky): app name "Rolodex" (Instrument Serif, 28pt, weight 400) left-aligned, two icon buttons right-aligned (Sun/Moon theme toggle, + Add).
- Subtitle beneath title: "{N} cards · {totalScans} scans" in muted foreground, 13pt, system-ui.
- Below: a **stacked card list** — each card 340×108pt, rounded 22pt, 14pt vertical gap between cards.
- Bottom: safe-area padded footer with a pill-shaped "Present" button centered, opens the current/favorite card.

**Card row components:**
- Left: 48×48 rounded-square brand tile (the platform's `solid` color or `bg` gradient) containing the platform logo in white at ~60% of tile width.
- Middle: platform name (14pt semibold, muted) above handle (19pt, the platform's `handleFont` at `handleWeight`).
- Right: `scans` count in a subtle rounded pill + a star icon if `favorite: true` (filled gold #F5A623 if favorited).
- Long-press drags to reorder; swipe-left reveals delete.

### 2. Present (Full-Screen QR) ★ primary flow

**Purpose:** Show the QR code to a person standing in front of the user.

**Layout (top to bottom, full-bleed):**
- Background: the platform's `bg` (solid color or gradient from `rolodex-data.jsx`).
- Top-left: small "×" close button (44×44 hit target, translucent white circle on colored bg).
- Center-upper (~40% down): **white rounded QR card**, 280×280pt, 28pt corner radius, 24pt inner padding. Contains the styled QR code (see QR Rendering below).
- Below QR card: handle in platform `handleFont` at 34pt + `handleWeight`, color = `text` (usually white).
- Below handle: formatted URL (e.g. `t.me/robwan`) in all-caps 11pt letter-spacing 1.2pt, 60% opacity.
- Pill button: "Open in {Platform}" — translucent white on colored bg, 52pt tall, 100% width minus 24pt margins, 26pt corner radius, arrow-up-right icon inline right.
- Bottom: scan counter chip flanked by ‹ › prev/next buttons to flip through the deck without returning home.
- Home indicator respected (bottom 8pt safe-area).

**Interactions:**
- Swipe left/right on the whole screen → prev/next card (spring animation, 320ms).
- Tap "Open in X" → `UIApplication.open(deepLink)` (iOS) / `Linking.openURL` (RN).
- Tap the QR itself → haptic + scan counter increments.
- Pulling down on the QR dismisses to Home with a shared element transition (the QR scales into its home-card tile).

### 3. Add / Edit Card

**Purpose:** Pick a platform, enter a handle, see live QR preview.

**Layout:**
- Modal sheet presentation (iOS `.sheet`), `detents: .large`, 20pt drag handle at top.
- Platform picker: 3-column grid of 48pt branded tiles. Selected tile has a 3pt ring in accent.
- Text field (below grid): label is the current platform's `prefix` (e.g. `@`, `in/`, `$`), placeholder pulls from `platform.placeholder`. Font = platform's `handleFont`. Auto-strips the prefix on paste.
- Live preview: a miniature card below, updating as the user types.
- Save button: sticky-bottom, full-width, platform's `solid` color background.

### 4. Camera Control Onboarding

**Purpose:** Teach the user to bind Rolodex to the iPhone 16 Camera Control button, turning it into a "Rolodex Button."

**Layout:**
- Full-screen. Light gray/deep dark bg depending on theme.
- Hero: a **side-view iPhone illustration** showing the right edge with the recessed sapphire-inset Camera Control oval button. A soft "pulse" ring emanates from the button, animated 1.8s ease-in-out infinite.
- Headline: "Your new Rolodex button." — Instrument Serif italic 32pt, line-height 1.1.
- Body: "Press and hold the Camera Control button to open Rolodex instantly. No fumbling, no searching — just squeeze and share." — system-ui 16pt, 65% opacity.
- 3-step illustrated list ("Open Settings → Action Button → Shortcuts → Rolodex").
- Primary CTA: "Open Settings" → opens `prefs:root=ACTION_BUTTON` (iOS).
- Skip link below: "I'll do this later" — 13pt underlined.

### 5. Home (Dark Mode Variant)

Same layout as Home, but:
- Background: `#0A0A0B`
- Card rows: `#161618` base with 1pt border `rgba(255,255,255,0.06)`.
- Text: `#EDEDEF` primary, `#8A8A8E` secondary.
- Brand tiles retain full brand color.

---

## Interactions & Behavior

### Card Stack (Home)
- Tapping a card → navigate to Present view for that card, with a hero transition (card scales + expands to fill screen, 380ms spring).
- Long-press card → enter reorder mode; cards lift 4pt with shadow `0 12px 32px rgba(0,0,0,0.18)`.
- Swipe-left on card → reveal "Delete" + "Favorite" actions (iOS native swipe actions).
- Pull-to-refresh: does nothing (or reshuffles order based on scan count).

### Present Flip Animation
- Prev/next uses a **horizontal card flip** not a page swipe — 3D rotateY(180deg) with perspective 1200px, 420ms `cubic-bezier(0.2, 0.8, 0.2, 1)`. The card turns over, revealing the next platform's QR on the backside. This is the "rolodex" metaphor.

### Haptics (iOS)
- Card tap → `.light`
- Card flip → `.medium` at midpoint of flip
- Favorite toggle → `.rigid`
- QR shown (scan counter bump) → `.soft`

### Theme Toggle
- Home top-right button cycles: system → light → dark → system.
- Persist to `@AppStorage("theme")` / `UserDefaults`.

### Deep Linking
- Every platform has a `deepLink(handle)` function. The QR encodes this URL. The "Open in X" button also uses it. Examples:
  - Instagram: `https://instagram.com/rob.wan`
  - Telegram: `https://t.me/robwan`
  - WhatsApp: `https://wa.me/16477783778`
  - Cash App: `https://cash.app/$robwan`

iOS will automatically route known hosts to the installed app via Universal Links — no deep-link scheme customization needed.

### Camera Control Integration (iOS 18+)
- Use `AVCaptureEventInteraction` to listen for Camera Control press events.
- When the app is foregrounded via Camera Control, jump directly to Present view of the **favorite card with the highest scan count** (the "networking default").
- Register via `UIApplicationShortcutItem` as a fallback for non-16-Pro devices.

---

## State Management

### Persistent state (UserDefaults / SwiftData)
- `cards: [Card]` — user's QR cards. Each has:
  - `id: UUID`
  - `platform: PlatformKey` (enum: instagram, tiktok, twitter, linkedin, whatsapp, facebook, snapchat, discord, telegram, venmo, cashapp, website)
  - `handle: String`
  - `scans: Int`
  - `favorite: Bool`
  - `order: Int`
  - `createdAt: Date`
- `theme: "system" | "light" | "dark"`
- `hasSeenCameraControlOnboarding: Bool`

### Ephemeral state (view-local)
- `currentCardIndex: Int` (for Present view)
- `isEditing: Bool` (for reorder mode)
- `sheetPresented: Bool`

### Derived
- `favoriteCards` = `cards.filter(\.favorite).sorted(by: scans desc)`
- `totalScans` = `cards.map(\.scans).reduce(0, +)`

---

## Design Tokens

### Colors — Neutral

| Token | Light | Dark |
|---|---|---|
| `bg.primary` | `#FAFAFA` | `#0A0A0B` |
| `bg.secondary` | `#FFFFFF` | `#161618` |
| `fg.primary` | `#0A0A0B` | `#EDEDEF` |
| `fg.secondary` | `#6B6B70` | `#8A8A8E` |
| `fg.tertiary` | `#A1A1A6` | `#55555A` |
| `border` | `rgba(0,0,0,0.06)` | `rgba(255,255,255,0.06)` |
| `accent.favorite` | `#F5A623` | `#F5A623` |

### Colors — Platform Brand (source of truth: `source/rolodex-data.jsx`)

| Platform | `bg` | `solid` | `qrColor` | Text |
|---|---|---|---|---|
| Instagram | gradient `#515BD4 → #8134AF → #DD2A7B → #FEDA77 → #F58529` (135deg) | `#E1306C` | `#C13584` | white |
| TikTok | gradient `#010101 → #161616` (165deg) | `#000000` | `#FE2C55` | white |
| X | `#000000` | `#000000` | `#000000` | white |
| LinkedIn | gradient `#0A66C2 → #004182` (165deg) | `#0A66C2` | `#0A66C2` | white |
| WhatsApp | gradient `#25D366 → #128C7E` (165deg) | `#25D366` | `#128C7E` | white |
| Facebook | gradient `#1877F2 → #0a4db0` (165deg) | `#1877F2` | `#1877F2` | white |
| Snapchat | `#FFFC00` | `#FFFC00` | `#000000` | black |
| Discord | gradient `#5865F2 → #404ab8` (165deg) | `#5865F2` | `#5865F2` | white |
| Telegram | gradient `#2AABEE → #229ED9` (165deg) | `#229ED9` | `#229ED9` | white |
| Venmo | gradient `#3D95CE → #1e5e8a` (165deg) | `#3D95CE` | `#008CFF` | white |
| Cash App | `#00D632` | `#00D632` | `#00D632` | black |
| Website | gradient `#1a1a1a → #3a3a3a` (165deg) | `#1a1a1a` | `#1a1a1a` | white |

### Typography

Page-level UI chrome uses **SF Pro** (iOS system font; `.system`).

Display heading (app name, onboarding hero): **Instrument Serif** — available on Google Fonts, or bundle the TTF.

**Per-platform handle font** (applied only to the user's handle on each card, giving each card the visual DNA of that app):

| Platform | Font stack | Weight |
|---|---|---|
| Instagram | Instagram Sans → Rubik → Helvetica Neue | 700 |
| TikTok | TikTok Sans → Montserrat → Proxima Nova → Helvetica Neue | 700 |
| X | Chirp → Inter → Helvetica Neue | 700 |
| LinkedIn | Source Sans 3 → Helvetica Neue | 600 |
| WhatsApp | Helvetica Neue | 500 |
| Facebook | Facebook Sans → Inter → Helvetica Neue | 700 |
| Snapchat | Avenir Next → Helvetica Neue | 700 |
| Discord | gg sans → Noto Sans → Whitney → Helvetica Neue | 600 |
| Telegram | Roboto → Helvetica Neue | 500 |
| Venmo | Graphik → Figtree → Helvetica Neue | 600 |
| Cash App | Cash Sans → Manrope → Helvetica Neue | 700 |
| Website | Instrument Serif | 400 |

**Important:** Proprietary brand fonts (Instagram Sans, TikTok Sans, Chirp, Facebook Sans, gg sans, Graphik, Cash Sans) are licensed and cannot be shipped. Ship the Google Fonts fallback (Rubik, Montserrat, Inter, Noto Sans, Figtree, Manrope) and the system will substitute if the real font is present on the device (some are, e.g. SF Pro as a fallback satisfies many).

### Type scale

| Role | Size | Weight | Line height |
|---|---|---|---|
| Display / app title | 28pt | 400 (Instrument Serif) | 1.15 |
| Onboarding hero | 32pt | italic 400 | 1.1 |
| Handle on card (Home) | 19pt | (per platform) | 1.2 |
| Handle on Present | 34pt | (per platform) | 1.1 |
| Platform label | 14pt | 600 | 1.3 |
| Body | 16pt | 400 | 1.5 |
| Caption / URL | 13pt | 500 | 1.4 |
| Chip / counter | 11pt | 600, tracking 1.2pt, UPPERCASE | 1 |

### Spacing scale

`4, 8, 12, 16, 20, 24, 32, 44, 64` pt. Card gap on Home = 14pt. Screen edge padding = 20pt.

### Radii

- Card: 22pt
- Brand tile (48×48): 12pt
- QR card (Present): 28pt
- Pill button: `height/2` (full round)
- Chip: 10pt

### Shadows

- Card at rest (light mode): `0 2px 8px rgba(0,0,0,0.04), 0 1px 2px rgba(0,0,0,0.06)`
- Card lifted (reorder): `0 12px 32px rgba(0,0,0,0.18)`
- QR card on colored bg (Present): `0 8px 40px rgba(0,0,0,0.15)`
- Dark mode: replace rgba with `rgba(0,0,0,0.4)` + subtle 1pt top inner highlight `rgba(255,255,255,0.04)`

---

## QR Rendering

The QRs in the prototype are **decorative stand-ins** (styled dots arranged in a QR-like grid). In production you must generate real scannable QR codes.

**iOS:** `CIFilter.qrCodeGenerator()` → CIImage → apply custom rendering.

**Styling spec:**
- Encode the platform's `deepLink(handle)` URL.
- Error correction: **Quartile (Q, 25%)** — enough for a center logo overlay without breaking scans.
- Module shape: **circles** (not squares), diameter ≈ 85% of module size for visible gutters.
- Module color: platform's `qrColor`.
- Finder patterns (three corner eyes): **rounded squares**, outer size 7 modules, inner filled rounded square 3 modules. Outer stroke = `qrColor`, inner fill = `qrColor`, background = white.
- Center logo: platform logo in a 52×52pt white rounded square (12pt radius), with a 2pt border in `qrColor`, placed dead-center over the QR. Covers ~14% of QR area — safe for Q-level correction.
- Quiet zone: 4 modules on all sides, filled white.

**Reference implementation:** see `source/rolodex-qr.jsx` for the module/finder/logo composition (same logic, just reading real QR data instead of hardcoded patterns).

---

## Platform Logos

SVG logos for all 12 platforms are in `source/rolodex-logos.jsx`. They're hand-drawn simplifications rendering in a single color (white when on brand bg, brand color on white QR center). For production:

- **iOS:** use SF Symbols where they exist (`logo.whatsapp` does not — but `link` / custom Symbol packs do). Otherwise, export the SVGs in `rolodex-logos.jsx` to PDF and add as asset-catalog vector images.
- **Consider** using each platform's official branding guidelines / press-kit logos if app store review flags the simplified versions.

---

## Assets

| Asset | Source | Notes |
|---|---|---|
| Platform logos | `source/rolodex-logos.jsx` | Inline SVG; re-export for native |
| QR module graphics | Generated at runtime | Use `CoreImage` on iOS |
| iPhone side-view (onboarding) | `source/rolodex-screens.jsx` | Illustrated in SVG; consider replacing with Apple's official Camera Control imagery if available |
| Fonts | Google Fonts (fallbacks) | Bundle TTFs: Instrument Serif, Rubik, Montserrat, Inter, Source Sans 3, Noto Sans, Figtree, Manrope, Roboto |

---

## Feature Checklist (from user conversation)

Must-ship v1 (all present in the prototype):

- [x] Card deck home with all 12 platforms
- [x] Branded per-platform QR codes with center logo
- [x] Flip-card rolodex metaphor (subtle, modern) on Present
- [x] Deep-link URL strategy (no regeneration on handle change)
- [x] Per-card handle font matching each brand
- [x] Scan counter per card
- [x] Favorite / reorder
- [x] Dark mode + light mode
- [x] Camera Control onboarding flow
- [x] "Open in {App}" button on Present

Nice-to-haves for v1.1+ (scaffold, not implemented in prototype):

- [ ] AirDrop / share sheet export of a single card
- [ ] NFC tap-to-share
- [ ] vCard download
- [ ] Widget (lock-screen small widget with favorite QR)
- [ ] Live deep-link preview in Add/Edit flow

---

## Files

In `source/`:

| File | Purpose |
|---|---|
| `Rolodex.html` | Entry point, loads React + Babel + all jsx modules |
| `rolodex-app.jsx` | Top-level `<App/>`, theme state, screen routing |
| `rolodex-data.jsx` | **Source of truth** — platform metadata, colors, fonts, deep links, default cards |
| `rolodex-cards.jsx` | Home-screen card list + card row component |
| `rolodex-screens.jsx` | Home + Present + Add + Camera Control onboarding screens |
| `rolodex-qr.jsx` | Branded QR renderer (decorative; replace with CIFilter output) |
| `rolodex-logos.jsx` | SVG platform logos |
| `ios-frame.jsx` | iPhone bezel wrapper (prototype-only; drop in production) |

To preview the original: open `Rolodex.html` in a browser.

---

## Implementation Notes

1. **Start with `rolodex-data.jsx`.** Port it to Swift as an enum + associated values. Every other screen consumes this.
2. **Build Present view first.** It's the #1 use case ("I just met someone, show them my Insta"). Everything else is in service of that 2-second interaction.
3. **QR generation** — test every platform's deep link on a real device before shipping. Some (Venmo, Cash App) have quirks about which URL formats trigger in-app vs. web.
4. **Camera Control** requires iPhone 15 Pro / 16 / 16 Pro and iOS 18. Gate the onboarding behind `UIDevice` capability check; fall back to Shortcuts integration on older phones.
5. **Brand guidelines caveat:** Platforms like Instagram have rules about using their logo/name. This app stores *the user's own* QR codes — lower legal risk than third-party scanning apps — but review each platform's brand guidelines before App Store submission. Consider adding a small "Not affiliated with {Platform}" note in the About screen.
