//
//  PreviewImage_ViewController.swift
//  photo-library-mirai
//
//  Created by Achmad Abdul Aziz on 22/06/20.
//  Copyright © 2020 Achmad Abdul Aziz. All rights reserved.
//

import UIKit

class PreviewImage_ViewController: UIViewController, UIScrollViewDelegate {
    
    static func makeViewController(image: UIImage) -> PreviewImage_ViewController {
        let newViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "previewImage_ViewController") as! PreviewImage_ViewController
        
        newViewController.imageZoom = image
        
        return newViewController
    }

    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageZoom: UIImage!
    @IBOutlet weak var imageToScroll: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self

        imageToScroll.image = imageZoom
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageToScroll
    }

}
