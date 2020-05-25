//
//  CountryModel.swift
//  Covid19Tracker
//
//  Created by Dhiky Aldwiansyah on 15/04/20.
//  Copyright © 2020 Kyald. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - CountryElement
class CountryModel : NSObject {
    var updated = 0
    var country = ""
    var countryInfo: CountryInfo? = nil
    var cases =  0
    var todayCases = 0
    var deaths = 0
    var todayDeaths = 0
    var recovered = 0
    var active = 0
    var critical = 0
    var casesPerOneMillion = 0
    var deathsPerOneMillion = 0
    var tests = 0
    var testsPerOneMillion = 0
    
    
    override init(){} //Constructor
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        updated = json["updated"].intValue
        country = json["country"].stringValue
        cases = json["cases"].intValue
        deaths = json["deaths"].intValue
        todayCases = json["todayCases"].intValue
        recovered = json["recovered"].intValue
        active = json["active"].intValue
        critical = json["critical"].intValue
        casesPerOneMillion = json["casesPerOneMillion"].intValue
        deathsPerOneMillion = json["deathsPerOneMillion"].intValue
        tests = json["tests"].intValue
        testsPerOneMillion = json["testsPerOneMillion"].intValue
        let countryInfoJson = json["countryInfo"]
        if !countryInfoJson.isEmpty{
            countryInfo = CountryInfo(fromJson: countryInfoJson)
        }
    }
    
}


// MARK: - CountryInfo
class CountryInfo : NSObject {
    var id = 0
    var iso2 = ""
    var iso3 = ""
    var lat = 0.0
    var long = 0.0
    var flag = ""
    
    override init(){} //Constructor
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json["id"].intValue
        iso2 = json["iso2"].stringValue
        iso3 = json["iso3"].stringValue
        lat = json["lat"].doubleValue
        long = json["long"].doubleValue
        flag = json["flag"].stringValue
    }
}
