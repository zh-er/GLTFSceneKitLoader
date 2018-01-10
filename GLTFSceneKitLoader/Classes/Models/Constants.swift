//
//  Constants.swift
//  Pods
//
//  Created by zh-er on 31/8/17.
//  Copyright © 2017 zh-er. All rights reserved.
//

import Foundation
import SceneKit
import Mapper

enum ComponentType: Int {
    case BYTE = 5120
    case UNSIGNED_BYTE = 5121
    case SHORT = 5122
    case UNSIGNED_SHORT = 5123
    case UNSIGNED_INT = 5125
    case FLOAT = 5126    
    
    var bytesPerComponent: Int {
        switch self {
        case .BYTE,
             .UNSIGNED_BYTE:
            return 1
            
        case .SHORT,
             .UNSIGNED_SHORT:
            return 2
            
        case .UNSIGNED_INT,
             .FLOAT:
            return 4
        }
    }

}

enum AccessorType: String {
    case SCALAR = "SCALAR"
    case VEC2 = "VEC2"
    case VEC3 = "VEC3"
    case VEC4 = "VEC4"
    case MAT2 = "MAT2"
    case MAT3 = "MAT3"
    case MAT4 = "MAT4"
    
    var componentsPerVector: Int {
        switch self {
        case .SCALAR, .VEC2:
            return 2
        case .VEC3:
            return 3
        case .VEC4, .MAT2:
            return 4
        case .MAT3:
            return 9
        case .MAT4:
            return 16
        }
    }
}

enum BufferViewTarget: Int {
    case ARRAY_BUFFER = 34962
    case ELEMENT_ARRAY_BUFFER = 34963
}

enum PrimitiveMode: Int {
    case POINTS = 0, LINES, LINE_LOOP, LINE_STRIP, TRIANGLES, TRIANGLE_STRIP, TRIANGLE_FAN
    
    var scnPrimitive: SCNGeometryPrimitiveType {
        switch self {
        case .POINTS:
            return .point
        case .LINES,
             .LINE_LOOP,
             .LINE_STRIP:
            return .line
        case .TRIANGLES:
            return .triangles
        case .TRIANGLE_STRIP:
            return .triangleStrip
        default:
            return .triangles
        }
    }
}


enum SamplingFilter: Int {
    case NEAREST = 9728
    case LINEAR = 9729
    case NEAREST_MIPMAP_NEAREST = 9984
    case LINEAR_MIPMAP_NEAREST = 9985
    case NEAREST_MIPMAP_LINEAR = 9986
    case LINEAR_MIPMAP_LINEAR = 9987
    
    init() {
        self = .LINEAR
    }
    
    var scnfilter: SCNFilterMode {
        switch self {
        case .NEAREST,
             .LINEAR_MIPMAP_NEAREST,
             .NEAREST_MIPMAP_NEAREST:
            return .nearest
            
        case .LINEAR,
             .NEAREST_MIPMAP_LINEAR,
             .LINEAR_MIPMAP_LINEAR:
            return .linear

        }
    }
}

enum SamplerWrapping: Int {
    case CLAMP_TO_EDGE = 33071
    case MIRRORED_REPEAT = 33648
    case REPEAT = 10497
    
    init() {
        self = .REPEAT
    }
    
    var SCNWrapMode: SCNWrapMode {
        switch self {
        case .CLAMP_TO_EDGE:
            return .clampToBorder
        case .MIRRORED_REPEAT:
            return .mirror
        default:
            return .repeat
        }
    }
}



