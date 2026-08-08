# FRINKELs Design System Specification V2 (`DESIGN_SYSTEM_V2.md`)
**Architected by**: Design System Engineering & UX Taskforce  
**Design Influences**: Apple iOS 18, Nothing OS Dot-Matrix & Monochrome, Telegram Fluid Motion, Discord Dark Aesthetics, Linear Sharp Precision, Notion Clean Typography, Material 3 Expressive Tokens.

---

## 🎨 1. Design Tokens & Core Primitives

### Color Tokens (Dark Mode First + Light Mode)
- **Background Base**: Dark `#090A0F` | Light `#F8FAFC`
- **Surface Elevation 1 (Card)**: Dark `RGBA(255, 255, 255, 0.04)` | Light `RGBA(0, 0, 0, 0.02)`
- **Surface Elevation 2 (Modal/Sheet)**: Dark `RGBA(255, 255, 255, 0.08)` | Light `RGBA(0, 0, 0, 0.05)`
- **Brand Primary Accent (Linear Gradient)**: `LinearGradient(from #6366F1 to #8B5CF6)` (Indigo to Electric Violet)
- **Brand Secondary Accent (Nothing Red)**: `#D71921` (High emphasis status/action)
- **Text Primary**: Dark `#F8FAFC` (95% Opacity) | Light `#0F172A` (90% Opacity)
- **Text Secondary**: Dark `#94A3B8` (60% Opacity) | Light `#64748B` (60% Opacity)
- **Border Outline**: Dark `RGBA(255, 255, 255, 0.12)` | Light `RGBA(0, 0, 0, 0.08)`

---

## 📐 2. Spacing, Radius & Glassmorphism Tokens

### Spacing Scale
- `space_2xs`: 4 dp
- `space_xs`: 8 dp
- `space_sm`: 12 dp
- `space_md`: 16 dp (Standard Padding)
- `space_lg`: 24 dp
- `space_xl`: 32 dp
- `space_2xl`: 48 dp

### Corner Radius Scale (Apple & Nothing Curved Aesthetics)
- `radius_xs`: 6 dp (Tag pills, small badges)
- `radius_sm`: 12 dp (Buttons, input fields)
- `radius_md`: 18 dp (Cards, list tiles)
- `radius_lg`: 28 dp (Bottom sheets, modals)
- `radius_full`: 9999 dp (Circular avatars)

### Glassmorphism Tokens
- **Backdrop Blur Sigma**: `15.0` (Glassmorphic panels)
- **Glass Border Stroke**: `1.0 dp` solid `RGBA(255, 255, 255, 0.15)`
- **Glass Shimmer Highlight**: Subtle top-left to bottom-right linear gradient highlight.

---

## 🔤 3. Typography System (Google Fonts: Inter & Outfit)

- **Display Large**: Outfit Bold, 34 sp, Line Height 40 sp, Letter Spacing -0.5 sp
- **Headline Medium**: Outfit SemiBold, 22 sp, Line Height 28 sp
- **Body Large**: Inter Regular, 16 sp, Line Height 24 sp
- **Body Medium**: Inter Regular, 14 sp, Line Height 20 sp
- **Caption**: Inter Medium, 12 sp, Line Height 16 sp, Letter Spacing +0.2 sp

---

## 📱 4. Component UI Specifications

### Buttons
- **Primary Action Button**: Full-width, `height: 52 dp`, `radius: 14 dp`, primary gradient fill (`#6366F1` -> `#8B5CF6`), subtle drop shadow (`blur: 16`, `offset: (0, 4)`), scale feedback on press (`0.97`).
- **Secondary Glass Button**: Translucent background (`RGBA(255, 255, 255, 0.08)`), 1dp glass border.

### Cards & List Items
- `radius: 20 dp`, surface elevation 1 background, padded with `16 dp`.
- Micro-interaction: Scale down on touch down (`scale: 0.98`), spring elasticity curve (`cubic-bezier(0.175, 0.885, 0.32, 1.275)`).

### Bottom Sheets & Dialogs
- Top rounded corners `radius: 28 dp`, background backdrop blur `25.0`, top drag handle indicator (`40x4 dp`, rounded, `30%` opacity).

### Navigation Bars
- Floating glassmorphic bottom navigation bar with integrated blur. Active icon highlights with micro-scale pulse animation.

### Lottie Micro-Animation Guidelines
- Use Lottie for state feedback (e.g. dynamic success checkmark, voice search wave, empty inbox, pull-to-refresh spinner). Keep JSON payload sizes under 50 KB.
