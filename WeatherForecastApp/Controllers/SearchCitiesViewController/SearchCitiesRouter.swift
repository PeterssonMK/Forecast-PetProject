
import Foundation
import UIKit

protocol SearchCitiesRouterProtocol:AnyObject {
    
    func routeTo(target: SearchCitiesRouter.Targets)
    func showError(error: (String,String), on vc: UIViewController)
}

final class SearchCitiesRouter{
    
    weak var presenter: SearchCitiesPresenterProtocol?
    
    enum Targets{
        case listViewContoller(from: UIViewController, with: СityWeatherCopy)
    }
    
}

extension SearchCitiesRouter: SearchCitiesRouterProtocol{
    func routeTo(target: Targets) {
        switch target {
            case .listViewContoller(let fromVC, let copy):
                
                guard let tabbar = fromVC.presentingViewController as? UITabBarController else {return}
                guard let  navc = tabbar.viewControllers?[1] as? UINavigationController else {return}
                guard let listvc = navc.viewControllers[0] as? ListViewController else {return}
                
                DispatchQueue.main.async {
                    listvc.presenter?.updateFromSearchCities(received: copy)
                    listvc.presenter?.updateDetailsVC(with:copy)
                    listvc.dismiss(animated: true)
                }
                
        }
        
    }
    
    func showError(error: (String,String), on vc: UIViewController){
        
        
        let alertController = UIAlertController(title: error.0, message: error.1, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let settings = UIAlertAction(title: "Settings", style: .default) { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                })
            }
        }
        
        alertController.addAction(settings)
        alertController.addAction(cancel)
        
        vc.present(alertController, animated: true, completion: nil)
        
        }
    }
    

