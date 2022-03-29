import Foundation

public struct DependencyEnvironementOptionKey: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironementOptionKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
}

public struct DependencyEnvironementProcessKey: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension DependencyEnvironementProcessKey: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        rawValue = value
    }
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

    /// See `Equatable`
    public static func == (lhs: DependencyEnvironment, rhs: DependencyEnvironment) -> Bool {
        lhs.name == rhs.name && lhs.isRelease == rhs.isRelease
    }

    /// The process options (environment variable key: value)
    public let process: Process

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

    /// The arguments inside ProcessInfo.processInfo.arguments
    public var processInfoArguments: [String] {
        ProcessInfo.processInfo.arguments
    }

    /// The options for this `Environment`.
    public private(set) var options: Options

    public var rawValue: String { name }

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
        options: [String: Any] = [:])
    {
        self.init(name: name, process: Process(), arguments: arguments, options: options)
    }

    internal init(
        name: String,
        process: Process = Process(),
        arguments: [String] = CommandLine.arguments,
        options: [String: Any] = [:])
    {
        self.name = name
        self.process = process
        self.arguments = arguments
        self.options = Options(infoPlist: options)
    }

    // MARK: - Methods

    /// Set a `String` option
    public mutating func setStringOption(key: DependencyEnvironementOptionKey, value: String?) {
        options[dynamicMember: key.rawValue] = value
    }

    /// Set a generic option conforming to `LosslessStringConvertible`
    public mutating func setOption<T: LosslessStringConvertible>(key: DependencyEnvironementOptionKey, value: T?) {
        options[dynamicMember: key.rawValue] = value
    }

    /// Get a `String` option
    public func getStringOption(key: DependencyEnvironementOptionKey) -> String? {
        options[dynamicMember: key.rawValue]
    }

    /// Get a generic option
    public func getOption<T: LosslessStringConvertible>(key: DependencyEnvironementOptionKey) -> T? {
        options[dynamicMember: key.rawValue] as? T
    }

    /// Gets a key from the process environment
    public func get(_ key: DependencyEnvironementProcessKey) -> String? {
        ProcessInfo.processInfo.environment[key.rawValue]
    }
}

extension DependencyEnvironment: CustomStringConvertible {
    public var description: String {
        var desc: [String] = []
        desc.append("Environment: \(rawValue)")
        if !options.isEmpty {
            desc.append("\(options.description)")
        } else {
            desc.append("<none>")
        }
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
    public struct Options: CustomStringConvertible {
        private var _info: [String: Any]

        internal var isEmpty: Bool {
            _info.isEmpty
        }

        internal init(infoPlist: [String: Any]) {
            _info = infoPlist
        }

        /// Gets a variable's value from the process' environment, and converts it to generic type `T`.
        ///
        ///     Environment.development.options.DATABASE_PORT = 3306
        ///     Environment.development.options.DATABASE_PORT // 3306
        public subscript<T>(dynamicMember member: String) -> T? where T: LosslessStringConvertible {
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
        public subscript(dynamicMember member: String) -> String? {
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

#endif
