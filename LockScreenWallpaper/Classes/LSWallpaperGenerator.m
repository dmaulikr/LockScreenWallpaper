//
//  LSWallpaperGenerator.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/12/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSWallpaperGenerator.h"
#import "LSDeviceInformation.h"
#import "LSEtalonScheme.h"
#import "UIImage+Additions.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <QuartzCore/QuartzCore.h>

#define PHOTOT_ALBUM_NAME               @"LockyS Wallpapers"

@interface LSWallpaperGenerator() {
    LSDesignViewScheme          *_designViewScheme;
    ALAssetsLibrary             *_library;
}

@end

@implementation LSWallpaperGenerator

- (instancetype)initWithDrawScheme:(LSDesignViewScheme*)designViewScheme {
    self = [super init];
    
    if (self) {
        _designViewScheme   = designViewScheme;
        _library            = [[ALAssetsLibrary alloc] init];
        [self setupViewFrames];
    }
    
    return self;
}

- (LSWallpaperView*)generateWallpaperViewWithFakeElements:(BOOL)fake {
    LSDrawScheme *_drawScheme           = _designViewScheme.drawScheme;
    LSEtalonScheme *_etalonDrawScheme   = _designViewScheme.etalonScheme;
    
    LSWallpaperView *view = [[LSWallpaperView alloc] initWithFrame:_drawScheme.mainFrame];
    
    UIColor *shadowColor = [_drawScheme.mainBackgroundColor isEqualToColor:[UIColor blackColor]] ? [UIColor grayColor] : [UIColor blackColor];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:view.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.backgroundColor = _drawScheme.mainBackgroundColor;
    if(_drawScheme.mainBackgroundImage)
        backgroundImageView.image = _drawScheme.mainBackgroundImage;
    [view addSubview:backgroundImageView];
    
    if(fake) {
        CGFloat width, height;
        width = CGRectGetWidth(view.frame);
        height = 20.0;
        CGRect statusBarFrame = CGRectMake(0.0, 0.0, width, height);
        UIImageView *statusBarImageView = [[UIImageView alloc] initWithFrame:statusBarFrame];
        LSDeviceDisplayInch screenInfo = [LSDeviceInformation displayInch];
        NSString *imgName = @"";
        switch (screenInfo) {
            case LSDeviceDisplay55:
                imgName = @"MStatusBar6P";
                break;
            case LSDeviceDisplay47:
                imgName = @"MStatusBar6";
                break;
            default:
                imgName = @"MStatusBar";
                break;
        }
        
        statusBarImageView.contentMode = UIViewContentModeScaleAspectFill;
        statusBarImageView.image = [UIImage imageNamed:imgName];
        statusBarImageView.backgroundColor = [UIColor clearColor];
        [view addSubview:statusBarImageView];
        
        UIImageView *clockOnBackgroundImageView = [[UIImageView alloc] initWithFrame:_drawScheme.clockViewFrame];
        clockOnBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        clockOnBackgroundImageView.image = [UIImage imageNamed:@"MClockImage"];
        clockOnBackgroundImageView.backgroundColor = [UIColor clearColor];
        [view addSubview:clockOnBackgroundImageView];
        
        UIImageView *slideOnBackgroundImageView = [[UIImageView alloc] initWithFrame:_drawScheme.slideViewFrame];
        slideOnBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        slideOnBackgroundImageView.image = [UIImage imageNamed:@"MSlideImage"];
        slideOnBackgroundImageView.backgroundColor = [UIColor clearColor];
        [view addSubview:slideOnBackgroundImageView];
    }
    
    if (_drawScheme.clockViewCornerRadius >= 0.0) {
        UIImageView *clockView = [[UIImageView alloc] initWithFrame:_drawScheme.clockViewFrame];
        clockView.contentMode = UIViewContentModeScaleAspectFill;
        clockView.layer.masksToBounds = YES;
        
        clockView.layer.cornerRadius = _drawScheme.clockViewCornerRadius;
        clockView.backgroundColor = _drawScheme.clockViewColor;
        if(_drawScheme.clockViewImage)
            clockView.image = _drawScheme.clockViewImage;
        
        UIView *shadowView              = _etalonDrawScheme.shadowViewForClockOrSlideView;
        shadowView.frame                = _drawScheme.clockViewFrame;
        shadowView.layer.cornerRadius   = _drawScheme.clockViewCornerRadius;
        shadowView.layer.shadowColor    = shadowColor.CGColor;

        [view addSubview:shadowView];
        [view addSubview:clockView];
        
        if(fake)
        {
            UIImageView *clockOnClockImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(clockView.frame), CGRectGetHeight(clockView.frame))];
            clockOnClockImageView.contentMode = UIViewContentModeScaleAspectFit;
            clockOnClockImageView.image = [UIImage imageNamed:@"MClockImage"];
            clockOnClockImageView.backgroundColor = [UIColor clearColor];
            [clockView addSubview:clockOnClockImageView];
        }
    }
    
    if (_drawScheme.slideViewCornerRadius >= 0.0) {
        UIImageView *slideView = [[UIImageView alloc] initWithFrame:_drawScheme.slideViewFrame];
        slideView.contentMode = UIViewContentModeScaleAspectFill;
        slideView.layer.masksToBounds = YES;
        slideView.layer.cornerRadius = _drawScheme.slideViewCornerRadius;
        slideView.backgroundColor = _drawScheme.slideViewColor;
        if(_drawScheme.slideViewImage)
            slideView.image = _drawScheme.slideViewImage;
        
        UIView *shadowView              = _etalonDrawScheme.shadowViewForClockOrSlideView;
        shadowView.frame                = _drawScheme.slideViewFrame;
        shadowView.layer.cornerRadius   = _drawScheme.slideViewCornerRadius;
        shadowView.layer.shadowColor    = shadowColor.CGColor;
        
        [view addSubview:shadowView];
        [view addSubview:slideView];
        
        if(fake)
        {
            UIImageView *slideOnSlideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(slideView.frame), CGRectGetHeight(slideView.frame))];
            slideOnSlideImageView.contentMode = UIViewContentModeScaleAspectFit;
            slideOnSlideImageView.image = [UIImage imageNamed:@"MSlideImage"];
            slideOnSlideImageView.backgroundColor = [UIColor clearColor];
            [slideView addSubview:slideOnSlideImageView];
        }
    }
    
    if (_drawScheme.photoBorderViewCornerRadius >= 0.0) {
        UIImageView *borderView         = [[UIImageView alloc] initWithFrame:_drawScheme.photoBorderViewFrame];
        borderView.contentMode          = UIViewContentModeScaleAspectFill;
        borderView.layer.masksToBounds  = YES;
        borderView.layer.cornerRadius   = _drawScheme.photoBorderViewCornerRadius;
        borderView.backgroundColor      = _drawScheme.photoBorderViewColor;

        if (_drawScheme.photoBorderViewImage)
            borderView.image = _drawScheme.photoBorderViewImage;
        
        UIView *shadowView              = _etalonDrawScheme.shadowViewForPhotoOrBorderView;
        shadowView.frame                = _drawScheme.photoBorderViewFrame;
        shadowView.layer.cornerRadius   = _drawScheme.photoBorderViewCornerRadius;
        shadowView.layer.shadowColor    = shadowColor.CGColor;
        
        [view addSubview:shadowView];
        [view addSubview:borderView];
    }
    
    if (_drawScheme.photoViewCornerRadius >= 0.0) {
        UIImageView *photoImage = [[UIImageView alloc] initWithFrame:_drawScheme.photoViewFrame];
        photoImage.layer.masksToBounds = YES;
        photoImage.image = _drawScheme.photoViewImage;
        photoImage.layer.cornerRadius = _drawScheme.photoViewCornerRadius;
        
        if (_drawScheme.photoBorderViewCornerRadius < 0.0) {
            UIView *shadowView              = _etalonDrawScheme.shadowViewForPhotoOrBorderView;
            shadowView.frame                = _drawScheme.photoViewFrame;
            shadowView.layer.cornerRadius   = _drawScheme.photoViewCornerRadius;
            shadowView.layer.shadowColor    = shadowColor.CGColor;
            
            [view addSubview:shadowView];
        }
        [view addSubview:photoImage];
    }
    
    return view;
}

