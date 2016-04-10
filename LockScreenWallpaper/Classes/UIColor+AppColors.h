//
//  UIColor+AppColors.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/16/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)

- (BOOL)isEqualToColor:(UIColor *)otherColor;

+ (UIColor*)colorWithHex:(int)hexValue;

+ (UIColor*)mainBackgroundColor;
+ (UIColor*)secondBackgroundColor;
+ (UIColor*)thirdBackgroundColor;
+ (UIColor*)topButtonColor;

+ (UIColor*)topButtonFontColor;

+ (UIColor*)shadowColor;

+ (UIColor*)mainBorderColor;

// Color collections
+ (NSArray*)redColors;
+ (NSArray*)pinkColors;
+ (NSArray*)purpleColors;
+ (NSArray*)deepPurpleColors;
+ (NSArray*)indigoColors;
+ (NSArray*)blueColors;
+ (NSArray*)lightBlueColors;
+ (NSArray*)cyanColors;
+ (NSArray*)tealColors;
+ (NSArray*)greenColors;
+ (NSArray*)lightGreenColors;
+ (NSArray*)limeColors;
+ (NSArray*)yellowColors;
+ (NSArray*)amberColors;
+ (NSArray*)orangeColors;
+ (NSArray*)deepOrangeColors;
+ (NSArray*)brownColors;
+ (NSArray*)blueGrayColors;
+ (NSArray*)whiteColors;
+ (NSArray*)blackColors;

@end
