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

    @IBOutlet weak var eventNameText: UITextField!
    @IBOutlet weak var addElementImageButton: UIButton!
    @IBOutlet weak var addElementImageView: UIImageView!

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        datePicker.minimumDate = Date() // Current date

    }

    @IBAction func selectImageAddElementAction(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }

    @IBAction func saveEvent(_ sender: Any) {
        let newEvent = UserCountdowns(context: self.context)
        let noTitleAlert = UIAlertController(title: "Alert", message: "You have not added a title", preferredStyle: .alert)
        let noImageAlert = UIAlertController(title: "Alert", message: "You have not added an image", preferredStyle: .alert)

        noTitleAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")

                case .cancel:
                print("cancel")

                case .destructive:
                print("destructive")

            @unknown default:
                print("Unknown")
            }
        }))

        noImageAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")

                case .cancel:
                print("cancel")

                case .destructive:
                print("destructive")

            @unknown default:
                print("Unknown")
            }
        }))

        if eventNameText.hasText {
            newEvent.title = eventNameText.text
        }
        else {
            self.present(noTitleAlert, animated: true, completion: nil)
            return
        }

        newEvent.date = datePicker.date

        if addElementImageView.image != nil {
            newEvent.image = addElementImageView.image?.pngData()
        }
        else {
            self.present(noImageAlert, animated: true, completion: nil)
            return
        }

        try! self.context.save()

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
