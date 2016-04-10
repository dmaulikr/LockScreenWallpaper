//
//  LSThemeModelMetalShine.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 3/16/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeModelMetalShine.h"
#import "LSDrawScheme.h"

@implementation LSThemeModelMetalShine

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
    return LSThemeMetalShine;
}

- (NSString*)themeName {
    if (_themeName)
        return _themeName;
    
    _themeName = @"MetalShine";
    return _themeName;
}

- (NSString*)themeDisplayName {
    if (_themeDisplayName)
        return _themeDisplayName;
    
    _themeDisplayName = @"Metal Shine";
    return _themeDisplayName;
}

- (LSDrawScheme*)defaultDrawScheme {
    LSDrawScheme *drawScheme    = [super defaultDrawScheme];

    return drawScheme;
}

- (void)setupInitialDrawState {
    LSThemeDrawState *drawState = [LSThemeDrawState new];
    
    drawState.mainBackgroundColorIndexPath = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.mainBackgroundImageIndexPath = [[NSIndexPath alloc] initWithIndex:1];
    
    drawState.clockViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.clockViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.clockViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:2];
    
    drawState.slideViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.slideViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.slideViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:2];
    
    drawState.photoViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    
    drawState.photoBorderViewColorIndexPath         = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.photoBorderViewCornerRadiusIndexPath  = [[NSIndexPath alloc] initWithIndex:1];
    drawState.photoBorderViewImageIndexPath         = [[NSIndexPath alloc] initWithIndex:3];
    
    self.initialDrawState = drawState;
}

- (NSString*)nameForImageBorderWithIndexPath:(NSIndexPath*)indexPath {
    NSString *imageName = [super nameForImageBorderWithIndexPath:indexPath];
    NSString *imageCornerString = @"1234";
    
    switch (indexPath.row+1) {
        case 4: {
            switch (indexPath.section) {
                case 1: imageCornerString = @"1";   break;
                case 2:
                case 3: imageCornerString = @"23";  break;
                case 4: imageCornerString = @"4";   break;
                default:
                    break;
            }
        }
            break;
        default: break;
    }
    
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@" withString:imageCornerString];
    return imageName;
}

@end
