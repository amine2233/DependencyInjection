import DependencyInjection

@propertyWrapper
public struct InjectServiceType<T: DependencyServiceType> {
    var dependencies: DependencyType

    public init(dependencies: DependencyType) {
        self.dependencies = dependencies
    }

    public var wrappedValue: T {
        mutating get {
            if let dependency: T = try? dependencies.resolve(T.self) {
                return dependency
            }
            return dependencies.register(T.self)
        }
    }
}
