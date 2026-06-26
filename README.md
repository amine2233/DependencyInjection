# DependencyInjection

A lightweight, pure-Swift dependency injection container with **zero third-party dependencies**, built for Swift 6 with strict concurrency. The container is a value type, every registered service is `Sendable`, and resolution is fully type-safe.

The package ships three libraries:

| Library | Description |
| --- | --- |
| `DependencyInjection` | The core container: register, resolve, singletons, factories, providers, environments. |
| `DependencyInjectionPropertyWrapper` | `@Injection`-style property wrappers for ergonomic resolution. |
| `DependencyInjectionAutoRegistration` | `autoregister` helpers that auto-resolve initializer parameters. |

**Platforms:** iOS 13+ · macOS 10.15+ · watchOS 6+ · tvOS 13+ · visionOS 1+

## Installation

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/amine2233/DependencyInjection.git", from: "1.0.0")
]
```

Then add the products you need to your target:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "DependencyInjection", package: "DependencyInjection"),
        .product(name: "DependencyInjectionPropertyWrapper", package: "DependencyInjection"),
        .product(name: "DependencyInjectionAutoRegistration", package: "DependencyInjection"),
    ]
)
```

## Quick Start

```swift
import DependencyInjection

// Build a container (a value type — keep a reference where you need it)
var container = DependencyCore()

// Register a factory: the closure runs on every resolve (fresh instance each time)
container.register(NetworkClient.self) { _ in NetworkClientDefault() }

// Register a dependency that needs another dependency
container.register(UserRepository.self) { resolver in
    UserRepositoryDefault(client: try resolver.resolve(NetworkClient.self))
}

// Resolve
let repository: UserRepository = try container.resolve(UserRepository.self)
```

## Registration Styles

### 1. Closure registration

The closure receives the container so you can resolve nested dependencies:

```swift
container.register(UserRepository.self) { resolver in
    UserRepositoryDefault(client: try resolver.resolve(NetworkClient.self))
}
```

### 2. `DependencyServiceType`

Let a type describe how to build itself, then register it by type:

```swift
struct AnalyticsService: DependencyServiceType {
    static func makeService(for container: any Dependency) throws -> Self {
        AnalyticsService()
    }
}

container.register(AnalyticsService.self)
```

### 3. Keyed registration & subscript

Register and resolve by an explicit `DependencyKey` (`ExpressibleByStringLiteral`):

```swift
container.register(key: "api.baseURL") { _ in URL(string: "https://api.example.com")! }
let url: URL = try container.resolve(key: "api.baseURL")

// Or via subscript
container["feature.flag"] = true
let flag: Bool? = container["feature.flag"]
```

## Factories vs Singletons

```swift
// Factory: new instance on every resolve
container.register(Token.self) { _ in Token() }

// Singleton: built once at registration, cached and reused
try container.registerSingleton(Database.self) { _ in DatabaseDefault() }
let db: Database = try container.singleton(Database.self)
```

`factory(_:)` builds an instance **without** registering it, and the `registerOperation` /
`registerSingletonOperation` variants run a post-construction transform on the resolved value.

## Property Wrappers

`import DependencyInjectionPropertyWrapper`. All wrappers default to `DependencyInjector.default.dependencies`.

```swift
struct ProfileViewModel {
    @Injection var repository: UserRepository          // fatalError if unresolved
    @OptionalInjection var analytics: AnalyticsService? // nil if unresolved
    @LazyInjection var database: Database               // resolved on first access
    @WeakLazyInjection var cache: Cache?                // lazy + optional
    @InjectionKey("api.baseURL") var baseURL: URL       // resolve by key
}
```

## Auto-Registration

`import DependencyInjectionAutoRegistration`. `autoregister` resolves each initializer argument from the container automatically — no manual `resolve` calls:

```swift
container.autoregister(NetworkClient.self, initializer: NetworkClientDefault.init)

// One dependency — `client` is resolved for you
container.autoregister(UserRepository.self) { (client: NetworkClient) in
    UserRepositoryDefault(client: client)
}

// Singleton variant
try container.autoregisterSingleton(Database.self, initializer: DatabaseDefault())
```

Bundle registrations with `DependencyRegistering` and wire them through `DependencyInjector`'s
result-builder initializers:

```swift
enum AppDependencies: DependencyRegistering {
    static func registerAllServices(in dependencies: inout any Dependency) {
        dependencies.autoregister(NetworkClient.self, initializer: NetworkClientDefault.init)
        dependencies.autoregister(UserRepository.self) { (client: NetworkClient) in
            UserRepositoryDefault(client: client)
        }
    }
}

let injector = DependencyInjector(register: AppDependencies.self)
let repository: UserRepository = try injector.dependencies.resolve(UserRepository.self)
```

`preview(...)` variants only register when running in Xcode Previews (`XCODE_RUNNING_FOR_PREVIEWS == 1`).

## Providers & Environment

`Provider` exposes lifecycle hooks (`willBoot` / `didBoot` / `didEnterBackground` / `willShutdown`)
fanned out to every registered provider:

```swift
container.registerProvider(LoggingProvider())
container = container.willBoot().didBoot()
```

`DependencyEnvironment` carries `.production`, `.development`, `.testing`, or `.custom(name:)`
plus typed options and parameters for environment-specific configuration.

## Documentation

Full API documentation is available via DocC. Build it locally:

```bash
mise run build_documentations --serve   # builds into ./public and serves it locally
```

## Tests

```bash
swift test          # macOS
mise run test       # via mise/executor

# Linux (Docker)
docker run --rm --privileged --interactive --tty --volume "$(pwd):/src" --workdir "/src" swift:latest swift test
```

## License

See [LICENSE](LICENSE).
