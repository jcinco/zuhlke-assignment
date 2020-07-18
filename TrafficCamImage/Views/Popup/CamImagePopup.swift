//
//  CamImagePopup.swift
//  TrafficCamImage
//
//  Created by John Freidrich Cinco on 7/18/20.
//  Copyright © 2020 John Freidrich Cinco. All rights reserved.
//

import Foundation
import UIKit


class CamImagePopup: UIView {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var exitButton: UIButton!
    
    @IBOutlet var title: UILabel!
    
    private var callback: ((UIView)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        //self.removeFromSuperview()
        self.layer.cornerRadius = 24
        
    }
    
    @IBAction func buttonClick(sender: UIView) {
        if (self.callback != nil) {
            self.callback?(sender)
        }
    }
    
    func show(image: UIImage, title: String, meta: ImageMetadata?, callback: @escaping (UIView)->Void) {
        self.callback = callback
        self.imageView.image = image
        self.title.text = title
        self.isHidden = false
        
        if (meta != nil) {
            let frame = self.imageView.frame
            self.imageView.frame = CGRect(x: frame.origin.x,
                                          y: frame.origin.y,
                                          width: CGFloat(meta?.width ?? Float(frame.width)),
                                          height: CGFloat(meta?.height ?? Float(frame.height)))
        }
        
        self.imageView.layer.cornerRadius = 20
        self.imageView.backgroundColor = .lightGray
        
    }
    
    func hide() {
        self.callback = nil
        self.imageView.image = nil
        self.title.text = nil
        self.isHidden = true
    }
}

