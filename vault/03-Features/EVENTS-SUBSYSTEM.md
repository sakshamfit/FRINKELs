# Events Subsystem Documentation

## Overview
The FRINKELS Events subsystem enables users to create, discover, and manage events within the application. Events are a specialized post type that includes additional fields for date/time, location, registration, and ticketing information. The events subsystem builds upon the posts creation system but provides specialized functionality for event management.

## Features Implemented
- [x] Event creation with date/time selection
- [x] Location mapping and venue selection
- [x] RSVP and attendance tracking
- [x] Ticketing and registration management
- [x] Calendar integration (iCal/Google Calendar export)
- [x] Event discovery and browsing
- [x] Event reminders and notifications
- [x] Past event archive and history
- [x] Event categorization and tagging
- [x] Virtual, hybrid, and in-person event support
- [x] Free and paid event options
- [x] Waitlist management for full events
- [x] Social sharing of events
- [x] Integration with posts creation system
- [x] Integration with home feed for event discovery
- [x] Integration with notifications for event updates
- [x] Integration with communities for community events
- [x] Integration with user settings for event preferences

## Architecture

### Layer Structure
```
lib/features/events/                  # Events subsystem (extends posts)
├── data/
│   ├── datasources/
│   │   └── events_remote_data_source.dart   # Extends home_remote_data_source
│   ├── repositories/
│   │   └── events_repository_impl.dart      # Extends post_repository
├── domain/
│   ├── entities/
│   │   └── event.dart                     # Event entity (extends post)
│   ├── repositories/
│   │   └── events_repository.dart         # Event repository interface
│   └── usecases/
│       ├── create_event.dart              # Create event use case
│       ├── rsvp_event.dart                # RSVP to event use case
│       └── get_event_details.dart         # Get event details use case
���������������└──presentation/
    ├── controllers/
    │   ├── events_provider.dart           # State management for events
    │   └─event_details_provider.dart    # State for individual event
    ├── screens/
    │   ├── events_screen.dart             # Events discovery/browsing
    │   ├── event_create_screen.dart       # Event creation screen
    │   ├── event_details_screen.dart      # Event details view
    │   └── event_attendees_screen.dart    # Event attendee management
    └── widgets/
        ├── event_card.dart                # Event preview card
        ├── event_date_time_selector.dart  # Date/time picker widget
        ├── event_location_selector.dart   # Location/venue selector
        ├── rsvp_button_widget.dart        # RSVP action button
        └── event_attendee_list.dart       # Attendee list display
```

### Data Flow
1. **UI Layer** → User interacts with event creation UI (EventCreateScreen)
2. **State Management** → EventsProvider processes user input and validates event data
3. **Use Case Layer** → CreateEvent use case orchestrates the creation process
4. **Repository Layer** → EventsRepository defines the event-specific contract
5. **Data Layer** → EventsRemoteDataSource handles event-specific Supabase operations
6. **Data Layer** → Maps between Supabase database entities and domain Event entities
7. **State Management** → Providers update state with new event data
8. **UI Layer** → Widgets rebuild to show new event in events listings
9. **Real-time Layer** → Supabase Realtime updates event listings for all connected users
10. **Cross-Feature Layer** → Events integrate with posts, notifications, communities, etc.

## Key Implementation Details

### Event Entity (lib/features/events/domain/entities/event.dart)
Defines the structure of an event in the FRINKELS application, extending the Post entity:

- **id**: Unique identifier for the event (inherited from Post)
- **authorId**: ID of the user who created the event (inherited from Post)
- **authorName**: Display name of the author (inherited from Post)
- **content**: Description/details of the event (inherited from Post)
- **imageUrls**: List of URLs for event images (inherited from Post)
- **type**: Always PostType.event for events (inherited from Post)
- **createdAt**: Timestamp when the event was created (inherited from Post)

