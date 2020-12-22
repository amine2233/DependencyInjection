import DependencyInjection

@propertyWrapper
public struct InjectCreateServiceType<T: DependencyServiceType> {
    var dependencies: DependencyType

    public init(dependencies: DependencyType) {
        self.dependencies = dependencies
    }

    public var wrappedValue: T {
        mutating get {
            return dependencies.create(T.self)
        }
    }
}
