# Design System

## Introduction
This document outlines our design system principles, guidelines, and components to ensure consistency, accessibility, and efficiency across our product.

## Design Principles
1. **Clarity**: Interfaces should be clear, intuitive, and self-explanatory
2. **Consistency**: Similar elements should behave and appear consistently
3. **Accessibility**: Design must be usable by people of all abilities
4. **Efficiency**: Minimize user effort and cognitive load
5. **Feedback**: Provide clear feedback for user actions
6. **Flexibility**: Adapt to different user needs and contexts

## Color Palette
### Primary Colors
- **Primary**: #HEXCODE (Usage: Main actions, primary buttons)
- **Primary Dark**: #HEXCODE (Usage: Hover states, active states)
- **Primary Light**: #HEXCODE (Usage: Backgrounds, subtle accents)

### Secondary Colors
- **Secondary**: #HEXCODE (Usage: Secondary actions, accents)
- **Secondary Dark**: #HEXCODE (Usage: Hover states, active states)
- **Secondary Light**: #HEXCODE (Usage: Backgrounds, subtle accents)

### Neutral Colors
- **Gray 50**: #HEXCODE (Usage: Very light backgrounds, borders)
- **Gray 100**: #HEXCODE (Usage: Light backgrounds, dividers)
- **Gray 200**: #HEXCODE (Usage: Medium backgrounds, input borders)
- **Gray 300**: #HEXCODE (Usage: Disabled elements, subtle text)
- **Gray 400**: #HEXCODE (Usage: Secondary text, icons)
- **Gray 500**: #HEXCODE (Usage: Primary text, body copy)
- **Gray 600**: #HEXCODE (Usage: Headers, important text)
- **Gray 700**: #HEXCODE (Usage: Dark text, emphasis)
- **Gray 800**: #HEXCODE (Usage: Very dark text, strong emphasis)
- **Gray 900**: #HEXCODE (Usage: Almost black, maximum emphasis)

### Semantic Colors
- **Success**: #HEXCODE (Usage: Success messages, validation)
- **Warning**: #HEXCODE (Usage: Warning messages, caution)
- **Error**: #HEXCCODE (Usage: Error messages, validation failures)
- **Info**: #HEXCODE (Usage: Informational messages, tips)

## Typography
### Font Family
- **Primary**: [Font Name] (e.g., 'Inter', 'Roboto', 'San Francisco')
- **Secondary**: [Font Name] (for code, mono-spaced content)
- **Fallback**: system-ui, sans-serif

### Type Scale
- **Display / Hero**: 
  - Size: 3rem (48px)
  - Weight: 600
  - Line Height: 1.2
  - Usage: Main page headers, marketing sections

- **Heading H1**:
  - Size: 2.25rem (36px)
  - Weight: 600
  - Line Height: 1.3
  - Usage: Page titles, section headers

- **Heading H2**:
  - Size: 1.875rem (30px)
  - Weight: 600
  - Line Height: 1.3
  - Usage: Section titles, card headers

- **Heading H3**:
  - Size: 1.5rem (24px)
  - Weight: 600
  - Line Height: 1.35
  - Usage: Subsection headings, card titles

- **Heading H4**:
  - Size: 1.25rem (20px)
  - Weight: 600
  - Line Height: 1.4
  - Usage: Subsection : Form sections, widget titles

- **Heading H5**:
  - Size: 1.125rem (18px)
  - Weight: 600
  - Line Height: 1.4
  - Usage: Small section headers

- **Heading H6**:
  - Size: 1rem (16px)
  - Weight: 600
  - Line Height: 1.5
  - Usage: Table headers, list headers

- **Body Large**:
  - Size: 1.125rem (18px)
  - Weight: 400
  - Line Height: 1.6
  - Usage: Blog posts, long-form content

- **Body**:
  - Size: 1rem (16px)
  - Weight: 400
  - Line Height: 1.6
  - Usage: Primary body text, form labels

