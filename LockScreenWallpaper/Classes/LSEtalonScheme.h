//
//  LSEtalonSheme.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/12/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSEtalonScheme : NSObject {
    CGRect      _frameForClockView;
    CGRect      _frameForPhotoView;
    CGRect      _frameForSlideView;
    CGRect      _frameForClockBorderView;
    CGRect      _frameForPhotoBorderView;
    CGRect      _frameForSlideBorderView;
}

@property (nonatomic, assign) LSDeviceType      deviceType;

+ (LSEtalonScheme*)createForDeviceType:(LSDeviceType)type designViewFrame:(CGRect)viewFrame originalFrame:(CGRect)originalFrame;

- (CGRect)frameForClockView;
- (CGRect)frameForPhotoView;
- (CGRect)frameForSlideView;
- (CGRect)frameForPhotoBorderView;

- (UIView*)shadowViewForClockOrSlideView;
- (UIView*)shadowViewForPhotoOrBorderView;

- (CGRect)scaledFrameForClockView;
- (CGRect)scaledFrameForPhotoView;
- (CGRect)scaledFrameForSlideView;
- (CGRect)scaledFrameForPhotoBorderView;

- (UIView*)scaledShadowViewForClockOrSlideView;
- (UIView*)scaledShadowViewForPhotoOrBorderView;

- (CGRect)scaleRect:(CGRect)currentRect;
- (CGFloat)scaleCornerRadiusFrom:(CGFloat)radius;

@end
