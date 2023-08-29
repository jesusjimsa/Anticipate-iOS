//
//  iconCellView.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 8/8/23.
//

import UIKit

class iconCellView: UITableViewCell {
    @IBOutlet weak var iconNameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        iconImage.image = UIImage(named: "first_icon")
        iconImage.layer.cornerRadius = 16.0
        iconNameLabel.text = "First prototype"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
