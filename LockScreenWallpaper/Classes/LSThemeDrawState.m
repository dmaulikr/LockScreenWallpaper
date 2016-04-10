//
//  LSThemeDrawState.m
//  LockScreenWallpaper
//
//  Created by ZZI on 4/15/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeDrawState.h"

@implementation LSThemeDrawState

- (instancetype)copy {
    LSThemeDrawState *state = [LSThemeDrawState new];
    
    state.mainBackgroundImageIndexPath          = [self.mainBackgroundImageIndexPath copy];
    state.mainBackgroundColorIndexPath          = [self.mainBackgroundColorIndexPath copy];
    
    state.clockViewCornerRadiusIndexPath        = [self.clockViewCornerRadiusIndexPath copy];
    state.clockViewColorIndexPath               = [self.clockViewColorIndexPath copy];
    state.clockViewImageIndexPath               = [self.clockViewImageIndexPath copy];
    
    state.slideViewCornerRadiusIndexPath        = [self.slideViewCornerRadiusIndexPath copy];
    state.slideViewColorIndexPath               = [self.slideViewColorIndexPath copy];
    state.slideViewImageIndexPath               = [self.slideViewImageIndexPath copy];
    
    state.photoViewCornerRadiusIndexPath        = [self.photoViewCornerRadiusIndexPath copy];
    
    state.photoBorderViewCornerRadiusIndexPath  = [self.photoBorderViewCornerRadiusIndexPath copy];
    state.photoBorderViewColorIndexPath         = [self.photoBorderViewColorIndexPath copy];
    state.photoBorderViewImageIndexPath         = [self.photoBorderViewImageIndexPath copy];
    
    return state;
}

- (NSString*)description {
    NSMutableString *retSting = [NSMutableString new];
    
    [retSting appendFormat:@"\n%@", self.mainBackgroundColorIndexPath];
    [retSting appendFormat:@"\n%@", self.mainBackgroundImageIndexPath];
    [retSting appendFormat:@"\n%@", self.clockViewColorIndexPath];
    [retSting appendFormat:@"\n%@", self.clockViewCornerRadiusIndexPath];
    [retSting appendFormat:@"\n%@", self.clockViewImageIndexPath];
    [retSting appendFormat:@"\n%@", self.slideViewColorIndexPath];
    [retSting appendFormat:@"\n%@", self.slideViewCornerRadiusIndexPath];
    [retSting appendFormat:@"\n%@", self.slideViewImageIndexPath];
    [retSting appendFormat:@"\n%@", self.photoBorderViewColorIndexPath];
    [retSting appendFormat:@"\n%@", self.photoBorderViewCornerRadiusIndexPath];
    [retSting appendFormat:@"\n%@", self.photoBorderViewImageIndexPath];
    [retSting appendFormat:@"\n%@", self.photoViewCornerRadiusIndexPath];
    
    return retSting;
}

@end
