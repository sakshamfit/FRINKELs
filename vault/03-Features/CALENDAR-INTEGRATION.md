# Calendar Integration Documentation

## Overview
The FRINKELS Calendar Integration enables users to export events to their personal calendars (Google Calendar, Apple Calendar, Outlook, etc.) and import calendar events into the FRINKELS application. This feature enhances user engagement by allowing seamless synchronization between FRINKELS events and users' personal scheduling systems.

## Features Implemented
- [x] iCal (.ics) file generation for event export
- [x] Google Calendar API integration for direct synchronization
- [x] Apple Calendar (CalDAV) support for calendar synchronization
- [x] Microsoft Outlook/Exchange calendar integration
- [x] One-click export to calendar applications
- [x] Event reminders synchronization with calendar alerts
- [x] Recurring event support in calendar exports
- [x] Timezone handling for accurate calendar scheduling
- [x] Event updates synchronization (when events are modified)
- [x] Cancellation synchronization (when events are cancelled)
- [x] Privacy controls for calendar sharing
- [x] Customizable calendar event descriptions
- [x] Location mapping integration for calendar events
- [x] Attendee synchronization with calendar invites
- [x] Integration with events system for seamless export
- [x] Integration with user settings for calendar preferences
- [x] Integration with notifications for calendar sync alerts
- [x] Support for public, private, and unlisted event visibility
- [x] Offline caching of calendar data for poor connectivity
- [x] Background synchronization for up-to-date calendar views
- [x] Conflict detection for overlapping calendar events
- [x] Custom calendar color coding and categorization

## Architecture

### Layer Structure
```
lib/features/calendar/
├── data/
│   ├── datasources/
│   │   ├── calendar_remote_data_source.dart    # Calendar API integrations
│   │   ├── calendar_local_data_source.dart     # Local calendar cache
│   │   └── ical_generator.dart                 # iCal file generation
│   ├── repositories/
│   │   └── calendar_repository_impl.dart       # Calendar repository implementation
├── domain/
│   ├── entities/
│   │   ├── calendar_event.dart                 # Calendar event entity
│   │   ├── calendar_sync.dart                  # Calendar sync status entity
│   │   ├── calendar_reminder.dart              # Calendar reminder entity
│   │   └── subscription.dart                   # Calendar subscription entity
│   ├── repositories/
│   │   └── calendar_repository.dart            # Calendar repository interface
│   └── usecases/
│       ├── export_to_calendar.dart             # Export event to calendar use case
│       ├── import_from_calendar.dart           # Import calendar event to FRINKELS use case
│       ├── sync_calendar.dart                  # Synchronize with calendar use case
│       ├── subscribe_to_calendar.dart          # Subscribe to calendar updates use case
│       └── get_calendar_events.dart            # Get events from calendar use case
���└── presentation/
    ├── controllers/
    │   ├── calendar_provider.dart              # Calendar state management
    │   ├── sync_provider.dart                  # Calendar synchronization state
    │   └── subscription_provider.dart          # Calendar subscription state
    ├── screens/
    │   ├── calendar_screen.dart                # Calendar integration settings
    │   ├── calendar_events_screen.dart         # Calendar events view
    │   ├── export_screen.dart                  # Event export to calendar screen
    │   └── import_screen.dart                  # Calendar import to FRINKELS screen
    └── widgets/
        ├── calendar_button.dart                # Calendar export/import button
        ├── calendar_sync_status.dart           # Calendar sync status indicator
        ├── calendar_event_card.dart            # Calendar event display card
        └── subscription_card.dart              # Calendar subscription display card
```

### Data Flow
**Export to Calendar:**
1. **UI Layer** → User selects export to calendar option for an event
2. **State Management** → CalendarProvider processes export request
3. **Use Case Layer** → ExportToCalendar use case orchestrates the export process
4. **Repository Layer** → CalendarRepository defines the calendar contract
5. **Data Layer** → CalendarRemoteDataSource handles calendar API communication or iCal generation
6. **Data Layer** → Maps FRINKELS event data to calendar event format
7. **External Integration** → Calendar API call or iCal file generation/download
8. **State Management** → Providers update state with export status
9. **UI Layer** → Widgets rebuild to show export success/status
10. **Cross-Feature Layer** → Export status updated in events system

