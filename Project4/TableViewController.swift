//
//  TableViewController.swift
//  Project4
//
//  Created by Eddie Jung on 8/3/21.
//

import UIKit

class TableViewController: UITableViewController {

    var websitesAll = [String]()
    var websitesAllowed = [String]()
    var websitesNotAlowed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Easy Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if let websitesURL = Bundle.main.url(forResource: "websitesAll", withExtension: "txt") {
            if let websites = try? String(contentsOf: websitesURL) {
                websitesAll = websites.components(separatedBy: "\n")
            }
        }
        
        if let websitesWillAllowURL = Bundle.main.url(forResource: "websitesAllowed", withExtension: "txt") {
            if let websitesWillAllow = try? String(contentsOf: websitesWillAllowURL) {
                websitesAllowed = websitesWillAllow.components(separatedBy: "\n")
            }
        }
        
        if let websitesWillNotAllowURL = Bundle.main.url(forResource: "websitesNotAllowed", withExtension: "txt") {
            if let websitesWillNotAllow = try? String(contentsOf: websitesWillNotAllowURL) {
                websitesNotAlowed = websitesWillNotAllow.components(separatedBy: "\n")
            }
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return websitesAll.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Websites", for: indexPath)
        
        cell.textLabel?.text = websitesAll[indexPath.row]
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 20)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Url") as? ViewController {
            vc.selectedURL = websitesAll[indexPath.row]
            vc.websites = websitesAllowed
            vc.websitesDisabled = websitesNotAlowed
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    

}
