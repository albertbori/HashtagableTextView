//
//  ViewController.swift
//  HashtagableTextView
//
//  Created by Albert Bori on 12/8/15.
//  Copyright © 2015 albertbori. All rights reserved.
//

import UIKit

class TextViewSampleViewController: UIViewController {

    @IBOutlet weak var hashtagableTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hashtagableDelegate = HashtagableTextInputDelegate(textInput: hashtagableTextView)
        hashtagableDelegate.didStartTypingHashtag = { partialHashtag in
            let searchableString = partialHashtag.stringByReplacingOccurrencesOfString("#", withString: "")
            hashtagableDelegate.showSuggestedHashtags(hashtagDatabase.filter({ $0.lowercaseString.containsString(searchableString.lowercaseString) }))
        }
        hashtagableTextView.delegate = hashtagableDelegate
        
//        hashtagableDelegate.suggestedHashtagHeaderText = "Suggested Hashtags"
//        hashtagableTextView.text = "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nLorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris #nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
//        hashtagableDelegate.highlightHashtags()
        
        hashtagableTextView.becomeFirstResponder()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { [weak self] context in
                (self?.hashtagableTextView.delegate as? HashtagableTextInputDelegate)?.updateTableViewPosition()
            }, completion: { context in })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}