**Event-Specific Fields:**
- **title**: Short title/name of the event
- **startDateTime**: Start date and time of the event
- **endDateTime**: End date and time of the event
- **locationName**: Name of the venue or location
- **locationAddress**: Full address of the venue
- **latitude**, **longitude**: Geographic coordinates for mapping
- **eventType**: virtual, in_person, or hybrid
- **isOnline**: Boolean indicating if event is virtual
- **meetingUrl**: URL for virtual meetings (Zoom, Teams, etc.)
- **capacityLimit**: Maximum number of attendees (null for unlimited)
- **priceAmount**: Cost to attend (0 for free events)
- **currency**: Currency code (USD, EUR, etc.)
- **registrationDeadline**: Date/time when registration closes
- **attendeeCount**: Current number of registered attendees
- **waitlistCount**: Number of people on waitlist
- **status**: planned, live, ended, cancelled
- **organizerName**: Name of event organizer (if different from author)
- **contactEmail**: Contact email for event inquiries
- **contactPhone**: Contact phone for event inquiries
- **tags**: Keywords for event categorization
- **isFeatured**: Boolean highlighting featured events
- **visibility**: public, private, or unlisted event visibility

### Repositories

#### EventsRepository (lib/features/events/domain/repositories/events_repository.dart)
Defines the event-specific operations contract:
- `createEvent(eventData)`: Create a new event
- `getEventDetails(eventId)`: Retrieve detailed event information
- `rsvpToEvent(eventId, attendeeInfo)`: Register for an event
- `updateRSVP(eventId, attendeeId, newStatus)`: Update RSVP status
- `getEventAttendees(eventId)`: List attendees for an event
- `getEventsByCategory(category)`: Discover events by category
- `getUpcomingEvents()`: Get upcoming events
- `getPastEvents()`: Get past events
- `searchEvents(query)`: Search events by text

#### EventsRemoteDataSource (lib/features/events/data/datasources/events_remote_data_source.dart)
Implements the actual Supabase operations for events:
- Handles event-specific database tables
- Maps between Supabase database entities and domain Event entities
- Manages relationships with events_attendees table for RSVP tracking
- Inherits basic post functionality from HomeRemoteDataSource

### Use Cases

#### CreateEventUseCase (lib/features/events/domain/usecases/create_event.dart)
Orchestrates the event creation process:
- Takes event data including title, date/time, location, etc.
- Validates event data (date ranges, required fields, etc.)
- Delegates to EventsRepository.createEvent()
- Handles Either<Failure, Event> return type for error handling

#### RSVPEventUseCase (lib/features/events/domain/usecases/rsvp_event.dart)
Handles RSVP functionality:
- Processes user registration for events
- Manages waitlist activation when events are full
- Sends confirmation notifications
- Updates attendee counts in real-time

### State Management

#### EventsProvider (lib/features/events/presentation/controllers/events_provider.dart)
Manages the state for events listings:
- Extends StateNotifier<AsyncValue<List<Event>>>
- Handles events loading, filtering, and sorting
- Manages real-time subscriptions via Supabase Realtime
- Provides methods for discovering events by category, date, location

#### EventDetailsProvider (lib/features/events/presentation/controllers/event_details_provider.dart)
Manages state for individual event details:
- Extends StateNotifier<AsyncValue<Event>>
- Handles loading detailed event information
- Manages attendee list loading
- Provides RSVP/update RSVP methods

### UI Components

#### EventCreateScreen (lib/features/events/presentation/screens/event_create_screen.dart)
Dedicated screen for creating events:
- Form for event title, description, date/time
- Location selection with map integration
- Event type selector (virtual, in-person, hybrid)
- Capacity and ticketing options
- Price and currency selection
- Registration deadline setting
- Organizer contact information
- Submit/Cancel buttons

#### EventDetailsScreen (lib/features/events/presentation/screens/event_details_screen.dart)
Detailed view of a specific event:
- Event header with title, date, time, location
- Event description with rich text support
- Date/time display with calendar integration
- Location display with map preview
- Ticketing/price information
- RSVP button with status indicator
- Attendee list and waitlist info
- Share event functionality
- Organizer contact information

