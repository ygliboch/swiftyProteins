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
        let imgView = UIImageView(image: UIImage(named: "background"))
        tableView.backgroundView = imgView
        imgView.contentMode = .scaleAspectFill
        if let path = Bundle.main.path(forResource: "ligands", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                var ligandsArray = data.components(separatedBy: .newlines)
                if ligandsArray.last == "" {
                    ligandsArray.removeLast()
                }
                ligands = ligandsArray
                filterLigands = ligands
            } catch {
                print(error)
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterLigands = searchText.isEmpty ? ligands : ligands.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLigands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LigandTableViewCell {
            cell.backgroundColor = .clear
            cell.titleLabel.text = filterLigands[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelect \(indexPath.row)")
    }
}
