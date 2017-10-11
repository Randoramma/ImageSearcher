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
    var didMakeRequest: Bool! // ensures only 1 request is made per user scroll action.
    
    var dataSourceOfPhotos = [Photo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var dataSourceOfSearch = [Photo]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarControllerSetup()
        self.didMakeRequest = false
        requestDefaultPhotos()
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
        return self.searchBarController.isActive ? self.dataSourceOfSearch.count : self.dataSourceOfPhotos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PhotoTableViewCell
        
        if self.searchBarController.isActive {
            cell.photoData = self.dataSourceOfSearch[indexPath.row]
        } else {
            cell.photoData = self.dataSourceOfPhotos[indexPath.row]
        }
        return cell
    }
    
    // MARK: SearchBar Delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestSearchedForPhotos(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dataSourceOfSearch = self.dataSourceOfPhotos
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
    }
    
    // MARK: - ScrollView
    
    /*
     Notifies when the user scrolls, when the reach the bottom so we can know when to load new requests
     Note: scrollViewDidScroll may be called several times during a scroll event and thus the need for the
     didMakeRequest variable.
     */
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            if !self.didMakeRequest {
                self.didMakeRequest = true
                if (self.searchBarController.isActive) && (self.searchBarController.searchBar.text != "") {
                    requestSearchedForPhotos(self.searchBarController.searchBar.text!)
                    self.didMakeRequest = false
                }
            } else {
                requestDefaultPhotos()
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DetailViewController
        let _ = destinationVC.view // call to initialize view related properties of the destinationVC
        guard let indexPath = self.tableView.indexPathForSelectedRow else {return}
        
        let indexOfCellSelected = indexPath.row
        let cell = self.tableView.cellForRow(at: indexPath) as! PhotoTableViewCell
        
        /* Setup the detail view with DI */
        destinationVC.detailVCSetup(withImageView: cell.mainImage.image!, likesCount: self.dataSourceOfPhotos[indexOfCellSelected].likes!, andFavoritesCount: self.dataSourceOfPhotos[indexOfCellSelected].favorites!)
    }
    
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
    
    fileprivate func requestSearchedForPhotos(_ textToFind: String) {
        RequestManager.sharedInstance.getImagesByName(nameToSearch: textToFind) { (photos, error) in
            if error == nil {
                self.dataSourceOfSearch += photos!
            }
        }
    }
    
    fileprivate func requestDefaultPhotos() {
        RequestManager.sharedInstance.getEditorChoiceImages {[weak self] (photos, error) in
            if error == nil {
                self?.dataSourceOfPhotos += photos!
            }
        }
    }
}
