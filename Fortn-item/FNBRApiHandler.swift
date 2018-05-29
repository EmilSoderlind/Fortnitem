//
//  ApiHandler.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// Class responsible for talking directly to FNBR
class FNBRApiHandler {
    
    var mainView:TodaysTableViewController?
    
    
    // Parse API and update table via vc. Returns present error in vc if something go wrong.
    func parseCurrentItems(vc:TodaysTableViewController){
        
        let startDate:Date = Date()
        
        var possibleError = ""
        
        
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
                possibleError = "Something wrong with URLSession.shared.dataTask - \(err!)"
            }
            
            // If response isn't code 200
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: (\(httpResponse.statusCode))")
                if(httpResponse.statusCode != 200){
                    print("HTTP response: \(httpResponse.statusCode).")
                    possibleError = "HTTP response: \(httpResponse.statusCode)."
                }
            }
            
            print("Reachability.isConnectedToNetwork(): \(Reachability.isConnectedToNetwork())")
            
            if(!Reachability.isConnectedToNetwork()){
                possibleError = "No internet connection."
            }
            
            // If we have recieved error, present error pop-up via vc.
            if(possibleError != ""){
                // Generate Firebase crash-message
                FirebaseCrashMessage(possibleError)
                DispatchQueue.main.async {
                    print("Found error: \(possibleError)")
                    vc.presentErrorMessage(err: possibleError)
                }
                return
            }
            
            
            // If the data is faulty
            guard let data = data else {
                print("Faulty data recieved.")
                possibleError = "Faulty data recieved."
                return
            }
                        
            do {
                
                // Since the API mix and match datatypes i need to make all bools (false) to empty strings
                var dataString = String(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)
                dataString = dataString.replacingOccurrences(of: ":false}", with: ":\"\"}", options: .literal, range: nil)
                dataString = dataString.replacingOccurrences(of: ":false,", with: ":\"\",", options: .literal, range: nil)
                
                print()
                print("dataString: \(dataString)")
                print()
                
                let fetch = try JSONDecoder().decode(FullFetch.self, from: dataString.data(using: String.Encoding.utf8)!)
                
                let publishDate:Date = fetch.data.date.dateFromISO8601!
                
                var iml:ItemModelList = ItemModelList(date: publishDate, featured: [], daily: [])
                
                // Parse daily to itemModelItem (with images)
                for item in fetch.data.daily {
                    iml.daily.append(self.convertToItemModelItem(fi: item))
                }
                
                // Parse daily to itemModelItem (with images)
                for item in fetch.data.featured {
                    iml.featured.append(self.convertToItemModelItem(fi: item))
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
    
    /*func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                
                
                
                //self.imageView.image = UIImage(data: data)
            }
        }
    }*/
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    // Convert and parse images to itemModelItems
    func convertToItemModelItem(fi:FortniteItem) -> itemModelItem {
        print("convertToItemModelItem (\(fi.name))")
        
        let newPriceIconLink:UIImage = parseImgURL(uri: fi.priceIconLink)
        
        var newIconImg = UIImage()
        var newPngImg = UIImage()
        
 
        // If there is a emote or png-image is missing. Return icon-image.
        if((fi.type == "emote") || (fi.images["png"] == "")){
            newIconImg = parseImgURL(uri: fi.images["icon"]!)
        }else{
            newPngImg = parseImgURL(uri: fi.images["png"]!)
        }
        
        // If there is a emote or missing png-image, return icon otherwise the png.png
        if(fi.type == "emote" || fi.images["png"] == ""){
            
            let imi:itemModelItem = itemModelItem(id: fi.id, name: fi.name, price: fi.price, priceIcon: fi.priceIcon, priceIconLink: fi.priceIconLink, images: fi.images, rarity: fi.rarity, type: fi.type, readableType: fi.readableType, imagesParsed: true, imgPriceIconLink: newPriceIconLink, imgPng: nil, imgIcon: newIconImg,  imgLink: fi.images["icon"]!, favorited: false)
            return imi
        }
        
        let imi:itemModelItem = itemModelItem(id: fi.id, name: fi.name, price: fi.price, priceIcon: fi.priceIcon, priceIconLink: fi.priceIconLink, images: fi.images, rarity: fi.rarity, type: fi.type, readableType: fi.readableType, imagesParsed: true, imgPriceIconLink: newPriceIconLink, imgPng: newPngImg, imgIcon: nil, imgLink: fi.images["png"]!, favorited: false)
        
        
        //print("convertToItemModelItem - DONE")
        return imi
    }
    
    func parseImgURL(uri:String)->UIImage{
        //print("parseImgURL")
        //print("Parsing: \(uri)")
        
        
        if(uri == "https://image.fnbr.co/price/icon_vbucks.png"){
            return UIImage(named: "icon_vbucks.png")!
        }
        
        if let img:UIImage = UIImage(url: (URL(string: uri))){
            //print("parseImgURL - DONE")
            return img
        }else{
            print("parseImgURL - FAILED return logo.png")
            return UIImage(named: "logo.png")!
        }
    }
    
}
    



