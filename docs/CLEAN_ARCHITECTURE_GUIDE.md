# Clean Architecture Implementation Guide

This guide explains how to implement new features following Clean Architecture principles with Dio, Flutter Cubit, and Fpdart.

## Table of Contents

1. [Architecture Overview](#architecture-overview)
2. [Understanding Entities, Models, DTOs, and Use Cases](#understanding-entities-models-dtos-and-use-cases)
3. [When to Use Cubit vs Local State](#when-to-use-cubit-vs-local-state)
4. [When to Use Exceptions vs Failures](#when-to-use-exceptions-vs-failures)
5. [Freezed Setup for Entities, Models, and DTOs](#freezed-setup-for-entities-models-and-dtos)
6. [Step-by-Step Feature Implementation](#step-by-step-feature-implementation)
7. [Complete Example: User Profile Feature](#complete-example-user-profile-feature)
8. [Dependency Injection Setup](#dependency-injection-setup)
9. [Best Practices](#best-practices)

---

## Architecture Overview

### Layer Structure

```
lib/features/{feature_name}/
  ├── domain/              # Business logic (no dependencies on data/presentation)
  │   ├── entities/        # Pure Dart classes
  │   ├── repositories/    # Abstract interfaces
  │   └── usecases/        # Business logic operations
  ├── data/                # Data sources and implementations
  │   ├── models/          # JSON serialization (extends entities)
  │   ├── datasources/     # API calls, local storage
  │   └── repositories/    # Repository implementations
  └── presentation/        # UI layer
      ├── cubit/           # State management
      └── pages/           # UI screens
```

### Data Flow

```
UI (Cubit/Local State) → Use Case → Repository Interface → Repository Implementation → Data Source → API
                ↓
            Result<Entity> (Either<Failure, Entity>)
```

---

## Understanding Entities, Models, DTOs, and Use Cases

### **Entity** (Domain Layer)

- **What**: Pure business object representing a domain concept
- **Where**: `lib/features/{feature}/domain/entities/`
- **Characteristics**:
  - No dependencies on external libraries (except Freezed)
  - Represents business logic concepts
  - Immutable (using Freezed)
  - Used throughout the app for business logic
- **Example**: `User`, `Product`, `Order`

**File**: `lib/features/users/domain/entities/user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
  }) = _User;
}
```

### **Model** (Data Layer)

- **What**: Data representation for API/storage - extends or implements Entity
- **Where**: `lib/features/{feature}/data/models/`
- **Characteristics**:
  - Handles JSON serialization/deserialization
  - Maps API response format to Entity
  - Can have different field names than Entity (e.g., `avatar_url` vs `avatarUrl`)
  - Converts to Entity via `toEntity()` method
- **Example**: `UserModel`, `ProductModel`

**File**: `lib/features/users/data/models/user_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl, // API uses snake_case
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}
```

### **DTO (Data Transfer Object)** (Domain Layer)

- **What**: Objects used to transfer data between layers, especially for use case parameters
- **Where**: `lib/features/{feature}/domain/dtos/`
- **Types**:
  - **Request DTO**: Input parameters for use cases (e.g., `CreateUserRequest`, `UpdateUserRequest`)
  - **Response DTO**: Output structure from use cases (optional, usually just return Entity)
- **Characteristics**:
  - Immutable (using Freezed)
  - Validates input data
  - Encapsulates related parameters
  - Reduces method parameter lists
- **When to Use**:
  - ✅ Use case has 3+ parameters → Create Request DTO
  - ✅ Complex validation needed → Create Request DTO
  - ✅ Parameters are related → Group in Request DTO
  - ✅ API request body structure → Create Request DTO

**Example - Request DTO**: `lib/features/users/domain/dtos/create_user_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_request.freezed.dart';

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String name,
    required String email,
    String? password,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) = _CreateUserRequest;
}
```

**Example - Response DTO** (if needed): `lib/features/users/domain/dtos/user_response.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';

@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required User user,
    required DateTime createdAt,
    String? token,
  }) = _UserResponse;
}
```

### **Use Case** (Domain Layer)

- **What**: Single business operation/action
- **Where**: `lib/features/{feature}/domain/usecases/`
- **Characteristics**:
  - One use case = one business operation
  - Takes DTOs or simple parameters
  - Returns `Result<T>` (Either<Failure, Entity>)
  - Contains business logic validation
  - No dependencies on data/presentation layers
  - **Should implement `UseCase<Type, Params>` or `UseCaseNoParams<Type>`** for consistency
- **Naming**: Verb + Noun (e.g., `GetUser`, `CreateUser`, `UpdateUser`, `DeleteUser`)

**Base Use Case Classes:**

All use cases should extend the base use case classes for consistent behavior:

```dart
// lib/core/domain/usecases/base_usecase.dart
abstract class UseCase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

abstract class UseCaseNoParams<Type> {
  Future<Result<Type>> call();
}
```

**Example - Simple Use Case** (1-2 parameters):

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class GetUser implements UseCase<User, String> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Result<User>> call(String id) async {
    if (id.isEmpty) {
      return Left(ValidationFailure.missingField('id'));
    }
    return await repository.getUser(id);
  }
}
```

**Example - Use Case with Request DTO** (3+ parameters):

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/dtos/create_user_request.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class CreateUser implements UseCase<User, CreateUserRequest> {
  final UserRepository repository;

  CreateUser(this.repository);

  @override
  Future<Result<User>> call(CreateUserRequest request) async {
    // Business logic validation
    if (request.name.isEmpty) {
      return Left(ValidationFailure.missingField('name'));
    }

    if (request.email.isEmpty || !request.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }

    return await repository.createUser(request);
  }
}
```

**Example - Use Case with No Parameters:**

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class GetUsers implements UseCaseNoParams<List<User>> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Result<List<User>>> call() async {
    return await repository.getUsers();
  }
}
```

**Example - Use Case with Unit (for void operations):**

```dart
import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class DeleteUser implements UseCase<Unit, String> {
  final UserRepository repository;

  DeleteUser(this.repository);

  @override
  Future<Result<Unit>> call(String id) async {
    if (id.isEmpty) {
      return Left(ValidationFailure.missingField('id'));
    }

    final result = await repository.deleteUser(id);
    // Return Unit on success
    return result.map((_) => unit);
  }
}
```

**Why Use `Unit` Instead of `void`?**

- ✅ **Type Safety**: `Result<Unit>` is a proper type that works with `Either<Failure, Unit>`
- ✅ **Functional Programming**: `Unit` represents a value that carries no information (like `void`), but is a proper type
- ✅ **Composability**: You can use `map`, `flatMap`, and other functional operations on `Result<Unit>`
- ✅ **Consistency**: All use cases return `Result<T>`, even when there's no return value

**Usage in Cubit:**

```dart
class UserCubit extends Cubit<UserState> {
  final DeleteUser deleteUser;

  Future<void> deleteUserById(String id) async {
    emit(const UserState.loading());
    final result = await deleteUser(id);
    result.fold(
      (failure) => emit(UserState.error(failure.message)),
      (_) => emit(const UserState.deleted()), // Use _ to ignore Unit value
    );
  }
}
```

### **Key Differences Summary**

| Aspect      | Entity            | Model              | Request DTO         | Response DTO                 |
| ----------- | ----------------- | ------------------ | ------------------- | ---------------------------- |
| **Layer**   | Domain            | Data               | Domain              | Domain                       |
| **Purpose** | Business concept  | API representation | Use case input      | Use case output (optional)   |
| **JSON**    | ❌ No             | ✅ Yes             | ❌ No               | ❌ No (if needed, use Model) |
| **Used By** | Use cases, Cubits | Data sources       | Use cases           | Use cases                    |
| **Example** | `User`            | `UserModel`        | `CreateUserRequest` | `UserResponse`               |

### **Data Flow with DTOs**

```
UI → Use Case (with Request DTO) → Repository Interface
                                      ↓
                            Repository Implementation
                                      ↓
                            Data Source (converts DTO to Model)
                                      ↓
                            API (sends Model as JSON)
```

**Example Flow:**

```dart
// 1. UI creates Request DTO
final request = CreateUserRequest(
  name: 'John',
  email: 'john@example.com',
  password: 'password123',
);

// 2. Use Case receives Request DTO
final result = await createUser(request);

// 3. Repository receives Request DTO, converts to Model for API
Future<Result<User>> createUser(CreateUserRequest request) async {
  return await executeWithErrorHandling<User>(
    () async {
      // Convert Request DTO to Model for API call
      final userModel = UserModel(
        id: '', // Will be generated by server
        name: request.name,
        email: request.email,
      );
      final created = await remoteDataSource.createUser(userModel);
      return created.toEntity();
    },
  );
}
```

---

## When to Use Cubit vs Local State

### **Use Cubit/Bloc When:**

- ✅ State needs to be **shared across multiple screens/widgets**
- ✅ State needs to **persist across navigation**
- ✅ State needs to be **accessed from different parts of the app**
- ✅ Complex state management with multiple events/actions
- ✅ State that needs to be **tested independently**

**Examples:**

- User authentication state (logged in/out)
- Shopping cart state
- Theme settings
- Global app configuration
- User profile data (shared across screens)

### **Use Local State (StatefulWidget/ValueNotifier) When:**

- ✅ State is **only used in a single widget/screen**
- ✅ Simple form inputs (text fields, checkboxes)
- ✅ UI-only state (expanded/collapsed, selected tab)
- ✅ Temporary state that doesn't need to persist
- ✅ State that's **not shared** with other widgets

**Examples:**

- Form input fields
- Dropdown selections
- Toggle switches (UI only)
- Scroll position
- Animation controllers

### **Decision Flow:**

```
Is state shared across multiple screens?
  ├─ YES → Use Cubit/Bloc
  └─ NO → Is it complex state with multiple actions?
      ├─ YES → Use Cubit/Bloc
      └─ NO → Use Local State (StatefulWidget/ValueNotifier)
```

### **Example: When NOT to Use Cubit**

```dart
// ❌ DON'T: Simple form with local state
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(controller: _emailController),
          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
          ),
          IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ],
      ),
    );
  }
}
```

### **Example: When to Use Cubit**

```dart
// ✅ DO: Shared authentication state
class AuthCubit extends Cubit<AuthState> {
  final LoginUser loginUser;

  AuthCubit({required this.loginUser}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await loginUser(email, password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}

// Used across multiple screens
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return Text('Welcome ${state.user.name}');
        }
        return LoginButton();
      },
    );
  }
}
```

---

## When to Use Exceptions vs Failures

### **Exceptions** (Data Layer)

- **Where**: Used in **data layer** (data sources, repository implementations)
- **When**:
  - Network calls fail (Dio throws exceptions)
  - Local storage operations fail
  - Data parsing fails
  - Any technical/implementation error

**Example:**

```dart
// In data source
try {
  final response = await dioClient.get('/users');
  return UserModel.fromJson(response.data);
} on DioException catch (e) {
  // DioClient already converts to AppException
  throw ServerException(message: 'Failed to fetch user');
}
```

### **Failures** (Domain/Presentation Layer)

- **Where**: Used in **domain layer** (use cases, repository interfaces) and **presentation layer** (Cubit)
- **When**:
  - Business logic validation fails
  - Use case operations fail
  - UI needs to display error messages
  - Returning `Result<T>` (Either<Failure, T>)

**Example:**

```dart
// In repository implementation
Future<Result<User>> getUser(String id) async {
  return await executeWithErrorHandling<User>(
    () async {
      final user = await remoteDataSource.getUser(id);
      return user.toEntity();
    },
  );
  // executeWithErrorHandling automatically converts exceptions to failures
}
```

### **Key Rule**

- **Data Layer**: Throw **Exceptions** → Caught and converted to **Failures**
- **Domain/Presentation Layer**: Return **Result<T>** (Either<Failure, T>)

---

## Freezed Setup for Entities, Models, and DTOs

We use **Freezed** for immutable data classes with code generation. This provides:

- ✅ Immutability
- ✅ Value equality
- ✅ Copy methods
- ✅ JSON serialization (with json_serializable) - for Models only
- ✅ Union types for states
- ✅ Reduced boilerplate code

### When to Use Freezed vs When NOT to Use Freezed

#### ✅ **USE Freezed For:**

1. **Entities** (Domain Layer)

   - ✅ Always use Freezed for entities
   - ✅ They represent business concepts and need immutability
   - ✅ Value equality is important for comparisons
   - **Example**: `User`, `Product`, `Order`

2. **Models** (Data Layer)

   - ✅ Always use Freezed for models
   - ✅ Need JSON serialization/deserialization
   - ✅ Need to convert to/from entities
   - **Example**: `UserModel`, `ProductModel`

3. **Request DTOs** (Domain Layer)

   - ✅ Use Freezed when DTO has 3+ fields
   - ✅ Use Freezed when you need `copyWith` for partial updates
   - ✅ Use Freezed when validation logic is complex
   - **Example**: `CreateUserRequest`, `UpdateUserRequest`

4. **Response DTOs** (Domain Layer)

   - ✅ Use Freezed when response has multiple fields
   - ✅ Use Freezed when response structure is complex
   - **Example**: `UserResponse`, `LoginResponse`

5. **Cubit/Bloc States**

   - ✅ Always use Freezed for state classes
   - ✅ Union types provide exhaustive pattern matching
   - ✅ Type-safe state management
   - **Example**: `UserState`, `AuthState`

6. **Complex Value Objects**
   - ✅ Use Freezed for value objects that need immutability
   - ✅ Use when you need value equality
   - **Example**: `Money`, `Address`, `DateRange`

#### ❌ **DON'T Use Freezed For:**

1. **Simple Value Types**

   - ❌ Don't use Freezed for primitive wrappers
   - ❌ Don't use Freezed for single-field classes
   - **Example**:

     ```dart
     // ❌ BAD: Overkill for simple wrapper
     @freezed
     class UserId with _$UserId {
       const factory UserId(String value) = _UserId;
     }

     // ✅ GOOD: Just use String directly
     String userId;
     ```

2. **Use Cases**

   - ❌ Don't use Freezed for use case classes
   - ❌ Use cases are classes with behavior, not data
   - **Example**: `GetUser`, `CreateUser` (these are classes, not Freezed)

3. **Repositories**

   - ❌ Don't use Freezed for repository interfaces/implementations
   - ❌ These are contracts/implementations, not data structures
   - **Example**: `UserRepository`, `UserRepositoryImpl`

4. **Services/Utilities**

   - ❌ Don't use Freezed for service classes or utility classes
   - ❌ These contain behavior, not data
   - **Example**: `AuthService`, `ValidationUtils`

5. **Simple Enums**

   - ❌ Don't use Freezed for simple enums (use Dart's built-in enum)
   - ✅ Only use Freezed for enums if you need associated data
   - **Example**:

     ```dart
     // ❌ BAD: Simple enum doesn't need Freezed
     @freezed
     class Status with _$Status {
       const factory Status.pending() = _Pending;
       const factory Status.loading() = _Loading;
       const factory Status.success() = _Success;
     }

     // ✅ GOOD: Use Dart enum
     enum Status { pending, loading, success }

     // ✅ GOOD: Use Freezed if enum has associated data
     @freezed
     class Status with _$Status {
       const factory Status.pending() = _Pending;
       const factory Status.loading() = _Loading;
       const factory Status.success(String data) = _Success;
     }
     ```

6. **Simple Request DTOs** (1-2 fields)

   - ❌ Don't use Freezed for very simple DTOs
   - ✅ Use regular classes or just pass parameters directly
   - **Example**:

     ```dart
     // ❌ BAD: Too simple for Freezed
     @freezed
     class GetUserRequest with _$GetUserRequest {
       const factory GetUserRequest(String id) = _GetUserRequest;
     }

     // ✅ GOOD: Just pass String directly
     Future<Result<User>> getUser(String id) async { ... }
     ```

7. **Temporary/Internal Data Structures**
   - ❌ Don't use Freezed for temporary data that's only used internally
   - ✅ Use regular classes or maps
   - **Example**: Internal caching structures, temporary calculations

#### **Decision Tree:**

```
Is it a data structure?
├─ No → Don't use Freezed (use case, repository, service, etc.)
└─ Yes → Does it need immutability/value equality?
    ├─ No → Don't use Freezed (temporary data, simple wrappers)
    └─ Yes → Does it have 3+ fields or complex structure?
        ├─ No → Consider if Freezed benefits outweigh setup cost
        └─ Yes → ✅ Use Freezed
