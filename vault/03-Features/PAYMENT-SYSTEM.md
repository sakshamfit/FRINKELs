# Payment System Documentation

## Overview
The FRINKELS Payment System handles all financial transactions within the application, including ticket sales for events, premium subscriptions, in-app purchases, and marketplace transactions. It integrates with secure payment processors to provide a safe and seamless payment experience for users.

## Features Implemented
- [x] Secure payment processing for event tickets
- [x] Subscription management for premium tiers
- [x] In-app purchases for digital goods and services
- [x] Marketplace transactions for local business services
- [x] Multiple payment method support (credit/debit cards, digital wallets)
- [x] Payment verification and fraud prevention
- [x] Refund and dispute resolution handling
- [x] Transaction history and reporting
- [x] Tax calculation and compliance
- [x] Currency conversion for international transactions
- [x] Receipt generation and invoice management
- [x] Payment webhooks for real-time transaction updates
- [x] PCI DSS compliance for secure card handling
- [x] Integration with events system for ticket sales
- [x] Integration with premium tier system for subscriptions
- [x] Integration with local business system for service payments
- [x] Integration with user settings for payment preferences

## Architecture

### Layer Structure
```
lib/features/payment/
├── data/
│   ├── datasources/
│   │   ├── payment_remote_data_source.dart    # Payment processor integration
│   │   └── payment_local_data_source.dart     # Local transaction caching
│   ├── repositories/
│   │   └── payment_repository_impl.dart       # Payment repository implementation
├── domain/
│   ├── entities/
│   │   ├── payment_transaction.dart           # Payment transaction entity
│   │   ├── payment_method.dart                # Payment method entity
│   │   ├── refund.dart                        # Refund entity
│   │   └── invoice.dart                       # Invoice entity
│   ├── repositories/
│   │   └── payment_repository.dart            # Payment repository interface
│   └── usecases/
│       ├── process_payment.dart               # Process payment use case
│       ├── refund_payment.dart                # Refund payment use case
│       ├── get_payment_history.dart           # Get payment history use case
│       └── verify_payment.dart                # Verify payment status use case
�└── presentation/
    ├── controllers/
    │   ├── payment_provider.dart              # Payment state management
    │   ├── subscription_provider.dart         # Subscription state management
    │   └── invoice_provider.dart              # Invoice state management
    ├── screens/
    │   ├── payment_screen.dart                # Payment processing screen
    │   ├── payment_methods_screen.dart        # Payment methods management
    │   ├── transaction_history_screen.dart    # Transaction history view
    │   └── invoice_screen.dart                # Invoice management screen
    └── widgets/
        ├── payment_form.dart                  # Payment form widget
        ├── payment_method_selector.dart       # Payment method selection
        ├── transaction_card.dart              # Transaction history card
        └── invoice_card.dart                  # Invoice display card
```

### Data Flow
1. **UI Layer** → User initiates payment (ticket purchase, subscription, etc.)
2. **State Management** → PaymentProvider processes payment request and validates data
3. **Use Case Layer** → ProcessPayment use case orchestrates the payment process
4. **Repository Layer** → PaymentRepository defines the payment contract
5. **Data Layer** → PaymentRemoteDataSource handles actual payment processor communication
6. **Data Layer** → Maps between payment processor responses and domain entities
7. **State Management** → Providers update state with payment transaction data
8. **UI Layer** → Widgets rebuild to show payment status and confirmation
9. **Webhook Layer** → Payment processor webhooks update transaction status in real-time
10. **Cross-Feature Layer** → Payment results update related systems (events, premium, etc.)

## Key Implementation Details

### Payment Transaction Entity (lib/features/payment/domain/entities/payment_transaction.dart)
Defines the structure of a payment transaction:

- **id**: Unique identifier for the transaction
- **userId**: ID of the user making the payment
- **amount**: Transaction amount in currency units
- **currency**: Currency code (USD, EUR, etc.)
- **status**: Payment status (pending, processing, completed, failed, refunded)
- **paymentMethod**: Payment method used (card, wallet, etc.)
- **transactionId**: External transaction ID from payment processor
- **description**: Description of what the payment is for
- **metadata**: Additional data associated with the transaction
- **createdAt**: Timestamp when transaction was initiated
- **updatedAt**: Timestamp when transaction status was last updated
- **completedAt**: Timestamp when transaction was completed
- **failureReason**: Reason for payment failure (if applicable)
- **receiptUrl**: URL to download transaction receipt
- **invoiceId**: Associated invoice ID (if applicable)

