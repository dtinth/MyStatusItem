//
//  MenuDelegate.swift
//  MyStatusItem
//
//  Created by Thai Pangsakulyanont on 2014-10-23.
//  Copyright (c) 2014年 Thai Pangsakulyanont. All rights reserved.
//

@objc protocol MenuDelegate {
	func handleUrl(url: String) -> Void
}
