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

        // Hide keyboard when clicking intro key
        eventNameText.delegate = self
        eventNameText.tag = 1

        // This has been disabled for now because it creates an problem where the date picker stops working.
        initializeHideKeyboard()    // Hide keyboard when touching outside
        setupToolbar()  // 'Done' button to hide keyboard

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

    @objc func keyboardWillShow(_ notification: Notification) {
        // Enable the tap gesture recognizer when the keyboard is shown
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        // Disable the tap gesture recognizer when the keyboard is hidden
        view.gestureRecognizers?.forEach {
            if let tapGesture = $0 as? UITapGestureRecognizer {
                view.removeGestureRecognizer(tapGesture)
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

    func setupToolbar() {
        // Create a toolbar
        let bar = UIToolbar()

        // Create a done button with an action to trigger our function to dismiss the keyboard
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))

        // Create a felxible space item so that we can add it around in toolbar to position our done button
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        // Add the created button items in the toobar
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()

        // Add the toolbar to our textfield
        eventNameText.inputAccessoryView = bar
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

    func initializeHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboard))

        // Initially, set the gesture recognizer as disabled
        tapGesture.isEnabled = false

        // Add the tap gesture to the view
        view.addGestureRecognizer(tapGesture)

        // Register for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    @objc func dismissMyKeyboard() {
        // endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        // In short- Dismiss the active keyboard.
        view.endEditing(true)
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

extension AddItemController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Check if there is any other text-field in the view whose tag is +1 greater than the current text-field on
        // which the return key was pressed. If yes → then move the cursor to that next text-field. If No → Dismiss the
        // keyboard
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }

        return false
    }
}