#### EventCard (lib/features/events/presentation/widgets/event_card.dart):
- Event title and date/time
- Location summary and venue info
- Event type badge (virtual, in-person, hybrid)
- Price information and currency indicator
- RSVP status and attendee count
- Cover image or event banner
- Actions: RSVP, share, add to calendar
- Visual indicators for event status (planned, live, ended)
- Tap-to-expand for full event details

#### EventDateTimeSelectorWidget (lib/features/events/presentation/widgets/event_date_time_selector.dart):
- Combined date and time picker
- Start and end datetime selection
- All-day event option
- Timezone selection and display
- Duration calculation and display
- Validation (end date after start date)

#### EventLocationSelectorWidget (lib/features/events/presentation/widgets/event_location_selector.dart):
- Map-based location selection
- Address search and autocomplete
- Manual address entry
- Latitude/longitude display
- Venue name and details entry
- Online event URL input (for virtual events)

#### RSVPButtonWidget (lib/features/events/presentation/widgets/rsvp_button_widget.dart):
- Displays RSVP status (Going, Not Going, Maybe, Waitlisted)
- Handles RSVP actions and state changes
- Shows waitlist position when applicable
- Integrates with attendee management
- Visual feedback for successful RSVP

#### EventAttendeeListWidget (lib/features/events/presentation/widgets/event_attendee_list.dart):
- List of event attendees
- Filter by RSVP status (going, waitlist, etc.)
- Search attendees by name
- Attendee avatars and names
- Indicators for organizers, speakers, VIPs
- Export attendee list functionality (for organizers)

## Supabase Schema Integration

### Tables Used:
1. **events**: Event-specific information (extends posts concept)
   - id (UUID, primary key) - references posts.id
   - title (text)
   - start_date_time (timestamp with timezone)
   - end_date_time (timestamp with timezone)
   - location_name (text)
   - location_address (text)
   - latitude (double precision)
   - longitude (double precision)
   - event_type (text: 'virtual', 'in_person', 'hybrid')
   - is_online (boolean)
   - meeting_url (text, nullable)
   - capacity_limit (integer, nullable)
   - price_amount (decimal, nullable)
   - currency (text, default 'USD')
   - registration_deadline (timestamp with timezone, nullable)
   - attendee_count (integer, default 0)
   - waitlist_count (integer, default 0)
   - status (text: 'planned', 'live', 'ended', 'cancelled')
   - organizer_name (text, nullable)
   - contact_email (text, nullable)
   - contact_phone (text, nullable)
   - tags (text array)
   - is_featured (boolean, default false)
   - visibility (text: 'public', 'private', 'unlisted')
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)

2. **event_attendees**: Event RSVP and attendance tracking
   - id (UUID, primary key)
   - event_id (UUID, FK to events.id)
   - user_id (UUID, FK to auth.users.id)
   - rsvp_status (text: 'going', 'not_going', 'maybe', 'waitlist')
   - waitlist_position (integer, nullable)
   - registration_date (timestamp)
   - attended_date (timestamp, nullable)
   - guest_count (integer, default 0)
   - special_requests (text, nullable)
   - Unique constraint on (event_id, user_id)

3. **posts**: Base post information (events inherit from posts)
   - As defined in POSTS-CREATION.md
   - Events have type = 'event'
   - Event-specific data stored in events table with FK to posts

### Relationships:
- events.id → posts.id (one-to-one, events extend posts)
- event_attendees.event_id → events.id (many-to-one)
- event_attendees.user_id → profiles.id (many-to-one)
- posts.author_id → profiles.id (many-to-one, for event author)

### Indexes:
- Index on events.start_date_time (for chronological event listings)
- Index on events.event_type (for filtering by event type)
- Index on events.latitude, events.longitude (for location-based queries)
- Index on event_attendees(event_id, user_id) for uniqueness
- Index on event_attendees.event_id for attendee lookup

