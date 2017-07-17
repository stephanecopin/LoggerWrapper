//
//  ViewController.swift
//  LoggerWrapper
//
//  Created by stephane-fueled on 05/16/2017.
//  Copyright (c) 2017 stephane-fueled. All rights reserved.
//

import UIKit
import LoggerWrapper

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()

		LogDebug("View has loaded", module: "Main");

		Logger.shared?.modulesLogLevel = ["Main": [.info]]
		LogDebug("View has loaded", module: "Main"); // Not displayed

		LogInfo("View has loaded", module: "Main"); // Displayed
	}
}
