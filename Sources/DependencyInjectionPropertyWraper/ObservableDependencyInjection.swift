import Foundation
import DependencyInjection

#if canImport(SwifUI)

/// A  property wrapper to resolve dependency values.
///
/// ```
/// @ObjectInjection(dependencies: .dependencyCore)
/// var viewModel: ObjectViewModel
/// ```
///
@propertyWrapper
public struct ObjectInjection<Service>: DynamicProperty where Service: ObservableObject {
    @ObservedObject private var service: Service

    /// Initialization
    /// - Parameter dependencies: The dependency manager
    public init(dependencies: DependencyResolver = DependencyInjector.dependencies) {
        self.service = dependencies.resolve()
    }

    /// The property wrapper
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }

    /// The property wrapper
    public var projectedValue: ObjectInjection<Service>.Wrapper {
        return self.$service
    }
}

#endif
