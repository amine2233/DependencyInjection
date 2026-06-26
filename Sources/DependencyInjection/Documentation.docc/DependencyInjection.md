# ``DependencyInjection``

A lightweight, type-safe dependency injection container for Swift 6 with strict concurrency.

## Overview

`DependencyInjection` provides a value-type container, ``DependencyCore``, that registers and
resolves services in a fully `Sendable`, concurrency-safe way. Services can be registered as
**factories** (a fresh instance on every resolve) or **singletons** (built once and cached), keyed
by their type or by an explicit ``DependencyKey``.

```swift
import DependencyInjection

var container = DependencyCore()

container.register(NetworkClient.self) { _ in NetworkClientDefault() }
container.register(UserRepository.self) { resolver in
    UserRepositoryDefault(client: try resolver.resolve(NetworkClient.self))
}

let repository: UserRepository = try container.resolve(UserRepository.self)
```

The container is a **value type**: registration methods are `mutating`, and passing the container
around copies it. Use ``DependencyInjector`` and its ``DependencyInjector/default`` instance when you
need a conventional shared container.

## Topics

### Essentials

- ``Dependency``
- ``DependencyCore``
- ``DependencyInjector``

### Keys & Identity

- ``DependencyKey``

### Resolving Dependencies

- ``DependencyResolve``
- ``DependencyResolver``
- ``DependencyResolverFactory``
- ``DependencyServiceType``

### Registering Dependencies

- ``DependencyRegister``
- ``DependencyRegisterOperation``
- ``DependencyUnregister``
- ``DependencySubscript``

### Singletons

- ``DependencySingleton``
- ``DependencySingletonOperation``

### Validation

- ``DependencyCheck``

### Providers & Lifecycle

- ``Provider``
- ``DependencyProvider``

### Environment

- ``DependencyEnvironment``
- ``DependencyEnvironmentKey``
- ``DependencyParameters``

### Errors

- ``DependencyError``
- ``DependencyServiceError``
- ``DependencyResolverError``
- ``DependencyEnvironmentError``

### Inspection

- ``DependencyDescription``
