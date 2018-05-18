//
//  Item.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-14.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation
import UIKit

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
}
