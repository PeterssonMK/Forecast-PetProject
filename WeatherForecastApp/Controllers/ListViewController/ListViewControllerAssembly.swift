
import Foundation

// In the tabBar, this controller is wrapped in NavController!

//core data, user defaults are the ones assigned in TabBarControllerAssembly --> SCENE DELEGATE  !!

final class ListViewControllerAssembly {
    private let coreDataService: ReadableDatabase & WritableDatabase
    private let userDefaultsManager: UserDefaultsManagerProtocol
    
    init(coreDataService: ReadableDatabase & WritableDatabase, userDefaultsManager: UserDefaultsManagerProtocol ) {
        self.coreDataService = coreDataService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func createViewController(detailsViewController: DetailsViewController) -> ListViewController {
        let queryService = QueryService()
        let listPresenter = ListPresenter()
        let listRouter = ListRouter()
        let listInteractor = ListInteractor()
        let listWorker = ListWorker(queryService: queryService, coreDataService: coreDataService, detailsViewController: detailsViewController, userDefaultsManager: userDefaultsManager)
        
        
        
        let listViewController = ListViewController()
       
        listPresenter.router = listRouter
        listPresenter.interactor = listInteractor
        listPresenter.viewController = listViewController
        
        listViewController.presenter = listPresenter
        
        listInteractor.presenter = listPresenter
        listInteractor.worker = listWorker
        
        listRouter.presenter = listPresenter
        
        
        return listViewController
    }
}

