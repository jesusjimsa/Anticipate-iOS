//
//  customCell.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/4/23.
//

import UIKit

class customCell: UITableViewCell {
    @IBOutlet weak var elemTitle: UILabel!
    @IBOutlet weak var elemTimeLeft: UILabel!
    @IBOutlet weak var elemImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        elemImage.image = UIImage(named: "link_img")
        elemTitle.text = "Ejemplo título"
        elemTimeLeft.text = "14 days left"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
