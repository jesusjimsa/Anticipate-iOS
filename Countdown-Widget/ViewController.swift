//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 3/3/22.
//

import UIKit

class ViewController: UIViewController {
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

        day = formatter.date(from: "01/05/2022")!

        dates.append(day)

        day = formatter.date(from: "23/12/2022")!

        dates.append(day)

        day = formatter.date(from: "05/08/2022")!

        dates.append(day)
    }


}

extension ViewController: UITableViewDataSource {

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
        var cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        let formatter = DateFormatter()

        formatter.dateFormat = "EEEE dd MMMM yyyy"

        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell?.accessoryType = .disclosureIndicator
        }

        cell!.textLabel?.text = ("\(daysLeftTest[indexPath.row]) días para el " +
                                 "\(formatter.string(from: dates[indexPath.row]))")


        return cell!
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(daysLeftTest[indexPath.row])
    }
}
