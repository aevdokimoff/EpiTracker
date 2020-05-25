//
//  CountryDetailPresenter.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation

class CountryDetailPresenter: CountryDetailPresenterProtocol {
    
    weak var view: CountryDetailViewProtocol?
    var wireFrame: CountryDetailWireFrameProtocol?

    var country: CountryModel?

    func viewDidLoad() {
        view?.showCountryDetail(forCountry: country)
    }
    

}


