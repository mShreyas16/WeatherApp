//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shreyas Mandhare on 28/06/24.
//

import UIKit
import Kingfisher
import CoreData

class WeatherDetailsViewController: UIViewController {
    
    
    //MARK: Properties
    var weatherModelData : WeatherDetailsModel?
    let commonData = AppCommonData.sharedInstance
    var viewModel = WeatherDetailsViewModel()
    let defaults = UserDefaults.standard
    
    
    //MARK: Outlets
    @IBOutlet weak var weatherListTableView: UITableView!
    @IBOutlet weak var textFieldView: UIView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
        
    }
    
    
    func setupAll() {
        setupDelegate()
        registerTheCell()
        setupUI()
        bindTheData()
    }
    
    
    func bindTheData() {
        
        let dataa = defaults.string(forKey: "weatherObject")
        
        if dataa != "" || dataa != nil {
            viewModel.getWeatherData(location: deSerializeTheData(jsonString: dataa ?? "") ?? "")
        } else {
            //Default Implementation
            viewModel.getWeatherData(location: "London")
        }
        
        viewModel.getDataClosure = {response in
            
            if response == .success {
                self.weatherModelData = self.viewModel.weatherDetailsModel
                
                
                if self.weatherModelData != nil {
                   var Daata = self.serializeTheData(dataModel: self.weatherModelData!)
                    
                    self.defaults.set(Daata, forKey: "weatherObject")
                    self.defaults.synchronize()
                }
                
                
                DispatchQueue.main.async {
                    self.weatherListTableView.reloadData()
                }
                
            } else {
                self.showAlert("Please enter a Valid Location")
            }
        }
        
        
    }
    
    func createData(dataString: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let weatherEntity = NSEntityDescription.entity(forEntityName: "WeatherData", in: managedContext)!
        
        let weatherData = NSManagedObject(entity: weatherEntity, insertInto: managedContext)
        
        weatherData.setValue("", forKey: "dataString")
        weatherData.setValue("MainData", forKey: "name")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveData() -> String {
        
        var resultData = ""
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return ""}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeatherData")
        
        
        do {
            let result = try managedContext.fetch(fetchrequest)
            
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "dataString") as! String)
                resultData = data.value(forKey: "dataString") as! String
            }
            
        } catch {
            
            print("Failed")
            
        }
        
        return resultData
        
    }
    
    
    func updateData(dataString : String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchrequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "WeatherData")
        fetchrequest.predicate = NSPredicate(format: "name = %@", "MainData")
        
        do{
            let test = try managedContext.fetch(fetchrequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("", forKey: "name")
            objectUpdate.setValue("", forKey: "dataString")
            do{
                try managedContext.save()
            }catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    
    func serializeTheData(dataModel: WeatherDetailsModel) -> String {
        
        var result = ""
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(dataModel)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            
//            print(json as Any, "JSONPrinted")
            result = json ?? ""
            

        } catch {
            print(error.localizedDescription)
        }
        
        return result
        
    }
    
    func deSerializeTheData(jsonString: String) -> String? {
        var result : WeatherDetailsModel?
        var dataa = defaults.string(forKey: "weatherObject")
        if dataa != "" {
            // Decode
            
            if let data = dataa?.data(using: .utf8) {
                let jsonDecoder = JSONDecoder()
                let object = try? jsonDecoder.decode(WeatherDetailsModel.self, from: data)
                result = object
            }
            
        }
        
        return result?.location.name
    }
    
    
    func registerTheCell() {
        let nib = UINib(nibName: "WeatherListTableViewCell", bundle: nil)
        weatherListTableView.register(nib, forCellReuseIdentifier: "WeatherListTableViewCell")
    }
    
    
    func setupUI() {
        textFieldView.layer.cornerRadius = 10
        textFieldView.layer.borderWidth = 1
        textFieldView.layer.borderColor = commonData.bordercolor
        
        searchButton.layer.cornerRadius = 5
        searchButton.layer.borderWidth = 1
        searchButton.layer.borderColor = commonData.bordercolor
        
        weatherListTableView.layer.cornerRadius = 10
    }
    
    
    func setupDelegate() {
        weatherListTableView.delegate = self
        weatherListTableView.dataSource = self
    }
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        if locationTextField.text != "" {
            
            viewModel.getWeatherData(location: locationTextField.text ?? "")
            
        } else {
            
            showAlert("Please Enter the Location")
           
        }
    }
    
    
    func showAlert(_ messege:String) {
        let alert = UIAlertController(title: "", message: messege, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { _ in alert.dismiss(animated: true, completion: nil)} )
    }
    
    
}


extension WeatherDetailsViewController :UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weatherModelData == nil {
            return 0
        } else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherListTableViewCell", for: indexPath) as! WeatherListTableViewCell
        
        cell.locationLabel.text = weatherModelData?.location.name
        cell.temperatureLabel.text = "Temperature : \(String(describing: weatherModelData?.current.tempC ?? 0)) °C"
        cell.weatherLabel.text = "Weather : \(weatherModelData?.current.condition.text ?? "")"
        cell.humidityLabel.text = "Humidity : \(String(describing: weatherModelData?.current.humidity ?? 0))"
        cell.windSpeedLabel.text = "WindSpeed : \(weatherModelData?.current.windMph ?? 0) m/h"
        cell.windDirection.text = "Wind Direction : \(weatherModelData?.current.windDir ?? "")"
        
        cell.windDegreeLabel.text = "Wind Degree : \(String(describing: weatherModelData?.current.windDegree ?? 0))"
        
        cell.visLabel.text = "vis : \(String(describing: weatherModelData?.current.visKM ?? 0))Km"
        
        cell.cloudLabel.text = "Cloud : \(String(describing: weatherModelData?.current.cloud ?? 0))"
        
        cell.uvLabel.text = "UV : \(weatherModelData?.current.uv ?? 0)"
        
        let url = URL(string: "https:\(weatherModelData?.current.condition.icon ?? "")" )
        cell.logoImageView.kf.setImage(with: url)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        300
    }
    
    
}



