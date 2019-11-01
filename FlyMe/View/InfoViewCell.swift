//
//  InfoViewCell.swift
//  FlyMe
//
//  Created by Dalibor Kozak on 10/10/2019.
//  Copyright © 2019 Dalibor Kozak. All rights reserved.
//

import UIKit

class InfoViewCell: UITableViewCell {    
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var cityFromLabel: UILabel!
    @IBOutlet weak var cityToLabel: UILabel!
    @IBOutlet weak var portFromLabel: UILabel!
    @IBOutlet weak var portToLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    var linkUrl: String?
    
    @IBAction func bookButtonAction(_ sender: UIButton) {
        guard
            let linkUrlStr = linkUrl,
            let linkUrl = URL(string: linkUrlStr) else { return }
        UIApplication.shared.open(linkUrl, options: [ : ], completionHandler: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bookButton.layer.cornerRadius = 5
        bookButton.layer.borderWidth = 1
        bookButton.layer.borderColor = Constants.kiwiColor.cgColor
        bookButton.tintColor = Constants.kiwiColor
    }
    
    func configureView(_ trip: Trip) {
        durationLabel.text = trip.fly_duration
        dateLabel.text = Utilities.dateWith(format: Constants.dateFormat , value: trip.dTime)
        departureTimeLabel.text = Utilities.dateWith(format: Constants.timeFormat, value: trip.dTime)
        arrivalTimeLabel.text = Utilities.dateWith(format: Constants.timeFormat, value: trip.aTime)
        cityFromLabel.text = trip.cityFrom
        cityToLabel.text = trip.cityTo
        portFromLabel.text = trip.flyFrom
        portToLabel.text = trip.flyTo
        priceLabel.text = String(trip.price)
        currencyLabel.text = Constants.currency
        distanceLabel.text = String(String(trip.distance) + " km")
        availabilityLabel.text = trip.availability?.seats.map({ String( $0)}) ?? "0"
        linkUrl = trip.deep_link
    }
}
