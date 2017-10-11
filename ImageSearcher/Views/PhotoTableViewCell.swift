//
//  PhotoTableViewCell.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/10/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var indexOfCall = 0
    var photoData: Photo? {
        
        didSet {
        self.mainImage?.image = nil
        // make the instance
        guard let photoData = self.photoData else {return}
        let thisIndex = indexOfCall
        // setup the cell with network request for the image 
            RequestManager.sharedInstance.getImageByURL(urlOfImage: photoData.url!) {[weak self] (image, error) in
                if let error = error {
                    print("the error at \(thisIndex) is \(error)")
                } else if self?.indexOfCall == thisIndex {
                    DispatchQueue.main.async(execute: {
                        self?.mainImage.image = image
                        self?.activityIndicator.stopAnimating()
                    })
                    /* Use GCD over OperationQueue for more optimal performance
                     https://stackoverflow.com/questions/40764140/operationqueue-main-vs-dispatchqueue-main
                    OperationQueue.main.addOperation({

                    })
                     */
                }
            } // closure
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.activityIndicator.startAnimating()
        self.indexOfCall += 1 /* The Cell will retain the image until its discarded */
        self.photoData = nil /* If the cell is discarded, scrap its photoData so it can be reset */
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