**Import from Calendar:**
1. **UI Layer** → User selects import from calendar option
2. **State Management** → CalendarProvider processes import request
3. **Use Case Layer** → ImportFromCalendar use case orchestrates the import process
4. **Repository Layer** → CalendarRepository defines the calendar contract
5. **Data Layer** → CalendarRemoteDataSource handles calendar API communication
6. **External Integration** → Calendar API retrieves calendar events
7. **Data Layer** → Maps calendar event data to FRINKELS event format
8. **State Management** → Providers update state with imported events
9. **UI Layer** → Widgets rebuild to show imported events
10. **Cross-Feature Layer** → Imported events added to events system (as drafts or scheduled events)

## Key Implementation Details

### Calendar Event Entity (lib/features/calendar/domain/entities/calendar_event.dart)
Defines the structure of a calendar event:

- **id**: Unique identifier for the calendar event
- **frinkelsEventId**: ID of the associated FRINKELS event (if applicable)
- **title**: Event title/summary
- **description**: Event description/details
- **startTime**: Event start time
- **endTime**: Event end time
- **location**: Event location
- **isAllDay**: Boolean indicating if event is all-day
- **timezone**: Timezone for the event
- **recurrenceRule**: Recurrence rule (RRULE format) for recurring events
- **recurrenceId**: Instance ID for recurring event instances
- **status**: Event status (tentative, confirmed, cancelled)
- **transparency**: Transparency setting (opaque, transparent)
- **sequence**: Sequence number for version tracking
- **created**: Creation timestamp
- **lastModified**: Last modification timestamp
- **url**: URL to the FRINKELS event (if applicable)
- **attendees**: List of attendees with their response status
- **reminders**: List of reminder configurations
- **categories**: Event categories/tags
- **resources**: Resources associated with the event
- **attachments**: Attachments linked to the event
- **geo**: Geographic coordinates (latitude, longitude)
- **organizer**: Organizer information
- **source**: Source information (FRINKELS or external calendar)

### Calendar Sync Entity (lib/features/calendar/domain/entities/calendar_sync.dart)
Defines calendar synchronization status:

- **id**: Unique identifier for the sync record
- **userId**: ID of the user
- **calendarProvider**: Calendar service (google, apple, outlook, etc.)
- **calendarId**: Identifier of the external calendar
- **syncToken**: Token for incremental synchronization
- **lastSyncTime**: Timestamp of last successful synchronization
- **nextSyncTime**: Scheduled time for next synchronization
- **syncStatus**: Status of synchronization (idle, syncing, success, error)
- **errorMessage**: Error message if synchronization failed
- **eventsSynced**: Count of events synchronized
- **frinkelsEventsExported**: Count of FRINKELS events exported to calendar
- **calendarEventsImported**: Count of calendar events imported to FRINKELS
- **createdAt**: Timestamp when sync record was created
- **updatedAt**: Timestamp when sync record was last updated

### Repositories

#### CalendarRepository (lib/features/calendar/domain/repositories/calendar_repository.dart)
Defines the calendar operations contract:
- `exportEventToCalendar(eventId, calendarConfig)`: Export FRINKELS event to calendar
- `importEventFromCalendar(calendarEventId, importConfig)`: Import calendar event to FRINKELS
- `synchronizeCalendar(calendarConfig)`: Synchronize with external calendar
- `subscribeToCalendar(calendarConfig)`: Subscribe to calendar update notifications
- `getCalendarEvents(calendarConfig, filters)`: Get events from external calendar
- `deleteCalendarEvent(calendarEventId)`: Delete event from external calendar
- `updateCalendarEvent(calendarEvent)`: Update event in external calendar
- `getCalendarSubscriptions(userId)`: Get user's calendar subscriptions
- `createCalendarSubscription(subscriptionData)`: Create calendar subscription
- `deleteCalendarSubscription(subscriptionId)`: Delete calendar subscription

#### CalendarRemoteDataSource (lib/features/calendar/data/datasources/calendar_remote_data_source.dart)
Implements the actual calendar API integrations:
- **Google Calendar API**: OAuth2 integration with Google Calendar service
- **Apple Calendar (CalDAV)**: Integration with CalDAV servers (iCloud, etc.)
- **Microsoft Outlook/Exchange**: Integration with Exchange Web Services (EWS) or Microsoft Graph API
- **iCal Generator**: Local iCal (.ics) file generation for download/export
- Handles authentication, token refresh, and API rate limiting
- Manages data mapping between FRINKELS events and calendar events
- Implements conflict detection and resolution strategies
- Handles timezone conversions and daylight saving time adjustments
- Supports both bidirectional synchronization and export-only modes

