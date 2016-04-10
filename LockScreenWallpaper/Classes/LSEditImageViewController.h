//
//  LSEditImageViewController.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/25/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSEditImageFrame
@required
@property(nonatomic,assign) CGRect cropRect;
@end

@class  LSEditImageViewController;

@protocol LSEditImageViewControllerDelegate <NSObject>

- (void)editImageViewController:(LSEditImageViewController*)viewController didPressRetakeButton:(UIButton*)button;
- (void)editImageViewController:(LSEditImageViewController*)viewController didPressUseImageButton:(UIButton*)button withImage:(UIImage*)image;

@end

typedef void(^LSEditImageDoneCallback)(UIImage *image, BOOL canceled);

@interface LSEditImageViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<LSEditImageViewControllerDelegate>   delegate;

@property(nonatomic,copy) LSEditImageDoneCallback doneCallback;
@property(nonatomic,copy) UIImage *sourceImage;
@property(nonatomic,copy) UIImage *previewImage;
@property(nonatomic,assign) CGSize cropSize;
@property(nonatomic,assign) CGRect cropRect;
@property(nonatomic,assign) CGFloat outputWidth;
@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;

@property(nonatomic,assign) BOOL panEnabled;
@property(nonatomic,assign) BOOL rotateEnabled;
@property(nonatomic,assign) BOOL scaleEnabled;
@property(nonatomic,assign) BOOL tapToResetEnabled;
@property(nonatomic,assign) BOOL checkBounds;

@property(nonatomic,readonly) CGRect cropBoundsInSourceImage;

- (void)reset:(BOOL)animated;

- (void)prepareControlsView;
- (void)showControlsWithCompletion:(void(^)(void))completion;
- (void)hideControlsWithCompletion:(void(^)(void))completion;

@end
