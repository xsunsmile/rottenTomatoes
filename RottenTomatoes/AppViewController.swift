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
    @IBOutlet weak var networkErrorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.yellowColor()
        navigationController!.navigationBar.titleTextAttributes = NSDictionary(objectsAndKeys:
            UIColor.yellowColor(), NSForegroundColorAttributeName)
        
        SVProgressHUD.show()
        getPopularRentalMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("MovieCellView") as? MovieCellView
        cell!.movie = getMovieDetails(indexPath)
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 114.0
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
            var actualError: NSError? = error
            
            if let error = actualError {
                self.networkErrorView.hidden = false
                self.tableView.hidden = true
            } else {
                var responseDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &actualError) as NSDictionary
                self.movies = responseDict["movies"] as NSArray
                self.tableView.reloadData()
            }
            SVProgressHUD.dismiss()
        })
    }
    
    func getMovieDetails(indexPath: NSIndexPath) -> NSDictionary {
        return movies[indexPath.row] as NSDictionary
    }
}