### Use Cases

#### ExportToCalendarUseCase (lib/features/calendar/domain/usecases/export_to_calendar.dart)
Orchestrates exporting events to calendar:
- Takes event ID and calendar configuration (provider, calendar ID, etc.)
- Retrieves FRINKELS event data
- Maps FRINKELS event to calendar event format
- Handles recurrence rules, timezones, and attendee data
- Delegates to CalendarRepository.exportEventToCalendar()
- Handles Either<Failure, CalendarExportResult> return type for error handling
- Updates calendar sync status on successful export
- Triggers notifications for successful export

#### ImportFromCalendarUseCase (lib/features/calendar/domain/usecases/import_from_calendar.dart)
Orchestrates importing events from calendar:
- Takes calendar event ID and import configuration
- Retrieves calendar event data from external calendar
- Maps calendar event to FRINKELS event format
- Validates imported event data (title, time, location, etc.)
- Delegates to CalendarRepository.importEventFromCalendar()
- Handles Either<Failure, CalendarImportResult> return type for error handling
- Creates FRINKELS event (typically as draft or scheduled event)
- Triggers notifications for successful import

#### SynchronizeCalendarUseCase (lib/features/calendar/domain/usecases/sync_calendar.dart)
Orchestrates calendar synchronization:
- Takes calendar configuration (provider, credentials, etc.)
- Performs bidirectional synchronization when supported
- Handles conflict resolution (FRINKELS wins, calendar wins, or manual)
- Updates sync status and tracks synchronization metrics
- Handles Either<Failure, CalendarSyncResult> return type for error handling
- Triggers notifications for synchronization completion/failure

### State Management

#### CalendarProvider (lib/features/calendar/presentation/controllers/calendar_provider.dart)
Manages the state for calendar integration:
- Extends StateNotifier<AsyncValue<CalendarState>>
- Handles calendar connection status and authentication
- Manages export/import operations and their status
- Provides methods for connecting to calendar services
- Listens to calendar synchronization events and updates

#### SyncProvider (lib/features/calendar/presentation/controllers/sync_provider.dart)
Manages calendar synchronization state:
- Tracks ongoing synchronization operations
- Manages sync intervals and background synchronization
- Handles synchronization errors and retry logic
- Provides methods for initiating manual synchronization
- Manages sync tokens for incremental synchronization

#### SubscriptionProvider (lib/features/calendar/presentation/controllers/subscription_provider.dart)
Manages calendar subscriptions:
- Tracks active calendar subscriptions (webhooks, push notifications)
- Manages subscription lifecycle (creation, renewal, deletion)
- Handles incoming calendar update notifications
- Provides methods for managing calendar subscriptions

### UI Components

#### CalendarScreen (lib/features/calendar/presentation/screens/calendar_screen.dart)
Calendar integration settings screen:
- Lists connected calendar services (Google, Apple, Outlook, etc.)
- Allows adding new calendar service connections
- Shows connection status and last synchronization time
- Provides options to disconnect calendar services
- Manages calendar synchronization settings and preferences
- Shows synchronization history and statistics

#### CalendarEventsScreen (lib/features/calendar/presentation/screens/calendar_events_screen.dart)
Calendar events view:
- Displays events from connected calendars
- Shows FRINKELS events synced to calendars
- Allows filtering by calendar source and date range
- Provides import/export options for individual events
- Shows synchronization status for each event
- Enables viewing event details from external calendars

#### ExportScreen (lib/features/calendar/presentation/screens/export_screen.dart)
Event export to calendar screen:
- Select events to export (single or multiple)
- Choose target calendar service and calendar
- Configure export options (reminders, timezone, privacy)
- Preview calendar event before export
- Initiate export process with progress indicator
- Show export results and any errors
- Provide option to view exported event in calendar

#### ImportScreen (lib/features/calendar/presentation/screens/import_screen.dart)
Calendar import to FRINKELS screen:
- Select source calendar and date range
- Filter events by type, category, or keyword
- Preview calendar events before import
- Configure import options (default privacy, reminders)
- Initiate import process with progress indicator
- Show import results and any errors
- Provide option to view imported FRINKELS events

