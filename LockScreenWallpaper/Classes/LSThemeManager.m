//
//  LSThemeManager.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeManager.h"
#import "LSThemeModel.h"

const NSInteger themesCount = 5;

#define SHOULD_CHECK_PURCHASES                      @"ShouldCheckPurchasesFlag"

@implementation LSThemeManager

+ (instancetype)sharedManager {
    static LSThemeManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _themeWasChanged = NO;
    }
    
    return self;
}

- (BOOL)checkPurchasesAlert {
    return [[NSUserDefaults standardUserDefaults] boolForKey:SHOULD_CHECK_PURCHASES];
}

- (void)setCheckPurchasesAlert:(BOOL)checkPurchasesAlert {
    [[NSUserDefaults standardUserDefaults] setBool:checkPurchasesAlert forKey:SHOULD_CHECK_PURCHASES];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray*)themesList {
    NSMutableArray *arr = [NSMutableArray new];
    for(int i = 0; i < themesCount; i++) {
        LSThemeModel *model = [LSThemeModel themeModelWithType:[LSThemeModel themeTypeWithIndex:i]];
        [model loadImagesForThemesScreen];
        [arr addObject:model];
    }
    
    return (NSArray*)arr;
}

- (void)setCurrentThemeModel:(LSThemeModel *)currentThemeModel {
    if (_currentThemeModel != currentThemeModel) {
        self.themeWasChanged = YES;
        _currentThemeModel = currentThemeModel;
    }
}

@end