```

#### **Quick Reference:**

| Type                     | Use Freezed? | Reason                                  |
| ------------------------ | ------------ | --------------------------------------- |
| Entity                   | ✅ Always    | Business concepts need immutability     |
| Model                    | ✅ Always    | JSON serialization + immutability       |
| Request DTO (3+ fields)  | ✅ Yes       | Reduces boilerplate, enables copyWith   |
| Request DTO (1-2 fields) | ❌ No        | Overkill, just use parameters           |
| Response DTO             | ✅ Usually   | Complex structures benefit from Freezed |
| Cubit State              | ✅ Always    | Union types + pattern matching          |
| Use Case                 | ❌ No        | Behavior class, not data                |
| Repository               | ❌ No        | Contract/implementation, not data       |
| Simple Enum              | ❌ No        | Use Dart enum                           |
| Enum with Data           | ✅ Yes       | Freezed supports associated data        |
| Value Object             | ✅ Usually   | Immutability + value equality           |
| Simple Wrapper           | ❌ No        | Overkill for single field               |

### Setup

1. **Add dependencies** (already in `pubspec.yaml`):

   - `freezed_annotation: ^2.4.1`
   - `json_annotation: ^4.9.0`
   - `build_runner: ^2.4.13` (dev)
   - `freezed: ^2.5.7` (dev)
   - `json_serializable: ^6.8.0` (dev)

2. **Run code generation**:

   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

   For watch mode (auto-regenerate on file changes):

   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

### Entity with Freezed

**File**: `lib/features/users/domain/entities/user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
  }) = _User;
}
```

**Generated file**: `user.freezed.dart` (auto-generated)

**Usage:**

```dart
// Create
final user = User(id: '1', name: 'John', email: 'john@example.com');

