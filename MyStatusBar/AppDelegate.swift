//
//  AppDelegate.swift
//  MyStatusBar
//
//  Created by Thai Pangsakulyanont on 2014/10/13.
//  Copyright (c) 2014年 Thai Pangsakulyanont. All rights reserved.
//

import Cocoa

class Menu {

	var menu: NSMenu
	var target: AnyObject

	var separator: NSMenuItem
	var refresh: NSMenuItem
	var quit: NSMenuItem

	init(target: AnyObject) {
		self.target = target
		menu = NSMenu()
		separator = NSMenuItem.separatorItem()
		refresh = NSMenuItem(title: "Refresh", action: "refresh", keyEquivalent: "")
		refresh.target = target
		quit = NSMenuItem(title: "Quit", action: "quit", keyEquivalent: "")
		quit.target = target
		rebuild()
	}

	func rebuild() {
		menu.removeAllItems()
		menu.addItem(separator)
		menu.addItem(refresh)
		menu.addItem(quit)
	}

}

class AppDelegate: NSObject, NSApplicationDelegate {
	
	var statusItem: NSStatusItem!
	var menu: Menu!
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
		statusItem.highlightMode = true
		menu = Menu(target: self)
		statusItem.menu = menu.menu
		refresh()
	}
	
	func refresh() {
		statusItem.title = "🔄"
		let url = NSURL(string: "http://localhost:12799")!
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(url, completionHandler: { data, response, error in
			if error != nil {
				self.errored()
			} else {
			}
		})
		task.resume()
	}
	
	func quit() {
		exit(0)
	}
	
	func errored() {
		statusItem.title = "🆖"
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
	}
	
}

