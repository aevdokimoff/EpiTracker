//
//  CountryListWireframe.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import UIKit

class CountryListWireFrame: CountryListWireFrameProtocol {
    
    class func createCountryListModule(countryListRef: CountryListView) {
        
        let presenter: CountryListPresenterProtocol & CountryListInteractorOutputProtocol = CountryListPresenter()
        let interactor: CountryListInteractorInputProtocol & RemoteDataManagerOutputProtocol = CountryListInteractor()
        let remoteDataManager: RemoteDataManagerInputProtocol = RemoteDataManager()
        let wireFrame: CountryListWireFrameProtocol = CountryListWireFrame()
                
        countryListRef.presenter = presenter
        presenter.view = countryListRef
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.remoteDatamanager = remoteDataManager
        remoteDataManager.remoteRequestHandler = interactor
        
    }
    
    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
    

    func presentCountryDetailScreen(from view: CountryListViewProtocol, forCountry country: CountryModel?) {
        let countryDetailViewController = CountryDetailWireFrame.createCountryDetailModule(forCountry: country)

        if let sourceView = view as? UIViewController {
           sourceView.navigationController?.pushViewController(countryDetailViewController, animated: true)
        }
    }
    
}