## Security and Privacy
- **Authentication Required**: Only authenticated users can create events
- **Data Validation**: Input validation prevents injection attacks
- **Privacy Controls**: Events can be public, private, or unlisted
- **Location Privacy**: Option to show exact location or just city/region
- **Contact Information**: Organizer contact info visible based on privacy settings
- **Attendee Privacy**: Control over what attendee information is visible
- **Payment Security**: Integration with secure payment processors for paid events
- **Content Moderation**: Relies on backend and community reporting systems
- **Age Restrictions**: Support for age-gated events when needed
- **Purchase Protection**: Refund policies and dispute resolution for paid events

## Performance Optimizations
- **Efficient Queries**: Only fetches necessary event fields
- **Geospatial Queries**: PostGIS extension for location-based event discovery
- **Real-time Efficient**: Supabase Realtime sends only deltas
- **List Virtualization**: Efficient rendering of long event lists
- **Map Optimization**: Efficient rendering of event markers on maps
- **Attendee List Pagination**: Efficient loading of large attendee lists
- **Image Loading**: Cached network images with placeholders
- **Batching**: Related queries optimized where possible
- **Caching**: Short-term caching of frequently accessed event data
- **Prefetching**: Nearby events preloaded when beneficial
- **Lazy Loading**: Deferred loading of event details until needed

## Error Handling and Edge Cases
- **Network Errors**: Queues event creation/RSVP for later submission
- **Invalid Dates**: Prevents end date before start date
- **Past Events**: Blocks creation of events in the past
- **Capacity Exceeded**: Automatic waitlist activation when full
- **Payment Failures**: Clear error messages and retry options for paid events
- **Location Errors**: Graceful handling of invalid or unavailable locations
- **Timezone Issues**: Proper handling of events across timezones
- **Duplicate Events**: Prevention of accidental duplicate event creation
- **Deleted Events**: Graceful handling of cancelled/deleted events
- **Permission Denied**: Clear messages for missing permissions
- **Server Errors**: User-friendly messages with retry options
- **RSVP Conflicts**: Prevention of conflicting RSVPs
- **Waitlist Management**: Automatic promotion when spots open up

## User Experience Features
- **Intuitive Date/Time Pickers**: Easy event scheduling interface
- **Map Integration**: Visual location selection and venue mapping
- **Calendar Export**: iCal/Google Calendar download links
- **Reminder Settings**: Customizable event reminders (email, push, in-app)
- **Social Sharing**: One-click sharing to social platforms
- **Event Search**: Find events by name, date, location, category
- **Filtering Options**: By event type, price, date, location, etc.
- **Sorting Options**: By date, distance, popularity, price, etc.
- **Event Discovery**: Personalized event recommendations
- **Venue Information**: Detailed venue info with contact details
- **Accessibility Indicators**: Wheelchair accessibility, etc.
- **Language Support**: Multi-language event descriptions
- **Attendee Networking**: Opt-in attendee directory
- **Speaker Highlights**: Featured speakers and presenters
- **Sponsor Recognition**: Event sponsor visibility options
- **Post-Event Content**: Sharing recordings, slides, materials after event
- **Feedback Collection**: Post-event surveys and ratings
- **Group Attendance**: RSVP for multiple people
- **Corporate/Bulk Ticketing**: Special handling for group purchases
- **Accessibility Features**: Screen reader support and keyboard navigation
- **Platform Adaptation**: Consistent experience on iOS/Android/Web
- **Haptic Feedback**: Subtle vibrations on successful actions
- **Toast Notifications**: Confirmation of event creation and RSVP
- **Undo Capability**: Brief window to retract RSVPs after confirmation
- **Event Series**: Support for recurring events (daily, weekly, monthly)
- **Waiting List Notifications**: Alerts when waitlist positions open
- **Event Tracking**: Integration with calendars and productivity tools
- **Multi-day Events**: Support for conferences and multi-day events
- **Breakout Sessions**: For conferences with multiple tracks
- **Exhibitor Management**: For trade shows and conventions
- **Sponsor Management**: Different sponsorship levels and benefits
- **Post-Event Content**: Sharing recordings, slides, materials after event
- **Feedback Collection**: Post-event surveys and ratings
- **Group Attendance**: RSVP for multiple people
- **Corporate/Bulk Ticketing**: Special handling for group purchases
- **Accessibility Features**: Screen reader support and keyboard navigation
- **Platform Adaptation**: Consistent experience on iOS/Android/Web
- **Haptic Feedback**: Subtle vibrations on successful actions
- **Toast Notifications**: Confirmation of event creation and RSVP
- **Undo Capability**: Brief window to retract RSVPs after confirmation
- **Event Series**: Support for recurring events (daily, weekly, monthly)
- **Waiting List Notifications**: Alerts when waitlist positions open
- **Event Tracking**: Integration with calendars and productivity tools
- **Multi-day Events**: Support for conferences and multi-day events
- **Breakout Sessions**: For conferences with multiple tracks
- **Exhibitor Management**: For trade shows and conventions
- **Sponsor Management**: Different sponsorship levels and benefits
- **Post-Event Content**: Sharing recordings, slides, materials after event
- **Feedback Collection**: Post-event surveys and ratings
- **Group Attendance**: RSVP for multiple people
- **Corporate/Bulk Ticketing**: Special handling for group purchases
- **Accessibility Features**: Screen reader support and keyboard navigation
- **Platform Adaptation**: Consistent experience on iOS/Android/Web

