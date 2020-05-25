//
//  CountryListInteractor.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation


class CountryListInteractor: CountryListInteractorInputProtocol {

    weak var presenter: CountryListInteractorOutputProtocol?
    var remoteDatamanager: RemoteDataManagerInputProtocol?
    
    func retrieveCountryList() {
        remoteDatamanager?.retrieveCountryData()
    }
        
}

extension CountryListInteractor: RemoteDataManagerOutputProtocol {
    
    func onCountryRetrieved(_ country: [CountryModel]) {
        presenter?.didRetrieveCountries(country)
    }
    
    func onError() {
        presenter?.onError()
    }
    
}
