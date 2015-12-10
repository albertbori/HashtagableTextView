//
//  HashtagableTextView.swift
//  AutocompleteTests
//
//  Created by Albert Bori on 12/7/15.
//  Copyright © 2015 albertbori. All rights reserved.
//

import UIKit

public class HashtagableTextView: UITextView, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public var highlightColor: UIColor?
    public var tableRowHeight: CGFloat = 36
    public var tableRowTextColor: UIColor?
    public var tableBackgroundColor: UIColor = UIColor(white: 0.8, alpha: 1)
    public var didStartTypingHashtag: ((partialHashtag: String) -> ())?
    public var suggestedHashtagHeaderText: String?
    private var _tableView: UITableView?
    private var _hashtagSuggestions: [String] = []
    private var _partialHashtagRange: Range<String.Index>?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.delegate = self
    }
    
    
    //MARK - UITextViewDelegate
    
    public func textViewDidChange(textView: UITextView) {
        highlightHashtags()
        
        //check if user is typing a hashtag, if so, search for it
        let cursorOffset = self.offsetFromPosition(self.beginningOfDocument, toPosition: self.selectedTextRange!.start)
        let typedString = self.text.substringWithRange(self.text.startIndex.advancedBy(0)..<self.text.startIndex.advancedBy(cursorOffset))
        if let unfinishedHashtagRange = typedString.rangeOfString("#[a-z0-1_]+$", options: [.RegularExpressionSearch, .CaseInsensitiveSearch]) {
            _partialHashtagRange = unfinishedHashtagRange
            didStartTypingHashtag?(partialHashtag: typedString.substringWithRange(unfinishedHashtagRange))
        } else {
            clearSuggestedHashtags()
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        clearSuggestedHashtags()
    }
    
    
    //MARK - UITableViewDataSource
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return suggestedHashtagHeaderText
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _hashtagSuggestions.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = UITableViewCell()
        tableViewCell.textLabel?.text = _hashtagSuggestions[indexPath.row]
        tableViewCell.textLabel?.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
        if let textColor = tableRowTextColor {
            tableViewCell.textLabel?.textColor = textColor
        }
        return tableViewCell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard _hashtagSuggestions.count >= indexPath.row else {
            clearSuggestedHashtags()
            return
        }

        //grab cursor position for replacement after change
        let cursorOffset = self.offsetFromPosition(self.beginningOfDocument, toPosition: self.selectedTextRange!.start)
        let currentLength = self.text.characters.count
        
        var selectedHashtag = _hashtagSuggestions[indexPath.row]
        if !selectedHashtag.hasPrefix("#") {
            selectedHashtag = "#" + selectedHashtag
        }
        
        self.text.replaceRange(_partialHashtagRange!, with: selectedHashtag + " ")
        
        //restore cursor position
        if cursorOffset != currentLength {
            let lengthDelta = self.text.characters.count - currentLength
            let newCursorOffset = max(0, min(self.text.characters.count, cursorOffset + lengthDelta))
            let newPosition = self.positionFromPosition(self.beginningOfDocument, offset: newCursorOffset)!
            let newRange = self.textRangeFromPosition(newPosition, toPosition: newPosition)
            self.selectedTextRange = newRange
        }
        
        highlightHashtags()
        clearSuggestedHashtags()
    }
    
    
    //MARK - Helper methods
    
    public func highlightHashtags() {
        
        //highlight hashtags
        let regex = try! NSRegularExpression(pattern: "#[a-z0-1_]+", options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex.matchesInString(self.text, options: [], range: NSMakeRange(0, self.text.characters.count))
        
        let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, self.text.characters.count))
        for match in matches {
            let matchRange = match.rangeAtIndex(0)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: highlightColor ?? UIColor.redColor(), range: matchRange)
        }
        
        //grab cursor position for replacement after change
        let cursorOffset = self.offsetFromPosition(self.beginningOfDocument, toPosition: self.selectedTextRange!.start)
        let currentLength = self.text.characters.count
        
        self.attributedText = attributedString
        
        //restore cursor position
        if cursorOffset != currentLength {
            let lengthDelta = self.text.characters.count - currentLength
            let newCursorOffset = max(0, min(self.text.characters.count, cursorOffset + lengthDelta))
            let newPosition = self.positionFromPosition(self.beginningOfDocument, offset: newCursorOffset)!
            let newRange = self.textRangeFromPosition(newPosition, toPosition: newPosition)
            self.selectedTextRange = newRange
        }
    }
    
    public func showSuggestedHashtags(hashtagSuggestions: [String]) {
        _hashtagSuggestions = hashtagSuggestions
        if _tableView == nil {
            //scroll to correct position
            let cursorFrame = self.caretRectForPosition(self.selectedTextRange!.start)
            self.contentOffset = CGPoint(x: 0, y: cursorFrame.origin.y)
            
            //set up table
            let parentView = window ?? self
            let tableYPosition = self.frame.origin.y + cursorFrame.height
            //let tableHeight = parentView.frame.height - tableYPosition
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = UIView(frame: CGRectZero)
            tableView.backgroundColor = tableBackgroundColor
            tableView.rowHeight = tableRowHeight
            tableView.dataSource = self
            tableView.delegate = self
            parentView.addSubview(tableView)
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(tableYPosition)-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
            _tableView = tableView
        } else {
            _tableView?.reloadData()
        }
        
        if _hashtagSuggestions.count == 0 {
            let label = UILabel()
            label.textColor = UIColor.lightGrayColor()
            label.text = "No suggestions found."
            _tableView?.tableHeaderView = label
        } else {
            _tableView?.tableHeaderView = nil
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if _tableView != nil {
            let cursorFrame = self.caretRectForPosition(self.selectedTextRange!.start)
            self.contentOffset = CGPoint(x: 0, y: cursorFrame.origin.y)
        }
    }
    
    private func clearSuggestedHashtags() {
        if _tableView != nil {
            _tableView?.removeFromSuperview()
            _tableView = nil
            _partialHashtagRange = nil
            _hashtagSuggestions = []
            self.contentOffset = CGPointZero
        }
    }
}