import DependencyInjection

@propertyWrapper
public struct Inject<T> {
    var dependencies: DependencyType

    public init(dependencies: DependencyType) {
        self.dependencies = dependencies
    }

    public var wrappedValue: T {
        guard let dependency: T = try? dependencies.resolve() else {
            fatalError("The dependency \(String(describing: T.self)) is not registred.")
        }
        return dependency
    }
}
