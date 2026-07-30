# UI Guidelines

## Introduction
This document outlines the user interface guidelines for our application, ensuring consistency, usability, and accessibility across all platforms and devices. These guidelines are based on established design principles, platform conventions, and accessibility standards.

## Design Principles
1. **Clarity**: Interfaces should be clear, intuitive, and self-explanatory
2. **Consistency**: Similar elements should behave and appear consistently
3. **Feedback**: Provide immediate and clear feedback for user actions
4. **Efficiency**: Minimize user effort and reduce cognitive load
5. **Flexibility**: Adapt to different user needs, preferences, and contexts
6. **Aesthetic Integrity**: Visual design should be purposeful and not gratuitous
7. **User Control**: Users should feel in control of their interactions

## Platform-Specific Guidelines

### Web Applications
#### Layout & Structure
- **Grid System**: Use 12-column responsive grid with 24px gutter
- **Breakpoints**:
  - Mobile: < 640px
  - Tablet: 640px - 1023px
  - Desktop: ≥ 1024px
- **Margins & Padding**:
  - Outer margin: 24px on mobile, 48px on tablet/desktop
  - Inner padding: 16-24px depending on context
- **Max Content Width**: 1200px for optimal readability

#### Navigation
- **Primary Navigation**:
  - Horizontal header navigation for top-level sections
  - Sticky on scroll for easy access
  - Collapsible to hamburger menu on mobile
- **Secondary Navigation**:
  - Vertical sidebar for complex applications
  - Breadcrumb trails for hierarchical navigation
  - Tabs for switching between related views
- **Footer**:
  - Secondary links, legal information, social media
  - Newsletter signup (if applicable)

#### Interactive Elements
- **Buttons**:
  - Primary: Solid background with brand color
  - Secondary: Outline or text-based
  - Danger: Red background for destructive actions
  - Disabled: 40% opacity, cursor: not-allowed
  - Minimum size: 44x44px (touch target)
  - Corner radius: 4px (consistent across platform)
  - Hover/Focus states: Subtle elevation or color change
