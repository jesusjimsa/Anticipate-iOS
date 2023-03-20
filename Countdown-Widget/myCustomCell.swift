//
//  myCustomCell.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 20/3/23.
//

import UIKit

class myCustomCell: UITableViewCell {
    @IBOutlet weak var myCustomCellImg: UIImageView!
    @IBOutlet weak var myCustomCellLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        myCustomCellLabel.text = "Texto ejemplo"
        myCustomCellImg.image = UIImage(named: "link_img")

        timeLeftLabel.text = "Quedan 20 días"
        timeLeftLabel.textColor = .lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
