//
//  DetailViewController.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/10/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let minScale = calculateMinScaleFrom(imageView: imageView, andScrollView: scrollView)
        scrollView.zoomScale = minScale
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = 3.0
        self.scrollView.delegate = self
    }
    
    func detailVCSetup (withImageView image:UIImage, likesCount likes: Int, andFavoritesCount favs: Int) {
        self.imageView.image = image
        self.likesLabel.text = "\(likes)"
        self.favsLabel.text = "\(favs)"
    }
    
    // MARK: - ScrollView Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func calculateMinScaleFrom(imageView iv:UIImageView, andScrollView sv: UIScrollView)-> CGFloat {
        let imageSize = iv.bounds.size
        let widthScale = sv.bounds.width / imageSize.width
        let heightScale = sv.bounds.height / imageSize.height
        
        return min(widthScale, heightScale)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
