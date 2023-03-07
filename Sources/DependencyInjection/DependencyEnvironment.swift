import Foundation

public enum DependencyEnvironmentError: Error, Equatable {
    case notFoundStringOption(DependencyEnvironmentKey)
    case notFoundOption(DependencyEnvironmentKey)
    case notFoundParameter(DependencyEnvironmentKey)
    case notFoundEnvironment(String)
}

public struct DependencyEnvironment: Equatable, RawRepresentable {
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
    private var parameters: [DependencyEnvironmentKey: Any]

    public var rawValue: String {
        name
    }

    // MARK: - Init

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
    public init(
        name: String,
        arguments: [String] = CommandLine.arguments,
        options: [DependencyEnvironmentKey: Any] = [:],
        parameters: [DependencyEnvironmentKey: Any] = [:]
    ) {
        self.name = name
        self.arguments = arguments
        self.options = InfoPlist(info: options)
        self.parameters = parameters
    }

    // MARK: - Methods

    /// Set a `String` option
    public mutating func setStringOption(key: DependencyEnvironmentKey, value: String?) {
        options[dynamicMember: key] = value
    }

    /// Set a generic option conforming to `LosslessStringConvertible`
    mutating func setOption<T: LosslessStringConvertible>(key: DependencyEnvironmentKey, value: T?) {
        options[dynamicMember: key] = value
    }

    /// Get a `String` option
    public func getStringOption(key: DependencyEnvironmentKey) throws -> String {
        guard let value = options[dynamicMember: key] else {
            throw DependencyEnvironmentError.notFoundOption(key)
        }
        return value
    }

    /// Get a generic option implemented `LosslessStringConvertible`
    func getOption<T: LosslessStringConvertible>(key: DependencyEnvironmentKey) throws -> T {
        guard let value = options[dynamicMember: key] as? T else {
            throw DependencyEnvironmentError.notFoundOption(key)
        }
        return value
    }

    /// Set a parameter
    public mutating func setParameter<T>(key: DependencyEnvironmentKey, value: T?) {
        parameters[key] = value
    }

    /// Get a generic parameter
    public func getParameter<T>(key: DependencyEnvironmentKey) throws -> T {
        guard let value = parameters[key] as? T else { throw DependencyEnvironmentError.notFoundParameter(key) }
        return value
    }
}

extension DependencyEnvironment: CustomStringConvertible {
    public var description: String {
        var desc: [String] = []
        desc.append("Environment: \(rawValue)")
        desc.append("\(options.description)")
        return desc.joined(separator: "\n")
    }
}

#if swift(>=5.1)

extension DependencyEnvironment {
    @dynamicMemberLookup
    public struct Process {
        private let _info: ProcessInfo

        internal init(info: ProcessInfo = .processInfo) {
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
    @dynamicMemberLookup
    public struct InfoPlist: CustomStringConvertible {
        private var _info: [DependencyEnvironmentKey: Any]

        internal init(info: [DependencyEnvironmentKey: Any]) {
            _info = info
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.development.options.DATABASE_PORT = 3306
        ///     Environment.development.options.DATABASE_PORT // 3306
        subscript<T>(dynamicMember member: DependencyEnvironmentKey) -> T? where T: LosslessStringConvertible {
            get {
                guard let raw = _info[member], let value = raw as? T else { return nil }
                return value
            }
            mutating set(value) {
                self._info[member] = value as Any
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
                self._info[member] = value as Any
            }
        }

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
    @dynamicMemberLookup
    public class Reference<Value> {
        fileprivate(set) var value: Value

        public init(value: Value) {
            self.value = value
        }

        public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T {
            value[keyPath: keyPath]
        }
    }

    public final class MutableReference<Value>: Reference<Value> {
        public subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
            get { value[keyPath: keyPath] }
            set { value[keyPath: keyPath] = newValue }
        }
    }
}

#endif
