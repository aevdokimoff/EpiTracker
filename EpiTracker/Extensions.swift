//
//  Covid19DetectionVC.swift
//  EpiTracker
//
//  Created by Artem Evdokimov on 25.05.20.
//  Copyright © 2020 Artem Evdokimov. All rights reserved.
//

import UIKit
import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity

        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

extension UIColor {
    static func colorFor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1)
    }
}

// Credits: https://stackoverflow.com/questions/55653187/swift-default-alertviewcontroller-breaking-constraints
extension UIAlertController {
    func fixiOSAutolayoutNegativeConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

extension UIView {
    func autolayoutAddSubview(_ view: UIView) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension UIViewController {
    func presentOkAlertWithMessage(_ message: String) {
        let alertvc = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertvc.addAction(action)
        self.present(alertvc, animated: true, completion: nil)
    }
}

extension URL {
    func get<T: Codable>(completion: @escaping (Result<T, ApiError>) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: self) { data, _, error in
            if let _ = error {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }
            
            guard let unwrapped = data else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let result = try? decoder.decode(T.self, from: unwrapped) {
                DispatchQueue.main.async {
                    completion(.success(result))
                }
            }
            else {
                DispatchQueue.main.async {
                    completion(.failure(.generic))
                }
            }
        }
        
        task.resume()
    }
}

enum ApiError: Error {
    case generic
}

extension ApiError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .generic:
            return NSLocalizedString("Could not retrieve data.", comment: "")
        }
    }
}