#### CalendarButtonWidget (lib/features/calendar/presentation/widgets/calendar_button.dart)
Calendar export/import button widget:
- Displays calendar service icons (Google, Apple, Outlook)
- Shows export/import status with visual indicators
- Handles tap actions for export/import operations
- Provides tooltip with calendar service information
- Shows connection status (connected/disconnected/error)
- Animates during export/import processes

#### CalendarSyncStatusWidget (lib/features/calendar/presentation/widgets/calendar_sync_status.dart)
Calendar synchronization status indicator:
- Shows synchronization status (idle, syncing, success, error)
- Displays last synchronization time and next scheduled sync
- Shows synchronization statistics (events synced, exported, imported)
- Provides tap action to initiate manual synchronization
- Displays error messages with retry options when applicable
- Animates during synchronization processes

#### CalendarEventCardWidget (lib/features/calendar/presentation/widgets/calendar_event_card.dart)
Calendar event display card:
- Shows event title, date, time, and location
- Indicates event source (FRINKELS or external calendar)
- Shows RSVP/status for events with attendees
- Displays reminder settings for the event
- Indicates synchronization status with source calendar
- Provides actions: view details, export/import, synchronize
- Shows recurrence indicator for repeating events
- Displays privacy status (public, private, unlisted)

#### SubscriptionCardWidget (lib/features/calendar/presentation/widgets/subscription_card.dart)
Calendar subscription display card:
- Shows calendar service and calendar name
- Displays subscription type (webhook, push notification, polling)
- Shows last update time and update frequency
- Indicates subscription status (active, inactive, error)
- Provides actions: view details, renew, delete
- Shows statistics (updates received, events processed)
- Displays error messages with retry options when applicable

## Supabase Schema Integration

### Tables Used:
1. **calendar_events**: FRINKELS events synchronized with external calendars
   - id (UUID, primary key)
   - frinkels_event_id (UUID, FK to events.events.id)
   - calendar_provider (text: 'google', 'apple', 'outlook', etc.)
   - calendar_id (text) - external calendar identifier
   - external_event_id (text) - external calendar event identifier
   - sync_status (text: 'synced', 'pending', 'conflict', 'error')
   - last_synced_at (timestamp with timezone)
   - sync_token (text) - for incremental synchronization
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)

2. **calendar_subscriptions**: Calendar subscription records for push notifications
   - id (UUID, primary key)
   - user_id (UUID, FK to auth.users.id)
   - calendar_provider (text: 'google', 'apple', 'outlook', etc.)
   - calendar_id (text) - external calendar identifier
   - subscription_id (text) - external calendar subscription identifier
   - subscription_type (text: 'webhook', 'push_notification', 'polling')
   - webhook_url (text, nullable) - URL for webhook notifications
   - is_active (boolean, default true)
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)

3. **calendar_sync_logs**: Calendar synchronization history
   - id (UUID, primary key)
   - user_id (UUID, FK to auth.users.id)
   - calendar_provider (text: 'google', 'apple', 'outlook', etc.)
   - operation_type (text: 'export', 'import', 'sync')
   - record_count (integer) - number of records processed
   - success_count (integer) - number of successful operations
   - failure_count (integer) - number of failed operations
   - started_at (timestamp with timezone)
   - completed_at (timestamp with timezone)
   - status (text: 'pending', 'in_progress', 'completed', 'failed')
   - error_message (text, nullable)

### Relationships:
- calendar_events.frinkels_event_id → events.id (many-to-one)
- calendar_events.calendar_provider + calendar_id → external calendar reference
- calendar_subscriptions.user_id → auth.users.id (many-to-one)
- calendar_sync_logs.user_id → auth.users.id (many-to-one)

### Indexes:
- Index on calendar_events.frinkels_event_id (for FRINKELS event lookup)
- Index on calendar_events.calendar_provider, calendar_id (for calendar lookup)
- Index on calendar_events.external_event_id (for external event lookup)
- Index on calendar_subscriptions.user_id (for user-specific queries)
- Index on calendar_subscriptions.is_active (for filtering active subscriptions)
- Index on calendar_sync_logs.user_id (for user-specific queries)
- Index on calendar_sync_logs.started_at (for chronological queries)
- Index on calendar_sync_logs.status (for filtering by status)
- Index on calendar_sync_logs.calendar_provider (for provider-specific queries)

