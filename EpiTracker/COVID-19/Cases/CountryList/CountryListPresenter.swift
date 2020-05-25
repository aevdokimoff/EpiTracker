//
//  CountryListPresenter.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation

class CountryListPresenter: CountryListPresenterProtocol {
    weak var view: CountryListViewProtocol?
    var interactor: CountryListInteractorInputProtocol?
    var wireFrame: CountryListWireFrameProtocol?
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.retrieveCountryList()
    }
    
    func showCountryDetail(forCountry country: CountryModel?) {
        wireFrame?.presentCountryDetailScreen(from: view!, forCountry: country)
    }

}

extension CountryListPresenter: CountryListInteractorOutputProtocol {
    
    func didRetrieveCountries(_ countries: [CountryModel]) {
        view?.hideLoading()
        view?.showCountries(with: countries)
    }
    
    func onError() {
        view?.hideLoading()
        view?.showError()
    }
    
}

