//
//  DetailedViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 28/4/22.
//

import UIKit

class DetailedViewController: UIViewController {
    @IBOutlet weak var bigDetailedImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var daysLeftLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    var daysLeftValue: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        bigDetailedImageView.image = UIImage(named: "erizo")
        eventNameLabel.numberOfLines = 2

        daysLeftLabel.numberOfLines = 0
        daysLeftLabel.textAlignment = .center
        daysLeftLabel.text = "\(daysLeftValue)\nDays\nLeft"


        addVisibilityGradient()
    }

    fileprivate func addVisibilityGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = gradientView.bounds
        let startColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, endColor]
        gradientView.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )

        alert.addAction(
            .init(title: "Edit event name", style: .default) { _ in

            }
        )

        alert.addAction(
            .init(title: "Edit event date", style: .default) { _ in

            }
        )

        alert.addAction(
            .init(title: "Edit event image", style: .default) { _ in

            }
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
