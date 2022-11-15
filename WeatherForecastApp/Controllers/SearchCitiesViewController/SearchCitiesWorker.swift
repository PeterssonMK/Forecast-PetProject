
import Foundation

protocol SearchCitiesWorkerProtocol{
    var coreDataService: ReadableDatabase & WritableDatabase { get }
    var queryService: QueryServiceProtocol { get }

}

final class SearchCitiesWorker: SearchCitiesWorkerProtocol{
    
    var coreDataService: ReadableDatabase & WritableDatabase
    var queryService: QueryServiceProtocol
    weak var interactor: SearchCitiesInteractorProtocol?
    
   
    init(coreDataService: ReadableDatabase & WritableDatabase, queryService: QueryServiceProtocol){
        self.coreDataService = coreDataService
        self.queryService = queryService
    }
    
}


