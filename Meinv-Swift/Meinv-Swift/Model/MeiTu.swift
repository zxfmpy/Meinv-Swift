//
//  MeiTu.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/24.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


// 宏定义区
let MENU_HEIGHT:CGFloat = topViewHeight
let ERROR_OFFLINE: Int  = -1009
let ERROR_LAST: Int     = -1

// 存放图片信息的类
class PhotoInfo: NSObject {
    var forumUrl: String = ""
    var imageUrl: String = ""
    var imageSize: CGSize = CGSize(width: 0.0, height: 0.0)
    
    class func photo(url:String) -> PhotoInfo {
        let photo:PhotoInfo = PhotoInfo()
        photo.imageUrl = url
        return photo
    }
}

// 工具函数
class PhotoUtil {
    static let imageSource: String = "5442.com"
    
    static func selectTypeByNumber(number: Int) -> PageType {
        switch number {
        case 0:
            return .daxiong
        case 1:
            return .qiaotun
        case 2:
            return .heisi
        case 3:
            return .meitui
        case 4:
            return .yanzhi
        case 5:
            return .dazzhui
        default:
            return .daxiong
        }
    }
}

@objc public protocol ResponseObjectSerializable {
    init ? (response: NSHTTPURLResponse, representation: AnyObject)
}

//enum Router { // 必须实现URLRequestConvertible
//    static let baseUrlString: String = "http://www.5442.com/tag"
//    
//    case PhotoPage(PageType, Int)
//    
//    // 组装要请求的网页地址
//    var URLRequest: String {
//        var url: String
//        switch self {
//        case .PhotoPage(let type, let page):
//            url = Router.baseUrlString + "/" + type.rawValue
//            if page > 1 {
//                url += "/\(page)"
//            }
//            url += ".html"
//        }
//        return url;
//    }
//    
//    // 组装给每个类型的图片基本地址
//    var pageSource: String {
//        var url: String
//        switch self {
//        case .PhotoPage(let type, _):
//            url = Router.baseUrlString + "/" + type.rawValue + "/"
//        }
//        return url;
//    }
//    
//}

enum PageType:String {
    case daxiong    = "2"  // 1
    case qiaotun    = "6"  // 2
    case heisi      = "7"    // 3
    case meitui     = "3"   // 4
    case yanzhi     = "4"   // 5
    case dazzhui    = "5"  // 6
}