//
//  imageOnDiskHandler.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-29.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit


class imageOnDiskHandler{
    
    static func saveImage(img:UIImage, id:String){
        
        if(getImage(id: id).size != CGSize(width: 0, height: 0)){
            print("Already saved \(id)")
            return
        }
        
        print("Save id to disk: \(id)")
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(id).png")

        print(paths)
        let imageData = UIImagePNGRepresentation(img)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    static func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func getImage(id:String)->UIImage{
        print("Requesting img with id from disk: \(id)")
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(id).png")
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)!
        }else{
            print("ERROR: Could not retrieve img from disk.")
            return UIImage()
        }
    }
}
