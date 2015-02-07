//
//  MovieCellView.swift
//  RottenTomatoes
//
//  Created by Hao Sun on 2/4/15.
//  Copyright (c) 2015 Hao Sun. All rights reserved.
//

import UIKit

class MovieCellView: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    var movie: NSDictionary = NSDictionary() {
        didSet {
            posterImageView.setImageWithURL(getMoviePosterURL("profile"), placeholderImage: UIImage(named: "flixster"))
            titleLabel.text = getMovieProperty("title")! as NSString
            synopsisLabel.text = getMovieProperty("synopsis")! as NSString
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.grayColor()
        selectedBackgroundView = bgColorView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        
        var imageViewFrame = posterImageView.frame
        imageViewFrame.origin.x = 0
        imageViewFrame = CGRectMake(5.0, 5.0, imageViewFrame.width - 10, imageViewFrame.height - 10)
        posterImageView.frame = imageViewFrame;
        
        let labelOffset = imageViewFrame.width + 15
        titleLabel.frame = CGRectMake(labelOffset, 10, frame.size.width - labelOffset - 10, titleLabel.frame.height)
        
        synopsisLabel.numberOfLines = 4
        synopsisLabel.frame.origin.x = labelOffset
        let synopsisHeight = posterImageView.frame.height - 25
        synopsisLabel.frame = CGRectMake(labelOffset, 30, frame.size.width - labelOffset - 10, synopsisHeight)
    }
    
    func getMovieProperty(key: NSString) -> AnyObject? {
        return movie[key]
    }
    
    func getMoviePosterURL(type: NSString) -> NSURL! {
        let posters = movie["posters"] as NSDictionary
        let movieUrl = (posters[type] as String).stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        
        return NSURL(string: movieUrl)!
    }
}
