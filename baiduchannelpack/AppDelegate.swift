//
//  AppDelegate.swift
//  baiduchannelpack
//
//  Created by luokaiwen on 16/8/17.
//  Copyright © 2016年 luokaiwen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
//        let apkHandlePath = NSBundle.mainBundle().pathForResource("ApkHandle", ofType: "jar")
//        
//        let task = NSTask()
//        task.launchPath = "/usr/bin/java"
//        task.arguments = ["-jar", "/Users/luokaiwen/Desktop/ApkHandle.jar", "unzip", "/Users/luokaiwen/Desktop/test/ddd_driver.apk"];
//        let pipe = NSPipe()
//        task.standardOutput = pipe
//        task.standardError = pipe
//        task.launch()
//        let data = pipe.fileHandleForReading.readDataToEndOfFile()
//        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
//        
//        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
//        print(output)
//        print("task.launchPath" + task.launchPath!)
//        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
    
        
//        
//        // 存入选择的目录
//        NSUserDefaults.standardUserDefaults().setObject("hahaasdasda1212", forKey: "abc")
//        NSUserDefaults.standardUserDefaults().synchronize()
//        
//        // 获取以前选过的目录
//        if let text = NSUserDefaults.standardUserDefaults().objectForKey("abc") as? String {
//            print(text)
//        }
//        
//        print(NSBundle.mainBundle().resourcePath)
//        print(NSBundle.mainBundle().pathForResource("ApkChannel", ofType: "jar"))
//        
//        
//        
//        let date = NSDate()
//        let interval = date.timeIntervalSince1970
//        let intervalStr = String(format: "%.f", interval);
//        // var index = intervalStr.substringToIndex("7".endIndex)
//        
//        print(intervalStr.substringToIndex(intervalStr.startIndex.advancedBy(7)))
//
//        let a = "/Users/luokaiwen/Desktop/test.apk".stringByReplacingOccurrencesOfString("test.apk", withString: "")
//        
//        print("我勒个去" + a)
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}

