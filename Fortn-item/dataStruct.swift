//
//  dataStruct.swift
//  Fortn-item
//
//  Created by Emil Söderlind on 2018-05-17.
//  Copyright © 2018 ENOS Pr. All rights reserved.
//

import Foundation

struct data:Decodable {
    
    var date:String
    var featured:[FortniteItem]
    var daily:[FortniteItem]
    
}

