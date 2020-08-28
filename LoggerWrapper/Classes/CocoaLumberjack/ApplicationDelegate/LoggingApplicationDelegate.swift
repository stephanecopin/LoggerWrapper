//
//  LoggingApplicationDelegate.swift
//  LoggerWrapper
//
//  Created by Stephane Copin on 11/7/16.
//  Copyright © 2016 Stephane Copin. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHSTCER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import CocoaLumberjack
#if canImport(UIKit)
import UIKit

public typealias ApplicationDelegate = UIApplicationDelegate
#elseif canImport(AppKit)
import AppKit

public typealias ApplicationDelegate = NSApplicationDelegate
#endif

open class LoggingApplicationDelegate: NSObject, ApplicationDelegate {
	private var fileLogger: DDFileLogger!

	public struct Configuration {
		public let logLevel: STCLogLevel
		public let hasLogFiles: Bool
		public let logFileMaxSize: UInt64
		public let logFileMaxNumber: UInt

		public init(
			logLevel: STCLogLevel = .all,
			hasLogFiles: Bool = true,
			logFileMaxSize: UInt64 = 1024 * 1024,
			logFileMaxNumber: UInt = 10)
		{
			self.logLevel = logLevel
			self.hasLogFiles = hasLogFiles
			self.logFileMaxSize = logFileMaxSize
			self.logFileMaxNumber = logFileMaxNumber
		}
	}

	public let configuration: Configuration

	public init(configuration: Configuration = Configuration()) {
		self.configuration = configuration
	}

	#if canImport(UIKit)
	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
		self.applicationDidFinishLaunching()

		return false
	}
	#elseif canImport(AppKit)
	open func applicationDidFinishLaunching(_ aNotification: Notification) {
		self.applicationDidFinishLaunching()
	}
	#endif

	private func applicationDidFinishLaunching() {
		let logger = STCCocoaLumberjackLogger()
		logger.logLevel = self.configuration.logLevel
		Logger.shared = logger

		DDLog.add(DDOSLogger.sharedInstance)

		if self.configuration.hasLogFiles {
			self.fileLogger = DDFileLogger()
			self.fileLogger.maximumFileSize = self.configuration.logFileMaxSize
			self.fileLogger.logFileManager.maximumNumberOfLogFiles = self.configuration.logFileMaxNumber
			self.fileLogger.rollLogFile(withCompletion: nil)
			DDLog.add(self.fileLogger)
		}

		LogInfo("Logging has been setup")
	}

	// MARK: - Helper methods

	open func getLatestLogs(ofSize size: Int? = nil) -> String {
		let description = NSMutableString()
		let sortedLogFileInfos = self.fileLogger.logFileManager.sortedLogFileInfos

		for logFileInfo in sortedLogFileInfos.reversed() {
			if let logData = FileManager.default.contents(atPath: logFileInfo.filePath), !logData.isEmpty,
				let result = NSString(data: logData, encoding: String.Encoding.utf8.rawValue) as String? {
				description.append(result)
			}
		}

		if let size = size, description.length > size {
			description.deleteCharacters(in: NSRange(location: 0, length: description.length - size))
		}

		return description as String
	}
}
