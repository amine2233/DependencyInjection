import Foundation

public struct DependencyEnvironement: Equatable, RawRepresentable {
    public typealias RawValue = String

    /// An environment for deploying your application to consumers.
    public static var production: DependencyEnvironement {
        .init(name: "production")
    }

    /// An environment for developing your application.
    public static var development: DependencyEnvironement {
        .init(name: "development")
    }

    /// An environment for testing your application.
    public static var testing: DependencyEnvironement {
        .init(name: "testing")
    }

    /// Creates a custom environment.
    public static func custom(name: String) -> DependencyEnvironement {
        .init(name: name)
    }

    /// Gets a key from the process environment
    public static func get(_ key: String) -> String? {
        ProcessInfo.processInfo.environment[key]
    }

    /// See `Equatable`
    public static func == (lhs: DependencyEnvironement, rhs: DependencyEnvironement) -> Bool {
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
    public private(set) var options: InfoPlist

    public var rawValue: String {
        name
    }

    // MARK: - Init

    public init?(rawValue: String) {
        switch rawValue {
        case "production":
            self = DependencyEnvironement.production
        case "development":
            self = DependencyEnvironement.development
        case "testing":
            self = DependencyEnvironement.testing
        default:
            // return nil
            self = DependencyEnvironement(name: rawValue)
        }
    }

    /// Create a new `Environment`.
    public init(name: String, arguments: [String] = CommandLine.arguments, options: [String: Any] = [:]) {
        self.name = name
        self.arguments = arguments
        self.options = InfoPlist(infoPlist: options)
    }

    // MARK: - Methods

    /// Set a `String` option
    public mutating func setStringOption(key: String, value: String?) {
        options[dynamicMember: key] = value
    }

    /// Set a generic option conforming to `LosslessStringConvertible`
    public mutating func setOption<T: LosslessStringConvertible>(key: String, value: T?) {
        options[dynamicMember: key] = value
    }

    /// Get a `String` option
    public func getStringOption(key: String) -> String? {
        options[dynamicMember: key]
    }

    /// Get a generic option
    public func getOption<T: LosslessStringConvertible>(key: String) -> T? {
        options[dynamicMember: key] as? T
    }
}

extension DependencyEnvironement: CustomStringConvertible {
    public var description: String {
        var desc: [String] = []
        desc.append("Environement: \(rawValue)")
        desc.append("\(options.description)")
        return desc.joined(separator: "\n")
    }
}

#if swift(>=5.1)

extension DependencyEnvironement {
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

extension DependencyEnvironement {
    @dynamicMemberLookup
    public struct InfoPlist: CustomStringConvertible {
        private var _info: [String: Any]

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
