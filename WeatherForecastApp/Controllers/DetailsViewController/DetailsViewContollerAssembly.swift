
import Foundation

final class DetailsViewControllerAssembly {
    
    private let coreDataService: ReadableDatabase
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    init(coreDataService: ReadableDatabase, userDefaultsManager: UserDefaultsManagerProtocol) {
        self.coreDataService = coreDataService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func createViewController() -> DetailsViewController {
        
        let queryService = QueryService()
        
        let detailsViewController = DetailsViewController(queryService: queryService,
                                                          userDefaultsManager: userDefaultsManager,  // ?
                                                          coreDataService: coreDataService)
        return detailsViewController
    }
    
}
