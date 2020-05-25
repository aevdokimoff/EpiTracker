//
//  CountryDetailProtocol.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import UIKit

protocol CountryDetailViewProtocol: class {
    var presenter: CountryDetailPresenterProtocol? { get set }
       
    func showCountryDetail(forCountry country: CountryModel?)
}

protocol CountryDetailWireFrameProtocol: class {
    static func createCountryDetailModule(forCountry country: CountryModel?) -> UIViewController
}

protocol CountryDetailPresenterProtocol: class {
    var view: CountryDetailViewProtocol? { get set }
    var wireFrame: CountryDetailWireFrameProtocol? { get set }
    var country : CountryModel? { get set }

    func viewDidLoad()
}
