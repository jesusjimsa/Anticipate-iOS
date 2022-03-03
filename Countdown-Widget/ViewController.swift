//
//  ViewController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 3/3/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainTable: UITableView!
    private var daysLeftTest = [2, 7, 12, 5, 4]

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTable.dataSource = self
        mainTable.delegate = self
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
//        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "myCell")

            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
                cell?.accessoryType = .disclosureIndicator
            }

            cell!.textLabel?.text = String(daysLeftTest[indexPath.row]) + " days left"

            return cell!
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "mycustomcell", for: indexPath) as?
//                myCustomTableViewCell
//
//            cell?.myFirstLabel.text = String(indexPath.row + 1)
//            cell?.mySecondLabel.text = String(myCountries[indexPath.row])
//
//            return cell!
//        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(daysLeftTest[indexPath.row])
    }
}
