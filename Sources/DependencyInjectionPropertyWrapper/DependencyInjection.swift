import DependencyInjection

/// A  property wrapper to resolve dependency values.
///
/// ```
/// @Injection(dependencies: .dependencyCore)
/// var locationService: LocationService
/// ```
///
@propertyWrapper
public struct Injection<Service: Sendable>: Sendable {
    private var service: Service

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: any Dependency = DependencyInjector.default.dependencies) {
        do {
            self.service = try dependencies.resolve()
        } catch {
            fatalError("Can't resolve \(Service.self). Error: \(error.localizedDescription)")
        }
    }

    /// The property wrapper
    public var wrappedValue: Service {
        get { service }
        mutating set { service = newValue }
    }

    /// The property wrapper
    public var projectedValue: Injection<Service> {
        get { self }
        mutating set { self = newValue }
    }
}

/// A  property wrapper to resolve dependency values.
///
/// ```
/// @Injection(locationServiceKey, dependencies: .dependencyCore)
/// var locationService: LocationService
/// ```
///
@propertyWrapper
public struct InjectionKey<Service: Sendable>: Sendable {
    private var key: DependencyKey
    private var dependencies: any DependencySubscript

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(
        _ key: DependencyKey,
        dependencies: any Dependency = DependencyInjector.default.dependencies
    ) {
        self.dependencies = dependencies
        self.key = key
    }

    /// The property wrapper
    public var wrappedValue: Service {
        get {
            guard let service = dependencies[key] as Service? else {
                fatalError("Can't resolve \(Service.self). Error: missing value")
            }

            return service
        }
        mutating set {
            dependencies[key] = newValue
        }
    }

    /// The property wrapper
    public var projectedValue: InjectionKey<Service> {
        get { self }
        mutating set { self = newValue }
    }
}

/// A  property wrapper to resolve optionaly the dependency values.
///
/// ```
/// @OptionalInjection(dependencies: .dependencyCore)
/// var locationService: LocationService?
/// ```
///
@propertyWrapper
public struct OptionalInjection<Service: Sendable>: Sendable {
    private var service: Service?

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: any Dependency = DependencyInjector.default.dependencies) {
        self.service = try? dependencies.resolve(Service.self)
    }

    /// The property wrapper
    public var wrappedValue: Service? {
        get { service }
        mutating set { service = newValue }
    }

    /// The projected value
    public var projectedValue: OptionalInjection<Service> {
        get { self }
        mutating set { self = newValue }
    }
}

/// A  property wrapper to resolve dependency values.
///
/// ```
/// @Injection(locationServiceKey, dependencies: .dependencyCore)
/// var locationService: LocationService?
/// ```
///
@propertyWrapper
public struct OptionalInjectionKey<Service: Sendable>: Sendable {
    private var key: DependencyKey
    private var dependencies: any DependencySubscript

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(
        _ key: DependencyKey,
        dependencies: any Dependency = DependencyInjector.default.dependencies
    ) {
        self.dependencies = dependencies
        self.key = key
    }

    /// The property wrapper
    public var wrappedValue: Service? {
        get {
            dependencies[key] as Service?
        }
        mutating set {
            dependencies[key] = newValue
        }
    }

    /// The property wrapper
    public var projectedValue: OptionalInjectionKey<Service> {
        get { self }
        mutating set { self = newValue }
    }
}

/// A  property wrapper to resolve lazyly the dependency values.
///
/// ```
/// @LazyInjection(dependencies: .dependencyCore)
/// var locationService: LocationService?
/// ```
///
@propertyWrapper
public struct LazyInjection<Service: Sendable>: Sendable {
    private(set) var isInitialized: Bool = false
    private var service: Service!
    private let dependencies: any Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: any Dependency = DependencyInjector.default.dependencies) {
        self.dependencies = dependencies
    }

    /// Test if we have already initialized the dependency
    public var isEmpty: Bool {
        service == nil
    }

    /// The property wrapper
    public var wrappedValue: Service {
        mutating get {
            if !isInitialized {
                isInitialized = true
                do {
                    service = try dependencies.resolve(Service.self)
                } catch {
                    fatalError("Can't resolve \(Service.self). Error: \(error.localizedDescription)")
                }
            }
            return service
        }
        mutating set {
            isInitialized = true
            service = newValue
        }
    }

    /// The projected value
    public var projectedValue: LazyInjection<Service> {
        get { self }
        mutating set { self = newValue }
    }

    /// release the dependency or just set it empty internaly
    public mutating func release() {
        service = nil
        isInitialized = false
    }
}

/// A  property wrapper to resolve lazyly an optional dependency values.
///
/// ```
/// @WeakLazyInjection(dependencies: .dependencyCore)
/// var locationService: LocationService?
/// ```
///
@propertyWrapper
public struct WeakLazyInjection<Service: Sendable>: Sendable {
    private(set) var isInitialized: Bool = false
    private var service: Service?
    private let dependencies: any Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: any Dependency = DependencyInjector.default.dependencies) {
        self.dependencies = dependencies
    }

    /// Test if we have already initialized the dependency
    public var isEmpty: Bool {
        service == nil
    }

    /// The property wrapper
    public var wrappedValue: Service? {
        mutating get {
            if !isInitialized {
                isInitialized = true
                service = try? dependencies.resolve(Service.self)
            }
            return service
        }
        mutating set {
            isInitialized = true
            service = newValue
        }
    }

    /// The projected value
    public var projectedValue: WeakLazyInjection<Service> {
        get { self }
        mutating set { self = newValue }
    }

    /// release the dependency or just set it empty internaly
    public mutating func release() {
        service = nil
        isInitialized = false
    }
}
