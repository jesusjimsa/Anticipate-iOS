//
//  SettingsController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 18/7/23.
//

import UIKit

class SettingsController: UIViewController {
    @IBOutlet weak var appIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"

        // TODO: Select icons
        let defaults = UserDefaults.standard
        let selectedAppIcon = defaults.object(forKey: "icon") as? iconsEnum ?? iconsEnum(rawValue: 1)

        switch selectedAppIcon {
            case .FirstPrototype:
                appIcon.image = UIImage(named: "first_icon")
            default:
                appIcon.image = UIImage(named: "first_icon")
        }
    }


    @IBAction func emailDevButton(_ sender: Any) {
        let email = "jesusjimsa@icloud.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            }
            else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    @IBAction func openTwitterProfile(_ sender: Any) {
        let screenName =  "jesusjimsa"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/\(screenName)")!

        let application = UIApplication.shared

        if application.canOpenURL(appURL) {
            application.open(appURL, options:  [:], completionHandler:  nil)
        }
        else {
            application.open(webURL, options:  [:], completionHandler:  nil)
        }
    }

    @IBAction func openRepoGithub(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://github.com/jesusjimsa/Countdown-Widget-iOS")!, options: [:],
                                  completionHandler: nil)
    }

    @IBAction func openMastodon(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://mastodon.world/@jesusjimsa")!, options: [:],
                                  completionHandler: nil)
    }

    @IBAction func setDarkMode(_ sender: Any) {
        let alertController = UIAlertController(title: "Select an Option", message: nil, preferredStyle: .actionSheet)

        let systemAction = UIAlertAction(title: "System", style: .default) { _ in
            self.handleOptionSelected(appTheme: "System")
        }

        let lightAction = UIAlertAction(title: "Light", style: .default) { _ in
            self.handleOptionSelected(appTheme: "Light")
        }

        let darkAction = UIAlertAction(title: "Dark", style: .default) { _ in
            self.handleOptionSelected(appTheme: "Dark")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(systemAction)
        alertController.addAction(lightAction)
        alertController.addAction(darkAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func handleOptionSelected(appTheme: String) {
        UserDefaults.standard.set(appTheme, forKey: "appTheme")

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if let windowScene = windowScene {
            windowScene.windows.forEach { window in
                switch appTheme {
                case "Dark":
                    window.overrideUserInterfaceStyle = .dark
                case "Light":
                    window.overrideUserInterfaceStyle = .light
                case "System":
                    window.overrideUserInterfaceStyle = .unspecified
                default:
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }
        }
    }
}

