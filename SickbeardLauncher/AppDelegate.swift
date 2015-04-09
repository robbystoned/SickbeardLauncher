//
//  AppDelegate.swift
//  SwiftStatusBarApplication
//	Author: Robert vd Steen
//	All rights reserved 2015


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet var window: NSWindow?
    @IBOutlet var popover : NSPopover?
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var StatusItem: NSMenuItem!
     var buf : NSString = NSString()
    let task = NSTask()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
    
    func applicationDidFinishLaunching(aNotification: NSNotification?)
    {
        let icon = NSImage(named: "statusIcon")
        icon?.setTemplate(true)
        statusItem.image = icon
        statusItem.menu = menu
        startSickbeard()
    }
    
    func startSickbeard(){

        task.launchPath = "/usr/bin/python"
        task.arguments = ["/Applications/sickbeard/sickbeard.py"]
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.standardError = pipe
        let readHandle = pipe.fileHandleForReading
        readHandle.waitForDataInBackgroundAndNotify()
        var notificationCenter: NSNotificationCenter = NSNotificationCenter.defaultCenter()

        notificationCenter.addObserver(self, selector: "receivedOut:", name: NSFileHandleDataAvailableNotification, object: readHandle)
        
        task.launch()

    }
    
    func receivedOut(notif : NSNotification) {
        // Unpack the FileHandle from the notification
        let fh:NSFileHandle = notif.object as! NSFileHandle
        // Get the data from the FileHandle
        let data = fh.availableData
        // Only deal with the data if it actually exists
        if data.length > 1 {
            // Since we just got the notification from fh, we must tell it to notify us again when it gets more data
            fh.waitForDataInBackgroundAndNotify()
            // Convert the data into a string
            let string = (buf as String) + (NSString(data: data, encoding: NSUTF8StringEncoding)! as String)
            var lines = string.componentsSeparatedByString("\n")
            buf = lines.removeLast()
            for line in lines {
                if(line.contains("Loading initial show list")){
                    println("sickbeard started")
                } else if(line.contains("Unable to start web server, is something else running on port: 8081")){
                    println("startup failed, port 8081 already in use")

                }
                
               
            }
        }
    }

    @IBAction func quitApplication(sender: NSMenuItem) {
        //stop the sickbeard process and quit this app
        task.terminate();
        while(task.running){
             //wait until the sickbead thread has stopped
            sleep(5)
        }
        println("sickbeard thread stopped, terminating application")
        //if so exit this app
        exit(0)
    }
    @IBAction func openSettingsWindow(sender: AnyObject) {
        //open settings window
    }
    
    @IBAction func restartSickbeard(sender: NSMenuItem) {
    }

    
}

