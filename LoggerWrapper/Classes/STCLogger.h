//
//  STCLogger.h
//  LoggerWrapper
//
//  Created by Stephane Copin on 12/17/14.
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
//  LIABILITY, WHSTCER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, STCLogFlag) {
  STCLogFlagFatal   = (1 << 0),
  STCLogFlagError   = (1 << 1),
  STCLogFlagWarning = (1 << 2),
  STCLogFlagInfo    = (1 << 3),
  STCLogFlagDebug   = (1 << 4),
  STCLogFlagVerbose = (1 << 5),
  STCLogFlagTrace   = (1 << 6),
};

typedef NS_OPTIONS(NSUInteger, STCLogLevel) {
  STCLogLevelOff     =  0,
  STCLogLevelFatal   =  STCLogFlagFatal,
  STCLogLevelError   = (STCLogFlagError   | STCLogLevelFatal),
  STCLogLevelWarning = (STCLogFlagWarning | STCLogLevelError),
  STCLogLevelInfo    = (STCLogFlagInfo    | STCLogLevelWarning),
  STCLogLevelDebug   = (STCLogFlagDebug   | STCLogLevelInfo),
  STCLogLevelVerbose = (STCLogFlagVerbose | STCLogLevelDebug),
  STCLogLevelTrace   = (STCLogFlagTrace   | STCLogLevelVerbose),
  STCLogLevelAll     = NSUIntegerMax,
};

/**
 *  This provides an interface that can be used as a way to implement any kind of
 *  logging framework in a generic manner.
 *  LoggerWrapper provides for now only one logger, implemented via CocoaLumberjack, called STCCocoaLumberjackLogger.
 *  You can also chose to completely disable LoggerWrapper's logging system (In objective-c) by defining the macro
 *  LOGGERWRAPPER_DISABLE_LOGGING in the Build Settings of your app. This ensure that every call to the STCLog<Level> macros
 *  will be converted into noop.
 *  @note This means that, if the macro LOGGERWRAPPER_DISABLE_LOGGING is enabled, none of its arguments will be evaluated.
 *  Never include method call, assignment and such in the logging macros!
 *  Subclasses may just subclass [-log:file:function:line:message]
 */
NS_REFINED_FOR_SWIFT
@interface STCLogger: NSObject

@property (nonatomic, assign) STCLogLevel logLevel;

// When writing your own subclass not override the methods below, override `-[STCLogger(Subclass) writeLog:module:file:function:line:message]` instead.
// These method will take the current logLevel into account before writing the log message.
- (void)log:(STCLogFlag)flag module:(nullable NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format, ... NS_FORMAT_FUNCTION(6, 7);
- (void)log:(STCLogFlag)flag module:(nullable NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format arguments:(va_list)arguments;
- (void)log:(STCLogFlag)flag module:(nullable NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line message:(NSString *)message;

@property (class, nullable) STCLogger * sharedLogger;

@end

#undef _STCLog
#undef _STCTryLog

#undef STCLogTrace
#undef STCLogVerbose
#undef STCLogDebug
#undef STCLogInfo
#undef STCLogWarning
#undef STCLogError
#undef STCLogFatal

#ifndef CURRENT_MODULE
#define CURRENT_MODULE nil
#endif

#define _TOSTRING_STEP2(v) @#v
#define _TOSTRING(v) _TOSTRING_STEP2(v)

#define _STCTryLog(flag, functionName, formatString, ...) \
  [STCLogger.sharedLogger log:(flag) module:_TOSTRING(CURRENT_MODULE) file:[NSString stringWithUTF8String:__FILE__] function:(functionName) line:__LINE__ format:(formatString), ## __VA_ARGS__]

#if !defined(LOGGERWRAPPER_DISABLE_LOGGING)
#define STCLogC(flag, formatString, ...) _STCTryLog(flag, [NSString stringWithUTF8String:__func__], formatString, ## __VA_ARGS__)
#define STCLog(flag, formatString, ...) _STCTryLog(flag, NSStringFromSelector(_cmd), formatString, ## __VA_ARGS__)
#else
#define STCLogC(flag, formatString, ...) do { } while(0)
#define STCLog(flag, formatString, ...) do { } while(0)
#endif

#define STCLogTrace(format, ...)   STCLog(STCLogFlagTrace,   format, ## __VA_ARGS__)
#define STCLogVerbose(format, ...) STCLog(STCLogFlagVerbose, format, ## __VA_ARGS__)
#define STCLogDebug(format, ...)   STCLog(STCLogFlagDebug,   format, ## __VA_ARGS__)
#define STCLogInfo(format, ...)    STCLog(STCLogFlagInfo,    format, ## __VA_ARGS__)
#define STCLogWarning(format, ...) STCLog(STCLogFlagWarning, format, ## __VA_ARGS__)
#define STCLogError(format, ...)   STCLog(STCLogFlagError,   format, ## __VA_ARGS__)
#define STCLogFatal(format, ...)   STCLog(STCLogFlagFatal,   format, ## __VA_ARGS__)

#define STCLogTraceC(format, ...)   STCLogC(STCLogFlagTrace,   format, ## __VA_ARGS__)
#define STCLogVerboseC(format, ...) STCLogC(STCLogFlagVerbose, format, ## __VA_ARGS__)
#define STCLogDebugC(format, ...)   STCLogC(STCLogFlagDebug,   format, ## __VA_ARGS__)
#define STCLogInfoC(format, ...)    STCLogC(STCLogFlagInfo,    format, ## __VA_ARGS__)
#define STCLogWarningC(format, ...) STCLogC(STCLogFlagWarning, format, ## __VA_ARGS__)
#define STCLogErrorC(format, ...)   STCLogC(STCLogFlagError,   format, ## __VA_ARGS__)
#define STCLogFatalC(format, ...)   STCLogC(STCLogFlagFatal,   format, ## __VA_ARGS__)

NS_ASSUME_NONNULL_END
