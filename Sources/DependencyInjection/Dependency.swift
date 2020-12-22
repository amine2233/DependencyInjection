import Foundation

@propertyWrapper
public struct Dependency<T: DependencyServiceType> {
    var dependencies: DependencyType
    var dependency: T!
    
    public init(dependencies: DependencyType = DependencyInjector.dependencies, dependency: T? = nil) {
        self.dependencies = dependencies
        self.dependency = dependency
    }
    
    public var wrappedValue: T {
        mutating get {
            if dependency == nil {
                if let resolver = dependencies.resolve(T.self) {
                    self.dependency = resolver
                } else {
                    let copy = dependencies.register(T.self)
                    self.dependency = copy
                }
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}
