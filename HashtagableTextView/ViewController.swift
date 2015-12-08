//
//  ViewController.swift
//  HashtagableTextView
//
//  Created by Albert Bori on 12/8/15.
//  Copyright © 2015 albertbori. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var hashtagableTextView: HashtagableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hashtagableTextView.didStartTypingHashtag = { [weak self] partialHashtag in
            self?.hashtagableTextView.showSuggestedHashtags(["#Cool", "#Neat", "#Awesome"])
        }
        hashtagableTextView.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris #nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        hashtagableTextView.highlightHashtags()
    }
}

