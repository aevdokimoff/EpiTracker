//
//  CountryListProtocol.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import UIKit

protocol CountryListViewProtocol: class {
    var presenter: CountryListPresenterProtocol? { get set }
    
    func showCountries(with countries: [CountryModel])
    
    func showError()
    
    func showLoading()
    
    func hideLoading()
}

protocol CountryListWireFrameProtocol: class {
    static func createCountryListModule(countryListRef: CountryListView)
    func presentCountryDetailScreen(from view: CountryListViewProtocol, forCountry country: CountryModel?)
}

protocol CountryListPresenterProtocol: class {
    var view: CountryListViewProtocol? { get set }
    var interactor: CountryListInteractorInputProtocol? { get set }
    var wireFrame: CountryListWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func showCountryDetail(forCountry country: CountryModel?)
}

protocol CountryListInteractorInputProtocol: class {
    var presenter: CountryListInteractorOutputProtocol? { get set }
    var remoteDatamanager: RemoteDataManagerInputProtocol? { get set }
    
    func retrieveCountryList()
}

protocol CountryListInteractorOutputProtocol: class {
    func didRetrieveCountries(_ countries: [CountryModel])
    func onError()
}
