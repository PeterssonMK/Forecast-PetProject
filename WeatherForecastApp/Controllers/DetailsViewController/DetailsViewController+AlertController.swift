
import UIKit

extension DetailsViewController {
    
    func presentErrorAlert(error: Error) {
        
        var errorTitle = ""
        var errorMessage = "Repeat the request"
        
        let error = error as? NetworkManagerError
        
        switch error {
        case .errorStatusCode:
            errorTitle = "Error fetching data from server"
        case .errorServer:
            errorTitle = "Error fetching data from server"
            errorMessage = "Check your Wi-Fi connection to access the data"
        case .errorParseJSON:
            errorTitle = " Error in data Serialization"
        case .errorMimeType:
            errorTitle = "The returned data type is not supported"
        case .errorUrl:
            errorTitle = "The request can't be accepted by server"
        default:
            return
        }
        
        let alertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
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
        
        present(alertController, animated: true, completion: nil)
    }
}

