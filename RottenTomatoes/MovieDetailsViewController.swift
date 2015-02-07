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
    @IBOutlet weak var movieSynopsisTextView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var titleView = UILabel(frame: CGRectMake(0, 0, view.frame.size.width * 0.8, 100))
        titleView.text = getMovieProperty("title") as NSString
        titleView.textColor = UIColor.yellowColor()
        titleView.textAlignment = .Center
        navigationItem.titleView = titleView
        
        backgroundImage.setImageWithURL(getMoviePosterURL("profile"), placeholderImage: UIImage(named: "flixster"))
       
        let title = getMovieProperty("title") as NSString
        let year = getMovieProperty("year") as NSInteger
        let uiTitle = NSString(string: "\(title) (\(year))")
        
        let critics_score = getMovieScore("critics_score")
        let audience_score = getMovieScore("audience_score")
        let uiScores = NSString(string: "Critics score: \(critics_score) Audience score: \(audience_score)")
        
        let mpaa_rating = getMovieProperty("mpaa_rating") as NSString
        let synopsisText = getMovieProperty("synopsis") as NSString
        
        let synopsisBody = NSString(string: uiTitle
            .stringByAppendingString("\n")
            .stringByAppendingString(uiScores)
            .stringByAppendingString("\n")
            .stringByAppendingString(mpaa_rating)
            .stringByAppendingString("\n")
            .stringByAppendingString("\n")
            .stringByAppendingString(synopsisText))
        var synopsisAttrText = NSMutableAttributedString(string: synopsisBody)
        synopsisAttrText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(16), range: NSRange(location: 0,length: uiTitle.length))
        synopsisAttrText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(12), range: NSRange(location: uiTitle.length + 1,length: uiScores.length))
        synopsisAttrText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(10), range: NSRange(location: uiTitle.length + uiScores.length + 2,length: mpaa_rating.length))
        synopsisAttrText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSRange(location: uiTitle.length + uiScores.length + mpaa_rating.length + 4,length: synopsisText.length))
        synopsisAttrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: NSRange(location: 0,length: synopsisBody.length))
 
        movieSynopsisTextView.frame.size.width = view.frame.size.width
        movieSynopsisTextView.textContainerInset = UIEdgeInsetsMake(10.0, 15.0, 10.0, 15.0)
        movieSynopsisTextView.attributedText = synopsisAttrText
        
        let minimumHeight = view.frame.size.height - movieSynopsisTextView.frame.origin.y
        movieSynopsisTextView.sizeToFit()
        movieSynopsisTextView.frame.size.height = max(movieSynopsisTextView.frame.size.height, minimumHeight)
        movieSynopsisTextView.frame.size.width = max(movieSynopsisTextView.frame.size.width, view.frame.size.width)
        movieSynopsisTextView.layoutIfNeeded()
       
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
    
    func getMovieProperty(key: NSString) -> AnyObject {
        return movieDetail[key]!
    }
    
    func getMovieScore(key: NSString) -> NSInteger {
        let ratings = movieDetail["ratings"] as NSDictionary
        return ratings[key] as NSInteger
    }
}