### Payment Method Entity (lib/features/payment/domain/entities/payment_method.dart)
Defines stored payment methods:

- **id**: Unique identifier for the payment method
- **userId**: ID of the user who owns the payment method
- **type**: Type of payment method (card, wallet, bank_account)
- **brand**: Brand of card (visa, mastercard, amex, etc.)
- **lastFour**: Last four digits of card/account number
- **expiryMonth**: Expiry month (for cards)
- **expiryYear**: Expiry year (for cards)
- **isDefault**: Whether this is the default payment method
- **isVerified**: Whether the payment method has been verified
- **createdAt**: Timestamp when payment method was added
- **updatedAt**: Timestamp when payment method was last updated

### Repositories

#### PaymentRepository (lib/features/payment/domain/repositories/payment_repository.dart)
Defines the payment operations contract:
- `processPayment(paymentData)`: Process a payment transaction
- `refundPayment(transactionId, reason)`: Refund a completed payment
- `getPaymentHistory(userId, filters)`: Get payment history for a user
- `getPaymentStatus(transactionId)`: Get status of a specific transaction
- `savePaymentMethod(paymentMethod)`: Save a payment method for future use
- `getPaymentMethods(userId)`: Get saved payment methods for a user
- `deletePaymentMethod(methodId)`: Remove a saved payment method
- `createInvoice(invoiceData)`: Create an invoice for payment
- `getInvoice(invoiceId)`: Retrieve invoice details
- `payInvoice(invoiceId, paymentMethodId)`: Pay an invoice

#### PaymentRemoteDataSource (lib/features/payment/data/datasources/payment_remote_data_source.dart)
Implements the actual payment processor integration:
- Integrates with payment processors (Stripe, PayPal, etc.)
- Handles payment tokenization and secure card data handling
- Manages webhook endpoints for real-time transaction updates
- Implements retry logic for failed payments
- Handles currency conversion and tax calculations
- Ensures PCI DSS compliance for card data handling

### Use Cases

#### ProcessPaymentUseCase (lib/features/payment/domain/usecases/process_payment.dart)
Orchestrates the payment process:
- Takes payment data including amount, currency, payment method, description
- Validates payment data (amount limits, required fields, etc.)
- Creates payment token with payment processor (if needed)
- Delegates to PaymentRepository.processPayment()
- Handles Either<Failure, PaymentTransaction> return type for error handling
- Updates related systems based on payment purpose (events, premium, etc.)

#### RefundPaymentUseCase (lib/features/payment/domain/usecases/refund_payment.dart)
Handles payment refunds:
- Processes refund requests for completed transactions
- Validates refund eligibility (time limits, amount limits, etc.)
- Communicates with payment processor to initiate refund
- Updates transaction status to refunded
- Handles Either<Failure, Refund> return type for error handling
- Notifies relevant parties of refund completion

### State Management

#### PaymentProvider (lib/features/payment/presentation/controllers/payment_provider.dart)
Manages the state for payment processing:
- Extends StateNotifier<AsyncValue<PaymentTransaction>>
- Handles payment loading, processing, success, and error states
- Manages payment method selection and validation
- Provides methods for initiating payments and checking status
- Listens to payment processor webhooks for real-time updates

#### SubscriptionProvider (lib/features/payment/presentation/controllers/subscription_provider.dart)
Manages subscription state:
- Tracks active subscriptions and renewal dates
- Handles subscription upgrades/downgrades/cancellations
- Manages billing cycle and proration calculations
- Provides methods for subscription management

#### InvoiceProvider (lib/features/payment/presentation/controllers/invoice_provider.dart)
Manages invoice state:
- Tracks invoices and payment status
- Handles invoice creation, modification, and cancellation
- Manages payment reminders and overdue notifications
- Provides methods for invoice management

### UI Components

