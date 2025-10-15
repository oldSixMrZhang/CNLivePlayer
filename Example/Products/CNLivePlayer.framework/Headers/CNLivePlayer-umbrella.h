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

#import "CNLivePlayer.h"
#import "CNLivePlayerManager.h"
#import "CNLivePlayerDelegate.h"
#import "CNLivePlayerHeader.h"
#import "CNLivePlayerTypeDef.h"
#import "CNLivePlayerDBTool.h"

FOUNDATION_EXPORT double CNLivePlayerVersionNumber;
FOUNDATION_EXPORT const unsigned char CNLivePlayerVersionString[];

