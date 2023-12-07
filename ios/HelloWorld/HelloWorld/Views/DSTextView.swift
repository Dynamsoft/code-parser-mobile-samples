/*
 * This is the sample of Dynamsoft Code Parser.
 *
 * Copyright © Dynamsoft Corporation.  All rights reserved.
 */

import UIKit

typealias TextViewDidEndEditingCompletion = (_ string: String) -> Void

typealias TextViewAccessoryListStateChangedCompletion = (_ isHidden: Bool) -> Void

class DSTextView: UITextView, UITextViewDelegate {

    private var placeHolder: String!
    
    private var textFont: UIFont!
    
    var didEndEditingCompletion: TextViewDidEndEditingCompletion?
    
    var accessoryListStateChangedCompletion: TextViewAccessoryListStateChangedCompletion?
    
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 8.0, y: 8.0, width: self.width - 8.0 * 2, height: textFont.pointSize)
        label.textAlignment = .left
        label.text = placeHolder
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = textFont
        return label
    }()
    
    private lazy var inputCountTFAccessoryView: UIView = {
        let accessoryView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 40))
        accessoryView.backgroundColor = UIColor.init(red: 216.0 / 255.0, green: 216.0 / 255.0, blue: 216.0 / 255.0, alpha: 1.0)
        let btn = UIButton.init(frame: CGRect(x: kScreenWidth - 55, y: 5, width: 40, height: 28))
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.titleLabel?.font = kFont_Regular(16)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(doneButtonClicked(_:)), for: .touchUpInside)
        accessoryView.addSubview(btn)
        return accessoryView
    }()
    
    deinit {
        print("text view dealloc")
    }
    
    init(frame: CGRect, placeHolder: String = "", textFont: UIFont = kFont_Regular(12.0)) {
        super.init(frame: frame, textContainer: nil)
        self.placeHolder = placeHolder
        self.textFont = textFont
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupUI() -> Void {
        self.addSubview(placeHolderLabel)
        self.inputAccessoryView = inputCountTFAccessoryView
        super.delegate = self
    }
    
    func updateWith(text: String) -> Void {
        self.text = text
        placeHolderLabel.isHidden = self.text.count == 0 ? false : true
    }
    
    @objc private func doneButtonClicked(_ button: UIButton) -> Void {
        self.resignFirstResponder()
        didEndEditingCompletion?(self.text)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        accessoryListStateChangedCompletion?(false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let isHidden = textView.text.count == 0 ? false : true
        placeHolderLabel.isHidden = isHidden
        accessoryListStateChangedCompletion?(isHidden)
    }
    
}
