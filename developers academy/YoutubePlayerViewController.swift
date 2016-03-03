//
//  YoutubePlayerViewController.swift
//  HamburgerMenu
//
//  Created by Duc Tran on 12/26/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit

class YoutubePlayerViewController: UIViewController
{
    var videoURL: NSURL!
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Watch for details"

        // Do any additional setup after loading the view.
        if let videoURL = videoURL {
            youtubePlayerView.loadVideoURL(videoURL)
        } else {
            let alertController = UIAlertController(title: "Ooops!", message: "The video can't be accessed", preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
