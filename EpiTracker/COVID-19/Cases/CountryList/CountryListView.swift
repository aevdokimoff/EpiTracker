//
//  CountryListView.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import UIKit
import SPAlert
import PKHUD

class CountryListView: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: CountryListPresenterProtocol?
    var countryList: [CountryModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        CountryListWireFrame.createCountryListModule(countryListRef: self)
        presenter?.viewDidLoad()
        tableView.tableFooterView = UIView()
    }
}

extension CountryListView: CountryListViewProtocol {
    
    func showCountries(with countries: [CountryModel]) {
        countryList = countries
        tableView.reloadData()
    }
    
    func showError() {
        let alertView = SPAlertView(title: "No Internet connection", message: nil, preset: SPAlertPreset.done)
        alertView.duration = 1.0
        alertView.present()
    }
    
    func showLoading() {
        HUD.show(.progress)
    }
    
    func hideLoading() {
        HUD.hide()
    }
    
}

extension CountryListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryListCell
        
        let country = countryList[indexPath.row]
        cell.set(forCountry: country)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countryList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showCountryDetail(forCountry: countryList[indexPath.row])
    }
    
}
