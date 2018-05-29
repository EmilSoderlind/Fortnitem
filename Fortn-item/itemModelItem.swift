//
//  itemModelItem.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-20.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation

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

struct itemModelItem:Equatable {
    var id: String
    var name: String
    var price: String
    var priceIcon: String
    var priceIconLink: String
    var images: [String : String]?
    var rarity: String
    var type: String
    var readableType: String?
    
    var imagesParsed:Bool = false
    var imgPriceIconLink: UIImage?
    var imgPng:UIImage?
    var imgIcon:UIImage?
    var imgLink:String
    
    var favorited: Bool
    
}
