import DependencyInjection
import Foundation

/// The dependency environment.
///
/// ```
/// @EnvironmentInjection(dependencies: .dependencyCore)
/// var testingEnvironment: DependencyEnvironment
/// ```
///
@propertyWrapper
public struct EnvironmentInjection {
    private var dependencies: any Dependency

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: any Dependency = DependencyInjector.default.dependencies) {
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: DependencyEnvironment {
        get { dependencies.environment }
        mutating set { dependencies.environment = newValue }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentInjection {
        get { self }
        mutating set { self = newValue }
    }
}

/// The dependency environment parameter.
///
/// ```
/// @EnvironmentParameter(dependencies: .dependencyCore)
/// var parameter: TimeInterval?
/// ```
///
@propertyWrapper
public struct EnvironmentParameter<T: Sendable> {
    private let key: DependencyEnvironmentKey
    private var dependencies: any Dependency

    /// Initialization
    /// - Parameter key: The environment parameter key
    /// - Parameter dependencies: The dependency manager
    public init(
        key: DependencyEnvironmentKey,
        dependencies: any Dependency = DependencyInjector.default.dependencies
    ) {
        self.key = key
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: T? {
        get { try? dependencies.environment.getParameter(key: key) }
        mutating set { dependencies.environment.setParameter(key: key, value: newValue) }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentParameter {
        get { self }
        mutating set { self = newValue }
    }
}

/// The dependency environment option.
/// It works with `@dynamicMemberLookup`
///
/// ```
/// @EnvironmentStringOption(dependencies: .dependencyCore)
/// var option: String?
/// ```
///
@propertyWrapper
public struct EnvironmentStringOption {
    private let key: DependencyEnvironmentKey
    private var dependencies: any Dependency

    /// Initialization
    /// - Parameter key: The environment parameter key
    /// - Parameter dependencies: The dependency manager
    public init(
        key: DependencyEnvironmentKey,
        dependencies: any Dependency = DependencyInjector.default.dependencies
    ) {
        self.key = key
        self.dependencies = dependencies
    }

    /// The property wrapper
    public var wrappedValue: String? {
        get { try? dependencies.environment.getStringOption(key: key) }
        mutating set { dependencies.environment.setStringOption(key: key, value: newValue) }
    }

    /// The property wrapper
    public var projectedValue: EnvironmentStringOption {
        get { self }
        mutating set { self = newValue }
    }
}
