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
    
    var theView:ViewController?
    
    func parseCurrentItems(){
        
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
                let fetch = try JSONDecoder().decode(FullFetch.self, from: data)
                
                print(fetch)
                
                DispatchQueue.main.async {


                }
             
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
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
    
}
    