// Copy with changes
final updatedUser = user.copyWith(name: 'Jane');

// Equality
final user1 = User(id: '1', name: 'John', email: 'john@example.com');
final user2 = User(id: '1', name: 'John', email: 'john@example.com');
print(user1 == user2); // true
```

### Model with Freezed (with JSON serialization)

**File**: `lib/features/users/data/models/user_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Extension to convert model to entity
extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}
```

**Generated files**:

- `user_model.freezed.dart` (immutability, equality, copy)
- `user_model.g.dart` (JSON serialization)

**Usage:**

```dart
// From JSON
final userModel = UserModel.fromJson({
  'id': '1',
  'name': 'John',
  'email': 'john@example.com',
  'avatar_url': 'https://example.com/avatar.jpg',
});

// To JSON
final json = userModel.toJson();

// To Entity
final user = userModel.toEntity();
```

### Request DTO with Freezed

**File**: `lib/features/users/domain/dtos/create_user_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_request.freezed.dart';

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String name,
    required String email,
    String? password,
    String? phoneNumber,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
  }) = _CreateUserRequest;
}
```

**Generated file**: `create_user_request.freezed.dart` (auto-generated)

**Usage:**

```dart
// Create request
final request = CreateUserRequest(
  name: 'John Doe',
  email: 'john@example.com',
  password: 'secure123',
);

