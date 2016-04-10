//
//  LSDeviceInformation.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDeviceInformation.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation LSDeviceInformation

#pragma mark - Publick Methods

static LSDeviceType _currentDeviceType = LSDevice_Undefined;
+ (LSDeviceType)currentDeviceType {
    if (_currentDeviceType != LSDevice_Undefined)
        return _currentDeviceType;
    
    _currentDeviceType = [LSDeviceInformation detectCurrentDevice];
    return _currentDeviceType;
}

static float _displayScale = 0.0;
+ (float)displayScale {
    if (_displayScale != 0.0)
        return _displayScale;
    
    _displayScale = [UIScreen mainScreen].scale;
    return _displayScale;
}

static float _displayRatio = 0.0;
+ (float)displayRatio {
    if (_displayRatio != 0.0)
        return _displayRatio;
    
    _displayRatio = [LSDeviceInformation _displayRatio];
    return _displayRatio;
}

static LSDeviceDisplayInch _displayInch = LSDeviceDisplayUndefined;
+ (LSDeviceDisplayInch)displayInch {
    if (_displayInch != LSDeviceDisplayUndefined)
        return _displayInch;
    
    _displayInch = [LSDeviceInformation _displayInch];
    return _displayInch;
}

static UIImage *_deviceImage = nil;
+ (UIImage*)deviceImage {
    if (_deviceImage)
        return _deviceImage;
    
    LSDeviceType deviceType = [LSDeviceInformation currentDeviceType];
    NSString *imageName = @"";
    
    switch (deviceType) {
        case LSDevice_iPhone4:
            imageName = @"iPhone4.jpg";
            break;
        case LSDevice_iPhone5c:
            imageName = @"iPhone5C.jpg";
            break;
        case LSDevice_iPhone5s:
            imageName = @"iPhone5S.jpg";
            break;
        case LSDevice_iPhone6:
            imageName = @"iPhone6.jpg";
            break;
        case LSDevice_iPhone6P:
            imageName = @"iPhone6P.jpg";
            break;
        case LSDevice_iPod4:
            imageName = @"iPod4.jpg";
            break;
        case LSDevice_iPod5:
            imageName = @"iPod5.jpg";
            break;
        default: break;
    }
    
    _deviceImage = [UIImage imageNamed:imageName];
    return _deviceImage;
}

+ (UIImage*)tmpLockImage {
    LSDeviceType deviceType = [LSDeviceInformation currentDeviceType];
    NSString *imageName = @"";
    UIImage *retImage = nil;
    
    switch (deviceType) {
        case LSDevice_iPhone4:
            imageName = @"Lock35";
            break;
        case LSDevice_iPhone5c:
            imageName = @"Lock40";
            break;
        case LSDevice_iPhone5s:
            imageName = @"Lock40";
            break;
        case LSDevice_iPhone6:
            imageName = @"Lock47";
            break;
        case LSDevice_iPhone6P:
            imageName = @"Lock55";
            break;
        case LSDevice_iPod4:
            imageName = @"Lock35";
            break;
        case LSDevice_iPod5:
            imageName = @"Lock40";
            break;
        default: break;
    }
    
    retImage = [UIImage imageNamed:imageName];
    return retImage;
}

#pragma mark - Private Methods

+ (LSDeviceType)detectCurrentDevice {
    NSString *platform = [self platform];
    
    if ([platform isEqualToString:@"iPhone3,1"])    return LSDevice_iPhone4;
    if ([platform isEqualToString:@"iPhone3,3"])    return LSDevice_iPhone4;
    if ([platform isEqualToString:@"iPhone4,1"])    return LSDevice_iPhone4;
    
    if ([platform isEqualToString:@"iPhone5,1"])    return LSDevice_iPhone5s;
    if ([platform isEqualToString:@"iPhone5,2"])    return LSDevice_iPhone5s;
    if ([platform isEqualToString:@"iPhone5,3"])    return LSDevice_iPhone5c;
    if ([platform isEqualToString:@"iPhone5,4"])    return LSDevice_iPhone5c;
    if ([platform isEqualToString:@"iPhone6,1"])    return LSDevice_iPhone5s;
    if ([platform isEqualToString:@"iPhone6,2"])    return LSDevice_iPhone5s;
    if ([platform isEqualToString:@"iPhone8,4"])    return LSDevice_iPhone5s;
    
    if ([platform isEqualToString:@"iPhone7,1"])    return LSDevice_iPhone6P;
    if ([platform isEqualToString:@"iPhone8,2"])    return LSDevice_iPhone6P;
    
    if ([platform isEqualToString:@"iPhone7,2"])    return LSDevice_iPhone6;
    if ([platform isEqualToString:@"iPhone8,1"])    return LSDevice_iPhone6;
    
    if ([platform isEqualToString:@"iPod4,1"])      return LSDevice_iPod4;
    if ([platform isEqualToString:@"iPod5,1"])      return LSDevice_iPod5;
    if ([platform isEqualToString:@"iPod7,1"])      return LSDevice_iPod5;
    
    if ([platform isEqualToString:@"i386"])         return [LSDeviceInformation simulatorType];
    if ([platform isEqualToString:@"x86_64"])       return [LSDeviceInformation simulatorType];
    
    return LSDevice_iPhone4;
}

+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (LSDeviceType)simulatorType {
    LSDeviceDisplayInch screen = [LSDeviceInformation displayInch];
    switch (screen) {
        case LSDeviceDisplay35:
            return LSDevice_iPhone4; break;
        case LSDeviceDisplay40:
            return LSDevice_iPhone5s; break;
        case LSDeviceDisplay47:
            return LSDevice_iPhone6; break;
        case LSDeviceDisplay55:
            return LSDevice_iPhone6P; break;
        default:
            break;
    }
    
    return LSDevice_Undefined;
}

+ (float)iOSVersion {
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (LSDeviceDisplayInch)_displayInch {
    float screenHeight = UIScreen.mainScreen.bounds.size.height;
    if (screenHeight == 480) return LSDeviceDisplay35;
    if (screenHeight == 568) return LSDeviceDisplay40;
    if (screenHeight == 667) return LSDeviceDisplay47;
    if (screenHeight == 736) return LSDeviceDisplay55;
        
    return LSDeviceDisplayUndefined;
}

+ (float)_displayRatio {
    LSDeviceDisplayInch inches = [LSDeviceInformation displayInch];
    switch (inches) {
        case LSDeviceDisplay35: return 1.5;
        case LSDeviceDisplay40: return 1.775;
        case LSDeviceDisplay47: return 1.779;
        case LSDeviceDisplay55: return 1.804;
        default: break;
    }
    
    return 0.0;
}


@end
