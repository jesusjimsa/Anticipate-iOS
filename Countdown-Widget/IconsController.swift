//
//  IconsController.swift
//  Countdown-Widget
//
//  Created by Jesús Jiménez Sánchez on 15/8/23.
//

import UIKit

class IconsController: UIViewController {
    @IBOutlet weak var iconsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Icons"

        iconsTableView.dataSource = self
        iconsTableView.delegate = self

        iconsTableView.register(UINib(nibName: "iconCellView", bundle: nil), forCellReuseIdentifier: "iconCellView")
    }

}

extension IconsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "iconCellView") as? iconCellView {

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconsEnum.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension IconsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedIcon = iconsEnum.allCases[indexPath.row]
//        let defaults = UserDefaults.standard
//
//        defaults.set(selectedIcon, forKey: "icon")
//        print("Selected icon \(defaults.object(forKey: "icon")!)")
    }
}
