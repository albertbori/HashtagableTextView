//
//  HashtagableTextInputDelegate.swift
//  HashtagableTextInput
//
//  Created by Albert Bori on 3/7/16.
//  Copyright © 2016 albertbori. All rights reserved.
//

import UIKit

public class HashtagableTextInputDelegate: NSObject, UITextViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    public var highlightColor: UIColor?
    public var tableRowHeight: CGFloat = 36
    public var tableRowTextColor: UIColor?
    public var tableBackgroundColor: UIColor = UIColor(white: 0.8, alpha: 1)
    public var didStartTypingHashtag: ((partialHashtag: String) -> ())?
    public var suggestedHashtagHeaderText: String?
    public var minHashtagSearchLength = 2
    
    private weak var _textInput: UITextInput?
    private var _hashtagSuggestions: [String] = []
    private var _partialHashtagRange: Range<String.Index>?
    private var _isTypingHashtag: Bool = false
    private var _tableView: UITableView?
    private var _tableViewBorder: UIView?
    private var _tableTopConstraint: NSLayoutConstraint? {
        get {
            return _tableView?.constraintsAffectingLayoutForAxis(.Vertical).filter({$0.firstAttribute == .Top && $0.secondAttribute == .Top }).first
        }
    }
    private var _tableBottomConstraint: NSLayoutConstraint? {
        get {
            return _tableView?.constraintsAffectingLayoutForAxis(.Vertical).filter({$0.firstAttribute == .Bottom && $0.secondAttribute == .Bottom }).first
        }
    }
    private var _keyboardHeight: CGFloat = 0
    private var _isFirstResponder: Bool {
        return (_textInput as? UIView)?.isFirstResponder() == true
    }
    
    init(textInput: UITextInput) {
        super.init()
        _textInput = textInput
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: - UITextViewDelegate
    
    public func textViewDidChange(textView: UITextView) {
        
        highlightHashtags()
        
        guard let textInput = _textInput, let text = (textInput as? UITextView)?.text ?? (textInput as? UITextField)?.text where _isFirstResponder else {
            return
        }
        
        //check if user is typing a hashtag, if so, search for it
        let cursorOffset = textInput.offsetFromPosition(textInput.beginningOfDocument, toPosition: textInput.selectedTextRange!.start)
        let typedString = text.substringWithRange(text.startIndex.advancedBy(0)..<text.startIndex.advancedBy(cursorOffset))
        if let unfinishedHashtagRange = typedString.rangeOfString("(?<=\\B)#\\w{\(minHashtagSearchLength),}\\z", options: [.RegularExpressionSearch, .CaseInsensitiveSearch]) {
            _isTypingHashtag = true
            _partialHashtagRange = unfinishedHashtagRange
            didStartTypingHashtag?(partialHashtag: typedString.substringWithRange(unfinishedHashtagRange))
        } else {
            _isTypingHashtag = false
            clearSuggestedHashtags()
        }
    }
    
    public func textViewDidEndEditing(textView: UITextView) {
        clearSuggestedHashtags()
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let textInput = _textInput, let text = (textInput as? UITextView)?.text ?? (textInput as? UITextField)?.text where _isFirstResponder else {
            return true
        }
        
        //check if user is typing a hashtag, if so, search for it
        let cursorOffset = textInput.offsetFromPosition(textInput.beginningOfDocument, toPosition: textInput.selectedTextRange!.start)
        let typedString = text.substringWithRange(text.startIndex.advancedBy(0)..<text.startIndex.advancedBy(cursorOffset))  + string
        if let unfinishedHashtagRange = typedString.rangeOfString("(?<=\\B)#\\w{\(minHashtagSearchLength),}\\z", options: [.RegularExpressionSearch, .CaseInsensitiveSearch]) {
            _isTypingHashtag = true
            _partialHashtagRange = unfinishedHashtagRange
            didStartTypingHashtag?(partialHashtag: typedString.substringWithRange(unfinishedHashtagRange))
        } else {
            _isTypingHashtag = false
            clearSuggestedHashtags()
        }
        
        return true
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        clearSuggestedHashtags()
    }
    
    
    //MARK: - UITableViewDataSource
    
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
    
    
    //MARK: - UITableViewDelegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let textInput = _textInput, let text = (textInput as? UITextView)?.text ?? (textInput as? UITextField)?.text where _hashtagSuggestions.count >= indexPath.row else {
            clearSuggestedHashtags()
            return
        }
        
        //grab cursor position for replacement after change
        let cursorOffset = textInput.offsetFromPosition(textInput.beginningOfDocument, toPosition: textInput.selectedTextRange!.start)
        let currentLength = text.characters.count
        
        var selectedHashtag = _hashtagSuggestions[indexPath.row]
        if !selectedHashtag.hasPrefix("#") {
            selectedHashtag = "#" + selectedHashtag
        }
        
        if let textView = textInput as? UITextView {
            textView.text.replaceRange(_partialHashtagRange!, with: selectedHashtag + " ")
        } else if let textField = textInput as? UITextField {
            textField.text?.replaceRange(_partialHashtagRange!, with: selectedHashtag + " ")
        }
        
        //restore cursor position
        if cursorOffset != currentLength {
            let lengthDelta = text.characters.count - currentLength
            let newCursorOffset = max(0, min(text.characters.count, cursorOffset + lengthDelta))
            let newPosition = textInput.positionFromPosition(textInput.beginningOfDocument, offset: newCursorOffset)!
            let newRange = textInput.textRangeFromPosition(newPosition, toPosition: newPosition)
            textInput.selectedTextRange = newRange
        }
        
        highlightHashtags()
        clearSuggestedHashtags()
    }
    
    
    //MARK: - Helper methods
    
    public func highlightHashtags() {
        guard let textView = _textInput as? UITextView else {
            return
        }
        
        //highlight hashtags
        let regex = try! NSRegularExpression(pattern: "(?<=\\B)#[a-zA-Z0-9]\\w*[a-zA-Z0-9]\\b", options: NSRegularExpressionOptions.CaseInsensitive)
        let matches = regex.matchesInString(textView.text, options: [], range: NSMakeRange(0, textView.text.characters.count))
        
        let attributedString = NSMutableAttributedString(attributedString: textView.attributedText)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, textView.text.characters.count))
        for match in matches {
            let matchRange = match.rangeAtIndex(0)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: highlightColor ?? UIColor.redColor(), range: matchRange)
        }
        
        //grab cursor position for replacement after change
        let cursorOffset = textView.offsetFromPosition(textView.beginningOfDocument, toPosition: textView.selectedTextRange!.start)
        let currentLength = textView.text.characters.count
        
        textView.attributedText = attributedString
        
        //restore cursor position
        if cursorOffset != currentLength {
            let lengthDelta = textView.text.characters.count - currentLength
            let newCursorOffset = max(0, min(textView.text.characters.count, cursorOffset + lengthDelta))
            let newPosition = textView.positionFromPosition(textView.beginningOfDocument, offset: newCursorOffset)!
            let newRange = textView.textRangeFromPosition(newPosition, toPosition: newPosition)
            textView.selectedTextRange = newRange
        }
    }
    
    public func showSuggestedHashtags(hashtagSuggestions: [String]) {
        guard let textInput = _textInput as? UIView where _isTypingHashtag else { return }
        
        _hashtagSuggestions = hashtagSuggestions
        if _tableView == nil {
            //set up table
            let parentView = textInput.window ?? textInput
            let tableView = UITableView()
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.tableFooterView = UIView(frame: CGRectZero)
            tableView.backgroundColor = tableBackgroundColor
            tableView.rowHeight = tableRowHeight
            tableView.dataSource = self
            tableView.delegate = self
            parentView.addSubview(tableView)
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[tableView]-\(_keyboardHeight)-|", options: [], metrics: nil, views: ["tableView": tableView]))
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableView]-0-|", options: [], metrics: nil, views: ["tableView": tableView]))
            _tableView = tableView
            
            //add table view border
            let tableViewBorder = UIView()
            tableViewBorder.translatesAutoresizingMaskIntoConstraints = false
            tableViewBorder.backgroundColor = UIColor(white: 0.7, alpha: 1)
            parentView.addSubview(tableViewBorder)
            _tableViewBorder = tableViewBorder
            
            //position table
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[tableViewBorder(==1)]-0-[tableView]", options: [], metrics: nil, views: ["tableView": tableView, "tableViewBorder": tableViewBorder]))
            parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tableViewBorder]-0-|", options: [], metrics: nil, views: ["tableViewBorder": tableViewBorder]))
            updateTableViewPosition()
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
    
    public func updateTableViewPosition() {
        guard let textInputAsView = _textInput as? UIView else { return }
        
        let parentView = textInputAsView.window ?? textInputAsView
        
        var textViewCursorOffset: CGFloat = 0
        if let textView = _textInput as? UITextView {
            let lineSpacing: CGFloat = 2
            //scroll to correct position
            let cursorFrame = textView.caretRectForPosition(textView.selectedTextRange!.start)
            self.scrollAllToPoint(CGPoint(x: 0, y: cursorFrame.origin.y - lineSpacing))
            textViewCursorOffset = textView.textContainerInset.top + cursorFrame.height + (lineSpacing * 2)
        } else {
            self.scrollAllToPoint(CGPoint(x: 0, y: textInputAsView.frame.origin.y))
            textViewCursorOffset = textInputAsView.frame.height
        }
        
        //position tableview top constraint
        var topBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        if let currentViewController = getCurrentNavigationController(textInputAsView.window) {
            topBarHeight += currentViewController.navigationBar.frame.height
        }
        var originInWindow = parentView.convertPoint(textInputAsView.frame.origin, fromView: textInputAsView.superview ?? UIView())
        if originInWindow.y < topBarHeight { //If the origin is negative (inside a scroll view, scrolled down) just use the top of the viewport
            originInWindow = parentView.convertPoint(textInputAsView.frame.origin, fromView: textInputAsView)
        }
        
        let tableYPosition = originInWindow.y + textViewCursorOffset + (_tableViewBorder?.frame.height ?? 0)
        //print("Repositioning suggestion table to Y: \(tableYPosition)")
        _tableTopConstraint?.constant = tableYPosition
    }
    
    private func getCurrentNavigationController(window: UIWindow?) -> UINavigationController? {
        //try to locate the instance (if any) of the current navigation controller
        let currentNavController = window?.rootViewController as? UINavigationController ??
            window?.rootViewController?.navigationController ??
            (window?.rootViewController as? UITabBarController)?.selectedViewController as? UINavigationController ??
            (window?.rootViewController as? UITabBarController)?.selectedViewController?.navigationController
        
        return currentNavController
    }
    
    private var _scrollPositionCache = [CGPoint]()
    private func scrollAllToPoint(point: CGPoint) {
        guard let textInputAsView = _textInput as? UIView else { return }
        
        if let textView = _textInput as? UITextView {
            _scrollPositionCache.append(textView.contentOffset)
            textView.contentOffset = point
            //print("Scrolling text view to \(point)")
        }
        
        var parentView = textInputAsView.superview
        while parentView != nil {
            if let scrollView = parentView as? UIScrollView where scrollView.scrollEnabled && "\(scrollView.dynamicType)" != "UITableViewWrapperView" {
                let destinationOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.convertRect(textInputAsView.frame, fromView: textInputAsView.superview).origin.y)
                //print("Scrolling \(scrollView.dynamicType) from \(scrollView.contentOffset) to \(destinationOffset)")
                _scrollPositionCache.append(scrollView.contentOffset)
                scrollView.contentOffset = destinationOffset
            }
            parentView = parentView!.superview
        }
    }
    
    private func restoreScrollPosition() {
        if let textView = _textInput as? UITextView {
            textView.contentOffset = _scrollPositionCache.removeFirst() ?? textView.contentOffset
        }
        guard let textInputAsView = _textInput as? UIView else { return }
        
        var parentView = textInputAsView.superview
        while parentView != nil {
            if let scrollView = parentView as? UIScrollView where scrollView.scrollEnabled && "\(scrollView.dynamicType)" != "UITableViewWrapperView" {
                scrollView.contentOffset = _scrollPositionCache.removeFirst() ?? scrollView.contentOffset
            }
            parentView = parentView!.superview
        }
    }
    
    private func clearSuggestedHashtags() {
        if _tableView != nil {
            _tableViewBorder?.removeFromSuperview()
            _tableViewBorder = nil
            _tableView?.removeFromSuperview()
            _tableView = nil
            _partialHashtagRange = nil
            _hashtagSuggestions = []
            restoreScrollPosition()
        }
    }
    
    
    //MARK: - Keyboard Events
    
    func keyboardWillShow(notification: NSNotification) {
        let keyboardSize = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]?.CGRectValue.size
        _keyboardHeight = keyboardSize!.height
        _tableBottomConstraint?.constant = _keyboardHeight
    }
    
    func keyboardWillHide(notification: NSNotification) {
        _keyboardHeight = 0
        _tableBottomConstraint?.constant = 0
        clearSuggestedHashtags()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