- **Body Small**:
  - Size: 0.875rem (14px)
  - Weight: 400
  - Line Height: 1.5
  - Usage: Auxiliary text, captions

- **Label**:
  - Size: 0.75rem (12px)
  - Weight: 500
  - Letter Spacing: 0.5px
  - Text Transform: uppercase
  - Usage: Form labels, data labels

- **Caption**:
  - Size: 0.625rem (10px)
  - Weight: 400
  - Line Height: 1.4
  - Usage: Legal text, footnotes

### Font Weights
- Light: 300
- Regular: 400
- Medium: 500
- Semi-bold: 600
- Bold: 700
- Extra Bold: 800

## Spacing & Layout
### Base Unit
- 4px = 1 unit (foundation for all spacing)

### Spacing Scale
- **0**: 0px
- **1**: 4px
- **2**: 8px
- **3**: 12px
- **4**: 16px
- **5**: 20px
- **6**: 24px
- **7**: 28px
- **8**: 32px
- **9**: 36px
- **10**: 40px
- **12**: 48px
- **14**: 56px
- **16**: 64px
- **20**: 80px
- **24**: 96px
- **28**: 112px
- **32**: 128px

### Layout Grids
#### Container Widths
- **Extra Small**: 480px
- **Small**: 640px
- **Medium**: 768px
- **Large**: 1024px
- **Extra Large**: 1280px
- **Extra Extra Large**: 1440px

#### Column Systems
- **12-column grid** (standard for most layouts)
  - Gutter: 24px (6 units)
  - Column: Variable based on breakpoint
  
- **8-column grid** (for dashboards, complex layouts)
  - Gutter: 16px (4 units)
  - Column: Variable based on breakpoint

### Breakpoints
- **Mobile**: 0px - 639px
- **Tablet**: 640px - 1023px
- **Desktop**: 1024px - 1439px
- **Wide Desktop**: 1440px+

## Components
### Buttons
#### Primary Button
- Background: $primary
- Text: $white
- Padding: 12px 24px (3 units horizontal, 3 units vertical)
- Border Radius: 4px (1 unit)
- Font Weight: 600
- Font Size: 1rem (16px)
- Transition: all 0.2s ease
- Hover: background: $primary-dark
- Active: background: $primary-darker
- Disabled: background: $gray-300, cursor: not-allowed

#### Secondary Button
- Background: $white
- Text: $primary
- Border: 1px solid $primary
- Padding: 12px 24px
- Border Radius: 4px
- Font Weight: 600
- Font Size: 1rem
- Transition: all 0.2s ease
- Hover: background: $primary-light
- Active: background: $primary-lighter
- Disabled: border-color: $gray-300, color: $gray-400, cursor: not-allowed

#### Outline Button
- Background: transparent
- Text: $primary
- Border: 1px solid $primary
- Padding: 12px 24px
- Border Radius: 4px
- Font Weight: 600
- Font Size: 1rem
- Transition: all 0.2s ease
- Hover: background: $primary-light
- Active: background: $primary-lighter
- Disabled: border-color: $gray-300, color: $gray-400, cursor: not-allowed

#### Icon Button
- Width: 36px (9 units)
- Height: 36px (9 units)
- Background: transparent
- Border: none
- Padding: 0
- Border Radius: 50% (circle)
- Font Size: 1.25rem (20px)
- Color: $gray-600
- Transition: all 0.2s ease
- Hover: background: $gray-100, color: $gray-800
- Active: background: $gray-200
- Disabled: opacity: 0.5, cursor: not-allowed

### Input Fields
#### Text Input
- Height: 40px (10 units)
- Padding: 0 16px (0 horizontal, 4 units vertical)
- Border: 1px solid $gray-300
- Border Radius: 4px
- Font Size: 1rem (16px)
- Background: $white
- Transition: border-color 0.2s ease, box-shadow 0.2s ease
- Focus: border-color: $primary, box-shadow: 0 0 0 3px rgba($primary, 0.25)
- Error: border-color: $error
- Disabled: background: $gray-50, cursor: not-allowed

