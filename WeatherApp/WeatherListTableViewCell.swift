//
//  WeatherListTableViewCell.swift
//  WeatherApp
//
//  Created by Shreyas Mandhare on 29/06/24.
//

import UIKit

class WeatherListTableViewCell: UITableViewCell {
    
    let commonData = AppCommonData.sharedInstance
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var windDegreeLabel: UILabel!
    
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var uvLabel: UILabel!
    @IBOutlet weak var visLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    func setupUI() {
        outerView.layer.cornerRadius = 10
        outerView.layer.borderWidth = 1
        outerView.layer.borderColor = commonData.bordercolor
    }
    
}
