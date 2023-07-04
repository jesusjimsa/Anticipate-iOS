//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/4/23.
//

import UIKit
import PhotosUI
import CoreData

class AddItemController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var addEventPageTitle: UILabel!
    @IBOutlet weak var addEventChangeName: UILabel!
    @IBOutlet weak var addEventSelectDateTitle: UILabel!
    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var addElementImageButton: UIButton!
    @IBOutlet weak var addElementImageView: UIImageView!

    var isEditingEvent: Bool = false

    var editingImage: UIImage?
    var editingTitle: String?
    var editingDate: Date?
    var editingID: String?

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        datePicker.minimumDate = Date() // Current date

        if isEditingEvent {
            addEventPageTitle.text = "Edit Event"
            addEventChangeName.text = "Edit the title of your event"
            eventNameText.text = ""
            addEventSelectDateTitle.text = "Edit the date"
            addElementImageButton.setTitle("Select new image", for: .normal)

            if editingImage != nil {
                addElementImageView.image = editingImage
            }

            if editingTitle != nil {
                eventNameText.text = editingTitle
            }

            if editingDate != nil {
                datePicker.date = editingDate!
            }
        }
    }

    func generateRandomID() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length = 6
        var randomString = ""

        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]

            randomString.append(character)
        }

        return randomString
    }

    func isIDAlreadyPresent(id: String) -> Bool {
        let fetchRequest: NSFetchRequest<UserCountdowns> = UserCountdowns.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1 // Optimize performance by limiting the fetch to 1 result

        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Error checking ID existence: \(error)")
            return false
        }
    }


    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func selectImageAddElementAction(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func saveEvent(_ sender: Any) {
        let noTitleAlert = UIAlertController(title: "Alert", message: "You have not added a title", preferredStyle: .alert)
        let noImageAlert = UIAlertController(title: "Alert", message: "You have not added an image", preferredStyle: .alert)
        var newID: String = generateRandomID()

        noTitleAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            return
        }))

        noImageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            return
        }))

        if !eventNameText.hasText {
            self.present(noTitleAlert, animated: true, completion: nil)
            return
        }

        if addElementImageView.image == nil {
            self.present(noImageAlert, animated: true, completion: nil)
            return
        }

        // Generate new random ID if it's already present
        while isIDAlreadyPresent(id: newID) {
            newID = generateRandomID()
        }

        do {
            if !isEditingEvent {
                let newEvent = UserCountdowns(context: self.context)

                newEvent.id = newID
                newEvent.title = eventNameText.text
                newEvent.date = datePicker.date
                newEvent.image = addElementImageView.image?.pngData()
            }
            else {
                let fetchRequest: NSFetchRequest<UserCountdowns> = UserCountdowns.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", editingID!)

                let fetchedEvent = try context.fetch(fetchRequest)
                if let eventToUpdate = fetchedEvent.first {
                    eventToUpdate.date = datePicker.date
                    eventToUpdate.image = addElementImageView.image?.pngData()
                    eventToUpdate.title = eventNameText.text
                }
            }

            try self.context.save()
        }
        catch {
            print("Error saving or updating event: \(error)")
        }

        dismiss(animated: true, completion: nil)
    }


}

extension AddItemController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

extension AddItemController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            let previousImage = addElementImageView.image

            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    guard let self = self, let image = image as? UIImage, self.addElementImageView.image == previousImage else {
                        return
                    }
                    self.addElementImageView.image = image
                }

            }
        }
    }
}
