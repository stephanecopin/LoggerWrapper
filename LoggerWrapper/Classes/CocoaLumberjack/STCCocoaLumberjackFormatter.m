//
//  STCCocoaLumberjackFormatter.m
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

#import "STCCocoaLumberjackFormatter.h"
#import "STCLogger.h"

@interface STCCocoaLumberjackFormatter ()

@property (nonatomic, strong, readonly) NSDateFormatter * dateFormatter;

@end

@implementation STCCocoaLumberjackFormatter
@synthesize dateFormatter = _dateFormatter;

- (instancetype)init {
	self = [super init];
	if (self != nil) {
		_dateFormatter = [[NSDateFormatter alloc] init];
		_dateFormatter.dateFormat = @"YYYY-MM-dd' 'HH-mm-ss'.'SSS";
	}
	return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
	NSMutableString * flagString = [[NSMutableString alloc] init];
#define FLAG_EMOTICON(flagName, emoticon) \
	if (!!(logMessage.flag & (int)STCLogFlag ## flagName)) { \
		[flagString appendString:(emoticon)]; \
	}
	FLAG_EMOTICON(Trace, @"⚫️")
	FLAG_EMOTICON(Verbose, @"🔘")
	FLAG_EMOTICON(Debug, @"⚪️")
	FLAG_EMOTICON(Info, @"🔵")
	FLAG_EMOTICON(Warning, @"⚠️")
	FLAG_EMOTICON(Error, @"❌")
	FLAG_EMOTICON(Fatal, @"☢️")

	NSString * message = logMessage.message;
	if ([logMessage.tag isKindOfClass:[NSString class]]) {
		message = [NSString stringWithFormat:@"[%@] %@", logMessage.tag, logMessage.message];
	}
	
	return [NSString stringWithFormat:@"%@ %@ %@: %@",
					flagString,
					[self.dateFormatter stringFromDate:logMessage.timestamp],
					flagString,
					message];
}

@end
