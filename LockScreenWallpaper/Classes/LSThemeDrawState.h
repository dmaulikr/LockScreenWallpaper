//
//  LSThemeDrawState.h
//  LockScreenWallpaper
//
//  Created by ZZI on 4/15/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSThemeDrawState : NSObject

// background properties
@property (nonatomic, strong) NSIndexPath                   *mainBackgroundColorIndexPath;
@property (nonatomic, strong) NSIndexPath                   *mainBackgroundImageIndexPath;

// clock properties
@property (nonatomic, strong) NSIndexPath                   *clockViewCornerRadiusIndexPath;
@property (nonatomic, strong) NSIndexPath                   *clockViewColorIndexPath;
@property (nonatomic, strong) NSIndexPath                   *clockViewImageIndexPath;

// slide properties
@property (nonatomic, strong) NSIndexPath                   *slideViewCornerRadiusIndexPath;
@property (nonatomic, strong) NSIndexPath                   *slideViewColorIndexPath;
@property (nonatomic, strong) NSIndexPath                   *slideViewImageIndexPath;

// photo properties
@property (nonatomic, strong) NSIndexPath                   *photoViewCornerRadiusIndexPath;

// photo border properties
@property (nonatomic, strong) NSIndexPath                   *photoBorderViewCornerRadiusIndexPath;
@property (nonatomic, strong) NSIndexPath                   *photoBorderViewColorIndexPath;
@property (nonatomic, strong) NSIndexPath                   *photoBorderViewImageIndexPath;

@end
