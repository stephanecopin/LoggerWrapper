//
//  STCCocoaLumberjackLogger.m
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

@import CocoaLumberjack;

#import "STCCocoaLumberjackLogger.h"
#import "STCCocoaLumberjackFormatter.h"

@implementation STCCocoaLumberjackLogger
@synthesize logLevel = _logLevel;

+ (void)initialize {
  [DDASLLogger sharedInstance].logFormatter = [[STCCocoaLumberjackFormatter alloc] init];
  [DDTTYLogger sharedInstance].logFormatter = [DDASLLogger sharedInstance].logFormatter;
}

- (void)log:(STCLogFlag)flag module:(NSString *)module file:(NSString *)file function:(NSString *)function line:(int)line message:(NSString *)message {
	[DDLog log:NO level:(int)self.logLevel flag:(DDLogFlag)flag context:INT_MAX file:[file UTF8String] function:[function UTF8String] line:line tag:module format:@"%@", message];
}

@end
