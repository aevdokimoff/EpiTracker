//
//  RemoteDataManager.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol RemoteDataManagerInputProtocol: class {
    var remoteRequestHandler: RemoteDataManagerOutputProtocol? { get set }
    func retrieveCountryData()
}

protocol RemoteDataManagerOutputProtocol: class {
    func onCountryRetrieved(_ countryModel: [CountryModel])
    func onError()
}

class RemoteDataManager:RemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: RemoteDataManagerOutputProtocol?
    
    func retrieveCountryData() {
        
        print("HAYO REQUEST GAK")

        AF.request(Endpoints.Corona.fetch.url, method: .get)
            .validate()
            
            .responseJSON(completionHandler: { (response) in
                
                switch response.result {
                case .success(let countries):
                    
                    let countries = JSON(countries).arrayValue
                    var data = [CountryModel]()
                    
                    for dataJson in countries{
                        let value = CountryModel.init(fromJson: dataJson)
                        data.append(value)
                    }
                    
                    print("SUCCESS \(data)")
                    
                    self.remoteRequestHandler?.onCountryRetrieved(data)
                    
                case .failure( _):
                    
                    print("ERROR")
                    
                    self.remoteRequestHandler?.onError()
                }
                
            })
        
    }

}