- (UIImage*)generateImage {
    return [UIImage imageWithView:[self generateWallpaperViewWithFakeElements:NO]];
}

- (UIImage*)generateImageForSharing {
    UIImage *image = [UIImage imageWithView:[self generateWallpaperViewWithFakeElements:YES]];
    
    CGSize imageSize = image.size;
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0,0,imageSize.width,imageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)saveImage:(UIImage*)image withCompletion:(void(^)(NSError *error))completion {
    [_library saveImage:image toAlbum:PHOTOT_ALBUM_NAME withCompletionBlock:^(NSError *error) {
        if(completion)
            completion(error);
    }];
}

#pragma mark - Private Methods

- (void)setupViewFrames {
    LSDrawScheme *_drawScheme = _designViewScheme.drawScheme;
    LSEtalonScheme *_etalonScheme = _designViewScheme.etalonScheme;
    
    _drawScheme.mainFrame           = _designViewScheme.originViewFrame;
    _drawScheme.clockViewFrame = _etalonScheme.frameForClockView;
    _drawScheme.slideViewFrame = _etalonScheme.frameForSlideView;
    _drawScheme.photoViewFrame = _etalonScheme.frameForPhotoView;
    _drawScheme.photoBorderViewFrame = _etalonScheme.frameForPhotoBorderView;
}

@end