#### PaymentScreen (lib/features/payment/presentation/screens/payment_screen.dart)
Main payment processing screen:
- Displays payment amount and description
- Shows selected payment method or prompts for new method
- Collects required billing information
- Displays payment terms and conditions
- Processes payment with loading indicator
- Shows payment success or error message
- Provides receipt download option

#### PaymentMethodsScreen (lib/features/payment/presentation/screens/payment_methods_screen.dart)
Payment methods management screen:
- Lists saved payment methods
- Allows adding new payment methods
- Allows setting default payment method
- Allows removing payment methods
- Shows verification status of payment methods

#### TransactionHistoryScreen (lib/features/payment/presentation/screens/transaction_history_screen.dart)
Transaction history view:
- Lists all payment transactions with filtering options
- Shows transaction status, amount, date, and description
- Provides transaction details view
- Allows downloading receipts for completed transactions
- Filters by date range, transaction type, status

#### InvoiceScreen (lib/features/payment/presentation/screens/invoice_screen.dart)
Invoice management screen:
- Lists all invoices with status (draft, sent, paid, overdue)
- Shows invoice details including line items and totals
- Allows creating new invoices
- Allows sending invoices to customers
- Tracks payment status and overdue invoices
- Provides PDF generation for invoices

#### PaymentFormWidget (lib/features/payment/presentation/widgets/payment_form.dart)
Reusable payment form widget:
- Collects payment amount and currency
- Selects payment method (saved or new)
- Validates payment information
- Handles payment processing with loading states
- Shows payment success/error messages
- Integrates with payment processor SDKs

#### PaymentMethodSelectorWidget (lib/features/payment/presentation/widgets/payment_method_selector.dart)
Payment method selection widget:
- Displays saved payment methods with card details
- Allows selection of saved payment method
- Provides option to add new payment method
- Shows verification badges for verified methods
- Handles secure display of payment method information

#### TransactionCardWidget (lib/features/payment/presentation/widgets/transaction_card.dart)
Transaction history display widget:
- Shows transaction status with visual indicators
- Displays transaction amount, date, and description
- Shows payment method used (last 4 digits)
- Provides access to transaction details and receipt
- Indicates refund status for refunded transactions

#### InvoiceCardWidget (lib/features/payment/presentation/widgets/invoice_card.dart)
Invoice display widget:
- Shows invoice status (draft, sent, paid, overdue)
- Displays invoice number, date, due date, and amount
- Shows customer information and billing details
- Provides access to invoice details and PDF
- Indicates overdue status with visual warnings
- Shows payment options for unpaid invoices

## Supabase Schema Integration

### Tables Used:
1. **payment_transactions**: Payment transaction records
   - id (UUID, primary key)
   - user_id (UUID, FK to auth.users.id)
   - amount (decimal)
   - currency (text)
   - status (text: 'pending', 'processing', 'completed', 'failed', 'refunded')
   - payment_method_type (text)
   - payment_method_details (jsonb)
   - transaction_id (text, nullable) - external processor transaction ID
   - description (text)
   - metadata (jsonb)
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)
   - completed_at (timestamp with timezone, nullable)
   - failure_reason (text, nullable)
   - receipt_url (text, nullable)
   - invoice_id (UUID, FK to invoices.invoice_id, nullable)

2. **payment_methods**: Saved payment methods
   - id (UUID, primary key)
   - user_id (UUID, FK to auth.users.id)
   - type (text: 'card', 'wallet', 'bank_account')
   - brand (text, nullable) - for card types
   - last_four (text, nullable)
   - expiry_month (integer, nullable) - for cards
   - expiry_year (integer, nullable) - for cards
   - is_default (boolean, default false)
   - is_verified (boolean, default false)
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)

3. **invoices**: Invoices for goods/services
   - id (UUID, primary key)
   - user_id (UUID, FK to auth.users.id) - invoice creator
   - customer_id (UUID, FK to auth.users.id, nullable) - invoice recipient
   - invoice_number (text, unique)
   - status (text: 'draft', 'sent', 'paid', 'overdue', 'cancelled')
   - issue_date (timestamp with timezone)
   - due_date (timestamp with timezone, nullable)
   - amount (decimal)
   - currency (text)
   - tax_amount (decimal, default 0)
   - description (text)
   - line_items (jsonb) - detailed line items
   - paid_at (timestamp with timezone, nullable)
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)

