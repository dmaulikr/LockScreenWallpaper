//
//  LSEtalonSheme.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/12/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSEtalonScheme.h"
#import "LSEtalonScheme35.h"
#import "LSEtalonScheme40.h"
#import "LSEtalonScheme47.h"
#import "LSEtalonScheme55.h"
#import <QuartzCore/QuartzCore.h>

#define SHADOW_RADIUS               2.0
#define SHADOW_OPACITY              0.5
#define SHADOW_OFFSET_CLOCK         2.0
#define SHADOW_OFFSET_PHOTO         4.0

@interface LSEtalonScheme()
    
@property (nonatomic, assign) CGRect            designViewFrame;
@property (nonatomic, assign) CGRect            originalViewFrame;

@end

@implementation LSEtalonScheme

+ (LSEtalonScheme*)createForDeviceType:(LSDeviceType)type designViewFrame:(CGRect)viewFrame originalFrame:(CGRect)originalFrame
{
    LSEtalonScheme *retScheme = nil;
    
    switch (type) {
        case LSDevice_iPod4:
        case LSDevice_iPhone4:
            retScheme = [[LSEtalonScheme35 alloc] init];
            break;
        case LSDevice_iPhone5c:
        case LSDevice_iPhone5s:
        case LSDevice_iPod5:
            retScheme = [[LSEtalonScheme40 alloc] init];
            break;
        case LSDevice_iPhone6:
            retScheme = [[LSEtalonScheme47 alloc] init];
            break;
        case LSDevice_iPhone6P:
            retScheme = [[LSEtalonScheme55 alloc] init];
            break;
        default: break;
    }

    retScheme.deviceType = type;
    retScheme.designViewFrame = viewFrame;
    retScheme.originalViewFrame = originalFrame;
    
    return retScheme;
}

- (CGRect)frameForClockView {
    return CGRectZero;
}

- (CGRect)frameForPhotoView {
    return CGRectZero;
}

- (CGRect)frameForSlideView {
    return CGRectZero;
}

- (CGRect)frameForPhotoBorderView {
    return CGRectZero;
}

- (UIView*)shadowViewForClockOrSlideView {
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowRadius   = SHADOW_RADIUS;
    shadowView.layer.shadowOpacity  = SHADOW_OPACITY;
    shadowView.layer.shadowOffset   = CGSizeMake(SHADOW_OFFSET_CLOCK, SHADOW_OFFSET_CLOCK);
    return shadowView;
}

- (UIView*)shadowViewForPhotoOrBorderView {
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowRadius   = SHADOW_RADIUS;
    shadowView.layer.shadowOpacity  = SHADOW_OPACITY;
    shadowView.layer.shadowOffset   = CGSizeMake(SHADOW_OFFSET_PHOTO, SHADOW_OFFSET_PHOTO);
    return shadowView;
}

- (CGRect)scaledFrameForClockView {
    return [self scaleRect:[self frameForClockView]];
}

- (CGRect)scaledFrameForPhotoView {
    return [self scaleRect:[self frameForPhotoView]];
}

- (CGRect)scaledFrameForSlideView {
    return [self scaleRect:[self frameForSlideView]];
}

- (CGRect)scaledFrameForPhotoBorderView {
    return [self scaleRect:[self frameForPhotoBorderView]];
}

- (UIView*)scaledShadowViewForClockOrSlideView {
    float dX = 0.0;
    dX = self.designViewFrame.size.width / self.originalViewFrame.size.width;
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowRadius   = SHADOW_RADIUS*dX;
    shadowView.layer.shadowOpacity  = SHADOW_OPACITY*dX;
    shadowView.layer.shadowOffset   = CGSizeMake(SHADOW_OFFSET_CLOCK*dX, SHADOW_OFFSET_CLOCK*dX);
    
    return shadowView;
}
- (UIView*)scaledShadowViewForPhotoOrBorderView {
    float dX = 0.0;
    dX = self.designViewFrame.size.width / self.originalViewFrame.size.width;
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 10.0, 10.0)];
    shadowView.backgroundColor = [UIColor whiteColor];
    shadowView.layer.shadowRadius   = SHADOW_RADIUS*dX;
    shadowView.layer.shadowOpacity  = SHADOW_OPACITY*dX;
    shadowView.layer.shadowOffset   = CGSizeMake(SHADOW_OFFSET_PHOTO*dX, SHADOW_OFFSET_PHOTO*dX);
    
    return shadowView;
}

- (CGRect)scaleRect:(CGRect)currentRect {
    float dX = 0.0, dY = 0.0;
    
    dX = self.designViewFrame.size.width / self.originalViewFrame.size.width;
    dY = self.designViewFrame.size.height / self.originalViewFrame.size.height;
    
    currentRect.origin.x *= dX;
    currentRect.origin.y *= dY;
    currentRect.size.width *= dX;
    currentRect.size.height *= dY;
    
    return currentRect;
}

- (CGFloat)scaleCornerRadiusFrom:(CGFloat)radius {
    CGFloat dX = self.designViewFrame.size.width / self.originalViewFrame.size.width;
    return radius * dX;
}

@end
