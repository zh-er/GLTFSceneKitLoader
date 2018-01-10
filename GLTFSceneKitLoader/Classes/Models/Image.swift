//
//  Image.swift
//  Pods
//
//  Created by zh-er on 24/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import Mapper


struct Image: Mappable {
    
    let uri: String
    
    init(map: Mapper) throws {
        uri = try map.from("uri")
    }
}