4. **payment_refunds**: Refund records
   - id (UUID, primary key)
   - transaction_id (UUID, FK to payment_transactions.id)
   - amount (decimal)
   - reason (text)
   - refund_transaction_id (text, nullable) - external processor refund ID
   - status (text: 'pending', 'processed', 'failed')
   - created_at (timestamp with timezone)
   - updated_at (timestamp with timezone)
   - processed_at (timestamp with timezone, nullable)

### Relationships:
- payment_transactions.user_id → auth.users.id (many-to-one)
- payment_transactions.invoice_id → invoices.id (many-to-one, nullable)
- payment_methods.user_id → auth.users.id (many-to-one)
- invoices.user_id → auth.users.id (many-to-one) - invoice creator
- invoices.customer_id → auth.users.id (many-to-one, nullable) - invoice recipient
- payment_refunds.transaction_id → payment_transactions.id (many-to-one)

### Indexes:
- Index on payment_transactions.user_id (for user-specific queries)
- Index on payment_transactions.status (for filtering by status)
- Index on payment_transactions.created_at (for chronological queries)
- Index on payment_methods.user_id (for user-specific queries)
- Index on invoices.user_id and invoices.customer_id (for user-specific queries)
- Index on invoices.status (for filtering by status)
- Index on invoices.due_date (for overdue invoice queries)
- Index on payment_refunds.transaction_id (for refund tracking)

## Security and Privacy
- **PCI DSS Compliance**: Never stores raw card data; uses payment processor tokens
- **Encryption**: All sensitive data encrypted at rest and in transit
- **Tokenization**: Uses payment processor tokens for recurring payments
- **Authentication**: Requires authenticated user for all payment operations
- **Authorization**: Users can only access their own payment data
- **Fraud Prevention**: Implements velocity checks, IP analysis, and velocity limits
- **Secure Webhooks**: Validates payment processor webhook signatures
- **Data Minimization**: Only stores necessary payment information
- **Privacy Controls**: Respects user preferences for payment method storage
- **Audit Trail**: All payment transactions logged for compliance and auditing
- **Environment Separation**: Separate API keys for test and production environments
- **Input Validation**: Validates all payment data to prevent injection attacks
- **Rate Limiting**: Implements rate limiting to prevent abuse and card testing

## Performance Optimizations
- **Asynchronous Processing**: Payment processing handled asynchronously to avoid blocking UI
- **Connection Pooling**: Efficient database connection usage
- **Caching**: Short-term caching of frequently accessed payment data
- **Batch Processing**: Batch processing of recurring payments and subscriptions
- **Lazy Loading**: Deferred loading of payment details until needed
- **Index Optimization**: Proper database indexing for query performance
- **CDN Integration**: Uses CDN for static assets (receipt templates, etc.)
- **Webhook Efficiency**: Efficient webhook processing with minimal processing time
- **Database Connection Pooling**: Optimized database connection usage
- **Query Optimization**: Optimized database queries to minimize execution time
- **Payload Minimization**: Minimizes data transferred between client and server

## Error Handling and Edge Cases
- **Network Errors**: Queues payment requests for later submission with retry
- **Card Declined**: Clear error messages for declined cards with retry options
- **Insufficient Funds**: Specific error messages for insufficient funds
- **Expired Card**: Detection and clear messaging for expired cards
- **Invalid Card Number**: Validation and error messages for invalid card numbers
- **Processor Errors**: Graceful handling of payment processor downtime
- **Duplicate Payments**: Prevention of accidental duplicate payments
- **Currency Conversion Errors**: Handling of currency conversion failures
- **Tax Calculation Errors**: Fallback mechanisms for tax calculation errors
- **Refund Elimits**: Clear messaging when refunds exceed original amount
- **Partial Refunds**: Support for partial refund amounts
- **Chargeback Handling**: Process for handling payment processor chargebacks
- **Dispute Resolution**: Tools for resolving payment disputes
- **Webhook Failures**: Retry mechanisms for failed webhook deliveries
- **Idempotency**: Idempotent requests to prevent duplicate processing
- **Timeout Handling**: Proper timeout handling for payment processor requests
- **Connection Failures**: Retry logic for database and network connection failures
- **Data Corruption**: Data validation and corruption detection mechanisms

