# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
- Implemented authentication screen stabilization (login, signup, reset password)
- Fixed ConsumerStatefulWidget build method override errors
- Fixed undefined PrimaryButton references (updated to FrinkelsButton)
- Fixed syntax errors in widget trees
- Fixed deprecated Supabase anonKey usage (changed to publishableKey)
- Fixed router redirect parameter issues
- Implemented home screen with:
  * Custom AppBar with universal search
  * Today's Summary with metric cards (People Available, Nearby Events, Active Jobs, New Pals Nearby, Trending Topics, Growing Communities, Recommended Professionals)
  * Weather widget with location, temperature, and conditions
  * Stories section with horizontal scrollable stories
  * Posts feed section with tabbed interface (All, Posts, Reels, Blogs, Memes)
  * Communities section with horizontal scrollable community cards
  * Jobs section with horizontal scrollable job listings
  * Businesses section with horizontal scrollable business listings
  * News section with horizontal scrollable news articles
- Applied 2026 Dark-Mode-First design system (glassmorphism, electric blue accents)
- Integrated flutter_animate for smooth animations
- Used CustomScrollView with slivers for efficient scrolling

### Changed
- Converted auth screens from ConsumerStatefulWidget to StatefulWidget + Consumer pattern
- Updated main.dart to use publishableKey instead of deprecated anonKey
- Updated app_router.dart to include home route and fix redirect logic

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- flutter analyze now passes with 0 issues
- flutter build bundle completes successfully

### Security
- N/A

## [0.1.0] - 2026-07-22
### Added
- Created PROJECT.md with initial vision and scope
- Created ROADMAP.md with initial planning
- Created DESIGN_SYSTEM.md with initial design guidelines
- Created ARCHITECTURE.md with initial system architecture
- Created FEATURES.md with initial feature list
- Created FIREBASE.md with Firebase integration guide
- Created MAPS.md with maps integration documentation
- Created AI_KITTU.md with AI/KITTU integration details
- Created UI_GUIDELINES.md with user interface guidelines
- Created DEVELOPMENT_RULES.md with development standards and practices
- Created this CHANGELOG.md file

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A