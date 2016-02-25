//
//  DomobyHeader.swift
//  DomobyHeader
//
//  Created by Константин on 24.02.16.
//  Copyright © 2016 Domoby. All rights reserved.
//

import UIKit

class DomobyHeader: NSObject {

    var images = [UIImage]()
    
    var tableHeaderView : DomobyTableHeaderView!
    var navigationBarView : DomobyNavigationBarView!
    
    
    class func initWith(headerView headerView: DomobyTableHeaderView, navigationBarView: DomobyNavigationBarView) -> DomobyHeader {
        
        let item = DomobyHeader()
        
        item.tableHeaderView = headerView
        item.navigationBarView = navigationBarView
        
        navigationBarView.hidden = true
        
        return item
    }
    
    
    func setData(title title: String, message: String, logo: UIImage?, image: UIImage?) {
       
        setTitle(title)
        setMessage(message)
        
        if logo != nil {
            setLogo(logo)
        }
        
        if image != nil {
            setImage(image)
        }
    }
    
    
    func setTitle(title: String) {
        tableHeaderView.title.text = title
        navigationBarView.title.text = title
    }
    
    func setMessage(message: String) {
        tableHeaderView.message.text = message
        tableHeaderView.sizeHeaderToFit()
    }
    
    func setLogo(logo: UIImage!) {
        tableHeaderView.imageViewLogo.image = logo
    }
    
    func setImage(image: UIImage!) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let scaledImage = image.scaledVersion()
            
            var factor = CGFloat(1)
            
            var result = [UIImage]()
            result.append(scaledImage)
            
            let headerViewHeight = self.tableHeaderView.imageViewHeader.bounds.size.height
            
            for (var i = 0; i < Int(headerViewHeight/10); i++) {
                result.append(scaledImage.bluredVersionWithRadius(factor)!)
                factor = factor + 1
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                self.images = result
                self.tableHeaderView.imageViewHeader.image = scaledImage
            }
        }
    }
    
    
    func setColor(color: UIColor) {
        setTopColor(color)
        setBottomColor(color)
    }
    
    func setTopColor(color: UIColor) {
        tableHeaderView.imageViewHeader.backgroundColor = color
        navigationBarView.imageView.backgroundColor = color
    }
    
    func setBottomColor(color: UIColor) {
        tableHeaderView.view.backgroundColor = color
    }
    
    
    func handleScrollingOffset(offset:CGFloat) {
        
        tableHeaderView.handleScrollingOffset(offset)
        navigationBarView.handleScrollingOffset(offset)
        
        if images.count > 0 {
            changeImageWithOffset(offset)
        }
    }
    
    func changeImageWithOffset(offset:CGFloat) {
        
        var index = Int(offset/10)
        
        if (index <= 0) {
            index = 0
        } else if Int(index) >= images.count {
            index = images.count - 1
        }
        
        let image = images[index]
        
        if tableHeaderView.imageViewHeader.image != image {
            tableHeaderView.imageViewHeader.image = image
        }
        
        if navigationBarView.imageView.image != image {
            navigationBarView.imageView.image = image
        }
    }
    
}
