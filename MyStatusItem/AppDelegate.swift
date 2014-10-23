//
//  AppDelegate.swift
//  MyStatusItem
//
//  Created by Thai Pangsakulyanont on 2014/10/13.
//  Copyright (c) 2014年 Thai Pangsakulyanont. All rights reserved.
//

import Cocoa

typealias Item = [String: AnyObject]

class AppDelegate: NSObject, NSApplicationDelegate, MenuDelegate {
	
	var statusItem: NSStatusItem!
	var menu: Menu!
	var timer: NSTimer?
	var userDefaults = NSUserDefaults.standardUserDefaults()
	
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		_registerDefaults()
		statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
		statusItem.highlightMode = true
		menu = Menu(target: self)
		statusItem.menu = menu.menu
		refresh()
	}
	
	func _registerDefaults() {
		userDefaults.registerDefaults([
			"menuURL":          "http://127.0.0.1:12799/menu.json",
			"refreshInterval":  30.0,
		])
	}
	
	func handleUrl(url: String) {
		statusItem.title = "✳️"
		if let url = NSURL(string: url) {
			let session = NSURLSession.sharedSession()
			let request = NSMutableURLRequest(URL: url)
			request.HTTPMethod = "POST"
			let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error in
				if error != nil {
					self._handleUrlErrored(error!.localizedDescription)
				} else {
					let httpResponse = response as NSHTTPURLResponse
					if httpResponse.statusCode < 200 || httpResponse.statusCode >= 300 {
						self._handleUrlErrored("HTTP \(httpResponse.statusCode)\n\(url)")
					} else {
						self.refresh()
					}
				}
			})
			task.resume()
		} else {
			self._handleUrlErrored("Unable to create URL object... It's malformed?")
		}
	}
	
	func _handleUrlErrored(reason: String) {
		let alert = NSAlert()
		alert.messageText = "URL Action Error"
		alert.informativeText = "\(reason)"
		alert.runModal()
		self.refresh()
	}
	
	func refresh(subtly: Bool = false) {
		_beginOperation()
		if !subtly {
			statusItem.title = "🔄"
			menu.items = [
				["title": "Loading..."]
			]
		}
		if let urlString = userDefaults.stringForKey("menuURL") {
			if let url = NSURL(string: urlString) {
				let session = NSURLSession.sharedSession()
				let task = session.dataTaskWithURL(url, completionHandler: { data, response, error in
					if error != nil {
						self._errored(error!.localizedDescription)
					} else {
						let httpResponse = response as NSHTTPURLResponse
						if httpResponse.statusCode != 200 {
							self._errored("HTTP \(httpResponse.statusCode)")
						} else {
							self._parseAndBuildMenu(data!)
						}
					}
				})
				task.resume()
			} else {
				self._errored("Unable to construct URL for \(urlString)")
			}
		} else {
			self._errored("Unable to get the menuURL")
		}
	}
	
	func refreshFromMenu() {
		refresh()
	}
	
	func quit() {
		exit(0)
	}
	
	func _parseAndBuildMenu(data: NSData) {
		var jsonError: NSError?
		let object: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &jsonError)
		if jsonError != nil {
			self._errored("Unable to parse JSON: \(jsonError!.localizedDescription)")
		} else {
			if let dictionary = object as? NSDictionary {
				_processDictionaryAndBuildMenu(dictionary)
			} else {
				self._errored("Unable to parse JSON: It is not an dictionary")
			}
		}
		_doneOperation()
	}
	
	func _processDictionaryAndBuildMenu(dictionary: NSDictionary) {
		if let title = dictionary["title"] as? String {
			statusItem.title = title
		}
		if let items = dictionary["items"] as? [Item] {
			menu.items = items
		} else {
			self._errored("Unable to parse JSON: There are no items")
		}
	}
	
	func _errored(reason: String) {
		statusItem.title = "🆖"
		menu.items = [
			["title": "Unable to load: \(reason)"]
		]
		_doneOperation()
	}
	
	func applicationWillTerminate(aNotification: NSNotification) {
	}
	
	func _doneOperation() {
		var refreshPeriod = userDefaults.floatForKey("refreshPeriod")
		if refreshPeriod < 0 {
			return
		}
		if refreshPeriod == 0 {
			refreshPeriod = 30
		}
		timer = NSTimer(timeInterval: Double(refreshPeriod), target: self, selector: Selector("autorefresh:"), userInfo: nil, repeats: false)
		NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
		println("Make nstimer")
	}
	
	func _beginOperation() {
		if timer != nil {
			println("Invalidate")
		}
		timer?.invalidate()
	}
	
	func autorefresh(x: NSTimer!) {
		println("Autorefresh")
		refresh(subtly: true)
	}
	
}

