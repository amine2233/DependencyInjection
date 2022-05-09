import DependencyInjection

@propertyWrapper
public struct Injection<Service> {
    private var service: Service

    public init(dependencies: Dependency) {
        do {
            self.service = try dependencies.resolve()
        } catch {
            fatalError("Can't resolve \(Service.self). Error: \(error.localizedDescription)")
        }
    }

    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }

    public var projectedValue: Injection<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct OptionalInjection<Service> {
    private var service: Service?

    public init(dependencies: Dependency) {
        self.service = try? dependencies.resolve(Service.self)
    }

    public var wrappedValue: Service? {
        get { return service }
        mutating set { service = newValue }
    }

    public var projectedValue: OptionalInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}

@propertyWrapper
public struct LazyInjection<Service> {
    private(set) var isInitialized: Bool = false
    private var service: Service!
    private let dependencies: Dependency

    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    public var isEmpty: Bool {
        return service == nil
    }

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

    public var projectedValue: LazyInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }

    public mutating func release() {
        self.service = nil
        self.isInitialized = false
    }
}

@propertyWrapper
public struct WeakLazyInjection<Service> {
    private(set) var isInitialized: Bool = false
    private var service: Service?
    private let dependencies: Dependency

    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    public var isEmpty: Bool {
        return service == nil
    }

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

    public var projectedValue: WeakLazyInjection<Service> {
        get { return self }
        mutating set { self = newValue }
    }

    public mutating func release() {
        self.service = nil
        self.isInitialized = false
    }
}
