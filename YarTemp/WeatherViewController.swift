import UIKit
import SwiftSoup

class WeatherViewController: UIViewController {
    
    let weatherURL: String = "https://yartemp.com/mini/"
    var currentWeatherData: [String:String]? = nil
    
    
    struct settings{
        static var isImperialUnitSystem = false
    }
    
    @IBOutlet var mainVIew: UIView!
    @IBOutlet var currentTempTextField: UILabel!
    @IBOutlet var currentPresureTextField: UILabel!
    @IBOutlet var tempOneYearAgoTextField: UILabel!
    @IBOutlet var updateLabelTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeather()
    }
    
    @IBOutlet var weatherInfoTextField: UILabel!
    
    @IBAction func buttonTapped(_ sender: Any) {
        updateWeather()
    }
    
    
    
    func updateWeather(){
        guard let weatherList = getWeather(url: weatherURL) else { return }
        currentWeatherData = weatherList
        updateWeatherUI(weatherDataParsedDict: weatherList, isNew: true)
    }
    
    func getWeather(url: String) -> [String:String]?{
        guard let weatherData = getWeatherRawData(url: url)
        else{
            print("Не удалось подключиться к серверу погоды")
            return nil
        }
        
        guard let weather = parseWeather(weatherDataList: weatherData)
        else{
            print("Не удалось распарсить погоду")
            return nil
        }
        return weather
        
    }

    func getWeatherRawData(url: String) -> [String]?{
        var result: [String] = []
        guard let url = URL(string: url) else {
            return nil
        }
        do {
            let html = try String(contentsOf: url)
            let document = try SwiftSoup.parse(html)
            let div = try document.select("div")
            let brTags = try div.select("br")
            
            for br in brTags {
                if let nextSibling = try br.nextElementSibling() {
                    let text = try nextSibling.text()
                    result.append(text)
                }
            }
            return result
        } catch {
            return nil
        }
    }
    
    func parseWeather(weatherDataList: [String]) -> [String: String]?{
        var resultDict: [String: String] = [:]
        resultDict["CurrentTemperatureCelcius"] = weatherDataList[0]
        resultDict["TemperatureOneYearAgoCelcius"] = weatherDataList[4]
        resultDict["PresuremmHg"] = getPresure(rawString: weatherDataList[3])!
        return resultDict

    }

    func getPresure(rawString: String) -> String?{
        do {
            let regex = try NSRegularExpression(pattern: "\\b\\d+\\b", options: [])
            if let match = regex.firstMatch(in: rawString, options: [], range: NSRange(location: 0, length: rawString.utf16.count)) {
                if let range = Range(match.range, in: rawString) {
                    let numberString = rawString[range]
                    if let number = Int(numberString) {
                        return String(number)
                    }
                }
            }
        } catch {
            print("Ошибка при использовании регулярных выражений:", error)
        }
        return nil
        
    }
    
    
    func updateWeatherUI(weatherDataParsedDict: [String: String], isNew: Bool){
        var currentTemp = String(Int(Double(weatherDataParsedDict["CurrentTemperatureCelcius"]!)!.rounded(.up)))
        var currentPresure = weatherDataParsedDict["PresuremmHg"]!
        var tempOneYearAgo = String(Int(Double(weatherDataParsedDict["TemperatureOneYearAgoCelcius"]!)!.rounded(.up)))
        
        if !settings.isImperialUnitSystem{
            currentTemp+=" °C"
            currentPresure+=" мм. рт. ст."
            tempOneYearAgo+=" °C"
        } else{
            currentTemp = toFahrenheit(celcius: currentTemp) + " °F"
            currentPresure = toInHg(mmHg: currentPresure) + "\" рт. ст."
            tempOneYearAgo = toFahrenheit(celcius: tempOneYearAgo) + " °F"
        }
        
        currentTempTextField.text = currentTemp
        currentPresureTextField.text = currentPresure
        tempOneYearAgoTextField.text = tempOneYearAgo
        
        if isNew{
            updateUpdateLabel()
        }
        
    }
    
    func updateUpdateLabel(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss"
        let currentTime = format.string(from: date)
        updateLabelTextField.text = "Обновлено " + currentTime
    }
    
    
    func toFahrenheit(celcius: String) -> String{
        let celcius = Double(celcius)!
        return String(Int((celcius * 1.8).rounded(.up)) + 32)
    }
    
    func toInHg(mmHg: String) -> String{
        let mmHg = Double(mmHg)!
        return String(Int((mmHg / 25.4).rounded(.up)))
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateWeatherUI(weatherDataParsedDict: currentWeatherData!, isNew: false)
    }
}
