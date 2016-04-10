//
//  LSDeviceInformation.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LSDeviceType) {
    LSDevice_iPhone4 = 0,
    LSDevice_iPhone5c,
    LSDevice_iPhone5s,
    LSDevice_iPhone6,
    LSDevice_iPhone6P,
    LSDevice_iPod4,
    LSDevice_iPod5,
    LSDevice_Undefined
};

typedef NS_ENUM(NSInteger, LSDeviceDisplayInch) {
    LSDeviceDisplay35 = 0,
    LSDeviceDisplay40,
    LSDeviceDisplay47,
    LSDeviceDisplay55,
    LSDeviceDisplayUndefined
};

@interface LSDeviceInformation : NSObject

+ (LSDeviceType)currentDeviceType;
+ (float)displayScale;
+ (LSDeviceDisplayInch)displayInch;
+ (UIImage*)deviceImage;
+ (float)displayRatio;
+ (float)iOSVersion;

+ (UIImage*)tmpLockImage;

@end
