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
    var eventIndex: Int?
    var eventDate: Date?
    var eventID: String?

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var UserEventsList: [UserCountdowns]?
    
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

        if eventDate != nil {
            let left = daysLeft(date: eventDate!)
            detailedTimeLeftLabel.text = left >= 0 ? String(left) : "0"
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        recuperarDatos()

        updateDetailedUI()
    }

    // Update all elements in the UI after editing an event
    func updateDetailedUI() {
        detailedTitleLabel.text = self.UserEventsList![self.eventIndex!].title
        detailedImageView.image =  UIImage(data: self.UserEventsList![self.eventIndex!].image!)
        detailedTimeLeftLabel.text = String(daysLeft(date: self.UserEventsList![self.eventIndex!].date!))
    }

    func recuperarDatos() {
        do {
            self.UserEventsList = try context.fetch(UserCountdowns.fetchRequest())
        }
        catch {
            print("Error recuperando datos")
        }
    }

    @IBAction func deleteEvent(_ sender: Any) {
        let areYouSureAlert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to delete this event?", preferredStyle: .alert)

        areYouSureAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            self.recuperarDatos()
            self.context.delete(self.UserEventsList![self.eventIndex!])
            try! self.context.save()
            _ = self.navigationController?.popToRootViewController(animated: true)
        }))

        areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            // Nothing
        }))

        self.present(areYouSureAlert, animated: true, completion: nil)
    }

    @IBAction func editEvent(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddItem", bundle: nil)

        if let viewController = storyboard.instantiateViewController(identifier: "newElementVC") as? AddItemController {

            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve

            viewController.isEditingEvent = true

            viewController.editingImage = detailedImageView.image
            viewController.editingTitle = detailedTitleLabel.text

            if eventDate != nil {
                viewController.editingDate = eventDate
            }

            if eventID != nil {
                viewController.editingID = eventID
            }

            self.present(viewController, animated: true)
        }
    }
    
}
