
import Foundation
import UIKit

protocol ListRouterProtocol {
    
    func routeTo(target: ListRouter.Targets)
    
    func showAlert(on vc: UIViewController, with title: String)
}

final class ListRouter{

    weak var presenter: ListPresenterProtocol?
    
    enum Targets{
        case searchCity(coreData:ReadableDatabase & WritableDatabase,
                        query:QueryServiceProtocol,
                        navC: UIViewController)
        case detailsVC(tabBar: UITabBarController)
    }
}

extension ListRouter: ListRouterProtocol {
    

    func routeTo(target: Targets) {
        switch target {
            case .searchCity(let coreData, let query, let navC):
                
              
                let sca = SearchCititesAssembly(coreDataService: coreData, querySerice: query)
                let searchCitiesViewController = sca.createViewController()
                
                navC.present(searchCitiesViewController, animated: true)
            
            case .detailsVC(let tabBar):
                tabBar.selectedIndex = 0
                
        }
    }
    
    
    func showAlert(on vc: UIViewController, with title: String) {
        
        let alertController = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        vc.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1500)) {
            alertController.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}

