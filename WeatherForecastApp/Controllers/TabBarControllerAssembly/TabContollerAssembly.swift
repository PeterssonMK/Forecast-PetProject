
import UIKit


// Container class for 3 VC.

// instantiates in  sceneDelegate !

final class TabBarControllerAssembly {
    
    let coreDataService: ReadableDatabase & WritableDatabase
    let userDefaultsManager: UserDefaultsManagerProtocol
    
    init(coreDataService: ReadableDatabase & WritableDatabase = CoreDataService(),
         userDefaultsManager: UserDefaultsManagerProtocol = UserDefaultsManager()) {
        self.coreDataService = coreDataService
        self.userDefaultsManager = userDefaultsManager
    }
    
    func createViewController() -> UITabBarController {
        
        
      
        let detailsViewControllerAssembly = DetailsViewControllerAssembly(coreDataService: coreDataService, userDefaultsManager: userDefaultsManager)
        let detailsViewController = detailsViewControllerAssembly.createViewController()
        
        let listViewControllerAssembly = ListViewControllerAssembly(coreDataService: coreDataService, userDefaultsManager: userDefaultsManager)
        
        let listViewController = listViewControllerAssembly.createViewController(detailsViewController: detailsViewController)
        
        let navigationControllerRootList = UINavigationController(rootViewController: listViewController)
        let customizationViewController = UINavigationController(rootViewController: SettingsViewController(userDefaultsManager: userDefaultsManager))
        
        
        
        
        
        // icons for tabbarItem
        let thermometerImage = UIImage(systemName: "thermometer")
        let globeImage = UIImage(systemName: "globe")
        let gearImage = UIImage(systemName: "gear")
        
        
        // full scale tabbarItem
        let thermometerTabBarItem = UITabBarItem(title: "Weather", image: thermometerImage, tag: 0)
        let globeTabBarItem = UITabBarItem(title: "Cities", image: globeImage, tag: 1)
        let gearTabBarItem = UITabBarItem(title: "Settings", image: gearImage, tag: 2)
        
        // custom tabbaritem is assigned to the property of VC, not TabBarController
        detailsViewController.tabBarItem = thermometerTabBarItem
        listViewController.tabBarItem = globeTabBarItem
        customizationViewController.tabBarItem = gearTabBarItem
        
        let tabBarController = UITabBarController()
        
        let tabBarList = [detailsViewController, navigationControllerRootList, customizationViewController]
        
        tabBarController.viewControllers = tabBarList
        
        return tabBarController
    }
    
}