- **Form Controls**:
  - Input fields: 48px height, 16px horizontal padding
  - Label placement: Above input for mobile, left-aligned for desktop
  - Error state: Red border (#FF453A) with helper text below
  - Success state: Green border (#34C759) (optional)
  - Disabled state: Gray background (#F2F2F7), gray text
  - Font size: 16px minimum for readability
- **Select Menus**:
  - Consistent with input field styling
  - Dropdown arrow indicator
  - Options with adequate padding (12px vertical)
- **Checkboxes & Radio Buttons**:
  - Minimum 24x24px touch target
  - Clear visual distinction between checked/unchecked states
  - Label clickable to toggle state
- **Sliders**:
  - Minimum 44px height for touch ease
  - Clear thumb visual
  - Optional value display

#### Typography
- **Font Family**: System UI (with fallbacks: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif)
- **Type Scale**:
  - Display/Large Title: 36px/28px (mobile/desktop), 600 weight
  - Title 1: 28px/22px, 600 weight
  - Title 2: 22px/20px, 600 weight
  - Title 3: 20px/18px, 600 weight
  - Heading: 18px/17px, 600 weight
  - Body: 17px/16px, 400 weight
  - Callout: 17px/16px, 400 weight
  - Footnote: 13px, 400 weight
  - Caption: 12px, 400 weight
- **Line Height**: 1.5 for body text, 1.2-1.3 for headings
- **Letter Spacing**: -0.5px for display text, 0 for body
- **Text Alignment**: Left-aligned for readability, center for short headers

#### Color System
- **Primary Brand**: #0A84FF (iOS blue) or equivalent brand color
- **Secondary**: #5856D6 (purple) or brand secondary
- **Background**:
  - System Background: #FFFFFF (white) or #000000 (dark mode)
  - Secondary Background: #F2F2F7 (light gray) or #1C1C1E (dark)
  - Tertiary Background: #FFFFFF (white) or #2C2C2E (dark)
- **Labels**:
  - Label: #000000 (black) or #FFFFFF (white)
  - Secondary Label: #8E8E93 (gray) or #636366 (dark)
  - Tertiary Label: #AFACB4 (light gray) or #8E8E93 (dark)
- **Separators**: #C6C6C8 (light gray) or #38383A (dark)
- **System Colors**:
  - Red: #FF3B30 (error/destructive)
  - Green: #34C759 (success/affirmative)
  - Yellow: #FF9500 (warning)
  - Orange: #FF9F0A
  - Pink: #FF2D55
  - Purple: #AF52DE
  - Blue: #0A84FF
  - Teal: #5AC8FA
- **Opacity Layers**:
  - Overlay: 0 rgba(0,0,0,0.4) for modals
  - Disabled: 0.4 opacity for inactive elements

#### Icons & Images
- **Icon Style**: Line icons with 1.5-2px stroke weight, 24x24px baseline
- **Icon Sources**: SF Symbols (iOS), Material Icons (Android), or custom icon set
- **Image Treatment**:
  - Border radius: 8px for thumbnails, 12px for cards
  - Aspect ratios: 16:9 for video, 4:3 for photos, 1:1 for avatars
  - Placeholders: Blurred low-quality image placeholder (LQIP)
  - Loading states: Skeleton loaders or activity indicators
- **Accessibility**: Provide alt text for meaningful images

### Mobile Applications (iOS/Android)
#### Platform Conventions
- **iOS**:
  - Follow Human Interface Guidelines (HIG)
  - Use system fonts (San Francisco)
  - Adopt safe area considerations
  - Modal presentation styles (form sheet, page sheet, full screen)
  - Tab bar navigation for primary destinations (max 5 tabs)
  - Navigation bar with back button
- **Android**:
  - Follow Material Design guidelines
  - Use system fonts (Roboto)
  - Navigation drawer for top-level destinations
  - Bottom navigation for 3-5 destinations
  - Toolbar/app bar for actions and title
  - Floating Action Button (FAB) for primary action

#### Touch Targets & Spacing
- **Minimum Touch Target**: 48x48dp (Android), 44x44pt (iOS)
- **Recommended Touch Target**: 56x56dp/pt for frequently used actions
- **Spacing Between Elements**: Minimum 8dp/pt, preferred 12dp/pt
- **Edge Swipes**: Reserve for system gestures (navigation, control center)
- **Scroll Areas**: Ensure content is scrollable when needed

#### Navigation Patterns
- **Hierarchical**: Drill-down navigation for structured data
- **Flat**: Tab-based navigation for peer categories
- **Content-Driven**: Scrolling content with contextual actions
- **Modal**: Temporary views requiring user input or confirmation
- **Contextual**: Menus appearing from user touch point

#### Platform-Specific Components
- **iOS**:
  - Navigation Bar: Title, back button, optional actions
  - Toolbar: Contextual actions at bottom
  - Tab Bar: 4-5 primary destinations
  - Search Bar: Integrated in navigation bar
  - Segmented Control: For mutually exclusive options
  - Stepper: For incremental numeric input
  - Picker Wheel: For selecting from lists
  - Switch: For binary options
  - Slider: For continuous value selection
  - Activity Indicator: For loading states
  - Progress View: For determinate progress
  
- **Android**:
  - App Bar: Title, navigation icon, action items
  - Bottom Navigation: 3-5 primary destinations
  - Navigation Drawer: For additional destinations
  - Floating Action Button: Primary promoted action
  - Snackbar: Brief messages at bottom
  - Dialog: Modal interruptions
  - Menu: Overflow actions (three dots)
  - Chip: Compact input or choice elements
  - Bottom Sheet: From-bottom sheets for options or content
  - Progress Bar: Linear or circular indicators

### Desktop Applications
#### Window Management
- **Standard Controls**: Minimize, maximize, close (platform conventional placement)
- **Menu Bar**: Application-specific menus (File, Edit, View, etc.)
- **Toolbar**: Contextual actions below menu bar
- **Sidebar**: Navigation or supplementary information
- **Split Views**: Resizable panels for multi-view layouts
- **Dialogs**: Modal windows requiring user input
- **Popovers**: Transient windows pointing to source

#### Input Optimization
- **Keyboard Shortcuts**: Standard (Cmd/Ctrl+C/V/Z, etc.) and custom power-user shortcuts
- **Mouse Actions**: Click, double-click, right-click, hover effects
- **Touchpad/Gestures**: Scroll, zoom, swipe navigation where appropriate
- **Accessibility**: Full keyboard navigation, focus indicators

## Accessibility Guidelines
### WCAG 2.1 AA Compliance
#### Perceivable
1. **Text Alternatives**:
   - Provide alt text for all non-decorative images
   - Provide captions and transcripts for multimedia
   - Use ARIA labels for complex widgets
2. **Time-Based Media**:
   - Provide controls for audio/video playback
   - Avoid auto-playing audio >3 seconds
   - Provide sign language options for prerecorded video
3. **Adaptable**:
   - Ensure content can be presented in different ways without loss
   - Proper semantic markup (headings, lists, landmarks)
   - Meaningful sequence preserved when CSS disabled
4. **Distinguishable**:
   - Color contrast ratio ≥ 4.5:1 for normal text, 3:1 for large text
   - Text resizable up to 200% without loss of content/function
   - Images of text avoided (use actual text)
   - Audio controls provided for any auto-playing audio

#### Operable
1. **Keyboard Accessible**:
   - All functionality available via keyboard
   - No keyboard traps
   - Visible focus indicator (minimum 3:1 contrast)
   - Logical tab order
2. **Enough Time**:
   - Provide option to turn off, adjust, or extend time limits
   - Pause, stop, hide for moving/blinking/scrolling content
   - No content updates that cause distraction without user control
3. **Seizure Prevention**:
   - No content flashing >3 times per second
   - Red flash thresholds considered
4. **Navigable**:
   - Bypass blocks available (skip links)
   - Page titles descriptive and unique
   - Focus order meaningful and logical
   - Multiple ways to locate pages
   - Headings and labels descriptive
   - Focus visible on keyboard interface

#### Understandable
1. **Readable**:
   - Language of page identified
   - Unusual words, idioms, jargon explained
   - Abbreviations expanded on first use
2. **Predictable**:
   - Navigation mechanisms consistent across pages
   - Consistent identification of functional components
   - Change of context only on user request
3. **Input Assistance**:
   - Error identification clearly indicated
   - Labels or instructions provided when user input required
   - Error suggestions provided when known
   - Error prevention (legal, financial, data modifications)

#### Robust
1. **Compatible**:
   - Maximize compatibility with current and future user agents
   - Proper use of markup languages per specification
   - Name, role, value provided for all user interface components
   - Status messages conveyed to assistive technologies

### Specific Accessibility Practices
#### Visual Impairments
- **Screen Reader Support**:
  - Semantic HTML elements (header, nav, main, section, article, footer)
  - Proper heading hierarchy (h1-h6)
  - Label elements associated with form controls
  - ARIA labels for custom controls
  - Live regions for dynamic content updates
  - Skip navigation links
- **Color Usage**:
  - Never rely solely on color to convey information
  - Use patterns, textures, or labels in addition to color
  - Test with color blindness simulators (Deuteranopia, Protanopia, Tritanopia)
- **Visual Alternatives**:
  - Provide text alternatives for charts and graphs
  - Offer high contrast modes
  - Support user-defined stylesheets

#### Motor Impairments
- **Touch Target Size**: Minimum 44x44pt (iOS), 48x48dp (Android), 44x44px (web)
- **Spacing**: Adequate space between interactive elements
- **Gesture Alternatives**: Provide button alternatives for swipe gestures
- **Timing Adjustments**: Allow adjustment or disabling of time-based interactions
- **Motor Alternatives**: Support switch control, voice control, eye tracking

#### Hearing Impairments
- **Audio Alternatives**:
  - Captions for all video content
  - Transcripts for audio content
  - Visual indicators for audio cues
  - Volume controls independent of system volume
- **Communication Alternatives**:
  - Provide text-based alternatives for voice communication
  - Support TTY/TDD where applicable

#### Cognitive & Learning Disabilities
- **Clear Language**:
  - Use simple, concise language
  - Avoid jargon and idioms
  - Provide definitions for specialized terms
- **Consistent Navigation**:
  - Predictable layout and navigation
  - Consistent icons and terminology
  - Clear visual hierarchy
- **Reduced Cognitive Load**:
  - Break complex tasks into steps
  - Provide progress indicators
  - Minimize distractions
  - Offer ability to hide advanced options
- **Error Tolerance**:
  - Clear error messages with suggested fixes
  - Undo/redo capabilities
  - Confirmation dialogs for destructive actions
  - Input validation with helpful feedback

## Interaction Patterns
### Navigation
- **Hierarchical Navigation**:
  - Clear back navigation (back button, gesture)
  - Breadcrumbs for deep hierarchies
  - Visible indication of current location
- **Flat Navigation**:
  - Tab bars for primary destinations (mobile)
  - Sidebar navigation for secondary destinations
  - Consistent iconography and labeling
- **Contextual Navigation**:
  - Menu options relevant to current context
  - Long press or right-click for context menus
  - Toolbars that change based on selection
- **Search-Driven Navigation**:
  - Prominent search bar
  - Search suggestions and filtering
  - Voice search option where appropriate
  - Search history and saved searches

### Data Input
- **Forms**:
  - Logical grouping of related fields
  - Clear labels and instructions
  - Real-time validation where helpful
  - Progressive disclosure for complex forms
  - Auto-advance for logical field sequences
  - Save draft functionality for long forms
- **Selection Controls**:
  - Radio buttons for mutually exclusive options (2-5 options)
  - Checkboxes for multiple selections
  - Dropdowns for larger sets (>5 options)
  - Toggle switches for binary states
  - Segmented controls for related options (iOS)
- **Data-Specific Inputs**:
  - Date/time pickers (native controls preferred)
  - Number steppers for small ranges
  - Sliders for continuous ranges with imprecise values
  - Color pickers with visual feedback
  - File upload with drag-and-drop and preview
- **Error Prevention & Handling**:
  - Inline validation with clear messages
  - Prevent invalid submissions
  - Provide undo for destructive actions
  - Error summaries for long forms
  - Optional fields clearly marked

### Data Display
- **Lists & Tables**:
  - Clear column headers with sorting capability
  - Alternating row colors for readability
  - Row selection indicators
  - Bulk actions with clear selection
  - Empty states with guidance
  - Pagination or infinite scroll with clear indicators
- **Cards**:
  - Consistent sizing and spacing
  - Clear visual hierarchy (title, description, actions)
  - Touchable area clearly defined
  - Shadow/elevation to separate from background
  - Hover/press feedback
- **Grids**:
  - Consistent item sizing
  - Clear spacing between items
  - Loading states for asynchronous loading
  - Error states with retry options
- **Dashboards**:
  - Prioritize most important information
  - Use appropriate visualization types
  - Provide drill-down capability
  - Allow customization of widgets
  - Auto-refresh with manual override option
- **Notifications**:
  - Non-intrusive (toasts, banners, badges)
  - Persistent notification center
  - Clear dismissal options
  - Actionable notifications where appropriate
  - Granular user controls for notification types

### Feedback & Communication
- **Loading States**:
  - Skeleton loaders for content-heavy views
  - Spinners for immediate actions
  - Progress bars for determinate progress
  - Percentage text for long operations
  - Cancel option where appropriate
- **Success States**:
  - Subtle animations (checkmark, pop)
  - Temporary banners or toasts
  - Undo option for reversible actions
  - Confirmation of what was accomplished
- **Error States**:
  - Clear, human-readable error messages
  - Visual indicators (color, icon, inline)
  - Suggested solutions or next steps
  - Support contact information when appropriate
  - Distinction between user errors and system errors
- **Empty States**:
  - Educational content explaining purpose
  - Clear call-to-action to populate
  - Visual illustration or icon
  - Optional dismissal for permanent empty states
- **Onboarding & Tutorials**:
  - Optional, skippable tours
  - Contextual tooltips for feature discovery
  - Progressive disclosure of advanced features
  - Video or interactive tutorials for complex features
  - Welcome messages for first-time users

## Motion & Animation
### Principles
- **Purposeful**: Animation should serve a function (feedback, orientation, guidance)
- **Natural**: Follow physical principles (mass, velocity, friction)
- **Brief**: Typically 100-300ms for UI transitions
- **Consistent**: Similar actions use similar animations
- **Optional**: Respect reduced motion preferences

### Common Animations
- **Entrance/Exit**:
  - Fade: 0.1-0.3s ease-in-out
  - Slide: 0.2-0.4s ease-in-out (direction dependent)
  - Scale: 0.1-0.2s spring
- **State Changes**:
  - Toggle: 0.15-0.25s ease
  - Expand/Collapse: 0.2-0.35s ease-in-out
  - Refresh: 0.8-1.2s rotating spinner
- **Feedback**:
  - Button press: 0.05-0.1s scale down
  - Error shake: 0.4s horizontal oscillation
  - Success check: 0.2-0.3s draw + scale
- **Navigation**:
  - Push: 0.2-0.3s slide from side
  - Modal: 0.2-0.3s fade + scale up
  - Tab switch: Instant or 0.1s crossfade
- **List Operations**:
  - Insert: 0.2s fade + slide up
  - Remove: 0.2s fade + scale down
  - Reorder: 0.2s lift + move + settle

### Implementation Guidelines
- **CSS**:
  ```
  .transition-fast { transition: all 100ms ease; }
  .transition-medium { transition: all 200ms ease; }
  .transition-slow { transition: all 300ms ease; }
  .transition-slow-spring { transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1); }
  ```
- **JavaScript Frameworks**:
  - Use built-in transition systems (React Transition Group, Vue transitions)
  - Consider animation libraries (Framer Motion, GSAP) for complex animations
- **Performance**:
  - Use transform and opacity for GPU-accelerated animations
  - Avoid animating layout properties (width, height, top, left)
  - Use will-change property sparingly for known animations
  - Limit concurrent animations to maintain 60fps

## Component Library Guidelines
### Component Design
- **Atomic Approach**:
  - Atoms: Basic elements (buttons, inputs, icons)
  - Molecules: Groups of atoms working together (search form, date picker)
  - Organisms: Complex UI sections (header, product card, dashboard)
  - Templates: Page layouts arranging organisms
  - Pages: Specific instances with real content
- **Reusability**:
  - Design for multiple contexts and variations
  - Use props/parameters for customization
  - Avoid hardcoded values where flexibility needed
  - Clear documentation of intended use cases
- **Encapsulation**:
  - Isolated styles to prevent leakage
  - Clear public API (props, events, methods)
  - Internal state management encapsulated
  - Minimal dependencies on external state
- **Extensibility**:
  - Extension points for custom behavior
  - Theming capabilities through CSS variables or props
  - Slot-based content distribution where applicable
  - Clear extension documentation

### Component States
- **States to Consider**:
  - Default: Normal appearance
  - Hover: Mouse pointer over (web/desktop)
  - Focus: Keyboard focus or programmatic focus
  - Pressed/Active: During interaction
  - Disabled: Non-interactive version
  - Loading: Asynchronous operation in progress
  - Error: Validation or operation failed
  - Success: Operation completed successfully
  - Empty: No content to display
  - Partial: Some content loading or available
- **State Transitions**:
  - Clear visual progression between states
  - Consistent timing and easing
  - Priority ordering (disabled overrides others)
  - Mutually exclusive states handled appropriately

### Theming & Customization
- **Design Tokens**:
  - Colors: Primary, secondary, background, text, border, etc.
  - Typography: Font families, sizes, weights, line heights
  - Spacing: Margin, padding, gap values
  - Radius: Border radius values
  - Elevation: Shadow depths
  - Duration: Animation timing values
  - Easing: Animation curve functions
- **Theme Variations**:
  - Light/Dark modes
  - High contrast modes
  - Brand-specific color schemes
  - Seasonal or promotional themes
- **Implementation**:
  - CSS Custom Properties (variables) for web
  - Theme context/provider for React
  - Styled-components or Emotion for styled components
  - Platform-specific theming (iOS Appearance, Android Themes)

## Content & Messaging Guidelines
### Tone of Voice
- **Principles**:
  - Clear and concise
  - Friendly but professional
  - Empathetic and user-centered
  - Consistent with brand personality
- **Voice Characteristics**:
  - Approachable: Like a helpful colleague
  - Informative: Providing useful information without jargon
  - Reassuring: Reducing anxiety and uncertainty
  - Empowering: Encouraging user agency and success
- **Avoid**:
  - Technical jargon without explanation
  - Overly formal or legalistic language
  - Humor that may not translate or date poorly
  - Ambiguity or vagueness

### Microcopy Guidelines
- **Buttons**:
  - Action-oriented verbs: "Save", "Delete", "Send"
  - Specific to outcome: "Upload Photo", "Invite Team"
  - Avoid generic: "Submit", "OK" (unless contextually clear)
  - Maximum 2-3 words for clarity
- **Labels & Placeholders**:
  - Clear and descriptive
  - Sentence case (only first word capitalized)
  - Examples in parentheses when helpful: "john@example.com"
  - Avoid placeholder as sole label (use floating labels)
- **Error Messages**:
  - Explain what went wrong in plain language
  - Suggest how to fix it
  - Be polite and non-blaming
  - Specific to the field or action
  - Example: "Please enter a valid email address" instead of "Invalid input"
- **Success Messages**:
  - Confirm what was accomplished
  - Provide next steps if applicable
  - Keep brief and celebratory when appropriate
  - Example: "Your profile has been updated successfully"
- **Empty States**:
  - Explain purpose of the feature
  - Guide user to first action
  - Use encouraging tone
  - Example: "You haven't created any playlists yet. Tap '+' to get started!"
- **Tooltips & Help Text**:
  - Concise and directly relevant
  - Appear on demand (hover, focus, tap)
  - Avoid stating the obvious
  - Example: "Password must be at least 8 characters"

### Internationalization & Localization
- **Text Expansion**:
  - Design for up to 30% horizontal expansion
  - Consider vertical stacking for limited width spaces
  - Test with pseudo-localization and actual translations
- **Numerals & Formats**:
  - Use locale-specific number, date, time formats
  - Respect reading direction (LTR vs RTL)
  - Handle pluralization correctly (not just singular/plural)
- **Cultural Considerations**:
  - Avoid culture-specific idioms, metaphors, references
  - Consider color meanings in different cultures
  - Test date formats (MM/DD/YYYY vs DD/MM/YYYY)
  - Be aware of right-to-left layout requirements
- **Implementation**:
  - Use format-aware libraries (Intl.js, i18next)
  - Externalize all user-facing strings
  - Provide context for translators
  - Support dynamic content insertion safely

## Development & Implementation Guidelines
### HTML/CSS Best Practices (Web)
- **Semantic Markup**:
  - Use appropriate HTML5 elements (header, nav, main, section, article, footer, aside)
  - Proper heading hierarchy (h1-h6)
  - Lists for related items (ul, ol)
  - Tables for tabular data only
- **CSS Methodology**:
  - BEM (Block__Element--Modifier) or similar
  - CSS modules or scoped styles for components
  - Avoid !important unless absolutely necessary
  - Limit specificity to improve maintainability
- **Performance**:
  - Minimize and compress CSS/JS
  - Use critical CSS for above-the-fold content
  - Lazy load offscreen images and components
  - Use font-display: swap for web fonts
  - Optimize images (WebP, AVIF, appropriate compression)
- **Accessibility**:
  - Proper ARIA roles and properties when needed
  - Ensure keyboard navigability
  - Sufficient color contrast (use tools like axe, Lighthouse)
  - Logical tab index order
- **Responsive Design**:
  - Mobile-first approach
  - Fluid grids and flexible images
  - Media queries based on breakpoints
  - Test on actual devices and emulators
  - Consider touch vs mouse interactions

### Component-Specific Guidelines
#### Buttons
- **Variants**:
  - Primary: Solid background, brand color, white text
  - Secondary: Transparent background, border, text color
  - Tertiary: Text only (or with icon)
  - Danger: Red background for destructive actions
  - Link: Text styled as link (underlined on hover)
- **Sizes**:
  - Small: 32px height (icons only or compact UIs)
  - Default: 40-48px height
  - Large: 56px height (prominent actions)
  - Icon-only: 40x40px minimum touch target
- **States**:
  - Default, hover, focus, pressed, disabled, loading
  - Clear visual progression between states
- **Icons**:
  - Left-aligned for icon + text
  - Right-aligned for icons indicating movement (next, play)
  - Consistent icon size (usually 20x20px within button)
- **Implementation**:
  ```
  .button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 8px 16px;
    border-radius: 4px;
    font-weight: 600;
    cursor: pointer;
    transition: all 150ms ease;
  }
  .button:disabled {
    opacity: 0.4;
    cursor: not-allowed;
  }
  ```

#### Input Fields
- **Structure**:
  - Container with label, input, helper text, error message
  - Adequate padding and spacing
  - Clear visual separation between fields
- **States**:
  - Default: Neutral border
  - Focus: Primary color border (2px width) + subtle shadow
  - Error: Red border (#FF3B30) with error message below
  - Success: Green border (#34C759) (optional)
  - Disabled: Gray background (#F2F2F7), gray text
- **Sizes**:
  - Height: 44px minimum
  - Padding: 12px vertical, 16px horizontal
  - Font size: 16px minimum
- **Types**:
  - Text, email, password, number, tel, url, search
  - Each with appropriate keyboard type (mobile)
  - Password: Show/hide toggle button
  - Number: Step attributes where applicable
- **Validation**:
  - HTML5 validation attributes where supported
  - Custom validation with clear feedback
  - Avoid validation on blur only; consider real-time for helpful feedback
- **Implementation**:
  ```
  .input-group {
    margin-bottom: 16px;
  }
  .input-label {
    display: block;
    margin-bottom: 4px;
    font-weight: 600;
    font-size: 14px;
  }
  .input-field {
    width: 100%;
    padding: 12px 16px;
    border: 1px solid #D1D1D6;
    border-radius: 6px;
    font-size: 16px;
    transition: border-color 200ms ease;
  }
  .input-field:focus {
    outline: none;
    border-color: #007AFF;
    box-shadow: 0 0 0 3px rgba(0, 122, 255, 0.2);
  }
  .input-field.error {
    border-color: #FF3B30;
  }
  .input-help {
    font-size: 13px;
    color: #8E8E93;
    margin-top: 4px;
  }
  .input-error {
    font-size: 13px;
    color: #FF3B30;
    margin-top: 4px;
    display: block;
  }
  ```

#### Cards
- **Structure**:
  - Container with optional header, media, body, footer
  - Consistent padding and spacing
  - Clear visual hierarchy
- **Variants**:
  - Basic: Bordered or elevated container
  - Image: Featured image at top
  - Action: Buttons or links in footer
  - Interactive: Entire card clickable (with clear indication)
- **Spacing**:
  - Padding: 16-24px internal
  - Gap between elements: 8-12px
  - elevation/shadow: 0-2px for subtle lift
- **Responsiveness**:
  - Stack vertically on narrow screens
  - Adjust image aspect ratios as needed
  - Consider horizontal scrolling for card collections
- **Implementation**:
  ```
  .card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    overflow: hidden;
  }
  .card-header {
    padding: 16px 24px;
    border-bottom: 1px solid #E5E5EA;
  }
  .card-body {
    padding: 24px;
  }
  .card-footer {
    padding: 16px 24px;
    border-top: 1px solid #E5E5EA;
    display: flex;
    justify-content: space-between;
    align-items: center;
  }
  ```

#### Navigation
- **Top Navigation (Web/Desktop)**:
  - Fixed height (56-64px)
  - Brand/logo on left
  - Menu items spaced evenly or grouped
  - User avatar/actions on right
  - Responsive collapse to hamburger menu
- **Tab Navigation (Mobile/Web)**:
  - Fixed height (49-56px)
  - Icons with labels below (or alongside on wider screens)
  - Active state indicator (color change, underline, dot)
  - Maximum 5 destinations for thumb reach
- **Sidebar Navigation**:
  - Fixed width (240-300px) or collapsible
  - Section headers for grouping
  - Icons with text labels
  - Scrollable content if exceeds viewport
  - Indicators for badges/counts
- **Navigation Patterns**:
  - Hierarchical: Expand/collapse sections with chevrons
  - Breadcrumb: "Home > Category > Subcategory > Item"
  - Pagination: "Previous 1 2 3 4 5 Next"
  - Stepper: "Step 1 of 3" with visual progress
- **Implementation** (Tab Bar Example):
  ```
  .tab-bar {
    display: flex;
    height: 56px;
    border-top: 1px solid #E5E5EA;
    background: white;
  }
  .tab-button {
    flex: 1;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 4px;
    color: #8E8E93;
    text-decoration: none;
    font-size: 10px;
    transition: color 200ms ease;
  }
  .tab-button.active {
    color: #007AFF;
  }
  .tab-icon {
    width: 24px;
    height: 24px;
  }
  ```

## Testing & Validation
### Visual Testing
- **Pixel Comparison**:
  - Tools: Percy, Chromatic, Applitools
  - Baseline comparisons across browsers/devices
  - Threshold settings for acceptable differences
- **Layout Testing**:
  - Grid alignment verification
  - Consistent spacing and padding
  - Responsive breakpoints validation
  - Overflow and clipping checks
- **Component States**:
  - All visual states rendered correctly
  - State transitions smooth and complete
  - Edge cases (empty, error, loading) covered
- **Typography**:
  - Font rendering consistency
  - Line height and letter spacing preservation
  - Fallback font handling
  - Accessibility of text (contrast, size)

### Functional Testing
- **Interaction Testing**:
  - Click/tap targets functional
  - Keyboard navigation complete
  - Form validation and submission
  - Navigation and routing correctness
  - Drag-and-drop where applicable
- **State Management**:
  - State transitions triggered correctly
  - Data binding and synchronization
  - Error handling and recovery
  - Pending and loading states
- **Performance**:
  - Frame rate maintenance (60fps)
  - Load time under thresholds
  - Memory leak detection
  - Animation smoothness
- **Accessibility**:
  - Screen reader compatibility
  - Keyboard-only navigation
  - Color contrast verification
  - Focus indicator visibility
  - ARIA attribute correctness

### Usability Testing
- **Task-Based Testing**:
  - Clear success criteria for user tasks
  - Think-aloud protocol for qualitative feedback
  - Time-on-task measurements
  - Error rate tracking
- **Heuristic Evaluation**:
  - Visibility of system status
  - Match between system and real world
  - User control and freedom
  - Consistency and standards
  - Error prevention
  - Recognition rather than recall
  - Flexibility and efficiency of use
  - Aesthetic and minimalist design
  - Help users recognize, diagnose, recover from errors
  - Help and documentation
- **Accessibility Audits**:
  - Automated testing (axe, Lighthouse, WAVE)
  - Manual testing with assistive technologies
  - User testing with people of diverse abilities
  - Color blindness simulation
  - Keyboard-only navigation testing

## Maintenance & Evolution
### Design System Updates
- **Versioning**:
  - Semantic versioning (MAJOR.MINOR.PATCH)
  - Breaking changes require major version bump
  - Deprecation warnings for upcoming removals
  - Changelog for all changes
- **Deprecation Policy**:
  - Deprecate before removing (minimum one release cycle)
  - Provide migration guides
  - Offer automated migration tools where possible
  - Clearly mark deprecated components in documentation
- **Backward Compatibility**:
  - Prefer additive changes over breaking changes
  - Provide compatibility layers when major changes needed
  - Test upgrades from previous versions
  - Document compatibility matrix

### Contribution Guidelines
- **Design Contributions**:
  - Follow existing patterns and conventions
  - Provide usage examples and documentation
  - Include accessibility considerations from start
  - Match existing visual language and spacing
  - Write comprehensive unit and visual tests
- **Code Contributions**:
  - Follow established code style (ESLint, Prettier)
  - Write tests for new functionality
  - Ensure backward compatibility
  - Document public APIs and usage
  - Consider performance implications
- **Documentation Updates**:
  - Keep documentation in sync with implementation
  - Update examples when APIs change
  - Add troubleshooting sections for common issues
  - Version documentation alongside releases
- **Review Process**:
  - Design review for visual and UX consistency
  - Accessibility review for compliance
  - Performance review for impact
  - Security review for vulnerabilities
  - Code review for quality and adherence to standards

## Appendices
### A. Color Palette Reference
```
Primary:
  - #0A84FF (Blue)
  - #FF2D55 (Pink)
  - #FF9500 (Orange)
  - #FF3B30 (Red)
  - #34C759 (Green)
  - #5AC8FA (Teal)
  - #AF52DE (Purple)
  - #FF9F0A (Amber)
  - #FFCC00 (Yellow)

Secondary/Grayscale:
  - #000000 (Black)
  - #2C2C2E (Dark Gray)
  - #636366 (Medium Gray)
  - #8E8E93 (Light Gray)
  - #AEAEB2 (X-Light Gray)
  - #C7C7CC (XX-Light Gray)
  - #F2F2F7 (Light Background)
  - #FFFFFF (White)

Semantic:
  - Success: #34C759
  - Warning: #FF9500
  - Error: #FF3B30
  - Info: #0A84FF
```

### B. Typography Scale Reference
```
Text Styles:
  - Title 1: 36pt, 600 weight, 44pt line height
  - Title 2: 30pt, 600 weight, 36pt line height
  - Title 3: 28pt, 600 weight, 34pt line height
  - Heading: 22pt, 600 weight, 28pt line height
  - Title: 20pt, 600 weight, 26pt line height
  - Body: 17pt, 400 weight, 22pt line height
  - Callout: 17pt, 400 weight, 22pt line height
  - Footnote: 13pt, 400 weight, 18pt line height
  - Caption: 12pt, 400 weight, 16pt line height

Tracking:
  - Display: -0.5
  - Body: 0
```

### C. Iconography Guidelines
- **Style**: Line icons with 1.5-2px stroke weight
- **Grid**: 24x24px artboard with 2px padding
- **Corners**: 2px radius for rounded corners
- **Endpoints**: Round or square based on context
- **Consistency**: Similar weight and complexity across set
- **Export**: SVG optimized for web, PDF for print
- **Naming**: Verb-first, descriptive (e.g., "add-user", "settings-gear")

### D. Accessibility Resources
- **WCAG 2.1 Quick Reference**: https://www.w3.org/WAI/WCAG21/QuickRef/
- **WebAIM Contrast Checker**: https://webaim.org/resources/contrastchecker/
- **The A11y Project**: https://a11yproject.com/
- **Inclusive Design Principles**: https://inclusivedesignprinciples.org/
- **Material Design Accessibility**: https://material.io/design/usability/accessibility.html
- **Apple Accessibility**: https://developer.apple.com/accessibility/
- **Android Accessibility**: https://developer.android.com/guide/topics/ui/accessibility

### E. Tools & Resources
- **Design Tools**:
  - Figma: Component libraries, auto-layout, variants
  - Sketch: Symbols, nested symbols, libraries
  - Adobe XD: Component states, repeat grids
  - Storybook: Component documentation and testing
- **Development Tools**:
  - ESLint: Code quality and style enforcement
  - Prettier: Code formatting
  - Stylelint: CSS/SCSS linting
  - Jest: JavaScript testing
  - Cypress: End-to-end testing
  - Lighthouse: Performance, accessibility, SEO audits
- **Accessibility Tools**:
  - Axe Core: Automated accessibility testing
  - WAVE: Web accessibility evaluation tool
  - Colour Contrast Analyser: Desktop contrast tool
  - Screen Reader Testing: NVDA, JAWS, VoiceOver
- **Animation Tools**:
  - Framer Motion: React animation library
  - GSAP: High-performance JavaScript animation
  - Motion One: Tiny animation library
  - CSS Tricks: Animation guides and examples
- **Color Tools**:
  - Coolors: Color scheme generator
  - Adobe Color: Color wheel and harmony rules
  - Colorable: Contrast ratio checker
  - Stark: Contrast and blindness simulator (Figma plugin)
- **Font Resources**:
  - Google Fonts: Free, open-source fonts
  - Font Pair: Font combination suggestions
  - Type Scale: Visual typography scale calculator
  - Font Squirrel: Free commercial-use fonts

### F. Glossary of Terms
- **Accessibility (a11y)**: Design of products, devices, services, or environments for people with disabilities
- **Affordance**: Visual clue suggesting how an object should be used
- **Breakpoint**: Screen width at which layout changes
- **Breadcrumb**: Navigation aid showing user's location in hierarchy
- **Call to Action (CTA)**: Element encouraging user to take specific action
- **Dropdown**: List of options that appears when user interacts with control
- **Flat Design**: Minimalist design approach emphasizing usability
- **Gesture**: Touch-based interaction (tap, swipe, pinch, etc.)
- **Hamburger Menu**: Icon (☰) representing hidden navigation menu
- **Hover**: State when pointer is over element without clicking
- **Iconography**: System of symbols used to represent concepts
- **Information Architecture**: Structural design of shared information environments
- **Microcopy**: Small bits of text guiding users through interface
- **Modal**: Dialog box that requires user interaction to close
- **Navigation**: System enabling users to move through interface
- **Negative Space**: Empty space around and between design elements
- **Onboarding**: Process of introducing new users to product features
- **Prototype**: Preliminary model for testing concepts
- **Responsive Design**: Approach making web pages render well on various devices
- **Scrolling**: Moving content vertically or horizontally within viewport
- **Skeleton Screen**: Placeholder UI showing layout while content loads
- **Spacing**: Consistent use of padding and margin throughout interface
- **State**: Visual appearance of UI element based on interaction or data
- **Style Guide**: Document specifying design and usage standards
- **Touch Target**: Minimum area that responds to touch input
- **User Flow**: Path taken by typical user to accomplish task
- **Viewport**: Visible area of web page on device screen
- **Wireframe**: Basic visual guide representing skeletal framework
```

---
*Document Version: 1.0.0*
*Last Updated: $(date)*
*Maintained by: Design Systems Team*