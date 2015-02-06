//
//  AppViewController.swift
//  RottenTomatoes
//
//  Created by Hao Sun on 2/4/15.
//  Copyright (c) 2015 Hao Sun. All rights reserved.
//

import UIKit

class AppViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let api_key = "hkn96husrzd5gp824dkcteqc"
    var movies: NSArray = NSArray()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        getPopularRentalMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCellView") as MovieCellView
        cell.accessoryType = UITableViewCellAccessoryType.None
        cell.posterImageView.setImageWithURL(getMoviePosterURL(indexPath, type: "profile"))
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count;
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as MovieDetailsViewController
        var indexPath = tableView.indexPathForCell(sender as UITableViewCell)!
        vc.movieDetail = getMovieDetails(indexPath)
    }
    
    func getPopularRentalMovies() {
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + api_key
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            var responseDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            self.movies = responseDict["movies"] as NSArray
            self.tableView.reloadData()
        })
    }
    
    func getMovieDetails(indexPath: NSIndexPath) -> NSDictionary {
        return movies[indexPath.row] as NSDictionary
    }
 
  
    func getMoviePosterURL(indexPath: NSIndexPath, type: NSString) -> NSURL! {
        let movieDetails = getMovieDetails(indexPath)
        let posters = movieDetails["posters"] as NSDictionary
        let movieUrl = (posters[type] as String).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        
        println("movieUrl now: \(movieUrl)")
        return NSURL(string: movieUrl)!
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    @IBAction func toggle(sender: AnyObject) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
    }
}
