import Foundation

/// An enumeration representing possible errors related to dependency environment operations.
public enum DependencyEnvironmentError: Error, Equatable, Sendable {
    /// Indicates that a string option was not found for the specified environment key.
    ///
    /// - Parameter key: The key for which the string option was not found.
    case notFoundStringOption(DependencyEnvironmentKey)

    /// Indicates that an option was not found for the specified environment key.
    ///
    /// - Parameter key: The key for which the option was not found.
    case notFoundOption(DependencyEnvironmentKey)

    /// Indicates that a parameter was not found for the specified environment key.
    ///
    /// - Parameter key: The key for which the parameter was not found.
    case notFoundParameter(DependencyEnvironmentKey)

    /// Indicates that an environment was not found for the specified name.
    ///
    /// - Parameter name: The name of the environment that was not found.
    case notFoundEnvironment(String)
}

/// A struct representing an environment for dependency injection.
public struct DependencyEnvironment: Equatable, RawRepresentable, Sendable {
    /// The raw value type for the `DependencyEnvironment`.
    public typealias RawValue = String

    /// An environment for deploying your application to consumers.
    public static var production: DependencyEnvironment {
        .init(name: "production")
    }

    /// An environment for developing your application.
    public static var development: DependencyEnvironment {
        .init(name: "development")
    }

    /// An environment for testing your application.
    public static var testing: DependencyEnvironment {
        .init(name: "testing")
    }

    /// Creates a custom environment.
    public static func custom(name: String) -> DependencyEnvironment {
        .init(name: name)
    }

    /// Gets a key from the process environment
    public static func get(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }

    /// See `Equatable`
    public static func == (lhs: DependencyEnvironment, rhs: DependencyEnvironment) -> Bool {
        lhs.name == rhs.name && lhs.isRelease == rhs.isRelease
    }

    public static var process: Process {
        Process()
    }

    /// The environment's unique name.
    public let name: String

    /// `true` if this environment is meant for production use cases.
    ///
    /// This usually means reducing logging, disabling debug information, and sometimes
    /// providing warnings about configuration states that are not suitable for production.
    public var isRelease: Bool {
        !_isDebugAssertConfiguration()
    }

    /// The command-line arguments for this `Environment`.
    public private(set) var arguments: [String]

    /// The options for this `Environment`.
    public var options: InfoPlist

    /// The options for this `Environment`.
    private var parameters: [DependencyEnvironmentKey: any Sendable]

    /// The raw value of the environment.
    public var rawValue: String {
        name
    }

    // MARK: Initilizer

    /// Initializes a new `DependencyEnvironment` with the given raw value.
    ///
    /// - Parameter rawValue: The raw value of the environment.
    public init?(rawValue: String) {
        switch rawValue {
        case "production":
            self = DependencyEnvironment.production
        case "development":
            self = DependencyEnvironment.development
        case "testing":
            self = DependencyEnvironment.testing
        default:
            // return nil
            self = DependencyEnvironment(name: rawValue)
        }
    }

    /// Create a new `Environment`.
    ///
    /// - Parameters:
    ///   - name: The name of the environment.
    ///   - arguments: The arguments passed to the environment, default is `CommandLine.arguments`.
    ///   - options: A InfoPlist.
    ///   - parameters: A dictionary of parameters for the environment, default is an empty dictionary.
    public init(
        name: String,
        arguments: [String] = CommandLine.arguments,
        options: InfoPlist,
        parameters: [DependencyEnvironmentKey: any Sendable] = [:]
    ) {
        self.name = name
        self.arguments = arguments
        self.options = options
        self.parameters = parameters
    }
    
    /// Create a new `Environment`.
    ///
    /// - Parameters:
    ///   - name: The name of the environment.
    ///   - arguments: The arguments passed to the environment, default is `CommandLine.arguments`.
    ///   - options: A dictionary of options for the environment, default is an empty dictionary.
    ///   - parameters: A dictionary of parameters for the environment, default is an empty dictionary.
    public init(
        name: String,
        arguments: [String] = CommandLine.arguments,
        options: [DependencyEnvironmentKey: any Sendable] = [:],
        parameters: [DependencyEnvironmentKey: any Sendable] = [:]
    ) {
        self.init(
            name: name,
            arguments: arguments,
            options: InfoPlist(info: options),
            parameters: parameters
        )
    }
    

    // MARK: Public methods
    
    /// Sets a string option for the given key.
    ///
    /// - Parameters:
    ///   - key: The key for the option.
    ///   - value: The string value to set.
    public mutating func setStringOption(key: DependencyEnvironmentKey, value: String?) {
        options[dynamicMember: key] = value
    }
    
    /// Sets an option for the given key.
    ///
    /// - Parameters:
    ///   - key: The key for the option.
    ///   - value: The value to set, which must conform to `LosslessStringConvertible`.
    mutating func setOption<T: LosslessStringConvertible & Sendable>(key: DependencyEnvironmentKey, value: T?) {
        options[dynamicMember: key] = value
    }
    
    /// Retrieves a string option for the given key.
    ///
    /// - Parameter key: The key for the option.
    /// - Throws: `DependencyEnvironmentError.notFoundOption` if the option is not found.
    /// - Returns: The string value for the key.
    public func getStringOption(key: DependencyEnvironmentKey) throws -> String {
        guard let value = options[dynamicMember: key] else {
            throw DependencyEnvironmentError.notFoundOption(key)
        }
        return value
    }
    
    /// Retrieves an option for the given key.
    ///
    /// - Parameter key: The key for the option.
    /// - Throws: `DependencyEnvironmentError.notFoundOption` if the option is not found.
    /// - Returns: The value for the key, which must conform to `LosslessStringConvertible`.
    func getOption<T: LosslessStringConvertible>(key: DependencyEnvironmentKey) throws -> T {
        guard let value = options[dynamicMember: key] as? T else {
            throw DependencyEnvironmentError.notFoundOption(key)
        }
        return value
    }
    
