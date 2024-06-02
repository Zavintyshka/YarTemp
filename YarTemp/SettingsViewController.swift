import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet var weatherInfoTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func imperialSwitchToggled(_ sender: UISwitch) {
        WeatherViewController.settings.isImperialUnitSystem = sender.isOn
    }

    
}
