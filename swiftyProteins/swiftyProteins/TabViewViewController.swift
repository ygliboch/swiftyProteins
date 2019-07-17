//
//  TabViewViewController.swift
//  swiftyProteins
//
//  Created by Yaroslava HLIBOCHKO on 7/17/19.
//  Copyright © 2019 Yaroslava HLIBOCHKO. All rights reserved.
//

import UIKit

class TabViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    var ligands: [String] = []
    var filterLigands: [String] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                var myStrings = data.components(separatedBy: .newlines)
                if myStrings.last == "" {
                    myStrings.removeLast()
                }
                ligands = myStrings
                filterLigands = ligands
            } catch {
                print(error)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterLigands = searchText.isEmpty ? ligands : ligands.filter { (item: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLigands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LigandTableViewCell {
            cell.titleLabel.text = filterLigands[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
