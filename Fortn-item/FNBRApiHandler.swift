//
//  ApiHandler.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation

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
                    self.theView?.updateTestLabel(s: fetch.data.featured[0].name)
                }
             
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            
            
            }
            task.resume()
        
    }
}
    



