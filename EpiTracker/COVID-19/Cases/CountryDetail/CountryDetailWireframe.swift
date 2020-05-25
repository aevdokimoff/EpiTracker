//
//  CountryDetailWireframe.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import UIKit

class CountryDetailWireFrame: CountryDetailWireFrameProtocol {

    class func createCountryDetailModule(forCountry country: CountryModel?) -> UIViewController {
           let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CountryDetailController")
           if let view = viewController as? CountryDetailView {
               let presenter: CountryDetailPresenterProtocol = CountryDetailPresenter()
               let wireFrame: CountryDetailWireFrameProtocol = CountryDetailWireFrame()
               
               view.presenter = presenter
               presenter.view = view
               presenter.country = country
               presenter.wireFrame = wireFrame
               
               return viewController
           }
           return UIViewController()
       }
       
       static var mainStoryboard: UIStoryboard {
           return UIStoryboard(name: "Main", bundle: Bundle.main)
       }
    
}
