//
//  UnsplashService.swift
//  livecolor
//
//  Created by Sam on 6/28/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import PromiseKit

enum Unsplash_Order:String {
    case popular = "popular"
    case latest = "latest"
    case oldest = "oldest"
}
class UnsplashService {

    static let shared = UnsplashService()
    var baseURL:String!

    private init() {
        baseURL = base_url_unsplash
    }
    
    func getUnsplashPhoto(page:Int, orderBy:Unsplash_Order, complete: @escaping (_ arrPhoto:[UnsplashPhoto], _ error:AnyObject) -> ()) {
        
        let query = ["client_id" as NSObject:client_id_unsplash as AnyObject,
                     "page" as NSObject: String(page) as AnyObject,
                     "order_by" as NSObject : orderBy.rawValue as AnyObject,
                     "per_page" as NSObject : "15" as AnyObject]
        
        let urlString = String(format: "%@%@",self.baseURL,API.GET_PHOTO.rawValue)
        
        URLSession.shared.GET(urlString, query: query).asArray().then { json -> Void in
            print("%@",json)
            complete(UnsplashPhoto.createArrayPhotoWith(json: json as [AnyObject]), NSNull())
            
        }.catch{ error in
            print("%@", error)
            complete([],error as? PMKURLError as AnyObject)
        }
    }
}
