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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        var imageViewFrame = posterImageView.frame
        imageViewFrame.origin.x = 0
        posterImageView.frame = imageViewFrame;
    }

}
