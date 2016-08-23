//
//  ViewController.swift
//  baiduchannelpack
//
//  Created by luokaiwen on 16/8/17.
//  Copyright © 2016年 luokaiwen. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    // 加固后的apk路径
    @IBOutlet weak var tfApkPath: NSTextField!
    
    // 渠道输出目录
    @IBOutlet weak var tfOutputDir: NSTextField!
    
    @IBOutlet weak var tfSignPath: NSTextField!
    
    @IBOutlet weak var stfStorePass: NSSecureTextField!
    
    @IBOutlet weak var tfAlias: NSTextField!
    
    @IBOutlet weak var stfKeyPass: NSSecureTextField!
    
    @IBOutlet weak var channelTextField: NSTextFieldCell!
    
    @IBOutlet weak var tfChannelKey: NSTextField!
    
    @IBOutlet weak var btnChannel: NSButtonCell!
    
    @IBOutlet weak var btnSign: NSButtonCell!
    
    @IBAction func doChoiceChannel(sender: AnyObject) {
        
    }
    
    // 渠道列表
    var channelList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置签名密码和别名密码监听，没有处理签名文件输入框的监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(doGetAlias), name: NSControlTextDidChangeNotification, object: nil)
    }
    
    // 获取签名别名
    func doGetAlias() {
        
        if(stfStorePass.stringValue != "" && stfKeyPass.stringValue != "") {
            doGetKeySotreInfoCmd()
        }
    }
    
    // 查看签名信息
    func doGetKeySotreInfoCmd() {
        
        let task = NSTask()
        task.launchPath = "/usr/bin/keytool"
        task.arguments = ["-list","-v","-keystore",tfSignPath.stringValue,"-storepass",stfStorePass.stringValue]
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        let separated = output?.componentsSeparatedByString("\n")
        
        for separatedStr in separated!{
            print(separatedStr)
            if separatedStr.containsString("别名") {
                
                let aliasArray =  separatedStr.componentsSeparatedByString("别名:");
                let alias = aliasArray[1];
                tfAlias.stringValue = alias.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
        }
        
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
        print(output)
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
    }
    
    override var representedObject: AnyObject? {
        didSet {
            
        }
    }
    
    // 选择加固的apk存放的位置
    @IBAction func doChoiceApk(sender: AnyObject) {
        
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        
        if(myFileDialog.runModal() == NSModalResponseOK) {
            
            if let path = myFileDialog.URL?.path {
                print(path)
                tfApkPath.stringValue = path;
            }
        }
    }
    
    // 选择签名后文件存放的位置
    @IBAction func doOutputDir(sender: AnyObject) {
        
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        
        myFileDialog.canChooseDirectories = true
        myFileDialog.canChooseFiles = false
        
        if(myFileDialog.runModal() == NSModalResponseOK) {
            
            if let path = myFileDialog.directoryURL?.path {
                print(path)
                tfOutputDir.stringValue = path + "/";
            }
        }
    }
    
    // 选择签名文件
    @IBAction func doChoiceSign(sender: AnyObject) {
        
        let myFileDialog: NSOpenPanel = NSOpenPanel()
        
        if(myFileDialog.runModal() == NSModalResponseOK) {
            
            if let path = myFileDialog.URL?.path {
                print(path)
                tfSignPath.stringValue = path;
            }
        }
    }
    
    // 开始签名
    @IBAction func doSign(sender: AnyObject) {
        
        // 获取apk处理工具jar路径
        let apkHandlePath = NSBundle.mainBundle().pathForResource("ApkHandle", ofType: "jar")
        
        // 获取更改渠道jar路径
        let apkChannel = NSBundle.mainBundle().pathForResource("ApkChannel", ofType: "jar")
        
        print("apkHandlePath:" + apkHandlePath!)
        print("apkChannel:" + apkChannel!)
        
        for channel in self.channelList {
            
            print("开始签名渠道包:" + channel)
            
            // 1.解压apk
            
            print("加固apk路径：" + tfApkPath.stringValue)
            
            let unzipArgs = ["-jar", apkHandlePath!, "unzip", tfApkPath.stringValue];
            doCmdJar(unzipArgs);
            
            // 获取临时解压路径
            let tempPathList = tfApkPath.stringValue.componentsSeparatedByString("/"); // 获取apk路径
            let tempApkName = tempPathList[tempPathList.count - 1] // 获取apk名称
            let replaceApkPath = tfApkPath.stringValue.stringByReplacingOccurrencesOfString(tempApkName, withString: "")
            
            let date = NSDate()
            let interval = date.timeIntervalSince1970
            let intervalStr = String(format: "%.f", interval);
            let timeName = intervalStr.substringToIndex(intervalStr.startIndex.advancedBy(7));
            
            let tempPath = replaceApkPath + "temp" + timeName + "/"
            
            print("final temp path:" + tempPath)
            
            let manifestPath = tempPath + "AndroidManifest.xml";
            
            // 2.更换apk中的AndroidManifest文件中的渠道
            let channelArgs = ["-jar", apkChannel!, tfChannelKey.stringValue, channel, manifestPath, manifestPath];
            doCmdJar(channelArgs);
            
            // 3.压缩成apk
            let zipArgs = ["-jar", apkHandlePath!, "zip", tfApkPath.stringValue]
            doCmdJar(zipArgs)
            
            // 4.删除临时文件夹
            let deleteArgs = ["-jar", apkHandlePath!, "delete", tfApkPath.stringValue]
            doCmdJar(deleteArgs)
            
            // 5.签名程序
            let storeFile = tfSignPath.stringValue
            let origninApk = tfApkPath.stringValue
            let alias = tfAlias.stringValue
            let storePass = stfStorePass.stringValue
            let keyPass = stfKeyPass.stringValue
            
            let originApkSeparated = origninApk.componentsSeparatedByString("/")
            var originApkName = originApkSeparated[originApkSeparated.count - 1]
            originApkName = originApkName.stringByReplacingOccurrencesOfString(".apk", withString: "")
            originApkName = originApkName.stringByReplacingOccurrencesOfString(".zip", withString: "")
            
            let targetApkPath = tfOutputDir.stringValue + originApkName + "_signed_" + channel + ".apk"
            
            let signArgs = ["-jar", apkHandlePath!, "sign", storeFile, targetApkPath, origninApk, alias, storePass, keyPass]
            doCmdJar(signArgs)
        }
        
        let alertView = NSAlert()
        alertView.alertStyle = .CriticalAlertStyle
        alertView.messageText = "签名完成！！！"
        alertView.runModal()
    }
    
    // 执行jar命令
    func doCmdJar(arguments:[String]) {
        
        let task = NSTask()
        task.launchPath = "/usr/bin/java"
        task.arguments = arguments
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
        print(output)
        print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx:")
    }
    
    // 选择渠道后回调
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        
        guard let segueIdentifier = segue.identifier else {
            return
        }
        
        switch segueIdentifier {
            
        case "PresentChannelPickerViewController":
            if let window = segue.destinationController as? NSWindowController {
                if let controller = window.contentViewController as? ChannelPickViewController {
                    controller.handlePickerViewClosed = { [unowned self] (text) in
                        
                        print(text)
                        
                        self.channelList = text.componentsSeparatedByString("\n")
                        
                        var channelText = ""
                        
                        for channelTemp in self.channelList {
                            channelText += channelTemp + " "
                        }
                        
                        self.channelTextField.stringValue = channelText
                    }
                }
            }
            
        default: break
        }
    }
}

