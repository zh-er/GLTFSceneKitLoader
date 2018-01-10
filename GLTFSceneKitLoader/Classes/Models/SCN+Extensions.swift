//
//  SCN+Extensions.swift
//  Pods
//
//  Created by zh-er on 29/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import SceneKit
import Mapper

extension SCNMatrix4: Convertible {
    public static func fromMap(_ value: Any) throws -> SCNMatrix4 {
        guard let matrix = value as? [float4] else {
            throw MapperError.convertibleError(value: value, type: [float4].self)
        }
        return SCNMatrix4(float4x4(matrix))
    }
}

extension SCNVector3: Convertible {
    public static func fromMap(_ value: Any) throws -> SCNVector3 {
        print("SCNVector3: \(value)")
        guard let vec3 = value as? [Float] else {
            print("SCNVector3:Convertible -> throw error")
            throw MapperError.convertibleError(value: value, type: [Float].self)
        }
        
        return SCNVector3(float3(vec3))
    }
}


