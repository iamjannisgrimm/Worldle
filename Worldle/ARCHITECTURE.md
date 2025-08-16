# Architecture Guide

## MVVM Pattern Implementation

### Models (`Models/`)
- **Pure data structures** with no business logic
- **Immutable when possible** using `let` properties
- **Protocol conformance** for Identifiable, Equatable, etc.
- **Single responsibility** - each model represents one concept

### Views (`Views/`)
- **Declarative SwiftUI** components
- **No business logic** - delegate to ViewModels
- **Computed properties** for derived data
- **Bindings** for two-way data flow

### ViewModels (`ViewModels/`)
- **ObservableObject** for state management
- **@Published properties** for reactive updates
- **Business logic coordination** between services
- **Input validation** and error handling
- **@MainActor** for UI thread safety

### Services (`Services/`)
- **Protocol-based** for dependency injection
- **Single responsibility** principle
- **Error handling** with custom error types
- **Async/await** for modern concurrency
- **Thread-safe** operations

## Data Flow

```
User Input → View → ViewModel → Service → External API/Storage
                ↓
User Interface ← Published State ← Business Logic ← Data Response
```

## Key Principles

1. **Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Injection**: ViewModels accept service protocols
3. **Testability**: Protocol-based design enables easy mocking
4. **Reactive UI**: @Published properties drive UI updates
5. **Error Handling**: Comprehensive error types and handling
6. **Documentation**: Every public interface is documented

## Folder Organization

- **Logical grouping** by architectural layer
- **Components subfolder** for reusable UI elements
- **Legacy subfolder** for deprecated code
- **Clear naming** following Swift conventions

## Best Practices Followed

- ✅ Protocol-oriented programming
- ✅ Modern Swift concurrency (async/await)
- ✅ SwiftUI best practices
- ✅ SOLID principles
- ✅ Clean architecture
- ✅ Comprehensive documentation
- ✅ Error handling patterns
- ✅ Thread safety considerations