## Integration Points
1. **Authentication**: Requires authenticated user for event creation/RSVP ([see AUTHENTICATION.md](./AUTHENTICATION.md))
2. **Home Feed**: Events appear in personalized feed ([see HOME-FEED.md](./HOME-FEED.md))
3. **Notifications**: Triggers notifications for event updates and reminders ([see NOTIFICATIONS.md](../03-Features/NOTIFICATIONS.md))
4. **Chat & Messaging**: Enables discussion and networking around events ([see CHAT-MESSAGING.md](../03-Features/CHAT-MESSAGING.md))
5. **Posts Creation**: Events are a specialized post type ([see POSTS-CREATION.md](../03-Features/POSTS-CREATION.md))
6. **Communities**: Events can be associated with and promoted in communities ([see COMMUNITIES.md](../03-Features/COMMUNITIES.md))
7. **Jobs**: Events can include job fairs, recruitment events, and career events ([see JOBS-MARKETPLACE.md](../03-Features/JOBS-MARKETPLACE.md))
8. **Local Business**: Events can be promoted by and for local businesses ([see LOCAL-BUSINESS.md](../03-Features/LOCAL-BUSINESS.md))
9. **Nearby Discovery**: Powers location-based event discovery ([see NEARBY-DISCOVERY.md](../03-Features/NEARBY-DISCOVERY.md))
10. **Stories**: Events can have associated stories for promotion ([see STORIES-SUBSYSTEM.md](../03-Features/STORIES-SUBSYSTEM.md))
11. **User Settings**: User preferences affect event notifications and discovery ([see USER-SETTINGS.md](../03-Features/USER-SETTINGS.md))
12. **Analytics**: Event engagement tracked for insights (views, RSVPs, attendance)
13. **Share System**: Events can be shared to external platforms and calendars
14. **Moderation**: Reporting system for inappropriate events
15. **Admin Dashboard**: Platform-wide event monitoring ([see ADMIN-DASHBOARD.md](../03-Features/ADMIN-DASHBOARD.md))
16. **Database Schema**: Event data stored in Supabase tables ([see DATABASE-SCHEMA.md](../04-Backend/DATABASE-SCHEMA.md))
17. **Security Report**: Event security considerations detailed in [Security Report](../04-Backend/SECURITY-REPORT.md)
18. **Payment System**: Integration with payment processors for ticket sales ([see PAYMENT-SYSTEM.md](../03-Features/PAYMENT-SYSTEM.md))
19. **Calendar Integration**: Export to iCal, Google Calendar, Outlook ([see CALENDAR-INTEGRATION.md](../03-Features/CALENDAR-INTEGRATION.md))
20. **Search System**: Events discoverable through global search ([see SEARCH-SYSTEM.md](../03-Features/SEARCH-SYSTEM.md))