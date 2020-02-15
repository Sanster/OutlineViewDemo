//
//  FeedItem.swift
//  OutlineViewDemo
//
//  Created by 褚尉卿 on 2020/2/12.
//  Copyright © 2020 cwq. All rights reserved.
//

import Cocoa

class FeedItem: NSObject {
    let url: String
    let title: String
    let publishingDate: Date
    
    init(dictionary: NSDictionary) {
        self.url = dictionary.object(forKey: "url") as! String
        self.title = dictionary.object(forKey: "title") as! String
        self.publishingDate = dictionary.object(forKey: "date") as! Date
    }

}
