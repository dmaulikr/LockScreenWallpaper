//
//  LSImageEditorViewController.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/26/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "HFImageEditorViewController.h"

@class  LSImageEditorViewController;

@protocol LSImageEditorViewControllerDelegate <NSObject>

- (void)editImageViewController:(LSImageEditorViewController*)viewController didPressRetakeButton:(UIButton*)button;
- (void)editImageViewController:(LSImageEditorViewController*)viewController didPressUseImageButton:(UIButton*)button withImage:(UIImage*)image;

@end

@interface LSImageEditorViewController : HFImageEditorViewController

@property (nonatomic, weak) id<LSImageEditorViewControllerDelegate>                 delegate;

- (void)prepareControlsView;
- (void)showControlsWithCompletion:(void(^)(void))completion;
- (void)hideControlsWithCompletion:(void(^)(void))completion;

@end
