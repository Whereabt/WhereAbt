//
//  ImgExt.swift
//  Whereabout 2
//
//  Created by Nicolas Isaza on 1/11/16.
//  Copyright © 2016 Nicolas Isaza. All rights reserved.
//

import Foundation

extension UIImageView {
    func downloadImageFrom(link link:String, contentMode: UIViewContentMode) {
        NSURLSession.sharedSession().dataTaskWithURL( NSURL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}