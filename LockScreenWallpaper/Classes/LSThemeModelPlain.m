//
//  LSThemePlain.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeModelPlain.h"
#import "UIColor+AppColors.h"
#import "LSDrawScheme.h"

@interface LSThemeModelPlain() {
}

@end

@implementation LSThemeModelPlain

@synthesize themeName                   = _themeName,
            themeDisplayName            = _themeDisplayName;

- (LSThemeType)themeType {
    return LSThemePlain;
}

- (NSString*)themeName {
    if (_themeName)
        return _themeName;
    
    _themeName = @"Plain";
    return _themeName;
}

- (NSString*)themeDisplayName {
    if (_themeDisplayName)
        return _themeDisplayName;
    
    _themeDisplayName = @"Plain";
    return _themeDisplayName;
}

- (LSDrawScheme*)defaultDrawScheme {
    LSDrawScheme *drawScheme    = [super defaultDrawScheme];
    
    return drawScheme;
}

- (void)setupInitialDrawState {
    LSThemeDrawState *drawState = [LSThemeDrawState new];
    
    drawState.mainBackgroundColorIndexPath = [[[NSIndexPath alloc] initWithIndex:19] indexPathByAddingIndex:8];
    drawState.mainBackgroundImageIndexPath = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.clockViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:1] indexPathByAddingIndex:3];
    drawState.clockViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.clockViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.slideViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:1] indexPathByAddingIndex:3];
    drawState.slideViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.slideViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.photoViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    
    drawState.photoBorderViewColorIndexPath         = [[[NSIndexPath alloc] initWithIndex:1] indexPathByAddingIndex:8];
    drawState.photoBorderViewCornerRadiusIndexPath  = [[NSIndexPath alloc] initWithIndex:1];
    drawState.photoBorderViewImageIndexPath         = [[NSIndexPath alloc] initWithIndex:0];
    
    self.initialDrawState = drawState;
}

@end
