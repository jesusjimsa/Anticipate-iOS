//
//  customCell.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/4/23.
//

import UIKit

class customCell: UITableViewCell {
    @IBOutlet weak var elemTitle: UILabel!
    @IBOutlet weak var daysLeftText: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var elemImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        elemImage.image = UIImage(named: "link_img")
        elemImage.layer.cornerRadius = 8.0
        elemImage.contentMode = UIView.ContentMode.scaleAspectFill
        elemTitle.text = "Ejemplo título"
        daysLeftText.text = "Days Left"
        timeLeftLabel.text = "14"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