// Copy with changes (Freezed generates copyWith automatically)
final updated = request.copyWith(phoneNumber: '+1234567890');

// Use in use case
final result = await createUser(request);
```

### Response DTO with Freezed (Optional)

**File**: `lib/features/users/domain/dtos/user_response.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_response.freezed.dart';

@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required User user,
    required DateTime createdAt,
    String? accessToken,
    String? refreshToken,
  }) = _UserResponse;
}
```

**Usage:**

```dart
// Create response
final response = UserResponse(
  user: user,
  createdAt: DateTime.now(),
  accessToken: 'token123',
);

// Access properties
final user = response.user;
final token = response.accessToken;
```

### Cubit States with Freezed

**File**: `lib/features/users/presentation/cubit/user_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(User user) = _Loaded;
  const factory UserState.usersLoaded(List<User> users) = _UsersLoaded;
  const factory UserState.error(String message) = _Error;
}
```

**Usage in Cubit:**

```dart
class UserCubit extends Cubit<UserState> {
  Future<void> loadUser(String id) async {
    emit(const UserState.loading());
    final result = await getUser(id);
    result.fold(
      (failure) => emit(UserState.error(failure.message)),
      (user) => emit(UserState.loaded(user)),
    );
  }
}
```

**Usage in UI:**

```dart
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    return state.when(
      initial: () => const SizedBox(),
      loading: () => const CircularProgressIndicator(),
      loaded: (user) => Text(user.name),
      usersLoaded: (users) => ListView.builder(...),
      error: (message) => Text('Error: $message'),
    );
  },
)
```

---

## Step-by-Step Feature Implementation

### Step 1: Domain Layer - Entity (with Freezed)

Create an immutable entity using Freezed.

**File**: `lib/features/users/domain/entities/user.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? avatarUrl,
  }) = _User;
}
```

**Run code generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 2: Domain Layer - Repository Interface

Define the contract (abstract class) that the data layer will implement.

**File**: `lib/features/users/domain/repositories/user_repository.dart`

```dart
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/dtos/create_user_request.dart';
import 'package:nashik/features/users/domain/dtos/update_user_request.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

abstract class UserRepository extends BaseRepository {
  Future<Result<User>> getUser(String id);
  Future<Result<List<User>>> getUsers();
  Future<Result<User>> createUser(CreateUserRequest request);
  Future<Result<User>> updateUser(UpdateUserRequest request);
  Future<Result<Unit>> deleteUser(String id);
}
```

### Step 3: Domain Layer - DTOs (Optional but Recommended)

Create Request DTOs for use cases with multiple parameters to avoid boilerplate.

**File**: `lib/features/users/domain/dtos/create_user_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_request.freezed.dart';

@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String name,
    required String email,
    String? password,
    String? phoneNumber,
  }) = _CreateUserRequest;
}
```

**File**: `lib/features/users/domain/dtos/update_user_request.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_request.freezed.dart';

@freezed
class UpdateUserRequest with _$UpdateUserRequest {
  const factory UpdateUserRequest({
    required String id,
    String? name,
    String? email,
    String? avatarUrl,
  }) = _UpdateUserRequest;
}
```

**Run code generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 4: Domain Layer - Use Cases

Encapsulate business logic. Each use case does one thing. **All use cases should implement the base use case classes** for consistent behavior.

**Simple Use Case** (1-2 parameters - no DTO needed):

**File**: `lib/features/users/domain/usecases/get_user.dart`

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class GetUser implements UseCase<User, String> {
  final UserRepository repository;

  GetUser(this.repository);

  @override
  Future<Result<User>> call(String id) async {
    // Business logic validation
    if (id.isEmpty) {
      return Left(ValidationFailure.missingField('id'));
    }

    return await repository.getUser(id);
  }
}
```

