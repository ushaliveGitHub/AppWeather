//
//  WeatherViewController.swift
//  weatherforecast
//
//  Created by Usha Natarajan on 6/27/17.
//  Copyright © 2017 Developers Academy. All rights reserved.
//sample calls
// "https://api.darksky.net/forecast/855bd544f2dd0d3bdf70065dac71e66f/42.7654,-71.4676"
// "https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyBukz6G2y5azz8a-sHgmyVTTn7DQDiPTsA"
//GoogleGeoCodePlaceIDK : AIzaSyAiVoLgRfU5ivsVBAJrJR-NOIHe8ZQIq-g
//"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=paris&types=(cities)&key=AIzaSyAiVoLgRfU5ivsVBAJrJR-NOIHe8ZQIq-g"

import UIKit
import SafariServices

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentConditions: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var darkSkyButton: UIButton!
    @IBOutlet weak var icon8Button: UIButton!
    @IBOutlet weak var weeklySummaryLabel: UILabel!
    @IBOutlet weak var newLocationButton: UIButton!
    @IBOutlet weak var removeLocationButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var darkSkyClient:DarkSkyClient!
    var googleGeoCodingClient: GoogleGeoCodingClient!
    let locationManager = LocationManager()
    var internet:Bool = true
    
   
    //Location name
    var locationName: LocationName? {
        didSet{
            updateLocationUI(locationName:self.locationName!.location)
        }
    }
    
    // coordinates of weather location
    var coordinate:Coordinate?{
        didSet{
            if !checkLocation(){
                fetchLocation()
                fetchWeather(coordinate:self.coordinate)
            }
        }
    }
    
    //Update location Weather
    var locationWeather:LocationWeather?{
        didSet{
            updateWeatherUI()
        }
    }
    
    //To store New Weather Locations & index for new weather locations
    var weatherLocations:[LocationData] = []
    var newCoordinates:Coordinate?
    var locationAddress:LocationAddress?
    var locationIndex = -1
    var locationData:LocationData? = nil{
        didSet{
            if weatherLocations.contains(where: { $0.locationName == self.locationData!.locationName}){
            }else{
                self.locationIndex = self.locationIndex + 1
                weatherLocations.insert(self.locationData!, at: self.locationIndex)
            }
            self.locationData = nil
        }
    }
    
    //Transitions
    var transition:Transition = Transition.dissolve
    let transitionLeft = CATransition()
    let transitionRight = CATransition()
    let transitionDissolve = CATransition()
    
    // To show errors
   
    var weatherAppError:Error!{
        didSet{
            let alertControl = UIAlertController(title:"\(ErrorDomain)" , message: weatherAppError.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertControl.addAction(action)
            if let presented = self.presentedViewController {
                presented.removeFromParentViewController()
            }
            if presentedViewController == nil {
                self.present(alertControl, animated: true, completion: nil)
            }
            if !self.viewReload{
                self.weatherImageView.image = UIImage(named:"weatherError")
                hourlyCollectionView.layer.borderWidth = 0
                weeklySummaryLabel.layer.borderWidth = 0
            }
            if self.locationIndex <= 0{
                self.removeLocationButton.isEnabled = false
            }
            self.connected()
        }
    }
    
    //constants
    struct Storyboard{
        static let hourlyCell = "hourlyCell"
        static let dailyCell = "dailyCell"
        static let summaryCell = "summaryCell"
        static let detailCell = "detailCell"
        static let darkSky = "DarkSky"
        static let icon8 = "Icon8"
        static let darkSkyUrl = "https://darksky.net"
        static let icon8Url = "https://icons8.com"
        static let week = 8
        static let locationsSegue = "AddLocations"
        static let userLocationImage = "userLocation"
        static let maxLocations = 10
    }
    
    //Keys for api end points
    let ApiKey = valueForAPIKey(keyname: "DarkSkyApi")
    let googleApiKeyByID =  valueForAPIKey(keyname: "GoogleApiByID")
    
    //flags
    var viewReload:Bool = false
    var safari:Bool = false
    var locationPermission = false
    
    //for expandable cell
    var selectedIndex:IndexPath? = nil
    var isExpanded:Bool = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //For end points
        //googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKey)
        googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKeyByID)
        darkSkyClient = DarkSkyClient(ApiKey: ApiKey)
        
        // border for collection view
        hourlyCollectionView.layer.borderWidth = 0.5
        hourlyCollectionView.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        //weeklySummaryLabel.text = ""
        weeklySummaryLabel.layer.borderWidth = 0.5
        weeklySummaryLabel.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        weatherTableView.backgroundColor = UIColor.clear
        
        //For UIApplicationDidBecomeActiveNotification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appBecameActive),
            name: NSNotification.Name.UIApplicationWillEnterForeground,
            object: nil)
        
        //for lost internet connection
        if let reachability = AppDelegate.sharedAppDelegate().reachability{
            NotificationCenter.default.addObserver(self,selector: #selector(reachabilityStatusChanged),name: ReachabilityChangedNotification,object: reachability)
        }
        
        //Transtitions
        transitionLeft.type = kCATransitionPush
        transitionLeft.duration = 0.5
        transitionLeft.subtype = kCATransitionFromRight
        transitionRight.type = kCATransitionPush
        transitionRight.duration = 0.5
        transitionRight.subtype = kCATransitionFromLeft
        transitionDissolve.type = kCATransitionFade
        transitionDissolve.duration = 1.0
        
        //pageControl dot size change
        pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        
    }//end of viewWillAppear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.isHidden = true
        
        //Add gesture recognizer to view
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
    }//end of viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if no internet connection when app is launched
       let internetConnnection = Reachability.init()
        if !(internetConnnection?.isReachableViaWWAN)! && !(internetConnnection?.isReachableViaWiFi)!{
            self.internet = false
            let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.noInternetConnection.description)", comment: "")]
            let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
            weatherAppError = error
            return
        }
        getLocationPermission(flag:false)
        
    }//end of viewDidAppear
    
    func appBecameActive(){
        let internetConnnection = Reachability.init()
        if !(internetConnnection?.isReachableViaWWAN)! && !(internetConnnection?.isReachableViaWiFi)!{
            self.internet = false
            let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.noInternetConnection.description)", comment: "")]
            let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
            weatherAppError = error
            return
        }
       
        googleGeoCodingClient = nil
        darkSkyClient = nil
        //googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKey)
        googleGeoCodingClient = GoogleGeoCodingClient(googleApiKey: googleApiKeyByID)
        darkSkyClient = DarkSkyClient(ApiKey: ApiKey)
        getLocationPermission(flag:true)
       
    }
    
    //MARK: Handle gestures
    func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            let next = locationIndex - 1
            if next >= 0 {
                self.locationIndex -= 1
                self.transition = Transition.right
                self.locationName = LocationName(coordinate: weatherLocations[next].coordinate!, location: weatherLocations[next].locationName)
                self.locationWeather = weatherLocations[next].locationWeather
            }
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            let next = locationIndex + 1
            if next < (weatherLocations.count) {
                self.locationIndex += 1
                self.transition = Transition.left
                self.locationName = LocationName(coordinate: weatherLocations[next].coordinate!, location: weatherLocations[next].locationName)
                self.locationWeather = weatherLocations[next].locationWeather
            }
        }
        
    }//end of handleGestures
    
    func setAlphaValue()-> CGFloat{
        if locationIndex == 0{
            return  1.0
        }
        return 0.5
    }//end of setAlphaValue
    
