//
//  mainViewController.swift
//  QuickPic
//
//  Created by Ethan Cardwell on 26/8/20.
//  Copyright © 2020 Xenthio. All rights reserved.
//

import Cocoa

class mainViewController: NSViewController {
	var a = [String]()
	
	// Define a path for where the images are going to be
	let appSupportPath = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("QuickPic")
	
	// Create a file manager, so we can access files.
	let fileMan = FileManager.default
	
	// Get objects from the Interface Builder
	@IBOutlet var collectionView: NSCollectionView!
	@IBOutlet var mainView: NSView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
	}
	
	override var nibName: String! {
        return "mainWindow"
    }
	
	override func viewDidAppear() {
		
		// Set the datasource and delegate to ourself, as we extend this class later,
        collectionView.dataSource = self
		collectionView.delegate = self
		do {
			// Try create a folder for the images to be located at, just in case it doesn't exist
			try fileMan.createDirectory (at: appSupportPath, withIntermediateDirectories: true, attributes: nil)
			
			// Get the contents of previously said folder.
			let contents = try fileMan.contentsOfDirectory(atPath: appSupportPath.path)
			for item in contents {
				// Add them all to an array for later use
				a.append(item)
			}
			
			// Refresh the collection view,
			collectionView.reloadData()
		} catch {
			
		}
    }
	func pasteImage(image: String) {
		
		let pasteBoard = NSPasteboard.general
		window.close()
		pasteBoard.clearContents()
		pasteBoard.setData(try! Data(contentsOf: appSupportPath.appendingPathComponent(image)), forType: .png)
		usleep(800000)
		let event1 = CGEvent(keyboardEventSource: nil, virtualKey: 0x09, keyDown: true);
		event1?.flags = CGEventFlags.maskCommand;
		event1?.post(tap: CGEventTapLocation.cghidEventTap);
	}
}


// we use extentions so we can access all the variables we could access up there.
extension mainViewController: NSCollectionViewDataSource {
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		// Return the amount of values in the array, this tells the thing to add this many objects to the view
		return a.count
	}

}


extension mainViewController: NSCollectionViewDelegate {
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "itemView"), for: indexPath) as! itemView
		
		item.textField!.stringValue = a[indexPath.item].split(separator: ".").dropLast().joined(separator: ".")
		item.imageView!.image = NSImage(contentsOf: appSupportPath.appendingPathComponent(a[indexPath.item]))
		item.fileName = a[indexPath.item]
		
		return item
	}
	func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
		let buddy = collectionView.item(at: indexPaths.first!) as! itemView
		pasteImage(image: buddy.fileName)
		collectionView.deselectAll(Any?.self)
	}
}
