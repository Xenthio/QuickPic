//
//  itemView.swift
//  QuickPic
//
//  Created by Ethan Cardwell on 21/8/20.
//  Copyright © 2020 Xenthio. All rights reserved.
//

import Cocoa

class itemView: NSCollectionViewItem {
	var fileName = "Nul"
	
	override var nibName: String {
		// Return the name of the nib / xib file that serves as a template.
		return "itemView"
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // view setup here.
    }
}
