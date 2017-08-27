//
//  UnsplashPhoto.swift
//  livecolor
//
//  Created by Sam on 6/28/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit

class UnsplashPhoto: NSObject {
    
    var photoID:String = ""
    var urlThumb:String = ""
    var urlRegular:String = ""
    var urlSmall:String = ""
    var ownerName:String = ""
    
    
    init(json:AnyObject){
        super.init()
        updateWithJson(json: json)
    }
    
    func updateWithJson(json: AnyObject) {
        
        if let photoID = json["id"] as? String {
            self.photoID = photoID
        }
        
        if let urls = json["urls"] as? AnyObject {
            if let urlThumb = urls["thumb"] as? String  {
                self.urlThumb = urlThumb
            }
            if let urlRegular = urls["regular"] as? String  {
                self.urlRegular = urlRegular
            }
            if let urlSmall = urls["small"] as? String  {
                self.urlSmall = urlSmall
            }
        }
        
        if let user = json["user"] as? AnyObject {
            if let ownerName = user["name"] as? String  {
                self.ownerName = ownerName
            }
        }
    }
    
    static func createArrayPhotoWith(json:[AnyObject]) -> [UnsplashPhoto] {
        var arr:[UnsplashPhoto] = []
        var photo:UnsplashPhoto!
        for item in json {
            photo = UnsplashPhoto(json: item)
            arr.append(photo)
        }
        return arr
    }
    
    override var description: String {
        return "photoID: \(photoID)" +
            "urlThumb: \(urlThumb)" +
            "urlRegular: \(urlRegular)" +
            "ownerName: \(ownerName)"
    }
}
