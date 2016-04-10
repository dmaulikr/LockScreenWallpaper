//
//  LSCommon.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

#define VERSION_1_0_ONBOARD                             @"Vesrion_1_0_Onboard"
#define VERSION_1_0_SAVE_INFO                           @"Vesrion_1_0_SaveInfo"
#define VERSION_1_0_CHECK_PURCHASES_ALERT               @"Vesrion_1_0_CheckPurchasesAlert"
#define VERSION_1_0_FULL_SCREEN_ALERT                   @"Vesrion_1_0_FullScreenAlert"

#define VERSION_1_1_ONBOARD                             @"Vesrion_1_1_Onboard"

UIStoryboard*   LSMainStoryboard();
NSString*       LSDocumentsPath();
AppDelegate*    LSApplicationDelegate();

BOOL            LSIsFirstLaunchWithKey(NSString* key);

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

typedef NS_ENUM(NSInteger, LSScrollDirection) {
    LSScrollDirectionTop = 0,
    LSScrollDirectionBottpm,
    LSScrollDirectionLeft,
    LSScrollDirectionRight
};