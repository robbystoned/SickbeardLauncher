//
//  AppDelegate.swift
//  SwiftStatusBarApplication
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
    @IBOutlet var window: NSWindow?
    @IBOutlet var popover : NSPopover?
    @IBOutlet weak var menu: NSMenu!
    @IBOutlet weak var StatusItem: NSMenuItem!
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
        task.launch()
        
    }

    @IBAction func quitApplication(sender: NSMenuItem) {
        //stop the sickbeard process and quit this app
        task.terminate();
        //exit(0)
    }
    @IBAction func openSettingsWindow(sender: AnyObject) {
        //open settings window
    }
    
    @IBAction func restartSickbeard(sender: NSMenuItem) {
    }

    
}

