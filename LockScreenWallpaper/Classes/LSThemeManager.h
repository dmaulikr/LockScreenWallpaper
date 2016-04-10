//
//  LSThemeManager.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger                          themesCount;

@class LSThemeModel;

@interface LSThemeManager : NSObject

@property (nonatomic, assign) BOOL              themeWasChanged;
@property (nonatomic, strong) LSThemeModel      *currentThemeModel;
@property (nonatomic, strong) NSArray           *themesList;
@property (nonatomic, assign) BOOL              checkPurchasesAlert;

+ (instancetype)sharedManager;

@end
