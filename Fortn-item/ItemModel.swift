

import Foundation
import UIKit

struct ItemModel {
    var id: String
    var name: String
    var price: String
    var priceIcon: String
    var priceIconLink: UIImage
    
    var imgIcon:UIImageView
    var imgGallery:UIImageView
    var imgPng:UIImageView?
    var imgFeatured:UIImageView?
    
    var rarity: String
    var type: String
    var readableType: String
}
