//
//  LoggingApplicationService.swift
//  Tamaggo
//
//  Created by Stéphane Copin on 5/15/17.
//  Copyright © 2017 Stephane Copin. All rights reserved.
//

import UIKit
import CocoaLumberjack
import PluggableApplicationDelegate

open class LoggingApplicationService: NSObject, ApplicationService {
	private var fileLogger: DDFileLogger!

	public struct Configuration {
		public var logLevel: STCLogLevel
		public var hasLogFiles: Bool
		public var logFileMaxSize: UInt64
		public var logFileMaxNumber: UInt

		public init(logLevel: STCLogLevel = .all,
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

	open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
		let logger = STCCocoaLumberjackLogger()
		logger.logLevel = self.configuration.logLevel
		Logger.shared = logger

		DDLog.add(DDASLLogger.sharedInstance)
		DDLog.add(DDTTYLogger.sharedInstance)

		if self.configuration.hasLogFiles {
			self.fileLogger = DDFileLogger()
			self.fileLogger.maximumFileSize = self.configuration.logFileMaxSize
			self.fileLogger.logFileManager.maximumNumberOfLogFiles = self.configuration.logFileMaxNumber
			self.fileLogger.rollLogFile(withCompletion: nil)
			DDLog.add(self.fileLogger)
		}

		LogInfo("Logging has been setup")

		return false
	}

	// MARK: - Helper methods

	open func getLatestLogs(ofSize size: Int? = nil) -> String {
		let description = NSMutableString()
		let sortedLogFileInfos = self.fileLogger.logFileManager.sortedLogFileInfos ?? []

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
