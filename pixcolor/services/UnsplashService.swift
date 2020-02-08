//
//  UnsplashService.swift
//  livecolor
//
//  Created by Sam on 6/28/17.
//  Copyright © 2017 Sam. All rights reserved.
//

import UIKit
import Alamofire

enum Unsplash_Order:String {
    case popular = "popular"
    case latest = "latest"
    case oldest = "oldest"
}


class UnsplashService {

    static let shared = UnsplashService()
    var baseURL:String!

    private init() {
        self.baseURL = base_url_unsplash
    }
    
    func getUnsplashPhoto(page:Int, orderBy:Unsplash_Order, complete: @escaping (_ arrPhoto:[UnsplashPhoto], _ error:AnyObject) -> ()) {
        
        let parameters:[String:String] = ["client_id" :client_id_unsplash,
                     "page" : String(page),
                     "order_by"  : orderBy.rawValue,
                     "per_page" : "15"]
        
        let urlString = String(format: "%@%@",self.baseURL,API.GET_PHOTO.rawValue)

        
        AF.request(urlString,
                   method: .get,
                   parameters: parameters,
                   encoder: URLEncodedFormParameterEncoder.default).responseJSON { response in
                    debugPrint("Response: \(response.value)")
                    complete(UnsplashPhoto.createArrayPhotoWith(json: response.value as! [AnyObject]), NSNull())
        }
    }
}
