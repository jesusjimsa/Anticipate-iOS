//
//  customCounterCell.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 8/3/22.
//

import UIKit

class customCounterCell: UITableViewCell {
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        let eventImage = UIImage(named: "erizo")

        let targetSize = CGSize(width: 100, height: 100)

        let scaledImage = eventImage!.scalePreservingAspectRatio(
            targetSize: targetSize
        )

        eventImageView.image = scaledImage

        daysLeftLabel.font = UIFont.systemFont(ofSize: 20)
        daysLeftLabel.lineBreakMode = .byWordWrapping
        daysLeftLabel.numberOfLines = 0

        eventNameLabel.lineBreakMode = .byWordWrapping
        eventNameLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print(daysLeftLabel.text ?? "")
    }

}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height

        let scaleFactor = min(widthRatio, heightRatio)

        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }

        return scaledImage
    }
}
