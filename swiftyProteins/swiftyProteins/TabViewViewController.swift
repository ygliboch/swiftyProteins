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
    let activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var file: String?
    var name: String?
    
    @IBOutlet weak var navBar: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
//        let imgView = UIImageView(image: UIImage(named: "background"))
//        tableView.backgroundView = imgView
//        imgView.contentMode = .scaleAspectFill
        tableView.backgroundColor = .clear
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.isUserInteractionEnabled = true
        self.view.endEditing(false)
        searchBarSearchButtonClicked(self.searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterLigands = searchText.isEmpty ? ligands : ligands.filter { (item: String) -> Bool in
            return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterLigands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LigandTableViewCell {
//            cell.backgroundColor = .clear
            cell.contentView.layer.cornerRadius = 5
            cell.titleLabel.text = filterLigands[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LigandModelViewController {
            if (segue.identifier == "show3DModel" && sender != nil) {
                vc.file = self.file!
                vc.name = self.name!
                vc.info = sender as! String
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showActivityIndicator()
        name = filterLigands[indexPath.row]
        self.view.isUserInteractionEnabled = false
        self.tableView.cellForRow(at: indexPath)?.isSelected = true
        findFileForLigandModel(name: filterLigands[indexPath.row], completionHandler: {response in
            if response != nil {
                self.file = response
                print(response!)
                self.findFileForLigandInformation(name: self.filterLigands[indexPath.row], completionHandler: { response in
                    if response != nil {
                        self.performSegue(withIdentifier: "show3DModel", sender: response)
                        self.tableView.cellForRow(at: indexPath)?.isSelected = false
                        self.hideActivityIndicator()
                    }
                })
            }
            else {
                self.makeAlert(title: "Error", message: "Ligand not found")
            }
        })
    }
    
    func findFileForLigandModel(name: String, completionHandler: @escaping (String?) -> Void)  {
        guard let url = URL(string: "https://files.rcsb.org/ligands/\(name.first!)/\(name)/\(name)_ideal.pdb") else { return }
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    if let pdbfile : String = try? String(contentsOf: data) {
                        if pdbfile.isEmpty {
                            self.makeAlert(title: "Error", message: "Source file doesn't exist ☹️")
                            self.view.isUserInteractionEnabled = true
                            self.hideActivityIndicator()
                        }
                        completionHandler(pdbfile)
                    }
                }
            }
        }
        task.resume()
    }
    
    func findFileForLigandInformation(name: String, completionHandler: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://files.rcsb.org/ligands/download/\(name).cif") else { return }
        let task = URLSession.shared.downloadTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    if let cifFile: String = try? String(contentsOf: data) {
                        if cifFile.isEmpty == false {
                            completionHandler(cifFile)
                        } else {
                            self.makeAlert(title: "Error", message: "Source file doesn't exist ☹️")
                            self.view.isUserInteractionEnabled = true
                            self.hideActivityIndicator()
                        }
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
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.style = .whiteLarge
            self.activityIndicator.frame = CGRect(x: 0, y: 0, width: 80, height: 80) //or whatever size you would. like
            self.activityIndicator.center = CGPoint(x: self.view.bounds.size.width / 2, y: self.view.bounds.height / 2)
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
        }
    }
}