## Security and Privacy
- **OAuth2 Authentication**: Uses industry-standard OAuth2 for calendar service authentication
- **Token Storage**: Securely stores refresh tokens with encryption
- **Permission Scopes**: Requests minimal necessary permissions (calendar.readonly, calendar.events)
- **User Consent**: Explicit user consent required for calendar access
- **Data Minimization**: Only synchronizes necessary event data
- **Privacy Controls**: Respects event visibility settings (public/private/unlisted)
- **Secure Communication**: All calendar API communications over HTTPS/TLS
- **Input Validation**: Validates all calendar data to prevent injection attacks
- **Rate Limiting**: Implements rate limiting to respect calendar service limits
- **Webhook Security**: Validates webhook signatures to prevent spoofing
- **Token Encryption**: Encrypts stored refresh tokens and access tokens
- **Session Management**: Proper session handling and timeout management
- **Audit Trail**: Logs all calendar synchronization activities for compliance
- **Data Retention**: Respects user data retention preferences
- **Cross-Origin Security**: Implements proper CORS policies for web integrations
- **Third-Party Trust**: Only integrates with trusted, reputable calendar services

## Performance Optimizations
- **Incremental Synchronization**: Uses sync tokens for efficient calendar synchronization
- **Batch Operations**: Processes multiple events in single API calls where possible
- **Caching**: Caches calendar data locally to reduce API calls
- **Background Synchronization**: Efficient background sync with minimal battery impact
- **Network Optimization**: Minimizes data transferred in API requests/responses
- **Database Indexing**: Proper indexing for quick data retrieval
- **Connection Pooling**: Efficient database connection usage
- **Payload Compression**: Uses compression for large data transfers when beneficial
- **Lazy Loading**: Defers loading of calendar details until needed
- **Prefetching**: Prefetches calendar data for anticipated user actions
- **Throttling**: Implements throttling to prevent API rate limit exceedance
- **Query Optimization**: Optimized database queries for calendar operations
- **Memory Management**: Efficient memory usage to prevent leaks
- **File System Optimization**: Efficient iCal file generation and handling
- **CDN Integration**: Uses CDN for static assets when applicable
- **Webhook Efficiency**: Optimized webhook processing for minimal latency

## Error Handling and Edge Cases
- **Authentication Errors**: Handles expired/invalid tokens with re-authentication flow
- **Network Errors**: Queues synchronization requests for later submission with retry
- **API Rate Limits**: Implements exponential backoff for rate limit errors
- **Service Unavailable**: Graceful handling of calendar service downtime
- **Permission Denied**: Clear error messages for insufficient permissions
- **Invalid Data**: Handles malformed calendar data from external services
- **Timezone Conflicts**: Proper timezone handling to prevent scheduling errors
- **Recurring Events**: Complex recurrence rule handling and synchronization
- **Event Conflicts**: Conflict detection and resolution strategies
- **Deleted Events**: Proper handling of deleted events in external calendars
- **Privacy Changes**: Handles changes to event privacy settings
- **Format Incompatibility**: Handles differences in calendar data formats
- **Character Encoding**: Proper handling of international characters and encoding
- **Size Limits**: Manages large calendar files and data payloads
- **Duplicate Events**: Prevention of duplicate event creation during import
- **Orphaned Events**: Handling of events that lose their calendar association
- **Synchronization Loops**: Prevention of infinite synchronization loops
- **Daylight Saving Time**: Proper handling of DST transitions
- **Leap Year Handling**: Correct handling of leap years and date calculations
- **Invalid Recurrence Rules**: Graceful handling of invalid or unsupported recurrence patterns
- **Calendar Service Changes**: Adaptation to changes in calendar service APIs
- **Offline Operation**: Queues operations for when connectivity is restored
- **Conflict Resolution**: Clear strategies for resolving synchronization conflicts
- **Error Reporting**: Detailed error logging for troubleshooting and support
- **Fallback Mechanisms**: Alternative methods when primary integration fails
- **User Notification**: Clear user feedback on synchronization status and errors
- **Recovery Procedures**: Guided recovery procedures for common failure scenarios

