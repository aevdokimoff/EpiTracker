//
//  Commons.swift
//  EpiTracker
//
//  Created by Artem on 26.05.20.
//  Copyright © 2020 Artem. All rights reserved.
//

import Foundation

func checkCaseAddedOnce() -> Bool {
    let key = "isDiseaseAddedOnce"
    
    return UserDefaults.standard.object(forKey: key) != nil && UserDefaults.standard.bool(forKey: key)
}
