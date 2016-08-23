//
//  ChannelPickViewController.swift
//  baiduchannelpack
//
//  Created by luokaiwen on 16/8/17.
//  Copyright © 2016年 luokaiwen. All rights reserved.
//

import Cocoa

class ChannelPickViewController: NSViewController {
    
    @IBOutlet var textView: NSTextView!

    var handlePickerViewClosed: ((text: String) -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeWindow(sender: AnyObject) {
        
        self.view.window?.close()
        handlePickerViewClosed?(text: textView.string ?? "")
    }
}
