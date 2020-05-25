//
//  CountryListCell.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import UIKit
import AlamofireImage

class CountryListCell: UITableViewCell {

    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblRecovered: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    
    func set(forCountry country: CountryModel) {
        self.selectionStyle = .none
        lblCountry?.text = country.country
        lblRecovered?.text = "Recovered: \(country.recovered)"
        lblActive?.text = "Active: \(country.active)"
        let url = URL(string: country.countryInfo?.flag ?? "")!
        let placeholderImage = UIImage(named: "flag_placeholder")!
        imgCountry?.af_setImage(withURL: url, placeholderImage: placeholderImage)
    }
    
}
