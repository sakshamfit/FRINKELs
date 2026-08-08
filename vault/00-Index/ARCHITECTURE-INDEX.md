# FRINKELs Clean Architecture & State Management Index (`ARCHITECTURE_INDEX.md`)

This document defines the architectural boundaries, Clean Architecture patterns, and state management rules governing the FRINKELs platform.

---

## 🏛️ Clean Architecture Layers

FRINKELs follows a **Feature-First Clean Architecture** layout:

```
lib/features/<feature_name>/
├── domain/
│   ├── entities/       <- Pure immutable Dart data models (Equatable)
│   ├── repositories/   <- Abstract interface contracts
│   └── usecases/       <- Encapsulated business logic use-cases
├── data/
│   ├── datasources/    <- Remote (Supabase) & Local (Hive) data sources
│   ├── models/         <- Data Transfer Objects (DTOs) with json_serializable
│   └── repositories/   <- Concrete repository implementations
└── presentation/
    ├── controllers/    <- Riverpod StateNotifier & StateProvider
    ├── screens/        <- Screen UI widgets (ConsumerStatefulWidget)
    └── widgets/        <- Isolated component widgets
```

---

## 📐 Governance & Code Rules

1. **Strict Dependency Flow**:
   `Presentation Layer -> Domain Layer <- Data Layer`.
   The Domain layer contains pure business logic and contracts with ZERO external framework dependencies (no Flutter UI, no Supabase SDK).
2. **State Management Protocol**:
   - Use `StateNotifierProvider.autoDispose` for screen-scoped state.
   - Use `ref.watch(provider.select((s) => s.specificField))` to prevent unwanted widget rebuilds.
3. **Repository Pattern Protocol**:
   - All network and storage calls return `Either<Failure, T>` from the `dartz` package.
   - Catch all platform exceptions in `RemoteDataSource` and wrap them in strongly-typed `Failure` objects (`ServerFailure`, `CacheFailure`, `AuthenticationFailure`).
