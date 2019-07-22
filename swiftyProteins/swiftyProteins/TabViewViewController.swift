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
    var file: String?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let evc = segue.destination as? LigandModelViewController {
            if (segue.identifier == "show3DModel" && sender != nil) {
                evc.file = sender as! String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        findFileForLigand(name: filterLigands[indexPath.row], completionHandler: {response in
            if response != nil {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "show3DModel", sender: response)
                }
            }
            else {
                DispatchQueue.main.async {
                    self.makeAlert(title: "Error", message: "Ligand not found")
                }
            }
        })
        
    }
    
    func findFileForLigand(name: String, completionHandler: @escaping (String?) -> Void)  {
        guard let url = URL(string: "https://files.rcsb.org/ligands/\(name.first!)/\(name)/\(name)_ideal.pdb") else { return }
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    if let pdbfile : String = try? String(contentsOf: data) {
                        if pdbfile.isEmpty {
                            self.makeAlert(title: "Error", message: "Source file doesn't exist ☹️")
                        }
                        completionHandler(pdbfile)
                    }
                }
            }
        }
        task.resume()
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
}
