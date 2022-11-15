
import Foundation
import UIKit

final class SearchCititesAssembly{
    
    
    private let coreDataService: ReadableDatabase & WritableDatabase
    private let queryService: QueryServiceProtocol
    
    init(coreDataService: ReadableDatabase & WritableDatabase, querySerice: QueryServiceProtocol) {
        self.coreDataService = coreDataService
        self.queryService = querySerice
        
    }
    
    func createViewController() -> SearchCitiesViewController{
        
        let searchPresenter = SearchCitiesPresenter()
        let searchInteractor = SearchCitiesInteractor()
        let searchRouter = SearchCitiesRouter()
        let searchWorker = SearchCitiesWorker(coreDataService: coreDataService, queryService: queryService)
        let searchViewController = SearchCitiesViewController()
        
        searchViewController.presenter = searchPresenter
        
        searchPresenter.viewController = searchViewController
        searchPresenter.router = searchRouter
        searchPresenter.interactor = searchInteractor
    
        searchInteractor.presenter = searchPresenter
        searchInteractor.worker = searchWorker
        
        searchWorker.interactor = searchInteractor
        
        searchRouter.presenter = searchPresenter
        return searchViewController
    }
    
    
}
