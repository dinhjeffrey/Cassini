//
//  ImageVC.swift
//  Cassini
//
//  Created by jeffrey dinh on 7/1/16.
//  Copyright © 2016 jeffrey dinh. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size // is my model thivcfus outlet set first, or my scrollView gonna get set first? thus set both
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage() // can be expensive to user to fetch url because cellular data, so we want to do it when user is on screen. reliable way is to check view.window
            }
        }
    }
    
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating() // optional in case we call our spinner before our outlets get loaded
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                let contentsOfURL = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    guard url == self.imageURL else { print("ignored data returned from url \(url)"); return }
                    if let imageData = contentsOfURL {
                        self.image = UIImage(data: imageData)
                    } else {
                        self.spinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
    private var imageView = UIImageView() // creates a (0,0,0,0) frame image view from code. Remember to set contentSize!
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size // can fail if model sets first so we put it in didSet
            spinner?.stopAnimating()
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
}
