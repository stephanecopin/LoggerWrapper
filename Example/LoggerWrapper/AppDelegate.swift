//
//  AppDelegate.swift
//  LoggerWrapper
//
//  Created by stephane-fueled on 05/16/2017.
//  Copyright (c) 2017 stephane-fueled. All rights reserved.
//

import UIKit
import LoggerWrapper
import PluggableApplicationDelegate

@UIApplicationMain
class AppDelegate: PluggableApplicationDelegate {
	override var services: [ApplicationService] {
		return [LoggingApplicationService()]
	}
}

