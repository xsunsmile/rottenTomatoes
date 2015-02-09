//
//  AppViewController.swift
//  RottenTomatoes
//
//  Created by Hao Sun on 2/4/15.
//  Copyright (c) 2015 Hao Sun. All rights reserved.
//

import UIKit

class AppViewController: UIViewController,
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UISearchBarDelegate
{
    
    let api_key = "hkn96husrzd5gp824dkcteqc"
    var current_page = 1
    var numResults = 0
    var isFiltered = false
    var shouldBeginEditing = true
    var movies: [NSDictionary]! = []
    var filteredMovies = NSMutableArray()
    var refreshControl: UIRefreshControl! = UIRefreshControl()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.None
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.tintColor = UIColor.yellowColor()
        navigationController!.navigationBar.titleTextAttributes = NSDictionary(objectsAndKeys:
            UIColor.yellowColor(), NSForegroundColorAttributeName)
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refersh")
        self.refreshControl.addTarget(self, action: Selector("refresh"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        SVProgressHUD.show()
        getPopularRentalMovies()
        SVProgressHUD.dismiss()
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
        if(isFiltered) {
           return filteredMovies.count
        }
        
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
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=16&page=\(current_page)&apikey=\(api_key)"
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var actualError: NSError? = error
            
            if let error = actualError {
                self.networkErrorView.hidden = false
                self.tableView.hidden = true
            } else {
                var responseDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &actualError) as NSDictionary

                self.movies = responseDict["movies"] as [NSDictionary]
                self.numResults = responseDict["total"] as NSInteger

                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        })
    }
    
    func getMovieDetails(indexPath: NSIndexPath) -> NSDictionary {
        if isFiltered {
            return filteredMovies[indexPath.row] as NSDictionary
        }
        
        return movies[indexPath.row] as NSDictionary
    }

    func refresh() {
        current_page += 1
        getPopularRentalMovies()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies.removeAllObjects()
        
        if !searchBar.isFirstResponder() {
            shouldBeginEditing = false
            isFiltered = false
            view.endEditing(true)
            return
        }
        
        if(searchText.isEmpty) {
            NSLog("%@", "searching nothing")
            isFiltered = false
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.searchBar.resignFirstResponder()
                return
            }
            return
        } else {
            NSLog("%@", "searching \(searchText)")
            isFiltered = true
            for movie in movies {
                let movieTitle = movie["title"] as NSString
                let movieSynopsis = movie["synopsis"] as NSString
                
                var nameRange: NSRange = movieTitle.rangeOfString(searchText, options: .CaseInsensitiveSearch)
                var synopsisRange: NSRange = movieSynopsis.rangeOfString(searchText, options: .CaseInsensitiveSearch)
                
                NSLog("%@", "matching \(movieTitle) to \(searchText) :: \(nameRange.location)")
                
                if(nameRange.location != NSNotFound || synopsisRange.location != NSNotFound) {
                    NSLog("%@", "adding \(movieTitle)")
                    filteredMovies.addObject(movie)
                }
            }
        }
        
        if filteredMovies.count > 0 {
            NSLog("%@", "reload table")
            tableView.reloadData()
        }
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let returnValue = shouldBeginEditing
        shouldBeginEditing = true
        return returnValue
    }
}