#### Textarea
- Min Height: 80px (20 units)
- Padding: 12px 16px (3 units vertical, 4 units horizontal)
- Border: 1px solid $gray-300
- Border Radius: 4px
- Font Size: 1rem (16px)
- Background: $white
- Resize: vertical
- Transition: border-color 0.2s ease, box-shadow 0.2s ease
- Focus: border-color: $primary, box-shadow: 0 0 0 3px rgba($primary, 0.25)
- Error: border-color: $error
- Disabled: background: $gray-50, cursor: not-allowed

#### Select Input
- Height: 40px (10 units)
- Padding: 0 16px 0 12px (0 top, 4 units right, 0 bottom, 3 units left)
- Border: 1px solid $gray-300
- Border Radius: 4px
- Font Size: 1rem (16px)
- Background: $white
- Appearance: none
- Background Image: [dropdown icon]
- Background Repeat: no-repeat
- Background Position: right 12px center
- Transition: border-color 0.2s ease, box-shadow 0.2s ease
- Focus: border-color: $primary, box-shadow: 0 0 0 3px rgba($primary, 0.25)
- Error: border-color: $error
- Disabled: background: $gray-50, cursor: not-allowed

### Cards
#### Basic Card
- Background: $white
- Border Radius: 8px (2 units)
- Box Shadow: 0 2px 4px rgba(0,0,0,0.05)
- Padding: 24px (6 units)
- Transition: box-shadow 0.2s ease
- Hover: box-shadow: 0 4px 8px rgba(0,0,0,0.1)

#### Elevated Card
- Background: $white
- Border Radius: 12px (3 units)
- Box Shadow: 0 4px 12px rgba(0,0,0,0.1)
- Padding: 32px (8 units)
- Transition: box-shadow 0.2s ease
- Hover: box-shadow: 0 8px 16px rgba(0,0,0,0.15)

#### Outline Card
- Border: 1px solid $gray-200
- Background: $white
- Border Radius: 8px (2 units)
- Padding: 24px (6 units)
- Transition: border-color 0.2s ease
- Hover: border-color: $primary

### Navigation
#### Top Navigation Bar
- Height: 56px (14 units)
- Background: $white
- Border Bottom: 1px solid $gray-200
- Display: flex
- Align Items: center
- Padding: 0 24px (0 vertical, 6 units horizontal)
- Position: sticky
- Top: 0
- Z-index: 1000

#### Side Navigation
- Width: 240px (60 units)
- Background: $white
- Border Right: 1px solid $gray-200
- Padding: 24px 0 (6 units vertical, 0 horizontal)
- Overflow-y: auto

#### Navigation Item
- Height: 40px (10 units)
- Padding: 0 16px (0 vertical, 4 units horizontal)
- Display: flex
- Align Items: center
- Border Radius: 4px
- Color: $gray-600
- Font Size: 0.875rem (14px)
- Font Weight: 500
- Transition: background-color 0.2s ease, color 0.2s ease
- Hover: background-color: $gray-100, color: $gray-800
- Active: background-color: $primary-light, color: $primary, font-weight: 600

### Alerts & Notifications
#### Alert Banner
- Padding: 12px 16px (3 units vertical, 4 units horizontal)
- Border Radius: 4px
- Display: flex
- Align Items: center
- Gap: 12px (3 units)
- Font Size: 0.875rem (14px)

##### Info Alert
- Background: $info-light
- Border: 1px solid $info
- Color: $info-dark

##### Success Alert
- Background: $success-light
- Border: 1px solid $success
- Color: $success-dark

##### Warning Alert
- Background: $warning-light
- Border: 1px solid $warning
- Color: $warning-dark

##### Error Alert
- Background: $error-light
- Border: 1px solid $error
- Color: $error-dark

