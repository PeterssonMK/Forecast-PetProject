
import UIKit

class SettingsViewController: UIViewController {
    
    private lazy var сustomizationView = SettingsView()
    private var userDefaultsManager: UserDefaultsManagerProtocol
    
    init(userDefaultsManager: UserDefaultsManagerProtocol) {
        self.userDefaultsManager = userDefaultsManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = сustomizationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        сustomizationView.delegateView = self
        // assigning SVC as a Delegate for SettingsView, respective methods (ex:  selectedValueTemperature)  will be called by SettingsView via SVC => their realization is in SVC
        installSegmentedControl()
        //every time the third sceen loads, it installs the values for SegmentControls. Values are obtained from UserDefaults, they appear in UserDefaults when user changes the selectedSegmentIndex => calls up #selector method (see SettingsView)
    }
    
    func installSegmentedControl() {
        
        let temperature: String? = userDefaultsManager.get(key: .temperature)
        
        switch temperature {
        case "F":
            сustomizationView.temperatureSegmentedControl.selectedSegmentIndex = 1
        case "K":
            сustomizationView.temperatureSegmentedControl.selectedSegmentIndex = 2
        default:
            сustomizationView.temperatureSegmentedControl.selectedSegmentIndex = 0
        }
        
        let speed: String? = userDefaultsManager.get(key: .speed)
        
        switch speed {
        case "km":
            сustomizationView.windSpeedSegmentedControl.selectedSegmentIndex = 0
        case "milie":
            сustomizationView.windSpeedSegmentedControl.selectedSegmentIndex = 1
        case "kn":
            сustomizationView.windSpeedSegmentedControl.selectedSegmentIndex = 3
        default:
            сustomizationView.windSpeedSegmentedControl.selectedSegmentIndex = 2
        }
        
        let pressure: String? = userDefaultsManager.get(key: .pressure)
        
        switch pressure {
        case "kPa":
            сustomizationView.pressureSegmentedControl.selectedSegmentIndex = 2
        case "mm":
            сustomizationView.pressureSegmentedControl.selectedSegmentIndex = 3
        case "inch":
            сustomizationView.pressureSegmentedControl.selectedSegmentIndex = 1
        default:
            сustomizationView.pressureSegmentedControl.selectedSegmentIndex = 0
        }
    }
    
}


extension SettingsViewController: SelectedValueViewDelegate {
    
    func selectedValueTemperature(target: UISegmentedControl) {
        
        switch target.selectedSegmentIndex {
        case 0:
            userDefaultsManager.save("C", key: .temperature)
        case 1:
            userDefaultsManager.save("F", key: .temperature)
        case 2:
            userDefaultsManager.save("K", key: .temperature)
        default:
            break
        }
    }
    
    func selectedValueWindSpeed(target: UISegmentedControl) {
        
        switch target.selectedSegmentIndex {
        case 0:
            userDefaultsManager.save("km", key: .speed)
        case 1:
            userDefaultsManager.save("milie", key: .speed)
        case 2:
            userDefaultsManager.save("m", key: .speed)
        case 3:
            userDefaultsManager.save("kn", key: .speed)
        default:
            break
        }
    }
    
    func selectedValuePressure(target: UISegmentedControl) {
        
        switch target.selectedSegmentIndex {
        case 0:
            userDefaultsManager.save("hPa", key: .pressure)
        case 1:
            userDefaultsManager.save("inch", key: .pressure)
        case 2:
            userDefaultsManager.save("kPa", key: .pressure)
        case 3:
            userDefaultsManager.save("mm", key: .pressure)
        default:
            break
        }
    }
    
    func selectedValuePrecipitation(target: UISegmentedControl) {
        
    }
    
    func selectedValueDistance(target: UISegmentedControl) {
        
    }
}
