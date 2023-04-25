//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/4/23.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    @IBOutlet weak var newElementButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
//    @IBOutlet weak var addElementImageButton: UIButton!
//    @IBOutlet weak var addElementImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tableview.dataSource = self
        tableview.delegate = self

        tableview.register(UINib(nibName: "customCell", bundle: nil), forCellReuseIdentifier: "customCell")

        let settingsSymbol = UIImage(systemName: "gear")
        settingsButton.setImage(settingsSymbol, for: .normal)
        settingsButton.setTitle("", for: .normal)

        navigationBar.delegate = self
    }

//    @IBAction func selectImageAddElementAction(_ sender: Any) {
//        var configuration = PHPickerConfiguration()
//        configuration.filter = .images
//
//        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
//        present(picker, animated: true)
//    }
    @IBAction func test_action(_ sender: Any) {
        print("Press the other thing")
    }

    @IBAction func openNewElementView(_ sender: Any) {
        print("Press Add button")
        let storyboard = UIStoryboard(name: "AddItem", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newElementVC")
        self.present(vc, animated: true)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? customCell {
            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("myCountries[indexPath.row]")
    }
}

extension ViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
//
//extension ViewController: PHPickerViewControllerDelegate {
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        dismiss(animated: true)
//
//        if let itemProvider = results.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            let previousImage = addElementImageView.image
//
//            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
//                    guard let self = self, let image = image as? UIImage, self.addElementImageView.image == previousImage else {
//                        return
//                    }
//                    self.addElementImageView.image = image
//                }
//
//            }
//        }
//    }
//}
