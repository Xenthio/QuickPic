//
//  AppDelegate.swift
//  QuickPic
//
//  Created by Ethan Cardwell on 21/8/20.
//  Copyright © 2020 Xenthio. All rights reserved.
//

import Cocoa

//var fileName = String()
let window = mainWindow()


// This is so we can use python like for i in Int loops in swift, example:
// for i in 5 {
// 	print("this is being repeated 5 times")
// }
extension Int: Sequence {
	public func makeIterator() -> CountableRange<Int>.Iterator {
		return (0..<self).makeIterator()
	}
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	
	

	// Define some variables we use
	var inputMode = false
	var keypresses = [String]()
	
	
	// Define where the images should be Located
	let appSupportPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("QuickPic")
	
	// create an uninitialized variable for the status bar item
	var statusBarItem: NSStatusItem!

	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		NSApp.activate(ignoringOtherApps: true)
		
		// Lazy way of making it so if we click on something that isn't a button it closes the popover
		NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) {(event) in
			window.close()
		}
		
		// Totally not spyware.
		// this tracks keyboard inputs so we can type things like ;image; and it replaces it with a picture
		NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) {(event) in
			window.behavior = .transient
			
			// Mega else if
			if !self.inputMode && event.characters == ";" {
				// Empty the array of key presses
				self.keypresses = [String]()
				self.inputMode = true
			} else if self.inputMode && (event.characters == ";" || event.characters == " ") {
				self.inputMode = false
				
				// Gets the amount of backspaces we need to send to remove the previous text the user typed.
				let deleteAmount = self.keypresses.count + 2
				
				// append .png to the array of characters
				self.keypresses.append(".png")
				
				// merge all the characters to create something like wierD.png
				let joined = self.keypresses.joined()
				
				// create a variable to access the global clipboard
				let pasteBoard = NSPasteboard.general
				
				// Send abunch of backspaces
				for _ in deleteAmount {
					//print("deleting")
					let delevent = CGEvent(keyboardEventSource: nil, virtualKey: 0x33, keyDown: true); // delete key down
					delevent?.post(tap: CGEventTapLocation.cghidEventTap);
				}
				
				// do all that magic image stuff
				do {
					//print("pasting \(joined)...")
					pasteBoard.clearContents()
					pasteBoard.setData(try Data(contentsOf: self.appSupportPath.appendingPathComponent(joined)), forType: .png)
					usleep(100000)
					//print("doing event...")
					let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true); // cmd-v down
					event1?.flags = CGEventFlags.maskCommand;
					event1?.post(tap: CGEventTapLocation.cghidEventTap);
				} catch {
					
				}
				
				//print("STANDBY")
			} else if self.inputMode && event.characters == "\u{7F}" {
				// If the key is backspace and we are in inputmode delete the last character in the array
				self.keypresses.removeLast()
			} else if self.inputMode {
				// If we are in inputmode append the pressed key to the array of keys
				self.keypresses.append(event.characters!)
			}
			

			
		}
		
		// Create a status bar item.
		let statusBar = NSStatusBar.system
		statusBarItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
		statusBarItem.button?.title = "🍉"
		//statusBarItem.button?.image = NSImage.init(named: NSImage.Name("fruityMenuBarIcon"))
		let statusBarMenu = NSMenu(title: "Cap Status Bar Menu")
		
		
		// Add a menu and some Menu items to the status bar item
		statusBarItem.menu = statusBarMenu
		statusBarMenu.addItem(
			withTitle: "Open QuickPic",
			action: #selector(AppDelegate.open),
			keyEquivalent: "")
		statusBarMenu.addItem(
			withTitle: "Quit",
			action: #selector(AppDelegate.quit),
			keyEquivalent: "")
		NSApp.setActivationPolicy(.accessory)
		
		
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
	
	
	@objc func quit() {
		exit(0)
	}
	@objc func open() {
		// Set the popovers view controller to a new mainViewController
		window.contentViewController = mainViewController()
		
		// Show the popover at position relative to where the status bar item is
		window.show(relativeTo: NSRect(x: 0, y: 0, width: 0, height: 0), of: (statusBarItem.button?.window?.contentView!)!, preferredEdge: .maxY)
		
//		window.showWindow(self)
//		window.panel.orderFront(self)
//		mainViewController.awakeFromNib()
	}
}





