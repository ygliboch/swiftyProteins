//
//  TabViewViewController.swift
//  swiftyProteins
//
//  Created by Yaroslava HLIBOCHKO on 7/17/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class TabViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var ligands: [String] = []
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                var myStrings = data.components(separatedBy: .newlines)
                if myStrings.last == "" {
                    myStrings.removeLast()
                }
                ligands = myStrings
            } catch {
                print(error)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ligands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LigandTableViewCell {
            cell.titleLabel.text = ligands[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
