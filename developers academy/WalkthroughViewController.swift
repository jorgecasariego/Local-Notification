//
//  WalkthroughViewController.swift
//  TouchID
//
//  Created by Duc Tran on 11/29/15.
//  Copyright © 2015 Developers Academy. All rights reserved.
//

import UIKit

class WalkthroughViewController: UIViewController
{
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var index = 0               // the current page index
    var headerText = ""
    var imageName = ""
    var descriptionText = ""
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return .LightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text = headerText
        descriptionLabel.text = descriptionText
        imageView.image = UIImage(named: imageName)
        pageControl.currentPage = index
        
        // customize the next and start button
        startButton.hidden = (index == 3) ? false : true
        nextButton.hidden = (index == 3) ? true : false
        startButton.layer.cornerRadius = 5.0
        startButton.layer.masksToBounds = true
    }

    @IBAction func startClicked(sender: AnyObject)
    {
        // we're good with the walk through. 
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "DisplayedWalkthrough")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextClicked(sender: AnyObject)
    {
        let pageViewController = self.parentViewController as! PageViewController
        pageViewController.nextPageWithIndex(index)
    }
}

























