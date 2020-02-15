//
//  ViewController.swift
//  OutlineViewDemo
//
//  Created by 褚尉卿 on 2020/2/12.
//  Copyright © 2020 cwq. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var feeds = [Feed]()
    let dateFormatter = DateFormatter()

    @IBOutlet var outlineView: NSOutlineView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let filePath = Bundle.main.path(forResource: "Feeds", ofType: "plist") {
            feeds = Feed.feedList(filePath)
        }

        outlineView.dataSource = self
        outlineView.delegate = self
        outlineView.reloadData()

        dateFormatter.dateStyle = .short
    }

    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSOutlineViewDataSource {
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let feed = item as? Feed {
            return feed.children.count
        }
        return feeds.count
    }

    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        print("outlineView \(index)")
        if let feed = item as? Feed {
            return feed.children[index]
        }
        return feeds[index]
    }

    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if let feed = item as? Feed {
            return feed.children.count > 0
        }

        return false
    }
}

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?

        if let feed = item as? Feed {
            // Identifier is set in main.storeboard
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "DateColumn") {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = ""
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feed.name
                    textField.sizeToFit()
                }
            }
        } else if let feedItem = item as? FeedItem {
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "DateColumn") {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DateCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = dateFormatter.string(from: feedItem.publishingDate)
                    textField.sizeToFit()
                }
            } else {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedItemCell"), owner: self) as? NSTableCellView
                if let textField = view?.textField {
                    textField.stringValue = feedItem.title
                    textField.sizeToFit()
                }
            }
        }

        return view
    }

    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }

        let selectedIndex = outlineView.selectedRow
        if let feedItem = outlineView.item(atRow: selectedIndex) as? FeedItem {
            print(feedItem.url)
        }
    }
}
