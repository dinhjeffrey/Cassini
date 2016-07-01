//
//  ImageVC.swift
//  Cassini
//
//  Created by jeffrey dinh on 7/1/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit

class ImageVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // is my model thus outlet set first, or my scrollView gonna get set first? thus set both
        }
    }
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            fetchImage()
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            if let imageData = NSData(contentsOfURL: url) {
                image = UIImage(data: imageData)
            }
        }
    }
    
    private var imageView = UIImageView() // creates a (0,0,0,0) frame image view. Remember to set contentSize!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        imageURL = NSURL(string: DemoURL.Stanford)
    }

}
