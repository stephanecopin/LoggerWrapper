//
//  ViewController.swift
//  LoggerWrapper_Example-macOS
//
//  Created by Stéphane Copin on 8/28/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import AppKit
import LoggerWrapper

class ViewController: NSViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		LogDebug("View has loaded", module: "Main");

		Logger.shared?.modulesLogLevel = ["Main": [.info]]
		LogDebug("View has loaded", module: "Main"); // Not displayed

		LogInfo("View has loaded", module: "Main"); // Displayed
	}
}
