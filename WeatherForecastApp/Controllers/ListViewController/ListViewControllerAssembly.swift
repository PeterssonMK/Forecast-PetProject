
import Foundation


final class ListViewControllerAssembly {
    private let coreDataService: ReadableDatabase & WritableDatabase
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    init(coreDataService: ReadableDatabase & WritableDatabase, userDefaultsManager: UserDefaultsManagerProtocol ) {
        self.coreDataService = coreDataService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func createViewController(detailsViewController: DetailsViewController) -> ListViewController {
        let queryService = QueryService()
        
        let listViewController = ListViewController(queryService: queryService,
                                                    userDefaultsManager: userDefaultsManager,
                                                    coreDataService: coreDataService,
                                                    detailsViewController: detailsViewController)
        
        return listViewController
    }
}