**Use Case with Request DTO** (3+ parameters - use DTO):

**File**: `lib/features/users/domain/usecases/create_user.dart`

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/dtos/create_user_request.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class CreateUser implements UseCase<User, CreateUserRequest> {
  final UserRepository repository;

  CreateUser(this.repository);

  @override
  Future<Result<User>> call(CreateUserRequest request) async {
    // Business logic validation
    if (request.name.isEmpty) {
      return Left(ValidationFailure.missingField('name'));
    }

    if (request.email.isEmpty || !request.email.contains('@')) {
      return Left(ValidationFailure.invalidInput('email'));
    }

    return await repository.createUser(request);
  }
}
```

**Use Case with No Parameters:**

**File**: `lib/features/users/domain/usecases/get_users.dart`

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class GetUsers implements UseCaseNoParams<List<User>> {
  final UserRepository repository;

  GetUsers(this.repository);

  @override
  Future<Result<List<User>>> call() async {
    return await repository.getUsers();
  }
}
```

### Step 4: Data Layer - Model (with Freezed)

Create model with JSON serialization using Freezed.

**File**: `lib/features/users/data/models/user_model.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// Extension to convert model to entity
extension UserModelX on UserModel {
  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}
```

**Run code generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Step 5: Data Layer - Remote Data Source

Handles API calls. **Throws exceptions** (not failures).

**File**: `lib/features/users/data/datasources/user_remote_datasource.dart`

```dart
import 'package:dio/dio.dart';
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/core/error/exceptions/app_exception.dart';
import 'package:nashik/features/users/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String id);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUser(String id) async {
    try {
      // DioClient throws AppException (ServerException, NetworkException)
      final response = await dioClient.get('/users/$id');
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      // Re-throw - DioClient already converted to AppException
      rethrow;
    } on AppException {
      // Re-throw AppException
      rethrow;
    } catch (e) {
      // Catch any unexpected errors
      throw ServerException(
        message: 'Failed to get user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await dioClient.get('/users');
      if (response.data is List) {
        return (response.data as List)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to get users: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await dioClient.post(
        '/users',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to create user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await dioClient.put(
        '/users/${user.id}',
        data: user.toJson(),
      );
      return UserModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to update user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }

  @override
  Future<void> deleteUser(String id) async {
    try {
      await dioClient.delete('/users/$id');
    } on DioException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(
        message: 'Failed to delete user: ${e.toString()}',
        code: 'UNEXPECTED_ERROR',
      );
    }
  }
}
```

### Step 6: Data Layer - Repository Implementation

Implements the repository interface. **Converts exceptions to failures** using `executeWithErrorHandling`.

**File**: `lib/features/users/data/repositories/user_repository_impl.dart`

```dart
import 'package:fpdart/fpdart.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/data/datasources/user_remote_datasource.dart';
import 'package:nashik/features/users/domain/entities/user.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<User>> getUser(String id) async {
    // executeWithErrorHandling automatically:
    // 1. Catches AppException
    // 2. Converts to Failure using mapExceptionToFailure
    // 3. Returns Either<Failure, User>
    return await executeWithErrorHandling<User>(
      () async {
        final user = await remoteDataSource.getUser(id);
        return user.toEntity(); // Convert model to entity
      },
    );
  }

  @override
  Future<Result<List<User>>> getUsers() async {
    return await executeWithErrorHandling<List<User>>(
      () async {
        final users = await remoteDataSource.getUsers();
        return users.map((model) => model.toEntity()).toList();
      },
    );
  }

  @override
  Future<Result<User>> createUser(CreateUserRequest request) async {
    return await executeWithErrorHandling<User>(
      () async {
        // Convert Request DTO to Model for API call
        final userModel = UserModel(
          id: '', // Will be generated by server
          name: request.name,
          email: request.email,
        );
        final created = await remoteDataSource.createUser(userModel);
        return created.toEntity();
      },
    );
  }

  @override
  Future<Result<User>> updateUser(UpdateUserRequest request) async {
    return await executeWithErrorHandling<User>(
      () async {
        // Convert Request DTO to Model for API call
        final userModel = UserModel(
          id: request.id,
          name: request.name ?? '',
          email: request.email ?? '',
          avatarUrl: request.avatarUrl,
        );
        final updatedUser = await remoteDataSource.updateUser(userModel);
        return updatedUser.toEntity();
      },
    );
  }

  @override
  Future<Result<Unit>> deleteUser(String id) async {
    return await executeWithErrorHandling<Unit>(
      () async {
        await remoteDataSource.deleteUser(id);
        return unit; // Return Unit from fpdart
      },
    );
  }
}
```

### Step 7: Presentation Layer - Cubit (with Freezed States)

**Note**: Only create Cubit if state needs to be **globally shared**. For local state, use `StatefulWidget` or `ValueNotifier`.

Manages state using Cubit with Freezed union types. Handles `Result<T>` from use cases.

**File**: `lib/features/users/presentation/cubit/user_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nashik/features/users/domain/entities/user.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  const factory UserState.initial() = _Initial;
  const factory UserState.loading() = _Loading;
  const factory UserState.loaded(User user) = _Loaded;
  const factory UserState.usersLoaded(List<User> users) = _UsersLoaded;
  const factory UserState.error(String message) = _Error;
}
```

**Run code generation:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**File**: `lib/features/users/presentation/cubit/user_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/features/users/domain/usecases/get_user.dart';
import 'package:nashik/features/users/domain/usecases/get_users.dart';
import 'package:nashik/features/users/presentation/cubit/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUser getUser;
  final GetUsers getUsers;

  UserCubit({
    required this.getUser,
    required this.getUsers,
  }) : super(const UserState.initial());

  Future<void> loadUser(String id) async {
    emit(const UserState.loading());

    final result = await getUser(id);

    // Handle Result using fold
    result.fold(
      (failure) => emit(UserState.error(failure.message)),
      (user) => emit(UserState.loaded(user)),
    );
  }

  Future<void> loadUsers() async {
    emit(const UserState.loading());

    final result = await getUsers();

    result.fold(
      (failure) => emit(UserState.error(failure.message)),
      (users) => emit(UserState.usersLoaded(users)),
    );
  }
}
```

