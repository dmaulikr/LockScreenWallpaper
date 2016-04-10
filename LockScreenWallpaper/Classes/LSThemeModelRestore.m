//
//  LSThememodelRestore.m
//  LockScreenWallpaper
//
//  Created by ZZI on 25/05/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeModelRestore.h"

@implementation LSThemeModelRestore

@synthesize themeName                   = _themeName,
            themeDisplayName            = _themeDisplayName;

- (LSThemeType)themeType {
    return LSThemeRestorePurchases;
}

- (NSString*)themeName {
    if (_themeName)
        return _themeName;
    
    _themeName = @"RestorePurchases";
    return _themeName;
}

- (NSString*)themeDisplayName {
    if (_themeDisplayName)
        return _themeDisplayName;
    
    _themeDisplayName = @"Restore Purchases";
    return _themeDisplayName;
}

- (BOOL)isLock {
    return NO;
}

- (NSArray*)exampleWallpapers {
    return @[];
}

@end
