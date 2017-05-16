#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "STCCocoaLumberjackFormatter.h"
#import "STCCocoaLumberjackLogger.h"
#import "STCLogger.h"

FOUNDATION_EXPORT double LoggerWrapperVersionNumber;
FOUNDATION_EXPORT const unsigned char LoggerWrapperVersionString[];

