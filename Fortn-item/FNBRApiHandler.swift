//
//  ApiHandler.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit

// Class responsible for talking directly to FNBR
class FNBRApiHandler {
    
    var mainView:TodaysTableViewController?
    
    func parseCurrentItems(vc:TodaysTableViewController){
        
        var startDate:Date = Date()
        
        mainView = vc
        
        let urlString = URL(string: "https://fnbr.co/api/shop")
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:urlString!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        request.addValue("a2343d32-90a6-49a6-b905-262f15415acb", forHTTPHeaderField: "x-api-key")
        
        // Excute HTTP Request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, err in
            
            // If we get a error
            if(err != nil){
                print("Something wrong with URLSession.shared.dataTask - Error is NOT nill",err!)
                return
            }
            
            // If response isn't code 200
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                if(httpResponse.statusCode != 200){
                    print("We didn't get status code 200.")
                    return
                }
            }
            
            // If the data is faulty
            guard let data = data else {
                print("Faulty data!")
                return
            }
                        
            do {
                
                var dataString = String(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                dataString = dataString.replacingOccurrences(of: ":false}", with: ":\"\"}", options: .literal, range: nil)
                dataString = dataString.replacingOccurrences(of: ":false,", with: ":\"\",", options: .literal, range: nil)
                let fetch = try JSONDecoder().decode(FullFetch.self, from: dataString.data(using: String.Encoding.utf8)!)
                
                let publishDate:Date = fetch.data.date.dateFromISO8601!
                
                let nrOfDaily:Int = fetch.data.daily.count
                let nrOfFeatured:Int = fetch.data.featured.count

                var iml:ItemModelList = ItemModelList(date: publishDate, featured: [], daily: [])
                
                // Parse daily to itemModelItem (with images)
                for i in 0..<nrOfDaily {
                    iml.daily.append(self.convertToItemModelItem(fi: (fetch.data.daily[i])))
                }
                
                // Parse daily to itemModelItem (with images)
                for i in 0..<nrOfFeatured {
                    iml.featured.append(self.convertToItemModelItem(fi: (fetch.data.featured[i])))
                }
                
                print("Parse took: ",-startDate.timeIntervalSinceNow)
                // When we got data, do stuff on main queue
                DispatchQueue.main.async {
                    
                    vc.doneParsing(parsedIML: iml)
                    
                }
             
            } catch let err {
                print("Error serializing json:", err)
            }
            
            
            }
            task.resume()
        
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                
                
                
                //self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    // Convert and parse images to itemModelItems
    func convertToItemModelItem(fi:FortniteItem) -> itemModelItem {
        print("convertToItemModelItem (parse images)")
        
        let newPriceIconLink:UIImage = parseImgURL(uri: fi.priceIconLink)
        
        var newIconImg = UIImage()
        var newPngImg = UIImage()
        
        if(fi.type == "emote"){
            newIconImg = parseImgURL(uri: fi.images["icon"]!)
        
        }else{
            newPngImg = parseImgURL(uri: fi.images["png"]!)
           
        }
        
        // If there is a emote, return icon otherwise the png.png
        if(fi.type == "emote"){
            
            let imi:itemModelItem = itemModelItem(id: fi.id, name: fi.name, price: fi.price, priceIcon: fi.priceIcon, priceIconLink: fi.priceIconLink, images: fi.images, rarity: fi.rarity, type: fi.type, readableType: fi.readableType, imagesParsed: true, imgPriceIconLink: newPriceIconLink, imgPng: nil, imgIcon: newIconImg)
            return imi
        }
        
        let imi:itemModelItem = itemModelItem(id: fi.id, name: fi.name, price: fi.price, priceIcon: fi.priceIcon, priceIconLink: fi.priceIconLink, images: fi.images, rarity: fi.rarity, type: fi.type, readableType: fi.readableType, imagesParsed: true, imgPriceIconLink: newPriceIconLink, imgPng: newPngImg, imgIcon: nil)
        
        print("convertToItemModelItem (parse images) - DONE")
        return imi
    }
    
    func parseImgURL(uri:String)->UIImage{
        print("parseImgURL")
        var img:UIImage = UIImage(url: (URL(string: uri)))!
        print("parseImgURL - DONE")
        return img
    }
    
}
    



