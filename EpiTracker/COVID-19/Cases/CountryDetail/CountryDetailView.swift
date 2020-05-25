//
//  CountryDetailView.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import UIKit

class CountryDetailView: UIViewController {
    
    var presenter: CountryDetailPresenterProtocol?
    
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRecovered: UILabel!
    
    @IBOutlet weak var lblActiveCase: UILabel!
    @IBOutlet weak var lblInfectedCase: UILabel!
    @IBOutlet weak var lblDeathCase: UILabel!

    @IBOutlet weak var lblDeathDaily: UILabel!
    @IBOutlet weak var lblInfectedDaily: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }
}

extension CountryDetailView: CountryDetailViewProtocol {
    func showCountryDetail(forCountry country: CountryModel?) {
        
        lblCountry?.text = country?.country
        lblRecovered?.text = "\(country?.recovered ?? 0)"
        
        lblActiveCase?.text = "\(country?.active ?? 0)"
        lblInfectedCase?.text = "\(country?.cases ?? 0)"
        lblDeathCase?.text = "\(country?.deaths ?? 0)"

        lblDeathDaily?.text = "\(country?.todayDeaths ?? 0)"
        lblInfectedDaily?.text = "\(country?.todayCases ?? 0)"

        let url = URL(string: country?.countryInfo?.flag ?? "")!
        let placeholderImage = UIImage(named: "flag_placeholder")!
        imgFlag?.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
}
