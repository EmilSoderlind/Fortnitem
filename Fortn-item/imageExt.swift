//
//  imageExt.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-18.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        print("Starting image-parse")
        let t = Date()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    print("Could not parse UIImage from data.")
                    return
            }
            DispatchQueue.main.async() {
                self.image = image
                print("Starting image-parse - DONE (\(-t.timeIntervalSinceNow)s)")
            }
        }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else {
            print("Url-parsing dosen't work.")
            return
        }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Formatter.iso8601.date(from: self)   // "Mar 22, 2017, 10:22 AM"
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data)
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

extension UIView{
    func setGradientBackground(item: itemModelItem){
        
        var firstColor:UIColor = UIColor()
        var secondColor:UIColor = UIColor()
        
        if(item.rarity == "common"){
            firstColor = UIColor(red: 193.0/255.0, green: 194.0/255.0, blue: 194, alpha: 1)
            secondColor = UIColor(red: 146.0/255.0, green: 148.0/255.0, blue: 149.0/255.0, alpha: 1)
            
        }else if(item.rarity == "uncommon"){
            firstColor = UIColor(red: 72.0/255.0, green: 160.0/255.0, blue: 4.0/255.0, alpha: 1)
            secondColor = UIColor(red: 12.0/255.0, green: 120.0/255.0, blue: 9.0/255.0, alpha: 1)
            
        }else if(item.rarity == "rare"){
            firstColor = UIColor(red: 51.0/255.0, green: 180.0/255.0, blue: 239.0/255.0, alpha: 1)
            secondColor = UIColor(red: 9.0/255.0, green: 105.0/255.0, blue: 176.0/255.0, alpha: 1)
            
        }else if(item.rarity == "epic"){
            firstColor = UIColor(red: 191.0/255.0, green: 98.0/255.0, blue: 227.0/255.0, alpha: 1)
            secondColor = UIColor(red: 131.0/255.0, green: 22.0/255.0, blue: 175.0/255.0, alpha: 1)
            
        }else if(item.rarity == "legendary"){
            firstColor = UIColor(red: 223.0/255.0, green: 133.0/255.0, blue: 41.0/255.0, alpha: 1)
            secondColor = UIColor(red: 147.0/255.0, green: 88.0/255.0, blue: 50.0/255.0, alpha: 1)
        }
        
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [secondColor.cgColor, firstColor.cgColor]
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        // If cell dosen't have gradient background, add it!
        
        if(!(self.layer.sublayers?.contains(gradientLayer))!){
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
}
