//
//  dataSource.swift
//  QuickPic
//
//  Created by Ethan Cardwell on 21/8/20.
//  Copyright © 2020 Xenthio. All rights reserved.
//

import Cocoa
class dataSource: NSObject,NSCollectionViewDataSource {
	@IBOutlet var col: NSCollectionView!
	func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
		if col != nil {
			return col.numberOfItems(inSection: section)
		}
		return 0
	}
	
	func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
		let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "itemView"), for: indexPath)
		return item
	}
	

}
