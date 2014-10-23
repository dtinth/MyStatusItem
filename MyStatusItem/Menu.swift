//
//  Menu.swift
//  MyStatusItem
//
//  Created by Thai Pangsakulyanont on 2014-10-23.
//  Copyright (c) 2014年 Thai Pangsakulyanont. All rights reserved.
//

import Cocoa

class Menu: NSObject {
	
	var menu: NSMenu
	var target: MenuDelegate
	
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
	
	init(target: MenuDelegate) {
		self.target = target
		menu = NSMenu()
		menu.autoenablesItems = false
		separator = NSMenuItem.separatorItem()
		refresh = NSMenuItem(title: "Refresh", action: "refreshFromMenu", keyEquivalent: "r")
		refresh.target = target
		quit = NSMenuItem(title: "Quit", action: "quit", keyEquivalent: "q")
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
			if _isSeparator(item) {
				menu.addItem(NSMenuItem.separatorItem())
			} else {
				let title = _titleForItem(item)
				let menuItem = NSMenuItem(title: title, action: "itemSelected:", keyEquivalent: "")
				menuItem.target = self
				menuItem.enabled = _shouldEnable(item)
				if _isAlternate(item) {
					menuItem.alternate = true
					menuItem.keyEquivalentModifierMask = 524288 // NSAlternateKeyMask
				}
				menuItemToItem[menuItem] = item
				menu.addItem(menuItem)
			}
		}
	}
	
	func _shouldEnable(item: Item) -> Bool {
		if let url = item["url"] as? String {
			return true
		}
		if let script = item["script"] as? String {
			return true
		}
		return false
	}
	
	func _isAlternate(item: Item) -> Bool {
		if let alternate = item["alternate"] as? Bool {
			return alternate
		}
		return false
	}
	
	func itemSelected(sender: AnyObject) {
		if let item = menuItemToItem[sender as NSMenuItem] {
			if let script = item["script"] as? String {
				var error : NSDictionary?
				NSAppleScript(source: script)?.executeAndReturnError(&error)
				if error != nil {
					let alert = NSAlert()
					alert.messageText = "AppleScript Error"
					alert.informativeText = "\(error!)"
					alert.runModal()
				}
			}
			if let url = item["url"] as? String {
				target.handleUrl(url)
			}
		}
	}
	
	func _titleForItem(item: Item) -> String {
		if let title = item["title"] as? String {
			return title
		} else {
			return "Missing title: \(item)"
		}
	}
	
	func _isSeparator(item: Item) -> Bool {
		if let separator = item["separator"] as? Bool {
			return separator
		} else {
			return false
		}
	}
	
}
