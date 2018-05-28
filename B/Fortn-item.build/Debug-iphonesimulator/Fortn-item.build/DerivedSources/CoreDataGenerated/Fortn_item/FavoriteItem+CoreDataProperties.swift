//
//  FavoriteItem+CoreDataProperties.swift
//  
//
//  Created by Emil Söderlind on 2018-05-27.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension FavoriteItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteItem> {
        return NSFetchRequest<FavoriteItem>(entityName: "FavoriteItem")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var priceIcon: String?
    @NSManaged public var rarity: String?
    @NSManaged public var type: String?

}