### Step 8: Presentation Layer - UI Page

**File**: `lib/features/users/presentation/pages/users_page.dart`

**Using Freezed States with `when` method:**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nashik/core/get_it/get_it.dart';
import 'package:nashik/features/users/presentation/cubit/user_cubit.dart';
import 'package:nashik/features/users/presentation/cubit/user_state.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator<UserCubit>()..loadUsers(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Users')),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            // Using Freezed's when method for exhaustive pattern matching
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (user) => Center(child: Text('User: ${user.name}')),
              usersLoaded: (users) => ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    onTap: () {
                      // Navigate to user detail
                    },
                  );
                },
              ),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: $message'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserCubit>().loadUsers();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

**Alternative: Using pattern matching with `map` or `maybeWhen`:**

```dart
// Using map (exhaustive)
state.map(
  initial: (_) => const SizedBox.shrink(),
  loading: (_) => const CircularProgressIndicator(),
  loaded: (state) => Text('User: ${state.user.name}'),
  usersLoaded: (state) => ListView.builder(...),
  error: (state) => Text('Error: ${state.message}'),
);

// Using maybeWhen (non-exhaustive, with default)
state.maybeWhen(
  loading: () => const CircularProgressIndicator(),
  usersLoaded: (users) => ListView.builder(...),
  orElse: () => const SizedBox.shrink(),
);
```

### Step 9: Local State Example (When NOT to Use Cubit)

For simple forms or UI-only state, use local state instead:

**File**: `lib/features/users/presentation/pages/user_form_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:nashik/core/get_it/get_it.dart';
import 'package:nashik/features/users/domain/usecases/create_user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final createUser = locator<CreateUser>();
    final result = await createUser(
      name: _nameController.text,
      email: _emailController.text,
    );

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (user) {
        Navigator.pop(context, user);
      },
    );

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email is required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Dependency Injection Setup

Register all dependencies in `lib/core/get_it/get_it.dart`:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/features/users/data/datasources/user_remote_datasource.dart';
import 'package:nashik/features/users/data/repositories/user_repository_impl.dart';
import 'package:nashik/features/users/domain/repositories/user_repository.dart';
import 'package:nashik/features/users/domain/usecases/get_user.dart';
import 'package:nashik/features/users/domain/usecases/get_users.dart';
import 'package:nashik/features/users/presentation/cubit/user_cubit.dart';

final locator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // ... existing registrations ...

  // ===== USERS FEATURE =====

  // 1. Data Sources
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(
      dioClient: locator<DioClient>(),
    ),
  );

  // 2. Repositories
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator<UserRemoteDataSource>(),
    ),
  );

  // 3. Use Cases
  locator.registerLazySingleton<GetUser>(
    () => GetUser(locator<UserRepository>()),
  );
  locator.registerLazySingleton<GetUsers>(
    () => GetUsers(locator<UserRepository>()),
  );

  // 4. Cubits (use registerFactory for Cubits - new instance per widget)
  locator.registerFactory<UserCubit>(
    () => UserCubit(
      getUser: locator<GetUser>(),
      getUsers: locator<GetUsers>(),
    ),
  );
}
```

---

## Complete Example: User Profile Feature

Here's a complete working example showing all layers:

### Domain Layer

**Entity**: `lib/features/users/domain/entities/user.dart`

```dart
class User {
  final String id;
  final String name;
  final String email;
  const User({required this.id, required this.name, required this.email});
}
```

**Repository Interface**: `lib/features/users/domain/repositories/user_repository.dart`

```dart
abstract class UserRepository extends BaseRepository {
  Future<Result<User>> getUser(String id);
}
```

**Use Case**: `lib/features/users/domain/usecases/get_user.dart`

```dart
import 'package:nashik/core/domain/usecases/base_usecase.dart';

class GetUser implements UseCase<User, String> {
  final UserRepository repository;
  GetUser(this.repository);

  @override
  Future<Result<User>> call(String id) => repository.getUser(id);
}
```

### Data Layer

**Model**: `lib/features/users/data/models/user_model.dart`

```dart
class UserModel extends User {
  UserModel({required super.id, required super.name, required super.email});
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(...);
  User toEntity() => User(id: id, name: name, email: email);
}
```

**Data Source**: `lib/features/users/data/datasources/user_remote_datasource.dart`

```dart
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;
  Future<UserModel> getUser(String id) async {
    final response = await dioClient.get('/users/$id');
    return UserModel.fromJson(response.data);
  }
}
```

**Repository Implementation**: `lib/features/users/data/repositories/user_repository_impl.dart`

```dart
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;
  Future<Result<User>> getUser(String id) async {
    return await executeWithErrorHandling<User>(
      () async => (await remoteDataSource.getUser(id)).toEntity(),
    );
  }
}
```

### Presentation Layer

**Cubit**: `lib/features/users/presentation/cubit/user_cubit.dart`

```dart
class UserCubit extends Cubit<UserState> {
  final GetUser getUser;
  Future<void> loadUser(String id) async {
    emit(UserLoading());
    (await getUser(id)).fold(
      (failure) => emit(UserError(failure.message)),
      (user) => emit(UserLoaded(user)),
    );
  }
}
```

---

## Best Practices

### 1. **Exception Handling Flow**

```
Data Source (throws Exception)
  → Repository Impl (catches, converts to Failure)
  → Use Case (returns Result<Entity>)
  → Cubit (handles Result, emits state)
```

### 2. **Always Use `executeWithErrorHandling`**

