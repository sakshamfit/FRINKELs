# Vault Map - Navigation Guide for AI Assistant

## Purpose
This map helps the AI assistant navigate the FRINKELS knowledge base efficiently by understanding the structure and where to find specific types of information.

## Core Directories

### 00-Index - Master Navigation
- `MASTER-INDEX.md` - Primary knowledge graph navigation hub
- `FEATURE-INDEX.md` - Overview of all features and their status
- `API-INDEX.md` - API documentation references
- `ARCHITECTURE-INDEX.md` - Architecture specifications
- `README.md` - Getting started guide

### 01-Product - Product Vision & Planning
- `FEATURES-OVERVIEW.md` - High-level feature descriptions
- `PRODUCT-VISION.md` - Long-term product goals and vision
- `ROADMAP.md` - Planned features and timelines

### 02-Architecture - Technical Specifications
- `CLEAN-ARCHITECTURE.md` - Architecture layers and boundaries
- `DESIGN-SYSTEM-V2.md` - UI design tokens, glassmorphism, typography
- `STATE-MANAGEMENT.md` - Riverpod patterns and practices
- `UI-GUIDELINES.md` - Component usage and styling guidelines

### 03-Features - Detailed Feature Documentation
Each feature gets its own detailed specification:
- `AUTHENTICATION.md` - Auth flow, providers, security
- `COMMUNITIES.md` - Community creation, management, interactions
- `CHAT-MESSAGING.md` - Real-time messaging, notifications
- `HOME-FEED.md` - Feed algorithms, post types, engagement
- `JOBS-MARKETPLACE.md` - Job listings, applications, hiring
- `LOCAL-BUSINESS.md` - Business profiles, local services
- `NEARBY-DISCOVERY.md` - Location-based features, maps
- `NOTIFICATIONS.md` - Push notifications, in-app alerts
- `POSTS-CREATION.md` - Content creation tools, editors
- `PREMIUM-TIER.md` - Subscription models, paid features
- `STORIES-SUBSYSTEM.md` - Story creation, viewing, interactions
- `USER-SETTINGS.md` - Profile management, preferences
- `CALENDAR-INTEGRATION.md` - Events, scheduling, reminders
- `EVENTS-SUBSYSTEM.md` - Event creation, ticketing, attendance
- `PAYMENT-SYSTEM.md` - Transactions, subscriptions, invoicing
- `ADMIN-DASHBOARD.md` - Admin controls, analytics, moderation
- `HIRING-SUBSYSTEM.md` - Recruitment workflows, candidate tracking
- `AI-KITTU-ASSISTANT.md` - AI features, conversational abilities
- `AI-KITTU-DETAILED.md` - Technical implementation of AI systems

### 04-Backend - Infrastructure & Services
- `FIREBASE-INTEGRATION.md` - Firebase service usage and configuration
- `SECURITY-REPORT.md` - Security audits, vulnerability assessments

### 05-Development - Development Guidelines
- Coding standards, best practices, setup instructions

### 06-Operations - Deployment & Maintenance
- Deployment procedures, monitoring, incident response

### 07-Meeting-Notes - Meeting Records & Decisions
- Timestamped meeting notes with action items

### 08-AIOS - AI Operating System
- `AIOS/Index.md` - Main AIOS index and navigation
- `AIOS/Skill Map.md` - Reference for what AI skills exist and when to use them
- `AIOS/me.md` - Personal preferences and working style
- `AIOS/Vault Map.md` - Navigation guide for the knowledge base
- `AIOS/Skills/` - Individual skill files
- `AIOS/Templates/` - Note templates for consistent formatting
- `AIOS/Workflows/` - Pre-built workflows for common tasks
- `AIOS/Logs/` - AI interaction logs and histories

## Knowledge Linking Principles

### How to Navigate
1. Start with `MASTER-INDEX.md` for the knowledge graph overview
2. Use feature-specific notes in `03-Features/` for implementation details
3. Refer to architecture notes in `02-Architecture/` for systemic understanding
4. Check product notes in `01-Product/` for vision and planning context
5. Use backend notes in `04-Backend/` for infrastructure specifics

### Linking Conventions
- Use wiki-style links: `[[Feature Name]]` or `[[03-Features/AUTHENTICATION.md]]`
- Link to specific sections when possible: `[[AUTHENTICATION.md#sign-in-flow]]`
- Use relative paths from current file location
- Tag notes with relevant keywords in frontmatter for discovery

## Where to Add New Information

### New Features
1. Create file in `03-Features/` with feature name
2. Add entry to `FEATURE-INDEX.md`
3. Link from relevant architecture notes if applicable
4. Add to `MASTER-INDEX.md` knowledge graph if significant

### Architecture Changes
1. Update appropriate file in `02-Architecture/`
2. Add to `ARCHITECTURE-INDEX.md` if new major concept
3. Link from affected feature notes

### Process/Operations
1. Add to relevant directory (`05-Development/` or `06-Operations/`)
2. Update index files as needed
3. Link from related feature or architecture notes

## AI-Specific Guidelines
- AI-generated notes should go in `AIOS/` subdirectories unless integrating with main knowledge base
- When updating main knowledge base, follow existing patterns and conventions
- Always explain the "why" behind changes in commit messages or note comments
- Preserve existing links and improve rather than remove connections