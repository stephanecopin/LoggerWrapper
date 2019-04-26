//
//  Logger.swift
//  LoggerWrapper
//
//  Created by Stephane Copin on 1/19/15.
//  Copyright (c) 2014-2017 Stephane Copin.
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
//  LIABILITY, WHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public typealias Logger = __STCLogger

public typealias LogFlag = STCLogFlag
public typealias LogLevel = STCLogLevel

extension Logger {
	public var modulesLogLevel: [String: LogLevel] {
		get {
			var dictionary: [String: LogLevel] = [:]
			for (key, value) in self.__modulesLogLevel {
				dictionary[key] = LogLevel(rawValue: value.uintValue)
			}
			return dictionary
		}
		set {
			var dictionary: [String: NSNumber] = [:]
			for (key, value) in newValue {
				dictionary[key] = NSNumber(value: value.rawValue)
			}
			self.__modulesLogLevel = dictionary
		}
	}
}

func Log(_ flag: LogFlag, module: String?, file: String, function: String, line: UInt, message: @autoclosure () -> String) {
	if let logger = Logger.shared {
		withVaList([message()]) { args in
			logger.log(flag, module: module, file: file, function: function, line: Int32(line), format: "%@", arguments: args)
		}
	}
}

public func LogTrace(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.trace, module: module, file: file, function: function, line: line, message: message())
}

public func LogDebug(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.debug, module: module, file: file, function: function, line: line, message: message())
}

public func LogVerbose(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.verbose, module: module, file: file, function: function, line: line, message: message())
}

public func LogInfo(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.info, module: module, file: file, function: function, line: line, message: message())
}

public func LogWarning(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.warning, module: module, file: file, function: function, line: line, message: message())
}

public func LogError(_ message: @autoclosure () -> String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) {
	Log(.error, module: module, file: file, function: function, line: line, message: message())
}

public func LogFatal(_ message: String, module: String? = nil, file: String = #file, function: String = #function, line: UInt = #line) -> Never {
	Log(.fatal, module: module, file: file, function: function, line: line, message: message)
	fatalError(message)
}