In repository implementations, always wrap data source calls:

```dart
return await executeWithErrorHandling<Entity>(
  () async => (await dataSource.getData()).toEntity(),
);
```

### 3. **Use `fold` in Cubits**

Always use `fold` to handle `Result<T>`:

```dart
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (entity) => emit(SuccessState(entity)),
);
```

### 4. **Always Implement Base Use Case Classes**

All use cases should implement `UseCase<Type, Params>` or `UseCaseNoParams<Type>` for consistency:

```dart
// ✅ GOOD: Implements base use case
class GetUser implements UseCase<User, String> {
  @override
  Future<Result<User>> call(String id) async { ... }
}

// ✅ GOOD: No parameters
class GetUsers implements UseCaseNoParams<List<User>> {
  @override
  Future<Result<List<User>>> call() async { ... }
}

// ❌ BAD: Doesn't implement base use case
class GetUser {
  Future<Result<User>> call(String id) async { ... }
}
```

**Benefits:**

- ✅ Consistent interface across all use cases
- ✅ Type safety with generics
- ✅ Easier to test and mock
- ✅ Clear contract for what a use case should do

### 5. **Use `Unit` Instead of `void` for Void Operations**

When a use case or repository method doesn't return a value, use `Unit` from `fpdart` instead of `void`:

```dart
import 'package:fpdart/fpdart.dart';

// ✅ GOOD: Use Unit for void operations
abstract class UserRepository extends BaseRepository {
  Future<Result<Unit>> deleteUser(String id);
}

// Implementation
@override
Future<Result<Unit>> deleteUser(String id) async {
  return await executeWithErrorHandling<Unit>(
    () async {
      await remoteDataSource.deleteUser(id);
      return unit; // Return Unit from fpdart
    },
  );
}

// Use case
class DeleteUser implements UseCase<Unit, String> {
  @override
  Future<Result<Unit>> call(String id) async {
    return await repository.deleteUser(id);
  }
}

// ❌ BAD: Don't use void
Future<Result<void>> deleteUser(String id); // Doesn't work properly with Either
```

**Why Use `Unit`?**

- ✅ **Type Safety**: `Result<Unit>` works properly with `Either<Failure, Unit>`
- ✅ **Functional Operations**: You can use `map`, `flatMap`, etc. on `Result<Unit>`
- ✅ **Consistency**: All methods return `Result<T>`, even when there's no value
- ✅ **Composability**: Works seamlessly with functional programming patterns

**Usage in Cubit:**

```dart
final result = await deleteUser(id);
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (_) => emit(DeletedState()), // Use _ to ignore Unit value
);
```

### 6. **Dependency Injection Order**

Register in this order:

1. Data Sources
2. Repositories
3. Use Cases
4. Cubits/Blocs

### 7. **Naming Conventions**

- **Entities**: `User`, `Product` (singular, PascalCase, use Freezed)
- **Models**: `UserModel`, `ProductModel` (ends with Model, use Freezed)
- **Request DTOs**: `CreateUserRequest`, `UpdateUserRequest` (verb + Entity + Request, use Freezed)
- **Response DTOs**: `UserResponse`, `LoginResponse` (Entity + Response, use Freezed, optional)
- **Repositories**: `UserRepository` (interface), `UserRepositoryImpl` (implementation)
- **Use Cases**: `GetUser`, `CreateUser` (verb + noun)
- **Cubits**: `UserCubit`, `ProductCubit` (only for shared state)
- **States**: `UserState` (use Freezed union types)

### 8. **Freezed Code Generation**

Always run build_runner after creating/updating Freezed classes:

```bash
# One-time build
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-regenerate on changes)
flutter pub run build_runner watch --delete-conflicting-outputs
```

**Required files for Freezed:**

- Entity: `user.dart` + `user.freezed.dart` (generated)
- Model: `user_model.dart` + `user_model.freezed.dart` + `user_model.g.dart` (generated)
- Request DTO: `create_user_request.dart` + `create_user_request.freezed.dart` (generated)
- Response DTO: `user_response.dart` + `user_response.freezed.dart` (generated, optional)
- State: `user_state.dart` + `user_state.freezed.dart` (generated)

### 9. **When to Use Cubit vs Local State**

**Use Cubit when:**

- State is shared across multiple screens
- State needs to persist across navigation
- Complex state with multiple actions

**Use Local State when:**

- State is only in one widget
- Simple form inputs
- UI-only state (toggles, selections)

### 10. **When to Use Freezed vs When NOT to Use Freezed**

