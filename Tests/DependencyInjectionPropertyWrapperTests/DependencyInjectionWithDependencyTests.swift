import XCTest
@testable import DependencyInjection
@testable import DependencyInjectionPropertyWrapper

class DependencyInjectionWithDependenciesTests: XCTestCase {
    func testResolveWithDependencyType() throws {
        final class LocationPrivate: LocationService, AnyObject {
            func start() {}
        }
        // GIVEN
        var injector = DependencyInjector.current
        
        injector.register((any LocationService).self) { _ in
            LocationPrivate()
        }
        
        // WHEN
        let viewModel = withDependencies { dependencies in
            dependencies.dependencies.register((any LocationService).self) { _ in
                LocationServiceMock2()
            }
        } operation: {
            ViewModel()
        }

        
        // THEN
        XCTAssertEqual(viewModel.locationService.nameStructure, String(describing: LocationServiceMock2.self))
    }
}

final class ViewModel: ObservableObject, @unchecked Sendable {
    @Injection var locationService: any LocationService
}

final class LocationServiceMock2: LocationService {
    func start() {}
}
