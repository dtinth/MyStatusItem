//
//  AppDelegate.swift
//  MyStatusBar
//
//  Created by Thai Pangsakulyanont on 2014/10/13.
//  Copyright (c) 2014年 Thai Pangsakulyanont. All rights reserved.
//

import Cocoa

typealias Item = [String: AnyObject]

class Menu: NSObject {

	var menu: NSMenu
	var target: AnyObject

	var separator: NSMenuItem
	var refresh: NSMenuItem
	var quit: NSMenuItem
	
	var items: [Item] = [] {
		didSet(newValue) {
			println("Rebuild!")
			rebuild()
		}
	}
	
	var menuItemToItem = [NSMenuItem: Item]()

	init(target: AnyObject) {
		self.target = target
		menu = NSMenu()
		separator = NSMenuItem.separatorItem()
		refresh = NSMenuItem(title: "Refresh", action: "refresh", keyEquivalent: "")
		refresh.target = target
		quit = NSMenuItem(title: "Quit", action: "quit", keyEquivalent: "")
		quit.target = target
		super.init()
		rebuild()
	}

	func rebuild() {
		menu.removeAllItems()
		buildFromItems()
		menu.addItem(separator)
		menu.addItem(refresh)
		menu.addItem(quit)
	}
	
	func buildFromItems() {
		menuItemToItem.removeAll(keepCapacity: false)
		for item in items {
			let title = _titleForItem(item)
			let menuItem = NSMenuItem(title: title, action: "itemSelected", keyEquivalent: "")
			menuItem.target = self
			menuItemToItem[menuItem] = item
			menu.addItem(menuItem)
		}
	}
	
	func _titleForItem(item: Item) -> String {
		if item["title"] != nil && item["title"]! is String {
			return item["title"]! as String
		} else {
			return "Missing title: \(item)"
		}
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
		menu.items = [
			["title": "Loading..."]
		]
		let url = NSURL(string: "http://localhost:12799")!
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithURL(url, completionHandler: { data, response, error in
			if error != nil {
				self.errored(error!.localizedDescription)
			} else {
			}
		})
		task.resume()
	}
	
	func quit() {
		exit(0)
	}
	
	func errored(reason: String) {
		statusItem.title = "🆖"
		menu.items = [
			["title": "Unable to load: \(reason)"]
		]
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
	}
	
}