## User Experience Features
- **Multiple Payment Methods**: Support for credit/debit cards, digital wallets, bank transfers
- **Saved Payment Methods**: Securely save payment methods for faster checkout
- **One-Click Payments**: Enable one-click payments with saved methods
- **Payment Request API**: Browser-native payment request API support
- **Apple Pay/Google Pay**: Integration with mobile wallet payment methods
- **Installment Payments**: Support for buy-now-pay-later and installment options
- **Subscription Management**: Easy subscription upgrades, downgrades, and cancellations
- **Proration Calculations**: Accurate proration for subscription changes mid-cycle
- **Trial Periods**: Support for free trial periods with automatic conversion
- **Invoice Management**: Professional invoice creation, sending, and tracking
- **Payment Plans**: Support for split payments and payment plans
- **Cash Payments**: Support for in-person cash payments (where applicable)
- **Mobile Optimization**: Optimized payment forms for mobile devices
- **Accessibility**: Full keyboard navigation and screen reader support
- **Internationalization**: Support for multiple languages and currencies
- **Localization**: Adaptation to local payment preferences and regulations
- **Real-time Updates**: Instant payment status updates via webhooks
- **Transaction Search**: Easy search and filtering of transaction history
- **Receipt Generation**: Automatic receipt generation for completed transactions
- **Invoice Customization**: Customizable invoice templates and branding
- **Tax Inclusive/Exclusive**: Support for both tax-inclusive and tax-exclusive pricing
- **Discount Codes**: Support for promotional and discount codes
- **Fee Transparency**: Clear display of any processing or service fees
- **Payment Timers**: Visual timers for time-sensitive payments
- **Error Recovery**: Guided error recovery with clear next steps
- **Payment Confirmation**: Clear confirmation screens with transaction details
- **Refund Tracking**: Easy tracking of refund status and expected completion
- **Dispute Management**: Tools for managing and resolving payment disputes
- **Accessibility Compliance**: WCAG 2.1 compliance for payment interfaces
- **Security Indicators**: Visual indicators of secure payment processing
- **Save for Later**: Ability to save payment information for future use
- **Split Payments**: Support for splitting payments among multiple users
- **Group Payments**: Support for group payments and collections
- **Recurring Payments**: Support for recurring payments with flexible scheduling
- **Usage-Based Billing**: Support for usage-based billing models
- **Invoice Financing**: Integration with invoice financing services (future)
- **Multi-Party Payments**: Support for complex multi-party payment arrangements
- **Escrow Services**: Support for escrow-held payments (future)

## Integration Points
1. **Authentication**: Requires authenticated user for all payment operations ([see AUTHENTICATION.md](./AUTHENTICATION.md))
2. **Events System**: Processes ticket sales for events ([see EVENTS-SUBSYSTEM.md](../03-Features/EVENTS-SUBSYSTEM.md))
3. **Premium Tier**: Handles subscription payments for premium features ([see PREMIUM-TIER.md](../03-Features/PREMIUM-TIER.md))
4. **Local Business**: Facilitates payments for local business services ([see LOCAL-BUSINESS.md](../03-Features/LOCAL-BUSINESS.md))
5. **User Settings**: Stores user payment preferences and methods ([see USER-SETTINGS.md](../03-Features/USER-SETTINGS.md))
6. **Analytics**: Payment data tracked for financial insights and reporting
7. **Notifications**: Payment status updates trigger notifications ([see NOTIFICATIONS.md](../03-Features/NOTIFICATIONS.md))
8. **Admin Dashboard**: Platform-wide payment monitoring ([see ADMIN-DASHBOARD.md](../03-Features/ADMIN-DASHBOARD.md))
9. **Database Schema**: Payment data stored in Supabase tables ([see DATABASE-SCHEMA.md](../04-Backend/DATABASE-SCHEMA.md))
10. **Security Report**: Payment security considerations detailed in [Security Report](../04-Backend/SECURITY-REPORT.md)