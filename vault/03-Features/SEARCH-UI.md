# FRINKELs Search UI & UX Specification (`SEARCH_UI.md`)

This document defines the complete UI/UX design specification for the FRINKELs Search Experience.

---

## 🎨 UI Architecture & Screen Flow

```
┌───────────────────────────────────────────────────────────┐
│  [ 🔍 Search Users, Jobs, Communities, Posts... | 🎙️ ]   │  <- App Bar Header
├───────────────────────────────────────────────────────────┤
│ [ All ] [ People ] [ Jobs ] [ Businesses ] [ Communities ] │  <- Category Tabs Filter
├───────────────────────────────────────────────────────────┤
│                                                           │
│ 🕒 Recent Searches                    [ Clear All ]      │
│  • Flutter Developer (Remote)       [x]                   │
│  • Local Electrician                [x]                   │
│                                                           │
│ 🔥 Trending Searches                                      │
│  [ #Plumbing ] [ #AI Developers ] [ #Hyperlocal Jobs ]    │
│                                                           │
│ 💡 Recommended Professionals                              │
│  ┌─────────────────────────────────────────────────────┐  │
│  │ 👤 Satyam Panday  - Lead Flutter Architect         │  │
│  │ 📍 New Delhi, India • ★ 4.9                          │  │
│  └─────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────┘
```

---

## 🧩 Component Specifications

### 1. Header Search Input Bar
- **Glassmorphism Blur**: Backdrop blur `15px`, surface color `RGBA(255, 255, 255, 0.08)` (Dark Mode).
- **Search Icon**: Animated magnifying glass transitioning into back arrow on focus.
- **Voice Search Icon**: Micro-interaction pulsing microphone icon (`LucideIcons.mic`). Tapping opens Voice Search Overlay.
- **Debounce**: 300ms input debounce before dispatching network request.

### 2. Tabbed Category Selector
- Scrollable horizontal chip bar: `All`, `People`, `Posts`, `Communities`, `Businesses`, `Jobs`, `Stories`, `News`, `Chat`.
- Active tab pill: Dynamic gradient primary border (`#6366F1` to `#8B5CF6`).

### 3. Voice Search Modal Overlay
- Fullscreen translucent glass overlay with glowing audio wave visualizer (Lottie/Custom Painter).
- Realtime speech-to-text transcript rendering.
- Auto-submits search query after 1.5 seconds of silence.

### 4. Search Results Lists & Shimmers
- Tabbed results using custom result card widgets (`UserSearchTile`, `JobSearchTile`, `BusinessSearchTile`).
- Shimmer skeletons displayed during loading states.
- Empty states featuring contextual vector graphics ("No matching professionals found near you").
