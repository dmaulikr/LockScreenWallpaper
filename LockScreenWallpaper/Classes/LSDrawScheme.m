//
//  LSDrawScheme.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/12/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDrawScheme.h"

@implementation LSDrawScheme

- (instancetype)init {
    self = [super init];
    if (self) {
        _mainBackgroundColor    = [UIColor greenColor];
        _clockViewColor         = [UIColor greenColor];
        _slideViewColor         = [UIColor greenColor];
        _photoBorderViewColor   = [UIColor yellowColor];
        _photoViewImage         = [[UIImage alloc] init];
    }
    
    return self;
}

- (void)setCornerRadius:(CGFloat)radius indexPath:(NSIndexPath*)indexPath forElement:(LSThemeElement)element {
    BOOL circle = radius == CGFLOAT_MAX ? YES : NO;
    
    switch (element) {
        case LSThemeElementClock: {
            self.clockViewCornerRadius = radius;
            self.currentDrawState.clockViewCornerRadiusIndexPath = indexPath;
        }
            break;
        case LSThemeElementPhoto: {
            if(circle) {
                CGFloat rad1 = CGRectGetHeight(self.photoViewFrame) / 2.0;
                CGFloat rad2 = CGRectGetHeight(self.photoBorderViewFrame) / 2.0;
                if(self.photoBorderViewCornerRadius >= 0.0)
                    self.photoBorderViewCornerRadius = rad2;
                self.photoViewCornerRadius = rad1;
            } else {
                if(radius == -1) {
                    if(self.photoBorderViewCornerRadius >= 0.0)
                        self.photoBorderViewCornerRadius = radius;
                    self.photoViewCornerRadius = radius;
                } else {
                    if(self.photoBorderViewCornerRadius >= 0.0)
                        self.photoBorderViewCornerRadius = radius * 1.5;
                    self.photoViewCornerRadius = radius;
                }
            }
            
            self.currentDrawState.photoViewCornerRadiusIndexPath = indexPath;
            self.currentDrawState.photoBorderViewCornerRadiusIndexPath = indexPath;
        }
            break;
        case LSThemeElementPhotoBorder: {
            if(circle) {
                CGFloat rad1 = CGRectGetHeight(self.photoViewFrame) / 2.0;
                CGFloat rad2 = CGRectGetHeight(self.photoBorderViewFrame) / 2.0;
                self.photoBorderViewCornerRadius = rad2;
                self.photoViewCornerRadius = rad1;
            } else {
                if(radius == -1) {
                    self.photoBorderViewCornerRadius = radius;
                } else {
                    self.photoBorderViewCornerRadius = radius * 1.5;
                    self.photoViewCornerRadius = radius;
                }
            }
            
            self.currentDrawState.photoViewCornerRadiusIndexPath = indexPath;
            self.currentDrawState.photoBorderViewCornerRadiusIndexPath = indexPath;
        }
            break;
        case LSThemeElementSlider: {
            self.slideViewCornerRadius = radius;
            self.currentDrawState.slideViewCornerRadiusIndexPath = indexPath;
        }
            break;
        default:
            break;
    }
}

- (void)setColor:(UIColor*)color indexPath:(NSIndexPath*)indexPath forElements:(LSThemeElement)element {
    switch (element) {
        case LSThemeElementClock: {
            self.clockViewColor = color;
            self.clockViewImage = nil;
            self.currentDrawState.clockViewColorIndexPath = indexPath;
        }
            break;
        case LSThemeElementSlider: {
            self.slideViewColor = color;
            self.slideViewImage = nil;
            self.currentDrawState.slideViewColorIndexPath = indexPath;
        }
            break;
        case LSThemeElementPhotoBorder: {
            self.photoBorderViewColor = color;
            self.photoBorderViewImage = nil;
            self.currentDrawState.photoBorderViewColorIndexPath = indexPath;
        }
            break;
        case LSThemeElementBackground: {
            self.mainBackgroundColor = color;
            self.mainBackgroundImage = nil;
            self.currentDrawState.mainBackgroundColorIndexPath = indexPath;
        }
            break;
        default: break;
    }
}

- (void)setImage:(UIImage*)image indexPath:(NSIndexPath*)indexPath forElements:(LSThemeElement)element {
    switch (element) {
        case LSThemeElementClock: {
            self.clockViewImage = image;
            self.currentDrawState.clockViewImageIndexPath = indexPath;
        }
            break;
        case LSThemeElementSlider: {
            self.slideViewImage = image;
            self.currentDrawState.slideViewImageIndexPath = indexPath;
        }
            break;
        case LSThemeElementPhotoBorder: {
            self.photoBorderViewImage = image;
            self.currentDrawState.photoBorderViewImageIndexPath = indexPath;
        }
            break;
        case LSThemeElementBackground: {
            self.mainBackgroundImage = image;
            self.currentDrawState.mainBackgroundImageIndexPath = indexPath;
        }
            break;
        default: break;
    }
}

- (CGFloat)cornerRadiusForElement:(LSThemeElement)element {
    switch (element) {
        case LSThemeElementClock: {
            return self.clockViewCornerRadius;
        }
        case LSThemeElementSlider: {
            return self.slideViewCornerRadius;
        }
        case LSThemeElementPhotoBorder: {
            return self.photoBorderViewCornerRadius;
        }
        case LSThemeElementPhoto: {
            return self.photoViewCornerRadius;
        }
        case LSThemeElementBackground: {
            return 0.0;
        }
        default: break;
    }
}

@end
