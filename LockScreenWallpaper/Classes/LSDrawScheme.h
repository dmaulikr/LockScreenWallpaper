//
//  LSDrawScheme.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/12/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSThemeModel.h"
#import "LSThemeDrawState.h"

@interface LSDrawScheme : NSObject

@property (nonatomic, strong) LSThemeDrawState      *currentDrawState;
@property (nonatomic, assign) CGRect                 mainFrame;

// background properties
@property (nonatomic, copy) UIColor                 *mainBackgroundColor;
@property (nonatomic, copy) UIImage                 *mainBackgroundImage;

// clock properties
@property (nonatomic, assign) CGRect                 clockViewFrame;
@property (nonatomic, assign) CGFloat                clockViewCornerRadius;
@property (nonatomic, copy) UIColor                 *clockViewColor;
@property (nonatomic, copy) UIImage                 *clockViewImage;

// slide properties
@property (nonatomic, assign) CGRect                 slideViewFrame;
@property (nonatomic, assign) CGFloat                slideViewCornerRadius;
@property (nonatomic, copy) UIColor                 *slideViewColor;
@property (nonatomic, copy) UIImage                 *slideViewImage;

// photo properties

@property (nonatomic, assign) CGRect                 photoViewFrame;
@property (nonatomic, assign) CGFloat                photoViewCornerRadius;
@property (nonatomic, copy) UIImage                 *photoViewImage;

// photo border properties

@property (nonatomic, assign) CGRect                 photoBorderViewFrame;
@property (nonatomic, assign) CGFloat                photoBorderViewCornerRadius;
@property (nonatomic, copy) UIColor                 *photoBorderViewColor;
@property (nonatomic, copy) UIImage                 *photoBorderViewImage;

- (void)setCornerRadius:(CGFloat)radius indexPath:(NSIndexPath*)indexPath forElement:(LSThemeElement)element;
- (void)setColor:(UIColor*)color indexPath:(NSIndexPath*)indexPath forElements:(LSThemeElement)element;
- (void)setImage:(UIImage*)image indexPath:(NSIndexPath*)indexPath forElements:(LSThemeElement)element;

- (CGFloat)cornerRadiusForElement:(LSThemeElement)element;

@end