//MARK: Get location permission and current location coordinates

    func getLocationPermission(flag:Bool){
        if locationManager.getPermission(flag:flag){// Permission to get user location?
            locationManager.didTriggerError = { [weak self] locationError in
                let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(locationError.localizedDescription)", comment: "")]
                let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
                self?.weatherAppError = error
            }
            locationManager.didGetLocation = { [weak self] coordinate in
                self?.coordinate = coordinate
                //print("New coordinates are \(self!.coordinate)")
            }
        }else{
            let userInfo = [NSLocalizedDescriptionKey:NSLocalizedString("\(AppError.permissionDenied.description).\(AppError.locationDataUnavailable.description) for \(ErrorDomain) ", comment: "")]
            let error = NSError(domain: ErrorDomain,code:AppError.weatherInfoUnavailable.rawValue,userInfo: userInfo)
            weatherAppError = error
            return
        }
    }//end of getlocationPermission
    
//MARK: Fetch location address data
    
    func checkLocation()->Bool{
        if  weatherLocations.count > 0{
            let currentCoordinate = weatherLocations[0].coordinate!
            if self.coordinate! == currentCoordinate{// if current location is same
                self.locationIndex = 0
                self.transition = Transition.dissolve
                self.locationName = LocationName(coordinate: weatherLocations[0].coordinate!, location: weatherLocations[0].locationName)
                self.locationWeather = weatherLocations[0].locationWeather
                return true
            }else{// current user location could have changed
                weatherLocations.remove(at: 0)
                self.locationIndex = -1
                return false
            }
        }
        return false // new current location
    }
    
    func fetchLocation() {
        if let coordinate = self.coordinate{
            googleGeoCodingClient.fetchLocationFor(coordinate:coordinate, completion: {
                    (result) in
                    switch (result){
                    case .success(let locationName):
                        self.locationName = locationName
                        guard let _ = self.locationData else{
                            self.addToWeatherLocations()
                            return
                        }
                        return
                    case .failure(let error):
                        self.weatherAppError = error
                    }
                })
        }
    }//end of fetchLocation
    
