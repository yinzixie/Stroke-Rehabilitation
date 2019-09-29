//
//  ExtensionUIView.swift
//  Stroke-Rehabilitation
//
//  Created by yinzixie on 24/9/19.
//  Copyright © 2019 yinzixie. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func cardView(radius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = radius //3.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.8
    }
    
    func removeCardView() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
    }
    
    //https://blog.csdn.net/kmonarch/article/details/82892300
    func SetMutiBorderRoundingCorners(corner:CGFloat,topRight:Bool,topLeft:Bool,bottomRight:Bool, bottomLeft:Bool) {
        var cornors = [UIRectCorner]()
        
        if(topRight) {
            cornors += [UIRectCorner.topRight]
        }
        if(topLeft) {
            cornors += [UIRectCorner.topLeft]
        }
        if(bottomRight) {
            cornors += [UIRectCorner.bottomRight]
        }
        if(bottomLeft) {
            cornors += [UIRectCorner.bottomLeft]
        }
        let cornorst = UIRectCorner(cornors)
        let maskPath = UIBezierPath.init(roundedRect: self.bounds, byRoundingCorners:cornorst,cornerRadii: CGSize(width: corner, height: corner))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.frame = self.bounds
        
        maskLayer.path = maskPath.cgPath
        
        self.layer.mask = maskLayer
    }
    
    //https://blog.csdn.net/kmonarch/article/details/82892300
    func SetBorder(_ top:Bool,left:Bool,bottom:Bool,right:Bool,width:CGFloat,color:UIColor)
        
    {
        
        if top
            
        {
            let layer = CALayer()
            
            layer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
            
            layer.backgroundColor = color.cgColor
            
            self.layer.addSublayer(layer)
        }
        
        if left
            
        {
            
            let layer = CALayer()
            
            layer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
            
            layer.backgroundColor = color.cgColor
            
            self.layer.addSublayer(layer)
            
        }
        
        if bottom
            
        {
            
            let layer = CALayer()
            
            layer.frame = CGRect(x: 0, y: self.frame.size.height - width, width: width, height: width)
            
            layer.backgroundColor = color.cgColor
            
            self.layer.addSublayer(layer)
            
        }
        
        if right
            
        {
            
            let layer = CALayer()
            
            layer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
            
            layer.backgroundColor = color.cgColor
            
            self.layer.addSublayer(layer)
            
        }
        
    }
    

    
    
    
}
