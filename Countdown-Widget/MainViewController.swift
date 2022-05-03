//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 3/3/22.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var mainTable: UITableView!
    private var dates: [Date] = []
    private var daysLeftTest: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTable.dataSource = self
        mainTable.delegate = self

        fillWithElemsTest()

        for elem in dates {
            daysLeftTest.append(daysUntil(day: elem))
        }

        mainTable.register(UINib(nibName: "customCounterCell", bundle: nil), forCellReuseIdentifier: "mycustomcell")
    }

    func daysUntil(day: Date) -> Int {
        let today = Date()

        return Calendar.current.dateComponents([.day], from: today, to: day).day! + 1    // Add 1 to include today
    }

    // Test function
    func fillWithElemsTest() {
        let formatter = DateFormatter()

        formatter.dateFormat = "dd/MM/yyyy"

        var day = formatter.date(from: "08/10/2022")!

        dates.append(day)

        day = formatter.date(from: "01/05/2023")!

        dates.append(day)

        day = formatter.date(from: "23/12/2022")!

        dates.append(day)

        day = formatter.date(from: "05/08/2022")!

        dates.append(day)
    }


}

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Counters"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysLeftTest.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()

        formatter.dateFormat = "EEEE d MMMM yyyy"

        let cell = tableView.dequeueReusableCell(withIdentifier: "mycustomcell", for: indexPath) as?
            customCounterCell

        cell?.eventNameLabel.text = "Evento increíble"
        cell?.eventDateLabel.text = "\(formatter.string(from: dates[indexPath.row]))"
        cell?.daysLeftLabel.text = "Faltan \(daysLeftTest[indexPath.row]) días"

        return cell!
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "detailedViewController") as!
        DetailedViewController

        nextViewController.daysLeftValue = daysLeftTest[indexPath.row]

//        nextViewController.modalPresentationStyle = .
        self.present(nextViewController, animated:true, completion:nil)
    }
}
