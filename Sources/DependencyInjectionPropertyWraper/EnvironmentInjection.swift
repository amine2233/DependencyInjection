import Foundation
import DependencyInjection

/// The dependency environement.
///
/// ```
/// @EnvironmentInjection(dependencies: .dependencyCore)
/// var testingEncironment: DependencyEnvironement
/// ```
///
@propertyWrapper
public struct EnvironmentInjection {
    private var dependencies: Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: Dependency) {
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: DependencyEnvironement {
        get { return dependencies.environment }
        mutating set { dependencies.environment = newValue }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentInjection {
        get { return self }
        mutating set { self = newValue }
    }
}

/// The dependency environement parameter.
///
/// ```
/// @EnvironmentParameter(dependencies: .dependencyCore)
/// var parameter: TimeInterval?
/// ```
///
@propertyWrapper
public struct EnvironmentParameter<T> {
    private let key: DependencyEnvironementKey
    private var dependencies: Dependency

    /// Initialization
    /// - Parameter key: The environment parameter key
    /// - Parameter dependencies: The dependency manager
    public init(key: DependencyEnvironementKey, dependencies: Dependency) {
        self.key = key
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: T? {
        get { return try? dependencies.environment.getParameter(key: key) }
        mutating set { dependencies.environment.setParameter(key: key, value: newValue) }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentParameter {
        get { return self }
        mutating set { self = newValue }
    }
}

/// The dependency environement option.
/// It works with `@dynamicMemberLookup`
///
/// ```
/// @EnvironmentStringOption(dependencies: .dependencyCore)
/// var option: String?
/// ```
///
@propertyWrapper
public struct EnvironmentStringOption {
    private let key: DependencyEnvironementKey
    private var dependencies: Dependency

    /// Initialization
    /// - Parameter key: The environment parameter key
    /// - Parameter dependencies: The dependency manager
    public init(key: DependencyEnvironementKey, dependencies: Dependency) {
        self.key = key
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: String? {
        get { return try? dependencies.environment.getStringOption(key: key) }
        mutating set { dependencies.environment.setStringOption(key: key, value: newValue) }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentStringOption {
        get { return self }
        mutating set { self = newValue }
    }
}
