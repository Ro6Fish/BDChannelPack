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
        // Do view setup here.
        
    }

    @IBAction func closeWindow(sender: AnyObject) {
        
        self.view.window?.close()
        handlePickerViewClosed?(text: textView.string ?? "")

        NSUserDefaults.standardUserDefaults().setObject(textView.string ?? "", forKey: "xxxxxx")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let channle = NSUserDefaults.standardUserDefaults().objectForKey("xxxxxx")
        
        if let channleStr = channle as? String {
            print("aaa" + channleStr)
        }
    }
}