//MARK: Fetch weather data
    func fetchWeather(coordinate:Coordinate?){
        if let coordinate = coordinate{
            self.newCoordinates = coordinate
            darkSkyClient.fetchWeatherFor(coordinate: coordinate,  completion: {
                    (result) in
                    switch (result){
                    case .success(let locationWeather):
                        self.transition = Transition.dissolve
                        self.locationWeather = locationWeather
                        guard let _ = self.locationData else{
                            self.addToWeatherLocations()
                            return
                        }
                        return
                    case .failure(let error):
                        if let _ = self.weatherAppError{// if error is already caught
                            return
                        }
                        self.weatherAppError = error
                    }
                })
            }
    }//end of fetchWeather


//MARK: Update  UI
    
//Update button's UI based on internet connection
    func connected(){
        if !self.internet{
            self.newLocationButton.isEnabled = false
            self.darkSkyButton.isHidden = true
            self.darkSkyButton.isEnabled = false
            self.icon8Button.isHidden = true
            self.icon8Button.isEnabled = false
            self.statusLabel.isHidden = false
            self.pageControl.isHidden = true
            self.newLocationButton.isEnabled = false
            if self.locationIndex == 0{
                //self.removeLocationButton.isHidden = false
                self.removeLocationButton.isEnabled = false
            }
            self.newLocationButton.alpha = 0.5
            self.statusLabel.text = "⚠️\(self.weatherAppError.localizedDescription)"
        }else{
            if self.weatherLocations.count < Storyboard.maxLocations{
                self.newLocationButton.isEnabled = true
                self.newLocationButton.alpha = 1.0
            }else{
                self.newLocationButton.isEnabled = false
                self.newLocationButton.alpha = 0.5
            }
            self.statusLabel.isHidden = true
            self.darkSkyButton.isHidden = false
            self.darkSkyButton.isEnabled = true
            self.icon8Button.isHidden = false
            self.icon8Button.isEnabled = true
            self.pageControl.isHidden = false
        }
    }//end of connected
   
//update weather UI
    func updateWeatherUI(){
        self.viewReload = true
        DispatchQueue.main.async{
            //update buttons
            if self.locationIndex == 0{
                self.removeLocationButton.isEnabled = false
            }else{
                //self.removeLocationButton.isHidden = false
                self.removeLocationButton.isEnabled = true
                self.removeLocationButton.alpha = 1.0
            }
            self.connected()
            
            //update weather info
            self.updatePagesUI()
            switch self.transition{
                case .dissolve:
                    self.view.layer.add(self.transitionDissolve, forKey: "transitionDissolve")
                    self.weatherImageView.image = self.locationWeather?.weatherBackground.weatherImage
                    self.view.layer.removeAnimation(forKey: "transitionDissolve")
                case .left:
                    self.view.layer.add(self.transitionLeft, forKey: "transitionLeft")
                    self.weatherImageView.image = self.locationWeather?.weatherBackground.weatherImage
                    self.view.layer.removeAnimation(forKey: "transitionLeft")
                case .right:
                    self.view.layer.add(self.transitionRight, forKey: "transitionRight")
                    self.weatherImageView.image = self.locationWeather?.weatherBackground.weatherImage
                    self.view.layer.removeAnimation(forKey: "transitionRight")
                case .delete:
                    self.view.layer.add(self.transitionDissolve, forKey: "transitionDissolve")
                    self.weatherImageView.image = self.locationWeather?.weatherBackground.weatherImage
                    self.view.layer.removeAnimation(forKey: "transitionDissolve")
            }
            self.hourlyCollectionView.layer.borderWidth = 0.5
            self.weeklySummaryLabel.layer.borderWidth = 0.5
            let temperature = (self.locationWeather?.temperature)!
            self.currentTemperature?.text = String(format: "%.0f",temperature )
            self.currentConditions?.text = self.locationWeather?.currentConditions!
            self.weeklySummaryLabel?.text = self.locationWeather?.summary
            self.hourlyCollectionView.reloadData()
            self.weatherTableView.reloadData()
        }
    }//end of updateWeatherUI
    
