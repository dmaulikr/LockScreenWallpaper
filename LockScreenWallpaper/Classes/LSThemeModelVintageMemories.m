//
//  LSThemeModelVintageMemories.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 3/16/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeModelVintageMemories.h"
#import "LSDrawScheme.h"

@implementation LSThemeModelVintageMemories

@synthesize themeName                   = _themeName,
            themeDisplayName            = _themeDisplayName,
            iaThemeID                   = _iaThemeID;

- (NSString*)iaThemeID {
    if(_iaThemeID)
        return _iaThemeID;
    
    _iaThemeID = @""; // In-App Purchases ID
    return _iaThemeID;
}

- (LSThemeType)themeType {
    return LSThemeVintageMemories;
}

- (NSString*)themeName {
    if (_themeName)
        return _themeName;
    
    _themeName = @"VintageMemories";
    return _themeName;
}

- (NSString*)themeDisplayName {
    if (_themeDisplayName)
        return _themeDisplayName;
    
    _themeDisplayName = @"Vintage Memories";
    return _themeDisplayName;
}

- (LSDrawScheme*)defaultDrawScheme {
    LSDrawScheme *drawScheme    = [super defaultDrawScheme];

    return drawScheme;
}

- (void)setupInitialDrawState {
    LSThemeDrawState *drawState = [LSThemeDrawState new];
    
    drawState.mainBackgroundColorIndexPath = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.mainBackgroundImageIndexPath = [[NSIndexPath alloc] initWithIndex:2];
    
    drawState.clockViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.clockViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.clockViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:5];
    
    drawState.slideViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.slideViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.slideViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:5];
    
    drawState.photoViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    
    drawState.photoBorderViewColorIndexPath         = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.photoBorderViewCornerRadiusIndexPath  = [[NSIndexPath alloc] initWithIndex:1];
    drawState.photoBorderViewImageIndexPath         = [[NSIndexPath alloc] initWithIndex:4];
    
    self.initialDrawState = drawState;
}

- (NSString*)nameForImageBorderWithIndexPath:(NSIndexPath*)indexPath {
    NSString *imageName = [super nameForImageBorderWithIndexPath:indexPath];
    NSString *imageCornerString = @"1234";
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@" withString:imageCornerString];
    return imageName;
}

@end