    /// Sets a parameter for the given key.
    ///
    /// - Parameters:
    ///   - key: The key for the parameter.
    ///   - value: The value to set.
    public mutating func setParameter<T: Sendable>(key: DependencyEnvironmentKey, value: T?) {
        parameters[key] = value
    }
    
    /// Retrieves a parameter for the given key.
    ///
    /// - Parameter key: The key for the parameter.
    /// - Throws: `DependencyEnvironmentError.notFoundParameter` if the parameter is not found.
    /// - Returns: The value for the key.
    public func getParameter<T>(key: DependencyEnvironmentKey) throws -> T {
        guard let value = parameters[key] as? T else {
            throw DependencyEnvironmentError.notFoundParameter(key)
        }
        return value
    }
}

extension DependencyEnvironment: CustomStringConvertible {
    /// A textual representation of the `DependencyEnvironment`.
    public var description: String {
        var desc: [String] = []
        desc.append("Environment: \(rawValue)")
        desc.append("\(options.description)")
        return desc.joined(separator: "\n")
    }
}

#if swift(>=5.1)

extension DependencyEnvironment {
    /// A struct representing information about the current process.
    @dynamicMemberLookup public struct Process {
        /// The underlying process information.
        private let _info: ProcessInfo

        /// Initializes a new `Process` instance with the given process information.
        ///
        /// - Parameter info: The process information to use. Defaults to the current process information obtained from `ProcessInfo.processInfo`.
        init(info: ProcessInfo = .processInfo) {
            _info = info
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.process.DATABASE_PORT = 3306
        ///     Environment.process.DATABASE_PORT // 3306
        public subscript<T>(dynamicMember member: String) -> T? where T: LosslessStringConvertible {
            get {
                guard let raw = _info.environment[member], let value = T(raw) else { return nil }
                return value
            }
            nonmutating set(value) {
                if let raw = value?.description {
                    setenv(member, raw, 1)
                } else {
                    unsetenv(member)
                }
            }
        }

        /// Gets a variable's value from the process' environment as a `String`.
        ///
        ///     Environment.process.DATABASE_USER = "root"
        ///     Environment.process.DATABASE_USER // "root"
        public subscript(dynamicMember member: String) -> String? {
            get {
                guard let value = _info.environment[member] else { return nil }
                return value
            }
            nonmutating set(value) {
                if let raw = value {
                    setenv(member, raw, 1)
                } else {
                    unsetenv(member)
                }
            }
        }
    }
}

extension DependencyEnvironment {
    /// A struct that provides dynamic access to values in the Info.plist file.
    @dynamicMemberLookup public struct InfoPlist: CustomStringConvertible, Sendable {
        /// The underlying dictionary holding Info.plist values.
        private var _info: [DependencyEnvironmentKey: any Sendable]

        /// Initializes a new `InfoPlist` instance with the given dictionary of Info.plist values.
        ///
        /// - Parameter info: A dictionary containing the Info.plist values.
        init(info: [DependencyEnvironmentKey: any Sendable]) {
            _info = info
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.development.options.DATABASE_PORT = 3306
        ///     Environment.development.options.DATABASE_PORT // 3306
        public subscript<T: Sendable>(dynamicMember member: DependencyEnvironmentKey) -> T? where T: LosslessStringConvertible {
            get {
                guard let raw = _info[member], let value = raw as? T else { return nil }
                return value
            }
            mutating set(value) {
                self._info[member] = value
            }
        }

        /// Gets a variable's value from the process' environment as a `String`.
        ///
        ///     Environment.development.options.DATABASE_USER = "root"
        ///     Environment.development.DATABASE_USER // "root"
        public subscript(dynamicMember member: DependencyEnvironmentKey) -> String? {
            get {
                guard let raw = _info[member], let value = raw as? String else { return nil }
                return value
            }
            mutating set(value) {
                self._info[member] = value
            }
        }

        /// Returns a string description of the Info.plist values.
        public var description: String {
            var desc: [String] = []

            desc.append("Info:")
            if _info.isEmpty {
                desc.append("<none>")
            } else {
                for (id, value) in _info {
                    #if DEBUG
                    desc.append("- \(id): \(value)")
                    #else
                    desc.append("- \(id): **************")
                    #endif
                }
            }

            return desc.joined(separator: "\n")
        }
    }
}

/// https://www.swiftbysundell.com/tips/combining-dynamic-member-lookup-with-key-paths/
extension DependencyEnvironment {
    /// A class that holds a reference to a value, allowing for dynamic member lookup.
    @dynamicMemberLookup public class Reference<Value> {
        /// The value being referenced.
        fileprivate(set) var value: Value

        /// Initializes a new `Reference` instance with the given value.
        ///
        /// - Parameter value: The value to be referenced.
        public init(value: Value) {
            self.value = value
        }

        /// Provides dynamic member lookup to access properties of the referenced value using key paths.
        ///
        /// - Parameter keyPath: The key path to the desired property.
        /// - Returns: The value at the specified key path.
        public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
            value[keyPath: keyPath]
        }
    }

    /// A final class that extends `Reference` to allow for mutable access to the referenced value's properties.
    public final class MutableReference<Value>: Reference<Value> {
        /// Provides dynamic member lookup to access and modify properties of the referenced value using writable key paths.
        ///
        /// - Parameter keyPath: The writable key path to the desired property.
        /// - Returns: The value at the specified key path.
        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
            get { value[keyPath: keyPath] }
            set { value[keyPath: keyPath] = newValue }
        }
    }
}

#endif
