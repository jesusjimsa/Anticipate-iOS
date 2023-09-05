//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 4/4/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var newElementButton: UIButton!
    @IBOutlet weak var eventsTableView: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var UserEventsList: [UserCountdowns]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setThemeDidLoad()

        eventsTableView.dataSource = self
        eventsTableView.delegate = self

        eventsTableView.register(UINib(nibName: "customCell", bundle: nil), forCellReuseIdentifier: "customCell")

        let settingsSymbol = UIImage(systemName: "gear")
        settingsButton.setImage(settingsSymbol, for: .normal)
        settingsButton.setTitle("", for: .normal)

        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Events"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = eventsTableView.indexPathForSelectedRow {
            eventsTableView.deselectRow(at: selectedIndexPath, animated: animated)
        }

        recuperarDatos()
    }

    @IBAction func openNewElementView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddItem", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "newElementVC")

        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve

        self.present(vc, animated: true)
    }

    @IBAction func openSettings(_ sender: Any) {

    }

    func recuperarDatos() {
        do {
            self.UserEventsList = try context.fetch(UserCountdowns.fetchRequest())

            DispatchQueue.main.async {
                self.eventsTableView.reloadData()
            }
        }
        catch {
            print("Error recuperando datos")
        }
    }

    func setThemeDidLoad() {
        let defaults = UserDefaults.standard
        let appTheme = defaults.string(forKey: "appTheme")
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? customCell {
            if UserEventsList != nil {
                var timeLeft: String = String(daysLeft(date: UserEventsList![indexPath.row].date!))

                // Set time left to 0 when displaying a past event
                if Int(timeLeft)! < 0 {
                    timeLeft = "0"
                }
                else if Int(timeLeft) == 1 {
                    // Change to singular when just one day left
                    cell.daysLeftText.text = "Day Left"
                }

                cell.timeLeftLabel.text = timeLeft
                cell.elemTitle.text = UserEventsList![indexPath.row].title!
                cell.elemImage.image = UIImage(data: UserEventsList![indexPath.row].image!)
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserEventsList == nil {
            return 0
        }
        else {
            return UserEventsList!.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEvent = UserEventsList![indexPath.row]
        let storyboard = UIStoryboard(name: "DetailedView", bundle: nil)

        if let viewController = storyboard.instantiateViewController(identifier: "detailedView") as?
            DetailedViewController {

            viewController.timeLeftText = String(daysLeft(date: selectedEvent.date!))
            viewController.titleText = selectedEvent.title!
            viewController.image = UIImage(data: selectedEvent.image!)
            viewController.eventIndex = indexPath.row
            viewController.eventDate = selectedEvent.date
            viewController.eventID = selectedEvent.id

            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let areYouSureAlert = UIAlertController(title: "Are you sure?",
                                                    message: "Are you sure you want to delete this event?",
                                                    preferredStyle: .alert)

            areYouSureAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
                self.recuperarDatos()
                self.context.delete(self.UserEventsList![indexPath.row])
                try! self.context.save()
                self.recuperarDatos()
            }))

            areYouSureAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                // Nothing
            }))

            self.present(areYouSureAlert, animated: true, completion: nil)
        }
    }
}

extension ViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