See the detailed section [When to Use Freezed vs When NOT to Use Freezed](#when-to-use-freezed-vs-when-not-to-use-freezed) above.

**Quick Summary:**

- ✅ **Always use Freezed for**: Entities, Models, Cubit States, Complex DTOs (3+ fields)
- ❌ **Don't use Freezed for**: Use Cases, Repositories, Services, Simple Enums, Simple Wrappers (1-2 fields)

### 11. **Efficient DTO Usage (Avoiding Boilerplate)**

**Pattern 1: Use Freezed's `copyWith` for partial updates**

```dart
// Instead of creating new DTO with all fields
final updated = CreateUserRequest(
  name: request.name,
  email: request.email,
  password: request.password,
  phoneNumber: newPhoneNumber, // Only this changed
);

// Use copyWith (Freezed generates this automatically)
final updated = request.copyWith(phoneNumber: newPhoneNumber);
```

**Pattern 2: Use extensions for common conversions**

```dart
// Extension on Request DTO to convert to Model
extension CreateUserRequestX on CreateUserRequest {
  UserModel toModel() {
    return UserModel(
      id: '',
      name: name,
      email: email,
    );
  }
}

// Usage in repository
final userModel = request.toModel();
```

**Pattern 3: Use factory constructors for common cases**

```dart
@freezed
class CreateUserRequest with _$CreateUserRequest {
  const factory CreateUserRequest({
    required String name,
    required String email,
    String? password,
    String? phoneNumber,
  }) = _CreateUserRequest;

  // Factory for quick creation
  factory CreateUserRequest.simple({
    required String name,
    required String email,
  }) {
    return CreateUserRequest(name: name, email: email);
  }
}
```

**Pattern 4: Combine related DTOs**

```dart
// Instead of separate DTOs for each operation
@freezed
class UserRequest with _$UserRequest {
  const factory UserRequest.create({
    required String name,
    required String email,
  }) = CreateUserRequest;

  const factory UserRequest.update({
    required String id,
    String? name,
    String? email,
  }) = UpdateUserRequest;
}
```

### 12. **Error Messages**

- Failures should have user-friendly messages
- Exceptions can have technical details (for logging)

### 13. **Testing**

- Test use cases with mock repositories
- Test repository implementations with mock data sources
- Test Cubits with mock use cases

---

## Quick Reference

### Import Statements

**Domain Layer:**

```dart
import 'package:fpdart/fpdart.dart'; // For Unit
import 'package:nashik/core/utils/result.dart';
import 'package:nashik/core/domain/repositories/base_repository.dart';
import 'package:nashik/core/domain/usecases/base_usecase.dart';
```

**Data Layer:**

```dart
import 'package:fpdart/fpdart.dart'; // For Unit (if needed)
import 'package:nashik/core/dio/config.dart';
import 'package:nashik/core/error/exceptions/app_exception.dart';
import 'package:nashik/core/utils/result.dart';
```

**Presentation Layer:**

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nashik/core/utils/result.dart';
```

### Common Patterns

**Repository Implementation Pattern:**

```dart
@override
Future<Result<Entity>> getEntity(String id) async {
  return await executeWithErrorHandling<Entity>(
    () async => (await remoteDataSource.getEntity(id)).toEntity(),
  );
}
```

**Cubit Pattern (with Freezed):**

```dart
Future<void> loadData() async {
  emit(const UserState.loading());
  final result = await useCase();
  result.fold(
    (failure) => emit(UserState.error(failure.message)),
    (data) => emit(UserState.loaded(data)),
  );
}
```

**Use Case with Unit (for void operations):**

```dart
import 'package:fpdart/fpdart.dart';

class DeleteUser implements UseCase<Unit, String> {
  @override
  Future<Result<Unit>> call(String id) async {
    return await repository.deleteUser(id);
  }
}

// In repository
Future<Result<Unit>> deleteUser(String id) async {
  return await executeWithErrorHandling<Unit>(
    () async {
      await remoteDataSource.deleteUser(id);
      return unit; // Return Unit from fpdart
    },
  );
}

// In Cubit
final result = await deleteUser(id);
result.fold(
  (failure) => emit(ErrorState(failure.message)),
  (_) => emit(DeletedState()), // Use _ to ignore Unit value
);
```

**Local State Pattern (when NOT using Cubit):**

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  bool _isLoading = false;
  String? _error;

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await useCase();
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (data) => setState(() {
        // Handle success
        _isLoading = false;
      }),
    );
  }
}
```

**Use Case with Request DTO Pattern:**

```dart
// In UI
final request = CreateUserRequest(
  name: _nameController.text,
  email: _emailController.text,
  password: _passwordController.text,
);
final result = await createUser(request);

// In Use Case
Future<Result<User>> call(CreateUserRequest request) async {
  // Validation
  if (request.name.isEmpty) {
    return Left(ValidationFailure.missingField('name'));
  }
  return await repository.createUser(request);
}

// In Repository
Future<Result<User>> createUser(CreateUserRequest request) async {
  return await executeWithErrorHandling<User>(
    () async {
      // Convert DTO to Model
      final userModel = UserModel(
        id: '',
        name: request.name,
        email: request.email,
      );
      final created = await remoteDataSource.createUser(userModel);
      return created.toEntity();
    },
  );
}
```

---

## Summary

1. **Domain Layer**:
   - **Entities**: Pure business objects (use Freezed)
   - **DTOs**: Request/Response objects for use cases (use Freezed, use when 3+ parameters)
   - **Use Cases**: Business logic operations (implement `UseCase<Type, Params>` or `UseCaseNoParams<Type>`, take DTOs or simple params, return Result<T>)
   - **Repository Interfaces**: Abstract contracts (extend `BaseRepository`)
2. **Data Layer**:
   - **Models**: API representation (use Freezed with JSON serialization)
   - **Data Sources**: API calls (throw exceptions)
   - **Repository Implementations**: Convert exceptions to failures
3. **Presentation Layer**:
   - Use **Cubit** only for **globally shared state**
   - Use **local state** (StatefulWidget) for simple, page-specific state
   - Use Freezed for Cubit states
4. **Always use**:
   - `executeWithErrorHandling` in repositories
   - `fold` in Cubits/local state handlers
   - Freezed for entities, models, DTOs, and states
   - Request DTOs when use case has 3+ parameters
5. **Register everything**: In GetIt following the dependency order
6. **Code generation**: Run `build_runner` after creating Freezed classes

### Key Concepts Recap

- **Entity**: Business concept (domain layer, no JSON)
- **Model**: API representation (data layer, with JSON)
- **Request DTO**: Use case input parameters (domain layer, no JSON, use when 3+ params)
- **Response DTO**: Use case output structure (domain layer, optional)
- **Use Case**: Single business operation (implements `UseCase<Type, Params>` or `UseCaseNoParams<Type>`, takes DTOs or simple params)

This architecture ensures:

- ✅ Separation of concerns
- ✅ Testability
- ✅ Type safety with Result<T> and Freezed
- ✅ Proper error handling
- ✅ Immutability with Freezed
- ✅ Reduced boilerplate with Freezed
- ✅ Scalability
- ✅ Efficient state management (Cubit only when needed)
- ✅ Clean use case signatures with DTOs
