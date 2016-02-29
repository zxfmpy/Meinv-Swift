//
//  MNDouListsResponse.swift
//  Meinv-Swift
//
//  Created by Lorwy on 16/2/29.
//  Copyright © 2016年 Lorwy. All rights reserved.
//

import AlamofireObjectMapper
import ObjectMapper


class MNDouListsResponse: Mappable {
    
    var count: Int?
    var start: Int?
    var total: Int?
    var doulists: [MNDouListItem]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        count       <- map["count"]
        start       <- map["start"]
        total       <- map["total"]
        doulists    <- map["doulists"]
    }
}


class MNDouListItem: Mappable {
    
    var merged_cover_url:   String?
    var items_count:        Int?
    var sharing_url:        String?
    var url:                String?
    var is_follow:          Bool?
    var title:              String?
    var update_time:        String?
    var uri:                String?
    var followers_count:    Int?
    var create_time:        String?
    var id:                 String?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        merged_cover_url        <- map["merged_cover_url"]
        items_count             <- map["items_count"]
        sharing_url             <- map["sharing_url"]
        url                     <- map["url"]
        is_follow               <- map["is_follow"]
        title                   <- map["title"]
        update_time             <- map["update_time"]
        uri                     <- map["uri"]
        followers_count         <- map["followers_count"]
        create_time             <- map["create_time"]
        id                      <- map["id"]
    }
}