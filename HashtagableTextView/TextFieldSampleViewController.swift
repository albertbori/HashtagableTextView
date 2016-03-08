//
//  TextFieldSampleViewController.swift
//  HashtagableTextView
//
//  Created by Albert Bori on 3/3/16.
//  Copyright © 2016 albertbori. All rights reserved.
//

import UIKit

class TextFieldSampleViewController: UIViewController {
    
    @IBOutlet weak var hashtagableTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hashtagableDelegate = HashtagableTextViewDelegate(textBox: hashtagableTextField)
        hashtagableDelegate.didStartTypingHashtag = { partialHashtag in
            let searchableString = partialHashtag.stringByReplacingOccurrencesOfString("#", withString: "")
            hashtagableDelegate.showSuggestedHashtags(hashtagDatabase.filter({ $0.lowercaseString.containsString(searchableString.lowercaseString) }))
        }
        hashtagableTextField.delegate = hashtagableDelegate
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { [weak self] context in
                (self?.hashtagableTextField.delegate as? HashtagableTextViewDelegate)?.updateTableViewPosition()
            }, completion: { context in })
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
}
