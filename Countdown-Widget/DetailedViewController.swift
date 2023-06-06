//
//  DetailedViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 30/5/23.
//

import UIKit
import CoreData

class DetailedViewController: UIViewController {

    @IBOutlet weak var detailedTitleLabel: UILabel!
    @IBOutlet weak var detailedTimeLeftLabel: UILabel!
    @IBOutlet weak var detailedDaysLeftLabel: UILabel!
    @IBOutlet weak var detailedEditEventButton: UIButton!
    @IBOutlet weak var detailedRemoveEventButton: UIButton!
    @IBOutlet weak var detailedImageView: UIImageView!

    var titleText: String?
    var timeLeftText: String?
    var daysLeftText: String?
    var image: UIImage?
    
    
    override func viewDidLoad() {
        if titleText != nil {
            detailedTitleLabel.text = titleText
        }

        if image != nil {
            detailedImageView.image = image
            detailedImageView.contentMode = UIView.ContentMode.scaleAspectFill
        }

        if daysLeftText != nil {
            detailedDaysLeftLabel.text = daysLeftText
        }
        else {
            detailedDaysLeftLabel.text = "Days Left"
        }

        if timeLeftText != nil {
            detailedTimeLeftLabel.text = timeLeftText
        }
    }
}
