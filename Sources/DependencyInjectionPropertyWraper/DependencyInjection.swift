import DependencyInjection

/// A  property wrapper to resolve dependency values.
///
/// ```
/// @Injection(dependencies: .dependencyCore)
/// var locationService: LocationService
/// ```
///
@propertyWrapper
public struct Injection<Service> {
    private var service: Service

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: Dependency) {
        do {
            self.service = try dependencies.resolve()
        } catch {
            fatalError("Can't resolve \(Service.self). Error: \(error.localizedDescription)")
        }
    }

    /// The property wrapper
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }

    /// The property wrapper
    public var projectedValue: Injection<Service> {
        get { return self }
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
public struct OptionalInjection<Service> {
    private var service: Service?

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: Dependency) {
        self.service = try? dependencies.resolve(Service.self)
    }

    /// The property wrapper
    public var wrappedValue: Service? {
        get { return service }
        mutating set { service = newValue }
    }

    /// The projected value
    public var projectedValue: OptionalInjection<Service> {
        get { return self }
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
public struct LazyInjection<Service> {
    private(set) var isInitialized: Bool = false
    private var service: Service!
    private let dependencies: Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    /// Test if we have already initialized the dependency
    public var isEmpty: Bool {
        return service == nil
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
        get { return self }
        mutating set { self = newValue }
    }

    /// release the dependency or just set it empty internaly
    public mutating func release() {
        self.service = nil
        self.isInitialized = false
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
public struct WeakLazyInjection<Service> {
    private(set) var isInitialized: Bool = false
    private var service: Service?
    private let dependencies: Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    /// Test if we have already initialized the dependency
    public var isEmpty: Bool {
        return service == nil
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
        get { return self }
        mutating set { self = newValue }
    }

    /// release the dependency or just set it empty internaly
    public mutating func release() {
        self.service = nil
        self.isInitialized = false
    }
}
