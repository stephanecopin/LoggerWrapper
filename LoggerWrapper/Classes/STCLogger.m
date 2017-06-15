//
//  TFTLogger.m
//  LoggerWrapper
//
//  Created by Stéphane Copin on 5/15/17.
//  Copyright © 2017 Stephane Copin. All rights reserved.
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

#import "STCLogger.h"
#import "STCLogger+Subclass.h"

@import Foundation;

static STCLogger * sharedLogger;

@implementation STCLogger

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_logLevel = STCLogLevelAll;
	}
	return self;
}

- (void)log:(STCLogFlag)flag module:(NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format, ... {
  va_list args;
  va_start(args, format);

  [self log:flag module:module file:file function:function line:line format:format arguments:args];

  va_end(args);
}

- (void)log:(STCLogFlag)flag module:(NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line format:(NSString *)format arguments:(va_list)arguments {
	[self log:flag module:module file:file function:function line:line message:[[NSString alloc] initWithFormat:format arguments:arguments]];
}

- (void)log:(STCLogFlag)flag module:(NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line message:(NSString *)message {
	if(!!(self.logLevel & flag)) {
		[self writeLog:flag module:module file:file function:function line:line message:message];
	}
}

- (void)writeLog:(STCLogFlag)flag module:(NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line message:(NSString *)message {

}

+ (STCLogger *)sharedLogger {
  return sharedLogger;
}

+ (void)setSharedLogger:(STCLogger *)newSharedLogger {
  sharedLogger = newSharedLogger;
}

@end