## User Experience Features
- **One-Click Export**: Simple one-click export to connected calendars
- **Multiple Calendar Support**: Support for multiple calendar services simultaneously
- **Automatic Synchronization**: Configurable automatic synchronization intervals
- **Manual Synchronization**: Option for manual synchronization on demand
- **Conflict Resolution UI**: User-friendly interface for resolving synchronization conflicts
- **Export Preview**: Preview of calendar event before export
- **Import Preview**: Preview of FRINKELS event before import
- **Customizable Reminders**: Ability to set custom calendar reminders
- **Timezone Selection**: Option to specify timezone for exported events
- **Privacy Controls**: Control over how event details appear in exported calendars
- **Attendee Management**: Synchronization of attendee information and RSVPs
- **Location Integration**: Mapping of event location to calendar location fields
- **URL Integration**: Linking to FRINKELS event in calendar event description
- **Recurring Events**: Full support for exporting and importing recurring events
- **All-Day Events**: Proper handling of all-day events in calendar exports
- **Multi-Day Events**: Support for multi-day events and conferences
- **Event Updates**: Synchronization of event modifications (title, time, location, etc.)
- **Cancellation Sync**: Synchronization of event cancellations
- **Status Indicators**: Visual indicators of sync status (synced, pending, error)
- **Loading States**: Appropriate loading indicators during sync operations
- **Empty States**: Helpful empty states when no calendar events are present
- **Error States**: Clear error states with recovery options
- **Success Feedback**: Clear feedback on successful synchronization operations
- **History Tracking**: View synchronization history and statistics
- **Connection Management**: Easy management of calendar service connections
- **Security Indicators**: Visual indicators of secure calendar connections
- **Permission Explanation**: Clear explanation of requested calendar permissions
- **Service Selection**: Intuitive service selection for different calendar providers
- **Account Management**: Easy addition/removal of calendar accounts
- **Default Calendar**: Option to set default calendar for exports
- **Color Coding**: Customizable color coding for different calendar sources
- **Categorization**: Tagging and categorization of calendar events
- **Search Integration**: Integration with global search for calendar events
- **Notifications**: Calendar synchronization status notifications
- **Sharing**: Sharing of calendar export options with others
- **Accessibility**: Full keyboard navigation and screen reader support
- **Internationalization**: Support for multiple languages and locales
- **Platform Adaptation**: Consistent experience on iOS/Android/Web
- **Haptic Feedback**: Subtle vibrations on successful sync operations
- **Toast Notifications**: Confirmation of sync operations
- **Undo Capability**: Brief window to undo synchronization operations
- **Batch Operations**: Support for batch export/import of multiple events
- **Filtering Options**: Advanced filtering for calendar event views
- **Sorting Options**: Multiple sorting options for calendar event lists
- **Visual Indicators**: Clear visual indicators of event source and sync status
- **Tooltip Information**: Helpful tooltips with calendar service details
- **Contextual Help**: In-app guidance and help for calendar operations
- **Error Recovery**: Guided error recovery with clear next steps
- **Performance Indicators**: Visual indicators of sync performance and efficiency
- **Resource Usage**: Monitoring of battery and data usage during sync
- **Privacy Indicators**: Clear indicators of privacy settings for exported events
- **Legal Compliance**: Compliance with data protection regulations (GDPR, CCPA, etc.)
- **Accessibility Compliance**: WCAG 2.1 compliance for calendar interfaces
- **Third-Party Audits**: Regular security audits of calendar integrations
- **Community Feedback**: Incorporation of user feedback for improvements
- **Documentation**: Comprehensive documentation for developers and users

## Integration Points
1. **Authentication**: Requires authenticated user for calendar operations ([see AUTHENTICATION.md](./AUTHENTICATION.md))
2. **Events System**: Exports FRINKELS events to calendar and imports calendar events ([see EVENTS-SUBSYSTEM.md](../03-Features/EVENTS-SUBSYSTEM.md))
3. **User Settings**: Stores user calendar preferences and connection settings ([see USER-SETTINGS.md](../03-Features/USER-SETTINGS.md))
4. **Notifications**: Calendar synchronization triggers notifications ([see NOTIFICATIONS.md](../03-Features/NOTIFICATIONS.md))
5. **Analytics**: Calendar data tracked for engagement insights
6. **Admin Dashboard**: Platform-wide calendar integration monitoring ([see ADMIN-DASHBOARD.md](../03-Features/ADMIN-DASHBOARD.md))
7. **Database Schema**: Calendar data stored in Supabase tables ([see DATABASE-SCHEMA.md](../04-Backend/DATABASE-SCHEMA.md))
8. **Security Report**: Calendar security considerations detailed in [Security Report](../04-Backend/SECURITY-REPORT.md)