//
//  AppDelegate.swift
//  OutlineViewDemo
//
//  Created by 褚尉卿 on 2020/2/12.
//  Copyright © 2020 cwq. All rights reserved.
//

import Cocoa
import Preferences

extension PreferencePane.Identifier {
    static let general = Identifier("general")
    static let advanced = Identifier("advanced")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, GeneralPaneDelegate {
    var webViewController: WebViewController?

    var preferencesStyle: PreferencesStyle {
        get { PreferencesStyle.preferencesStyleFromUserDefaults() }
        set {
            newValue.storeInUserDefaults()
        }
    }

    lazy var preferences: [PreferencePane] = [
        GeneralPreferenceViewController(),
        AdvancedPreferenceViewController()
    ]

    lazy var preferencesWindowController: PreferencesWindowController = {
        let out = PreferencesWindowController(
            preferencePanes: preferences,
            style: preferencesStyle,
            animated: true,
            hidesToolbarForSingleItem: true
        )
        let genPane = preferences[0] as! GeneralPreferenceViewController
        genPane.delegate = self
        return out
    }()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    } // end func

    @IBAction private func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }

    func relunchPreference() {
        print("In relunchPreference")
        preferencesWindowController.close()

        preferencesStyle = preferencesStyle == .segmentedControl
            ? .toolbarItems
            : .segmentedControl

        preferencesWindowController = PreferencesWindowController(
            preferencePanes: preferences,
            style: preferencesStyle,
            animated: true,
            hidesToolbarForSingleItem: true
        )

        preferencesWindowController.show()
    }
}
