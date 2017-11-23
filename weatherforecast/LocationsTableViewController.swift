//
//  LocationsTableViewController.swift
//  WeatherForecast
//
//  Created by Usha Natarajan on 10/13/17.
//

import UIKit

class LocationsTableViewController: UITableViewController {
    
    //googlegeocoding clients for location(s) search
    var googleGeoCodingClient: GoogleGeoCodingClient!
    let googleApiKey = valueForAPIKey(keyname: "GoogleApi")
    var googleGeoCodingClientByID: GoogleGeoCodingClient!
    let googleApiKeyByID =  valueForAPIKey(keyname: "GoogleApiByID")
    
    //location search controller
    let searchController = UISearchController(searchResultsController: nil)
    
    //Location Data for weather
    var locationAddress:LocationAddress?
    var didGetAddress:((LocationAddress)->Void)?
    
    //location search results
    /*var locations:[LocationData]?{
        didSet{
            self.tableView.reloadData()
        }
    }*/
    var locationList:[LocationIDs]? = nil{//reload the searchList
        didSet{
            self.tableView.reloadData()
        }
    }
    
    var noLocations = false
    var oldSearch:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKey)
        googleGeoCodingClientByID = GoogleGeoCodingClient(googleApiKey: googleApiKeyByID)
        
        //setupSearch Controller
        
        
        self.searchController.searchResultsUpdater = self as UISearchResultsUpdating
        self.searchController.searchBar.delegate = self as UISearchBarDelegate
        self.searchController.searchBar.searchBarStyle = .prominent
        self.searchController.searchBar.barStyle = .black
        self.searchController.searchBar.barTintColor = UIColor.black
        self.searchController.searchBar.tintColor = UIColor.white
        self.searchController.searchBar.isTranslucent = true
        self.searchController.dimsBackgroundDuringPresentation = false
        //self.searchController.searchBar.placeholder = "Enter a City,Town or Location"
        let placeholderAttributes: [String : AnyObject] = [NSFontAttributeName: UIFont.init(name:"Avenir", size: 14.0)!]
        let attributedPlaceholder: NSAttributedString = NSAttributedString(string: "Enter a City,Town or Location", attributes: placeholderAttributes)
        let textFieldPlaceHolder = self.searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = attributedPlaceholder
        
        definesPresentationContext = true
        self.tableView.tableHeaderView = searchController.searchBar
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = locationList{
            return (locationList?.count)!
        }else{
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
        cell.textLabel?.text = locationList![indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locationID = locationList![indexPath.row]
        self.googleGeoCodingClientByID.fetchLocationByID(locationID:locationID, completion: {
            (result) in
            switch (result){
            case .success(let locationAddress):
                self.locationAddress = locationAddress
                UIApplication.shared.delegate?.window?!.rootViewController?.self.dismiss(animated: true, completion:
                    {
                        if let didGetAddress = self.didGetAddress{
                            didGetAddress(self.locationAddress!)
                        }
                })
            case .failure(let error):
                print(error)
            }
        })
       /* if let _ = self.locationAddress{
            self.searchController.dismiss(animated: true, completion:
                {
                if let didGetAddress = self.didGetAddress{
                    didGetAddress(self.locationAddress!)
                }
            })
        }*/
    }//end of didSelectRowAt
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LocationsTableViewController: UISearchResultsUpdating,UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }//end of searchBarTextDidBeginEditing*/
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.dismiss(animated: true, completion: nil)
    }//end of searchBarCancelButtonClicked
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filterContentForSearchText(searchKey: searchBar.text!)
        //self.searchController.dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //Commented out to prevent REST API Calls for every character
        //filterContentForSearchText(searchKey: oldSearch)
    }
    
    func filterContentForSearchText(searchKey: String){
        DispatchQueue.main.async{
            let searchLocation = searchKey.lowercased().replacingOccurrences(of: " ", with: "+")
            self.googleGeoCodingClient.fetchSearchResultsFor(input:searchLocation, completion: {
                (result) in
                switch (result){
                case .success(let locations):
                    self.locationList = locations
                case .failure(let error):
                    print(error)
                }
            })
        }
    }//end of func filterContentFor
}
