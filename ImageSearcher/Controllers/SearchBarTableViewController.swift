//
//  SearchBarTableViewController.swift
//  ImageSearcher
//
//  Created by Randy McLain on 10/10/17.
//  Copyright © 2017 Randy McLain. All rights reserved.
//

import UIKit

class SearchBarTableViewController: UITableViewController, UISearchBarDelegate {
    let reuseIdentifier:String = "tableCell"
    var searchBarController: UISearchController! // will not be nil
 
    var dataSourceOfPhotos = [Photo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarControllerSetup()

        RequestManager.sharedInstance.getEditorChoiceImages {[weak self] (photos, error) in
            if error == nil {
                self?.dataSourceOfPhotos = photos!
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataSourceOfPhotos.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoTableViewCell

        cell.photoData = self.dataSourceOfPhotos[indexPath.row]
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Helper
    
    fileprivate func searchBarControllerSetup() {
        self.searchBarController = UISearchController(searchResultsController: nil)
        self.searchBarController.searchBar.delegate = self as UISearchBarDelegate
        self.searchBarController.hidesNavigationBarDuringPresentation = true
        self.searchBarController.dimsBackgroundDuringPresentation = false
        self.searchBarController.searchBar.searchBarStyle = .prominent
        self.searchBarController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchBarController.searchBar
        self.searchBarController.definesPresentationContext = true // avoiding search bar remaining after segue.
        
        self.searchBarController.searchBar.text = "Search for Images"
    }
   
}
