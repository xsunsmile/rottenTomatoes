//
//  MovieDetailsViewController.swift
//  RottenTomatoes
//
//  Created by Hao Sun on 2/5/15.
//  Copyright (c) 2015 Hao Sun. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController, UIScrollViewDelegate {
    
    var movieDetail: NSDictionary = NSDictionary()
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var scrollDetail: UIScrollView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieSynopsisTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.setImageWithURL(getMoviePosterURL("profile"))
        
        var label = UILabel()
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont boldSystemFontOfSize:20.0];
//        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = UIColor.yellowColor()
        label.text = getMovieProperty("title")
        navigationItem.titleView = label
        
        movieSynopsisTextView.frame.size.width = view.frame.size.width
        movieSynopsisTextView.layoutMargins = UIEdgeInsetsMake(20.0, 5.0, 10.0, 5.0)
        movieSynopsisTextView.text = getMovieProperty("synopsis")
        movieSynopsisTextView.sizeToFit()
        movieSynopsisTextView.layoutIfNeeded()
        
        movieTitleLabel.text = getMovieProperty("title")
//        movieRatingLabel.text = getMovieProperty("ratings.critics_rating")
        
        scrollDetail.delegate = self
        scrollDetail.contentSize = CGSizeMake(
            view.frame.size.width,
            movieSynopsisTextView.frame.origin.y + movieSynopsisTextView.frame.size.height
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func getMoviePosterURL(type: NSString) -> NSURL! {
        let posters = movieDetail["posters"] as NSDictionary
        let movieUrl = (posters[type] as String).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        return NSURL(string: movieUrl)!
    }
    
    func getMovieProperty(key: NSString) -> NSString {
        return movieDetail[key] as NSString
    }
    
    @IBAction func toggle(sender: AnyObject) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
}
