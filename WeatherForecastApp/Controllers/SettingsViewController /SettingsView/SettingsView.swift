
import UIKit

protocol SelectedValueViewDelegate: AnyObject {
    func selectedValueTemperature(target: UISegmentedControl)
    func selectedValueWindSpeed(target: UISegmentedControl)
    func selectedValuePressure(target: UISegmentedControl)
    func selectedValuePrecipitation(target: UISegmentedControl)
    func selectedValueDistance (target: UISegmentedControl)
}

class SettingsView: UIScrollView {
    
    weak var delegateView: SelectedValueViewDelegate?
    
    let unitsLabel : UILabel = {
        let label = UILabel()
        label.text = "Units"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let tempLabel : UILabel = {
        let label = UILabel()
        label.text = "Temperature"
        label.font.withSize(18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let windSpeedLabel : UILabel = {
        let label = UILabel()
        label.text = "Wind speed"
        label.font.withSize(18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pressureLabel : UILabel = {
        let label = UILabel()
        label.text = "Pressure"
        label.font.withSize(18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let precipitationLabel : UILabel = {
        let label = UILabel()
        label.text = "Precipitation"
        label.font.withSize(18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel : UILabel = {
        let label = UILabel()
        label.text = "Distance"
        label.font.withSize(18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let temperatureSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl ( items : ["Celsius", "Fahrenheight", "Kelvin"] )
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.red
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let windSpeedSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl ( items : ["kph", "mph","mps","knot"] )
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.red
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let pressureSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl ( items : ["gPa", "Inhes","kPa","mm"] )
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.red
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let precipitationSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl ( items : ["Millimeters", "Inches"] )
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.red
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    let distanceSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl ( items : ["Killometers", "Miles"] )
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.tintColor = UIColor.red
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    
    let frameView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        frameView.addSubview(tempLabel)
        frameView.addSubview(windSpeedLabel)
        frameView.addSubview(pressureLabel)
        frameView.addSubview(precipitationLabel)
        frameView.addSubview(distanceLabel)
        
        frameView.addSubview(temperatureSegmentedControl)
        frameView.addSubview(windSpeedSegmentedControl)
        frameView.addSubview(pressureSegmentedControl)
        frameView.addSubview(precipitationSegmentedControl)
        frameView.addSubview(distanceSegmentedControl)
        
        addSubview(frameView)
        addSubview(unitsLabel)
        
        setupActions()
        setupConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupConstraints()
    }
    
    
    private func setupActions() {
        // if value of the segmentControl changes, it will call a method inside SettingsView, which in turn will call a delegate (SVC) method
        temperatureSegmentedControl.addTarget(self, action: #selector(selectedValueTemperature), for: .valueChanged)
        windSpeedSegmentedControl.addTarget(self, action: #selector(selectedValueWindSpeed), for: .valueChanged)
        precipitationSegmentedControl.addTarget(self, action: #selector(selectedValuePrecipitation), for: .valueChanged)
        distanceSegmentedControl.addTarget(self, action: #selector(selectedValueDistance), for: .valueChanged)
        pressureSegmentedControl.addTarget(self, action: #selector(selectedValuePressure), for: .valueChanged)
    }
    
    func setupConstraints() {
        
        unitsLabel.topAnchor.constraint(equalTo: self.topAnchor,constant: 20).isActive = true
        unitsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 20).isActive = true
        unitsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -20).isActive = true
        
        tempLabel.topAnchor.constraint(equalTo: frameView.topAnchor,constant: 20).isActive = true
        tempLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        tempLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        temperatureSegmentedControl.topAnchor.constraint(equalTo: tempLabel.bottomAnchor,constant: 15).isActive = true
        temperatureSegmentedControl.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        temperatureSegmentedControl.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        temperatureSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        windSpeedLabel.topAnchor.constraint(equalTo: temperatureSegmentedControl.bottomAnchor,constant: 20).isActive = true
        windSpeedLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        windSpeedLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        windSpeedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        windSpeedSegmentedControl.topAnchor.constraint(equalTo: windSpeedLabel.bottomAnchor,constant: 15).isActive = true
        windSpeedSegmentedControl.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        windSpeedSegmentedControl.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        windSpeedSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        pressureLabel.topAnchor.constraint(equalTo: windSpeedSegmentedControl.bottomAnchor,constant: 20).isActive = true
        pressureLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        pressureLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        pressureLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        pressureSegmentedControl.topAnchor.constraint(equalTo: pressureLabel.bottomAnchor,constant: 15).isActive = true
        pressureSegmentedControl.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        pressureSegmentedControl.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        pressureSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        precipitationLabel.topAnchor.constraint(equalTo: pressureSegmentedControl.bottomAnchor,constant: 20).isActive = true
        precipitationLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        precipitationLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        precipitationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        precipitationSegmentedControl.topAnchor.constraint(equalTo: precipitationLabel.bottomAnchor,constant: 15).isActive = true
        precipitationSegmentedControl.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        precipitationSegmentedControl.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        precipitationSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: precipitationSegmentedControl.bottomAnchor,constant: 20).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        distanceSegmentedControl.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor,constant: 15).isActive = true
        distanceSegmentedControl.leadingAnchor.constraint(equalTo: frameView.leadingAnchor,constant: 20).isActive = true
        distanceSegmentedControl.trailingAnchor.constraint(equalTo: frameView.trailingAnchor,constant: -20).isActive = true
        distanceSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        frameView.topAnchor.constraint(equalTo: self.topAnchor,constant: 60).isActive = true
        frameView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        frameView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -40).isActive = true
        frameView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -30).isActive = true
        frameView.heightAnchor.constraint(equalToConstant: 480).isActive = true
    }
}

extension SettingsView {
    @objc func selectedValueTemperature(target: UISegmentedControl) {
        if target == self.temperatureSegmentedControl {
            delegateView?.selectedValueTemperature(target: target) // calling func from inside SettingsViewController cuz SVC is assigned as a delegateView
        }
    }
    
    @objc func selectedValueWindSpeed(target: UISegmentedControl) {
        if target == self.windSpeedSegmentedControl {
            delegateView?.selectedValueWindSpeed(target: target)
        }
    }
    
    
    @objc func selectedValuePressure(target: UISegmentedControl) {
        if target == self.pressureSegmentedControl {
            delegateView?.selectedValuePressure(target: target)
        }
    }
    
    @objc func selectedValuePrecipitation(target: UISegmentedControl) {
        if target == self.precipitationSegmentedControl {
            delegateView?.selectedValuePrecipitation(target: target)
        }
    }
    
    @objc func selectedValueDistance(target: UISegmentedControl) {
        if target == self.distanceSegmentedControl {
            delegateView?.selectedValueDistance(target: target)
        }
    }
    
}