// Update Location UI
    func updateLocationUI(locationName:String?){
        DispatchQueue.main.async{
            if let _ = locationName{
                self.currentLocation?.text = locationName
            }
        }
    }//end of updateLocation
    
// Update pageControl and user Location UI
    func updatePagesUI(){
            self.pageControl.numberOfPages = self.weatherLocations.count
            self.pageControl.currentPage = self.locationIndex
            self.pageControl.tintColor = UIColor.gray
            if self.weatherLocations.count <= 1{
                self.pageControl.currentPageIndicatorTintColor = UIColor.clear
            }else{
                self.pageControl.currentPageIndicatorTintColor = UIColor.yellow
                self.pageControl.alpha = 1.0
            }
    }//end of UpdatePageControl and user Location UI
    
    
    
//MARK: Add or remove weatherLocations
    @IBAction func addNewWeatherLocation(_ sender: Any) {
        self.performSegue(withIdentifier: Storyboard.locationsSegue, sender: self)
    }
    
    @IBAction func removeWeatherLocation(_ sender: Any) {
        weatherLocations.remove(at: self.locationIndex)
        self.locationIndex -= 1
        self.transition = Transition.delete
        self.locationName = LocationName(coordinate: weatherLocations[locationIndex].coordinate!, location: weatherLocations[locationIndex].locationName)
        self.locationWeather = weatherLocations[locationIndex].locationWeather
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.locationsSegue {
            let locationsTableViewController = segue.destination as!
            LocationsTableViewController
            locationsTableViewController.didGetAddress = { [weak self] address in
                self?.locationAddress = address
                //extract location Name & update to new location Name
                self?.locationName = LocationName(coordinate: (self?.locationAddress!.coordinate)!, location: self?.locationAddress!.address.components(separatedBy: ",").first)
                //Fetch new location weather
                self?.fetchWeather(coordinate:self?.locationAddress!.coordinate)
            }
        }
    }//end of prepare for segue
    
    //add to weather locations array
    func addToWeatherLocations(){
        if let _ = self.locationName?.location,
            let _ = self.locationWeather {
            let newLocationData = LocationData(locationName: self.locationName?.location, coordinate: self.locationName?.coordinate, locationWeather: self.locationWeather)
            self.locationData = newLocationData
        }
        return
    }//end of addToWeatherLocations
    
    
//MARK: Acknowledgements
    @IBAction func darkSkyClicked(_ sender: Any) {
        if let url = URL(string: Storyboard.darkSkyUrl){
            let safariVC = SFSafariViewController(url:url)
            self.present(safariVC,animated: true, completion: nil)
        }else{
            let alertControl = UIAlertController(title:"\(ErrorDomain)" , message: AppError.websiteNotFound.description, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertControl.addAction(action)
            present(alertControl, animated: true, completion: nil)
        }
    }//end of darkSkyClicked
    
    @IBAction func icon8Clicked(_ sender: Any) {
        if let url = URL(string: Storyboard.icon8Url){
            let safariVC = SFSafariViewController(url:url)
            self.present(safariVC,animated: true, completion: {self.safari = true})
        }else{
            let alertControl = UIAlertController(title:"\(ErrorDomain)" , message: AppError.websiteNotFound.description, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertControl.addAction(action)
            present(alertControl, animated: true, completion: nil)
        }
    }
 
}//end of class weatherView Controller