#### Toast Notification
- Position: fixed
- Bottom: 24px (6 units)
- Right: 24px (6 units)
- Min Width: 280px (70 units)
- Padding: 16px 20px (4 units vertical, 5 units horizontal)
- Border Radius: 4px
- Box Shadow: 0 4px 12px rgba(0,0,0,0.15)
- Display: flex
- Align Items: center
- Gap: 12px (3 units)
- Z-index: 2000
- Animation: slide-in 0.3s ease-out, fade-out 0.3s ease-in forwards

### Modals & Dialogs
#### Modal Overlay
- Position: fixed
- Top: 0
- Left: 0
- Right: 0
- Bottom: 0
- Background: rgba(0,0,0,0.5)
- Display: flex
- Align Items: center
- Justify Content: center
- Z-index: 3000

#### Modal Container
- Background: $white
- Border Radius: 8px (2 units)
- Max Width: 90%
- Max Height: 90vh
- Width: 500px (125 units) - adjust based on content
- Overflow-y: auto
- Position: relative

#### Modal Header
- Padding: 20px 24px (5 units vertical, 6 units horizontal)
- Border Bottom: 1px solid $gray-200
- Display: flex
- Justify Content: space-between
- Align Items: center

#### Modal Title
- Font Size: 1.25rem (20px)
- Font Weight: 600
- Color: $gray-800

#### Modal Close Button
- Width: 24px (6 units)
- Height: 24px (6 units)
- Background: transparent
- Border: none
- Font Size: 1.25rem (20px)
- Color: $gray-400
- Cursor: pointer
- Transition: color 0.2s ease
- Hover: color: $gray-600

#### Modal Body
- Padding: 24px (6 units)
- Overflow-y: auto

#### Modal Footer
- Padding: 20px 24px (5 units vertical, 6 units horizontal)
- Border Top: 1px solid $gray-200
- Display: flex
- Justify Content: flex-end
- Gap: 12px (3 units)

## Icons
### Icon System
- We use [Icon Library Name, e.g., Font Awesome, Material Icons, custom SVG set]
- Icons should be consistent in style (line weight, fill vs outline)
- Standard size: 24px (6 units) for most UI elements
- Sizes: 16px (4 units), 20px (5 units), 24px (6 units), 32px (8 units), 40px (10 units), 48px (12 units)

### Icon Usage
- Navigation items: 20px (5 units)
- Buttons with text: 20px (5 units) before/after text
- Icon-only buttons: 24px (6 units) minimum touch target
- Form field icons: 18px-20px (4.5-5 units)
- Header/action icons: 24px-32px (6-8 units)

## Imagery & Illustration
### Photography Style
- **Tone**: [Describe: warm, professional, vibrant, etc.]
- **Lighting**: [Natural, studio, dramatic, etc.]
- **Composition**: [Rule of thirds, centered, environmental, etc.]
- **Subject Matter**: [People, products, environments, abstract, etc.]
- **Color Treatment**: [Natural, stylized, duotone, etc.]

### Illustration Style
- **Style**: [Flat, line art, isometric, 3D, hand-drawn, etc.]
- **Line Weight**: [Specify if applicable]
- **Color Palette**: [Derived from primary/secondary colors or specific palette]
- **Usage**: [Onboarding, empty states, blog posts, marketing, etc.]

### Iconography Style
- **Style**: [Outlined, filled, rounded, sharp, etc.]
- **Line Weight**: [Consistent stroke width]
- **Corner Radius**: [If applicable]
- **Grid**: [Specify grid system used for consistency]

## Motion & Animation
### Principles
- **Purposeful**: Animation should serve a function (feedback, orientation, guidance)
- **Natural**: Movements should follow physics principles (ease-in-out, arcs)
- **Brief**: Animations should be quick to avoid frustrating users (typically 100-300ms)
- **Consistent**: Similar actions should use similar animations

### Duration Guidelines
- **Micro-interactions**: 75-150ms (button presses, toggles)
- **Transitions**: 150-300ms (page changes, modal opens)
- **Complex motions**: 300-500ms (dashboard updates, data visualizations)
- **Departing elements**: 150-250ms (elements leaving the screen)

