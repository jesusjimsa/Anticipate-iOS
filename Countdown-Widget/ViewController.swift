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
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var UserEventsList: [UserCountdowns]?

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

    override func viewWillAppear(_ animated: Bool) {
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
                self.tableview.reloadData()
            }
        }
        catch {
            print("Error recuperando datos")
        }
    }

    func daysBetween(start: Date, end: Date) -> Int {
            return Calendar.current.dateComponents([.day], from: start, to: end).day!
        }

    func daysLeft(date: Date) -> Int {
        return daysBetween(start: Date(), end: date)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as? customCell {
            if UserEventsList != nil {
                cell.timeLeftLabel.text = String(daysLeft(date: UserEventsList![indexPath.row].date!))
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
        print("myCountries[indexPath.row]")
    }
}

extension ViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}
