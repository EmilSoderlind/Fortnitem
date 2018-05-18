//
//  Item.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

struct FortniteItem:Decodable {
    var id: String
    var name: String
    var price: String
    var priceIcon: String
    var priceIconLink: String
    var images: [String : String]
    var rarity: String
    var type: String
    var readableType: String

  /*  func convertToItemModel() -> ItemModel {
        
        var mainImage: UIImageView!

        
        
        
        
        var im = ItemModel(id: <#T##String#>, name: <#T##String#>, price: <#T##String#>, priceIcon: <#T##String#>, priceIconLink: <#T##UIImage#>, imgIcon: <#T##UIImageView#>, imgGallery: <#T##UIImageView#>, imgPng: <#T##UIImageView?#>, imgFeatured: <#T##UIImageView?#>, rarity: <#T##String#>, type: <#T##String#>, readableType: <#T##String#>)

        return im
    }
    */
    func parseImgURL(uri:String)->UIImage{
        if let filePath = Bundle.main.path(forResource: uri, ofType: "jpg"), let im = UIImage(contentsOfFile: filePath) {
            return im
            
        }
        return UIImage(named: "Gallery.png")!
    }

}