### Easing Functions
- **Standard**: cubic-bezier(0.25, 0.8, 0.25, 1) [ease-in-out]
- **Entrance**: cubic-bezier(0.4, 0, 0.2, 1) [ease-out]
- **Exit**: cubic-bezier(0.4, 0, 0.6, 1) [ease-in]
- **Attention**: cubic-bezier(0.4, 0, 0.6, 1) [pulse-like]
- **Bouncy**: cubic-bezier(0.68, -0.55, 0.265, 1.55) [for playful elements]

### Common Animations
#### Fade In/Out
```css
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes fade-out {
  from { opacity: 1; }
  to { opacity: 0; }
}
```

#### Slide Up/Down
```css
@keyframes slide-up {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}

@keyframes slide-down {
  from { transform: translateY(-20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}
```

#### Scale In/Out
```css
@keyframes scale-in {
  from { transform: scale(0.95); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

@keyframes scale-out {
  from { transform: scale(1); opacity: 1; }
  to { transform: scale(0.95); opacity: 0; }
}
```

## Accessibility
### Color Contrast
- **Text and background**: Minimum 4.5:1 ratio (AA), 7:1 for enhanced (AAA)
- **Large text**: Minimum 3:1 ratio (AA), 4.5:1 for enhanced (AAA)
- **UI components**: Minimum 3:1 ratio for active states and indicators
- **Placeholder text**: Minimum 3:1 ratio

### Typography Accessibility
- **Minimum font size**: 12px for body text (16px preferred for readability)
- **Line height**: Minimum 1.5 for body text
- **Letter spacing**: Normal to slightly increased for readability
- **Font weight**: Avoid light weights for body text below 14px

### Interactive Elements
- **Minimum touch target**: 44x44px (WCAG AA), 48x48px recommended
- **Keyboard navigation**: All interactive elements must be keyboard accessible
- **Focus indicators**: Visible focus outline with minimum 3:1 contrast
- **Skip links**: Provide mechanism to skip repetitive navigation

### Screen Reader Support
- **Semantic HTML**: Use appropriate elements (button, nav, header, etc.)
- **ARIA labels**: Provide descriptive labels when visual context isn't sufficient
- **Live regions**: Use for dynamic content updates
- **Landmarks**: Proper use of header, nav, main, footer, etc.

### Motion Sensitivity
- **Reduced motion**: Respect prefers-reduced-motion media query
- **Animation limits**: Non-essential animations should be disableable
- **Transition duration**: Keep animations under 5 seconds when possible

## Implementation Guidelines
### Development Practices
- **Component isolation**: Build components in isolation using Storybook or similar
- **Prop typing**: Use TypeScript PropTypes for component properties
- **Accessibility-first**: Build with accessibility considerations from the start
- **Performance**: Consider bundle size and render performance
- **Testing**: Unit tests for components, visual regression testing

### Usage Guidelines
- **Consistency**: Use design system components instead of custom implementations
- **Customization**: Extend through props/themes rather than forking components
- **Documentation**: Document any customizations or extensions
- **Feedback**: Report issues or suggest improvements through [channel]

### Theming
- **Light/Dark Mode**: Support both themes through CSS variables or theme context
- **Custom Brands**: Allow for brand-specific color overrides while maintaining structure
- **High Contrast**: Support for high contrast modes when needed

## Resources
- **Design Files**: [Link to Figma/Sketch/Adobe XD file]
- **Component Library**: [Link to Storybook or similar]
- **Style Guide**: [Link to living style guide]
- **Accessibility Guidelines**: [Link to accessibility resources]
- **Contributing**: [Guidelines for contributing to the design system]

## Version & Changelog
### Current Version: 1.0.0
### Last Updated: [Date]

#### v1.0.0 - [Date]
- Initial release of design system
- Core components: Buttons, Inputs, Cards, Navigation
- Basic typography and color system
- Foundation spacing and layout system

#### v1.1.0 - [Planned Date]
- [Planned features or improvements]