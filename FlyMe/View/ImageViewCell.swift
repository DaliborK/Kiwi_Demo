//
//  ImageViewCell.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 10/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var ltLabel: UILabel!
    @IBOutlet weak var rtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureView(_ main: (trip: Trip, image: UIImage?)) {
        ltLabel.text = String (String( main.trip.nightsInDest ) + " nights in " + String(main.trip.cityTo))
        rtLabel.text = String(String(main.trip.price) + " " + Constants.currency)
        if let img = main.image {
            self.imgView?.image = img
        }
    }
}
