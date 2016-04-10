//
//  LSDesignViewController.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDesignViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LSThemeManager.h"
#import "LSDeviceInformation.h"
#import "LSElementsView.h"
#import "LSDesignViewScheme.h"
#import "LSWallpaperView.h"
#import "LSWallpaperGenerator.h"
#import "LSThemesViewController.h"
#import "LSDesignToThemeTransition.h"
#import "UIViewController+CreateViewController.h"
#import "LSPhotoMenu.h"
#import "LSDesignToImagePickerTransition.h"
#import "LSImagePickerToImageEditorTransition.h"
#import "UIImagePickerController+NavigationBar.h"
#import "LSImageEditorViewController.h"
#import "UIImage+Additions.h"
#import "LSDesignElementShape.h"
#import "LSOnboardView.h"
#import "LSShareMenu.h"
#import "LSShareManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define FULLSCREEN_ANIMATION_DURATION           0.5
#define IMAGE_SAVE_SUCCESS_ALERT_TAG            739
#define IMAGE_SAVE_INFO_ALERT_TAG               732

@interface LSDesignViewController ()   <LSElementsViewDelegate,
LSElementColorViewDelegate,
LSElementStyleViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
LSPhotoMenuDelegate,
LSImageEditorViewControllerDelegate,
UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) LSThemeManager                                *themeManager;
@property (nonatomic, strong) LSDesignViewScheme                            *designViewScheme;
@property (nonatomic, strong) LSWallpaperGenerator                          *wallpaperGenerator;
@property (nonatomic, strong) LSDrawScheme                                  *drawScheme;
@property (nonatomic, assign) LSThemeElement                                 currentEditingElement;
@property (nonatomic, strong) LSShareManager                                *shareManager;

@property (nonatomic, strong) LSDesignToThemeTransition                     *transitionDelegate;
@property (nonatomic, strong) LSDesignToImagePickerTransition               *imagePickerTransitionDelegate;
@property (nonatomic, strong) LSImagePickerToImageEditorTransition          *editImageTransitionDelegate;

@property (nonatomic, strong) UIImageView                                   *fakeScreen;
@property (nonatomic, strong) UIImagePickerController                       *imagePickerController;
@property (nonatomic, strong) LSPhotoMenu                                   *photoMenu;

@property (nonatomic, assign) BOOL                                           startApp;
@property (nonatomic, assign) BOOL                                           blockElementRedraw;
@property (nonatomic, assign) BOOL                                           blockColorsReload;

//---- Preview Wallpaper
@property (nonatomic, strong) LSWallpaperView           *previewWallpaper;
@property (nonatomic, strong) CAAnimationGroup          *elementsViewFullScreenAnimations;
@property (nonatomic, strong) CABasicAnimation          *phoneImageFullScreenAnimation;
@property (nonatomic, strong) CAAnimationGroup          *elementsViewNonFullScreenAnimations;
@property (nonatomic, strong) CABasicAnimation          *phoneImageNonFullScreenAnimation;
@property (nonatomic, assign) CATransform3D              phoneImageLayerOriginalTransform;
@property (nonatomic, assign) CATransform3D              elementsLayerOriginalTransform;
@property (nonatomic, assign) CGPoint                    elementsLayerOriginalPosition;
//----

//---- Show/Hide Controls
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *saveButtonTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phototButtonSideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorsViewSideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorsCollectionViewSideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullscreenButtonSideConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *styleViewBottomConstraint;
//----

@end

@implementation LSDesignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shareManager           = [LSShareManager new];
    self.phoneImageView.image   = [LSDeviceInformation deviceImage];
    self.themeManager           = [LSThemeManager sharedManager];
    self.designViewScheme       = [[LSDesignViewScheme alloc] initWithDeviceType:[LSDeviceInformation currentDeviceType]];
    self.wallpaperGenerator             = [[LSWallpaperGenerator alloc] initWithDrawScheme:self.designViewScheme];
    self.themeManager.currentThemeModel = [LSThemeModel themeModelWithType:LSThemePlain];
    self.currentTheme                   = self.themeManager.currentThemeModel;
    
    self.elementsView.delegate          = self;
    self.elementsView.designViewScheme  = self.designViewScheme;
    
    self.elementsColorView.colorViewDelegate            = self;
    self.elementsColorCollectionView.colorViewDelegate  = self;
    self.elementsStyleView.elementViewDelegate          = self;
    
    [self setupUIForCurrentDevice];
    
    self.blockElementRedraw     = NO;
    self.startApp               = YES;
    self.blockColorsReload      = NO;
    self.elementsView.alpha     = 0.0;
    self.phoneImageView.alpha   = 0.0;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.elementsView.drawScheme = self.drawScheme;
    self.elementsView.frame = self.designViewScheme.designViewFrame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.themeManager.themeWasChanged) {
        self.currentTheme                       = self.themeManager.currentThemeModel;
        self.drawScheme                         = self.themeManager.currentThemeModel.defaultDrawScheme;
        
        self.designViewScheme.drawScheme        = self.drawScheme;
        self.elementsView.drawScheme            = self.drawScheme;
        self.wallpaperGenerator                 = [[LSWallpaperGenerator alloc] initWithDrawScheme:self.designViewScheme];
        self.currentEditingElement              = LSThemeElementClock;
        self.elementsView.currentThemeElement   = self.currentEditingElement;
        
        [self setupInitialThemeState];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.startApp) {
        self.startApp = NO;
        [UIView animateWithDuration:0.8 animations:^{
            self.elementsView.alpha = 1.0;
            self.phoneImageView.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    
    if (self.themeManager.themeWasChanged) {
        [self.elementsColorView showCells];
        [self.elementsColorCollectionView showCells];
        [self setupInitialThemeState];
        self.drawScheme.currentDrawState        = [self.currentTheme.initialDrawState copy];
        [self setupViewForThemeElement:self.currentEditingElement animation:NO];
        
        self.themeManager.themeWasChanged = NO;
    }
    
    if(LSIsFirstLaunchWithKey(VERSION_1_0_ONBOARD)) {
        LSIsFirstLaunchWithKey(VERSION_1_1_ONBOARD);
        LSOnboardView *view = [[LSOnboardView alloc] initWithDesignViewController:self];
        [view showInstruction];
    } else if (LSIsFirstLaunchWithKey(VERSION_1_1_ONBOARD)) {
        LSOnboardView *view = [[LSOnboardView alloc] initWithDesignViewController:self];
        [view showTips];
    }
}

- (LSDesignToThemeTransition*)transitionDelegate {
    if (_transitionDelegate)
        return _transitionDelegate;
    _transitionDelegate = [LSDesignToThemeTransition new];
    return _transitionDelegate;
}

- (LSDesignToImagePickerTransition*)imagePickerTransitionDelegate {
    if (_imagePickerTransitionDelegate)
        return _imagePickerTransitionDelegate;
    _imagePickerTransitionDelegate = [LSDesignToImagePickerTransition new];
    return _imagePickerTransitionDelegate;
}

- (LSImagePickerToImageEditorTransition*)editImageTransitionDelegate {
    if (_editImageTransitionDelegate)
        return _editImageTransitionDelegate;
    _editImageTransitionDelegate = [LSImagePickerToImageEditorTransition new];
    return _editImageTransitionDelegate;
}

- (UIImagePickerController*)imagePickerController {
    if (_imagePickerController)
        return _imagePickerController;
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.transitioningDelegate = self.imagePickerTransitionDelegate;
    
    return _imagePickerController;
}

- (LSPhotoMenu*)photoMenu {
    if (_photoMenu)
        return _photoMenu;
    
    _photoMenu = [[LSPhotoMenu alloc] initWithFrame:self.view.bounds];
    _photoMenu.delegate = self;
    return _photoMenu;
}

- (IBAction)themesButtonPushed:(UIButton *)sender {
    LSThemesViewController *vc  = (LSThemesViewController*)[UIViewController loadViewControllerFromStoryBoardWithIdentifier:@"LSThemesViewController"];
    vc.designViewController     = self;
    vc.transitioningDelegate    = self.transitionDelegate;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)saveButtonPushed:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        UIImage *image = [self.wallpaperGenerator generateImage];
        [self.wallpaperGenerator saveImage:image withCompletion:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide:YES];
                self.view.userInteractionEnabled = YES;
                if(error) {
                    DLog(@"Error: %@", error);
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                 message:@"Failed to create wallpaper. Check access to your gallery in system settings."
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                    [av show];
                } else {
                    if(LSIsFirstLaunchWithKey(VERSION_1_0_SAVE_INFO)) {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
                                                                     message:NSLocalizedString(@"You should disable parallax effect for the best view. Go to Settings - General - Accessibility - Reduce Motion. After setup new wallpaper.", @"")
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                           otherButtonTitles:nil];
                        av.tag = IMAGE_SAVE_INFO_ALERT_TAG;
                        [av show];
                    } else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                     message:@"Wallpaper saved to your photo library. Do you want to share with Facebook friends?"
                                                                    delegate:self
                                                           cancelButtonTitle:@"Cancel"
                                                           otherButtonTitles:@"Share", nil];
                        av.tag = IMAGE_SAVE_SUCCESS_ALERT_TAG;
                        [av show];
                    }
                }
            });
        }];
    });
}

- (IBAction)phototButtonPushed:(UIButton *)sender {
    [self.view addSubview:self.photoMenu];
    self.photoMenu.userInteractionEnabled = NO;
    [self.photoMenu showPhotoMenuWithCompletion:^{
        self.photoMenu.userInteractionEnabled = YES;
    }];
}

#pragma mark - Preview Wallpaper

- (CABasicAnimation*)phoneImageFullScreenAnimation {
    if (_phoneImageFullScreenAnimation)
        return _phoneImageFullScreenAnimation;
    
    CGFloat multiplier = self.elementsView.bounds.size.height / self.view.bounds.size.height;
    self.phoneImageLayerOriginalTransform = self.phoneImageView.layer.transform;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = FULLSCREEN_ANIMATION_DURATION;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.phoneImageLayerOriginalTransform, 1/multiplier, 1/multiplier, 1.0)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    _phoneImageFullScreenAnimation = animation;
    
    return _phoneImageFullScreenAnimation;
}

- (CAAnimationGroup*)elementsViewFullScreenAnimations {
    if (_elementsViewFullScreenAnimations)
        return _elementsViewFullScreenAnimations;
    
    CGFloat multiplier = self.elementsView.bounds.size.height / self.view.bounds.size.height;
    self.elementsLayerOriginalTransform = self.previewWallpaper.layer.transform;
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.elementsLayerOriginalTransform, 1/multiplier, 1/multiplier, 1.0)];
    
    self.elementsLayerOriginalPosition = self.elementsView.center;
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.view.center];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = FULLSCREEN_ANIMATION_DURATION;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[transformAnimation, positionAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    _elementsViewFullScreenAnimations = group;
    
    return _elementsViewFullScreenAnimations;
}

- (CABasicAnimation*)phoneImageNonFullScreenAnimation {
    if (_phoneImageNonFullScreenAnimation)
        return _phoneImageNonFullScreenAnimation;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = FULLSCREEN_ANIMATION_DURATION;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.toValue = [NSValue valueWithCATransform3D:self.phoneImageLayerOriginalTransform];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    _phoneImageNonFullScreenAnimation = animation;
    
    return _phoneImageNonFullScreenAnimation;
}

- (CAAnimationGroup*)elementsViewNonFullScreenAnimations {
    if (_elementsViewNonFullScreenAnimations)
        return _elementsViewNonFullScreenAnimations;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.toValue = [NSValue valueWithCATransform3D:self.elementsLayerOriginalTransform];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.elementsLayerOriginalPosition];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = FULLSCREEN_ANIMATION_DURATION;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[transformAnimation, positionAnimation];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    _elementsViewNonFullScreenAnimations = group;
    
    return _elementsViewNonFullScreenAnimations;
}

- (IBAction)fullScreenButtonPushed:(UIButton *)sender {
    self.view.userInteractionEnabled = NO;
    
    [self showControls:NO completion:^{
        self.previewWallpaper = [self.wallpaperGenerator generateWallpaperViewWithFakeElements:YES];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFromFullScreen:)];
        tapGesture.numberOfTapsRequired = 2;
        [self.previewWallpaper addGestureRecognizer:tapGesture];
        
        self.phoneImageFullScreenAnimation.delegate = self;
        [self.phoneImageView.layer addAnimation:self.phoneImageFullScreenAnimation forKey:@"PhoneImageFullScreenAnimation"];
        [self.elementsView.layer addAnimation:self.elementsViewFullScreenAnimations forKey:@"ElementsViewFullScreenAnimations"];
    }];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (flag && self.previewWallpaper) {
        [self.view addSubview:self.previewWallpaper];
        self.view.userInteractionEnabled = YES;
        self.phoneImageFullScreenAnimation.delegate = nil;
        if(LSIsFirstLaunchWithKey(VERSION_1_0_FULL_SCREEN_ALERT)) {
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:NSLocalizedString(@"Double tap to return to the editing mode.", @"")
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"")
                              otherButtonTitles:nil] show];
        }
    } else {
        [self showControls:YES completion:^{
            self.view.userInteractionEnabled = YES;
            self.phoneImageNonFullScreenAnimation.delegate = nil;
        }];
    }
}

- (void)backFromFullScreen:(UITapGestureRecognizer*)recognizer {
    self.phoneImageNonFullScreenAnimation.delegate = self;
    [self.phoneImageView.layer addAnimation:self.phoneImageNonFullScreenAnimation forKey:@"PhoneImageNonFullScreenAnimation"];
    [self.elementsView.layer addAnimation:self.elementsViewNonFullScreenAnimations forKey:@"ElementsViewNonFullScreenAnimations"];
    [self.previewWallpaper removeFromSuperview];
    self.previewWallpaper = nil;
}

#pragma mark - Show/Hide Controls

- (void)showControls:(BOOL)show completion:(void(^)(void))completion {
    [self showTopControls:show          animation:YES completion:completion];
    [self showFullScreenControl:show    animation:YES completion:nil];
    
    if (show) {
        [self setupViewForThemeElement:self.currentEditingElement animation:YES];
    } else {
        [self showColorControls:show        animation:YES completion:nil];
        [self showPhotoControl:show         animation:YES completion:nil];
        [self showStyleControl:show         animation:YES completion:nil];
    }
}

- (void)showTopControls:(BOOL)show animation:(BOOL)animation completion:(void(^)(void))completion {
    if(show) {
        self.themeButtonTopConstraint.constant  = 15.0;
        self.saveButtonTopConstraint.constant   = 15.0;
    } else {
        self.themeButtonTopConstraint.constant  = -(self.themesButton.frame.size.height + 5);
        self.saveButtonTopConstraint.constant   = -(self.saveButton.frame.size.height + 5);
    }
    
    if(animation) {
        UIViewAnimationOptions options;
        if(show) options = UIViewAnimationOptionCurveEaseIn;
        else options = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:options
                         animations:^{
                             [self.themesButton                 layoutIfNeeded];
                             [self.saveButton                   layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        [self.themesButton                 layoutIfNeeded];
        [self.saveButton                   layoutIfNeeded];
        if(completion)
            completion();
    }
}

- (void)showColorControls:(BOOL)show animation:(BOOL)animation completion:(void(^)(void))completion {
    if(show) {
        self.colorsViewSideConstraint.constant              = 13.0;
        self.colorsCollectionViewSideConstraint.constant    = 13.0;
    } else {
        self.colorsViewSideConstraint.constant              = -(self.elementsColorView.frame.size.width + 5);
        self.colorsCollectionViewSideConstraint.constant    = -(self.elementsColorCollectionView.frame.size.width + 5);
    }
    
    if(animation) {
        UIViewAnimationOptions options;
        if(show) options = UIViewAnimationOptionCurveEaseIn;
        else options = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:options
                         animations:^{
                             [self.elementsColorView            layoutIfNeeded];
                             [self.elementsColorCollectionView  layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        [self.elementsColorView            layoutIfNeeded];
        [self.elementsColorCollectionView  layoutIfNeeded];
        if(completion)
            completion();
    }
}

- (void)showFullScreenControl:(BOOL)show animation:(BOOL)animation completion:(void(^)(void))completion {
    if(show) {
        self.fullscreenButtonSideConstraint.constant        = 15.0;
    } else {
        self.fullscreenButtonSideConstraint.constant        = -(self.fullScreenButton.frame.size.width + 5);
    }
    
    if(animation) {
        UIViewAnimationOptions options;
        if(show) options = UIViewAnimationOptionCurveEaseIn;
        else options = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:options
                         animations:^{
                             [self.fullScreenButton             layoutIfNeeded];                         }
                         completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        [self.fullScreenButton             layoutIfNeeded];
        if(completion)
            completion();
    }
}

- (void)showPhotoControl:(BOOL)show animation:(BOOL)animation completion:(void(^)(void))completion {
    if (show) {
        self.phototButtonSideConstraint.constant = 15.0;
    } else {
        self.phototButtonSideConstraint.constant = -(self.photoButton.frame.size.width + 5);
    }
    
    if(animation) {
        UIViewAnimationOptions options;
        if(show) options = UIViewAnimationOptionCurveEaseIn;
        else options = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:options
                         animations:^{
                             [self.photoButton                 layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        [self.photoButton                 layoutIfNeeded];
        if(completion)
            completion();
    }
}

- (void)showStyleControl:(BOOL)show animation:(BOOL)animation completion:(void(^)(void))completion {
    if(show) {
        self.styleViewBottomConstraint.constant = 0.0;
    } else {
        self.styleViewBottomConstraint.constant = -(self.elementsStyleView.frame.size.height + 5);
    }
    
    if(animation) {
        UIViewAnimationOptions options;
        if(show) options = UIViewAnimationOptionCurveEaseIn;
        else options = UIViewAnimationOptionCurveEaseOut;
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options:options
                         animations:^{
                             [self.elementsStyleView            layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             if (completion)
                                 completion();
                         }];
    } else {
        [self.elementsStyleView            layoutIfNeeded];
        if(completion)
            completion();
    }
}

#pragma mark - LSPhotoMenuDelegate

- (void)didPressGalleryButtonPhotoMenu:(LSPhotoMenu *)phototMenu {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:self.imagePickerController animated:YES completion:^{
            [phototMenu hidePhotoMenuWithCompletion:^{[phototMenu removeFromSuperview];}];
        }];
    } else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                     message:@"You don't have access to the gallery"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

- (void)didPressPhototButtonPhotoMenu:(LSPhotoMenu *)phototMenu {
    BOOL alert = NO;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus != AVAuthorizationStatusDenied) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            _imagePickerController.showsCameraControls = NO;
            [self presentViewController:self.imagePickerController animated:YES completion:^{
                [phototMenu hidePhotoMenuWithCompletion:^{[phototMenu removeFromSuperview];}];
            }];
        } else {
            alert = YES;
        }
    } else {
        alert = YES;
    }
    
    if(alert) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                     message:@"You don't have access to the camera. Check it in system settings."
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [av show];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    BOOL isCamera = picker.sourceType == UIImagePickerControllerSourceTypeCamera ? YES : NO;
    if(isCamera) {
        if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
            CGSize imageSize = image.size;
            UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
            CGContextRef ctx = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(ctx, M_PI/2);
            CGContextTranslateCTM(ctx, 0, -imageSize.width);
            CGContextScaleCTM(ctx, imageSize.height/imageSize.width, imageSize.width/imageSize.height);
            CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, imageSize.width, imageSize.height), image.CGImage);
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    
    LSImageEditorViewController *vc = [[LSImageEditorViewController alloc] initWithNibName:@"LSImageEditorViewController" bundle:nil];
    vc.sourceImage = image;
    vc.delegate = self;
    vc.transitioningDelegate = self.editImageTransitionDelegate;
    
    self.fakeScreen = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.fakeScreen];
    if(isCamera) {
        [picker hideControlsWithCompletion:^{
            self.fakeScreen.image = [UIImage imageWithView:picker.view];
            [picker dismissViewControllerAnimated:NO completion:nil];
            [self presentViewController:vc animated:YES completion:^{
            }];
        }];
    } else {
        self.fakeScreen.image = [UIImage imageWithView:picker.view];
        [picker dismissViewControllerAnimated:NO completion:nil];
        [self presentViewController:vc animated:YES completion:^{
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LSEditImageViewControllerDelegate

- (void)editImageViewController:(LSImageEditorViewController *)viewController didPressRetakeButton:(UIButton *)button {
    [viewController dismissViewControllerAnimated:YES completion:^{
        [self presentViewController:self.imagePickerController animated:NO completion:^{
            [self.fakeScreen removeFromSuperview];
            
            BOOL isCamera = self.imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera ? YES : NO;
            if(isCamera)
                [self.imagePickerController showControlsWithCompletion:nil];
        }];
    }];
}

- (void)editImageViewController:(LSImageEditorViewController *)viewController didPressUseImageButton:(UIButton *)button withImage:(UIImage *)image {
    [self.fakeScreen removeFromSuperview];
    self.fakeScreen = nil;
    self.drawScheme.photoViewImage = image;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - LSElementsViewDelegate

- (void)elementsView:(LSElementsView *)elementsView willSelectThemeElements:(LSThemeElement)themeElement {
    self.view.userInteractionEnabled = NO;
}

- (void)elementsView:(LSElementsView *)elementsView didSelectThemeElements:(LSThemeElement)themeElement {
    self.view.userInteractionEnabled = YES;
    self.currentEditingElement = themeElement;
    [self setupViewForThemeElement:themeElement animation:YES];
}

#pragma mark - LSElementColorViewDelegate

- (NSInteger)numberOfColorElementsColorView:(LSElementColorView *)elementsColorView {
    NSArray *colorsCollections = [self.currentTheme colorsCollectionsForThemeElements:self.currentEditingElement];
    
    if(colorsCollections.count) {
        if(elementsColorView == self.elementsColorView)
        {
            return [colorsCollections count];
        } else {
            NSInteger index = self.elementsColorView.selectedIndexPath.row;
            NSArray *colors = colorsCollections[index];
            return (colors.count - 1);
        }
    }
    return 0;
}

- (UIColor*)elementsColorView:(LSElementColorView *)elementsColorView colorForIndexPath:(NSIndexPath *)indexPath {
    NSArray *colorsCollections = [self.currentTheme colorsCollectionsForThemeElements:self.currentEditingElement];
    
    if (colorsCollections.count) {
        if(elementsColorView == self.elementsColorView) {
            NSInteger index = indexPath.row;
            NSArray *colors = colorsCollections[index];
            return [colors firstObject];
        } else {
            if(self.blockColorsReload)
                return nil;
            NSInteger index = self.elementsColorView.selectedIndexPath.row;
            NSArray *colors = colorsCollections[index];
            [elementsColorView selectMiddleCellWithAnimation:NO];
            if((indexPath.row+1) >= colors.count)
                return colors[indexPath.row];
            else
                return colors[indexPath.row+1];
        }
    }
    
    return [UIColor blackColor];
}

- (void)elementsColorView:(LSElementColorView*)elementsColorView didSelectColorWithindexPath:(NSIndexPath*)indexPath {
    if(!self.blockElementRedraw) {
        if(elementsColorView == self.elementsColorView) {
            elementsColorView.selectedIndexPath = indexPath;
            if(self.blockColorsReload)
                return;
            [self.elementsColorCollectionView reloadData];
        } else {
            if([self.drawScheme cornerRadiusForElement:self.currentEditingElement] < 0.0) {
                [self.drawScheme setCornerRadius:0.0 indexPath:[NSIndexPath indexPathWithIndex:1] forElement:self.currentEditingElement];
                [self updateThemeStateForCurrentDrawState];
            }
            
            NSArray *colorsCollections = [self.currentTheme colorsCollectionsForThemeElements:self.currentEditingElement];
            NSInteger index = self.elementsColorView.selectedIndexPath.row;
            NSArray *colors = colorsCollections[index];
            UIColor *color = colors[indexPath.row+1];
            NSIndexPath *colorIndexPath = [[NSIndexPath indexPathWithIndex:self.elementsColorView.selectedIndexPath.row] indexPathByAddingIndex:indexPath.row];
            [self.drawScheme setColor:color indexPath:colorIndexPath forElements:self.currentEditingElement];
        }
    }
}

#pragma mark - LSElementStyleViewDelegate

- (NSInteger)numberOfElementsStyleView:(LSElementStyleView*)elementStyleView {
    if(elementStyleView.styleType == LSElementStyleShapes) {
        NSArray *shapes = [self.currentTheme shapesForThemeElements:self.currentEditingElement];
        return shapes.count;
    } else {
        NSArray *previews = [self.currentTheme imagesForThemeElements:self.currentEditingElement];
        return previews.count;
    }
    
    return 0;
}

- (UIImage*)elementsStyleView:(LSElementStyleView*)elementStyleView imageForIndexPath:(NSIndexPath*)indexPath {
    if(elementStyleView.styleType == LSElementStyleShapes) {
        NSArray *shapes = [self.currentTheme shapesForThemeElements:self.currentEditingElement];
        LSDesignElementShape *shape = shapes[indexPath.row];
        return shape.previewImage;
    } else {
        NSArray *previews = [self.currentTheme imagesForThemeElements:self.currentEditingElement];
        return previews[indexPath.row];
    }
    
    return nil;
}

- (void)elementsStyleView:(LSElementStyleView*)elementStyleView didSelectElementAtIndexPath:(NSIndexPath*)indexPath {
    if(!self.blockElementRedraw) {
        elementStyleView.userInteractionEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            elementStyleView.userInteractionEnabled = YES;
        });
        
        if(elementStyleView.styleType == LSElementStyleShapes) {
            NSArray *shapes = [self.currentTheme shapesForThemeElements:self.currentEditingElement];
            LSDesignElementShape *shape = shapes[indexPath.row];
            [self.drawScheme setCornerRadius:shape.curveRadius indexPath:[NSIndexPath indexPathWithIndex:indexPath.row] forElement:self.currentEditingElement];
            
            if(((self.currentEditingElement == LSThemeElementPhotoBorder) || (self.currentEditingElement == LSThemeElementPhoto)) && self.drawScheme.photoBorderViewImage) {
                NSIndexPath *imageIndexPath = [[NSIndexPath indexPathWithIndex:indexPath.row] indexPathByAddingIndex:[self.drawScheme.currentDrawState.photoBorderViewImageIndexPath indexAtPosition:0]];
                UIImage *image = [self.currentTheme imageForImageBorderWithIndexPath:imageIndexPath];
                [self.drawScheme setImage:image indexPath:self.drawScheme.currentDrawState.photoBorderViewImageIndexPath forElements:LSThemeElementPhotoBorder];
            }
        } else {
            if([self.drawScheme cornerRadiusForElement:self.currentEditingElement] < 0.0) {
                [self.drawScheme setCornerRadius:0.0 indexPath:[NSIndexPath indexPathWithIndex:1] forElement:self.currentEditingElement];
                [self updateThemeStateForCurrentDrawState];
            }
            
            UIImage *image = nil;
            if(self.currentEditingElement == LSThemeElementPhotoBorder) {
                NSIndexPath *imageIndexPath = [self.drawScheme.currentDrawState.photoBorderViewCornerRadiusIndexPath indexPathByAddingIndex:indexPath.row];
                image = [self.currentTheme imageForImageBorderWithIndexPath:imageIndexPath];
            } else {
                image = [self.currentTheme imageForThemeElements:self.currentEditingElement index:indexPath.row];
            }
            [self.drawScheme setImage:image indexPath:[NSIndexPath indexPathWithIndex:indexPath.row] forElements:self.currentEditingElement];
        }
    }
}

- (void)elementsStyleView:(LSElementStyleView*)elementStyleView didChangeStyleType:(LSElementStyleType)newType {
    elementStyleView.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        elementStyleView.userInteractionEnabled = YES;
    });
    [self updateThemeStateForCurrentDrawState];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == IMAGE_SAVE_INFO_ALERT_TAG) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Success"
                                                     message:@"Wallpaper saved to your photo library. Do you want to share with Facebook friends?"
                                                    delegate:self
                                           cancelButtonTitle:@"Cancel"
                                           otherButtonTitles:@"Share", nil];
        av.tag = IMAGE_SAVE_SUCCESS_ALERT_TAG;
        [av show];
    } else if(alertView.tag == IMAGE_SAVE_SUCCESS_ALERT_TAG && buttonIndex == 1) {
        self.view.userInteractionEnabled = NO;
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self.shareManager shareToFacebookImage:[self.wallpaperGenerator generateImageForSharing]
                             fromViewController:self
                                 withCompletion:^(NSError *error, BOOL success) {
                                     self.view.userInteractionEnabled = YES;
                                     [hud hide:YES];
                                     
                                     if(error) {
                                         [[[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Failed to share the wallpaper"
                                                                    delegate:nil
                                                           cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                           otherButtonTitles:nil] show];
                                     } else {
                                         if(success) {
                                             MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
                                             hud.detailsLabelText = NSLocalizedString(@"Success", @"");
                                             hud.mode = MBProgressHUDModeCustomView;
                                             hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CameraButton"]];
                                             [hud show:YES];
                                         } else {
                                             
                                         }
                                     }
                                 }];
    }
}

#pragma mark - Private Methods

- (void)setupViewForThemeElement:(LSThemeElement)themeElement animation:(BOOL)animation {
    BOOL colors, photo, style, images;
    switch (themeElement) {
        case LSThemeElementSlider:
        case LSThemeElementPhotoBorder:
        case LSThemeElementClock: {
            images  = [self.currentTheme imagesForThemeElements:themeElement].count ? YES : NO;
            colors  = YES;
            photo   = NO;
            style   = YES;
        }
            break;
        case LSThemeElementPhoto: {
            images  = NO;
            colors  = NO;
            photo   = YES;
            style   = YES;
        }
            break;
        case LSThemeElementBackground: {
            colors  = YES;
            photo   = NO;
            style   = [self.currentTheme imagesForThemeElements:themeElement].count ? YES : NO;
            images  = [self.currentTheme imagesForThemeElements:themeElement].count ? YES : NO;
        }
        default: break;
    }
    
    [self showColorControls:colors animation:animation completion:nil];
    [self showPhotoControl:photo animation:animation completion:nil];
    [self showStyleControl:style animation:animation completion:nil];
    
    self.elementsStyleView.changeGesture = images;
    self.elementsStyleView.imagesOnly = NO;
    if(themeElement == LSThemeElementBackground && images) {
        self.elementsStyleView.imagesOnly = YES;
        self.elementsStyleView.changeGesture = NO;
    }
    
    if ((themeElement != LSThemeElementBackground) || (themeElement == LSThemeElementBackground && images)) {
        [self.elementsStyleView reloadData];
    }
    
    [self updateThemeStateForCurrentDrawState];
}

- (void)setupUIForCurrentDevice {
    self.view.backgroundColor = [UIColor mainBackgroundColor];
    
    [self.themesButton      setupTopButton];
    [self.saveButton        setupTopButton];
    [self.fullScreenButton  setupTopButton];
    [self.photoButton       setupTopButton];
}

- (void)updateThemeStateForCurrentDrawState {
    LSThemeDrawState *drawState = self.drawScheme.currentDrawState;
    
    self.blockElementRedraw = YES;
    self.blockColorsReload = YES;
    self.view.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.blockElementRedraw = NO;
        self.view.userInteractionEnabled = YES;
    });
    
    __block NSIndexPath *colorCollectionIndexPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.blockColorsReload = NO;
        [self.elementsColorCollectionView reloadData];
        [self.elementsColorCollectionView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[colorCollectionIndexPath indexAtPosition:1]]
                                                        animation:YES];
    });
    
    switch (self.currentEditingElement) {
        case LSThemeElementClock: {
            [self.elementsColorView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.clockViewColorIndexPath indexAtPosition:0]]
                                                  animation:YES];
            colorCollectionIndexPath = drawState.clockViewColorIndexPath;
            if(self.elementsStyleView.styleType == LSElementStyleShapes)
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.clockViewCornerRadiusIndexPath indexAtPosition:0]]
                                                      animation:YES];
            else
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.clockViewImageIndexPath indexAtPosition:0]]
                                                      animation:YES];
        }
            break;
        case LSThemeElementSlider: {
            [self.elementsColorView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.slideViewColorIndexPath indexAtPosition:0]]
                                                  animation:YES];
            colorCollectionIndexPath = drawState.slideViewColorIndexPath;
            if(self.elementsStyleView.styleType == LSElementStyleShapes)
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.slideViewCornerRadiusIndexPath indexAtPosition:0]]
                                                      animation:YES];
            else
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.slideViewImageIndexPath indexAtPosition:0]]
                                                      animation:YES];
        }
            break;
        case LSThemeElementPhotoBorder: {
            [self.elementsColorView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.photoBorderViewColorIndexPath indexAtPosition:0]]
                                                  animation:YES];
            colorCollectionIndexPath = drawState.photoBorderViewColorIndexPath;
            if(self.elementsStyleView.styleType == LSElementStyleShapes)
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.photoBorderViewCornerRadiusIndexPath indexAtPosition:0]]
                                                      animation:YES];
            else
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.photoBorderViewImageIndexPath indexAtPosition:0]]
                                                      animation:YES];
        }
            break;
        case LSThemeElementPhoto: {
            if(self.elementsStyleView.styleType == LSElementStyleShapes)
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.photoViewCornerRadiusIndexPath indexAtPosition:0]]
                                                      animation:YES];
        }
            break;
        case LSThemeElementBackground: {
            [self.elementsColorView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.mainBackgroundColorIndexPath indexAtPosition:0]]
                                                  animation:YES];
            colorCollectionIndexPath = drawState.mainBackgroundColorIndexPath;
            if(self.elementsStyleView.styleType == LSElementStyleImages)
                [self.elementsStyleView selectCellWithIndexPath:[[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:[drawState.mainBackgroundImageIndexPath indexAtPosition:0]]
                                                      animation:YES];
        }
            break;
    }
}

- (void)setupInitialThemeState {
    LSThemeModel *model = self.currentTheme;
    LSThemeDrawState *drawState = self.currentTheme.initialDrawState;
    LSDrawScheme *drawScheme = self.drawScheme;
    
    // setup background color
    NSIndexPath *backgroundColorIndexPath = drawState.mainBackgroundColorIndexPath;
    NSArray *subColor = model.backgroundColors[[backgroundColorIndexPath indexAtPosition:0]];
    UIColor *backgroundColor = subColor[[backgroundColorIndexPath indexAtPosition:1]+1];
    drawScheme.mainBackgroundColor = backgroundColor;
    
    // setup background image
    NSIndexPath *backgroundImageIndexPath = drawState.mainBackgroundImageIndexPath;
    NSInteger imageIndex = [backgroundImageIndexPath indexAtPosition:0];
    if(imageIndex < model.backgroundImages.count) {
        UIImage *image = [self.currentTheme imageForThemeElements:LSThemeElementBackground index:imageIndex];
        drawScheme.mainBackgroundImage = image;
    }
    
    // setup clock color
    NSIndexPath *clockColorIndexPath = drawState.clockViewColorIndexPath;
    subColor = model.clockColors[[clockColorIndexPath indexAtPosition:0]];
    UIColor *clockColor = subColor[[clockColorIndexPath indexAtPosition:1]+1];
    drawScheme.clockViewColor = clockColor;
    
    // setup clock image
    NSIndexPath *clockImageIndexPath = drawState.clockViewImageIndexPath;
    imageIndex = [clockImageIndexPath indexAtPosition:0];
    if(imageIndex < model.clockImages.count) {
        UIImage *image = [self.currentTheme imageForThemeElements:LSThemeElementClock index:imageIndex];
        drawScheme.clockViewImage = image;
    }
    
    // setup clock corner radius
    drawScheme.clockViewCornerRadius = 0.0;
    
    // setup slide color
    NSIndexPath *slideColorIndexPath = drawState.slideViewColorIndexPath;
    subColor = model.slideColors[[slideColorIndexPath indexAtPosition:0]];
    UIColor *slideColor = subColor[[slideColorIndexPath indexAtPosition:1]+1];
    drawScheme.slideViewColor = slideColor;
    
    // setup slide image
    NSIndexPath *slideImageIndexPath = drawState.slideViewImageIndexPath;
    imageIndex = [slideImageIndexPath indexAtPosition:0];
    if(imageIndex < model.slideImages.count) {
        UIImage *image = [self.currentTheme imageForThemeElements:LSThemeElementSlider index:imageIndex];
        drawScheme.slideViewImage = image;
    }
    
    // setup slide corner radius
    drawScheme.slideViewCornerRadius = 0.0;
    
    // setup photo border color
    NSIndexPath *photoBorderColorIndexPath = drawState.photoBorderViewColorIndexPath;
    subColor = model.photoBorderColors[[photoBorderColorIndexPath indexAtPosition:0]];
    UIColor *photoBorderColor = subColor[[photoBorderColorIndexPath indexAtPosition:1]+1];
    drawScheme.photoBorderViewColor = photoBorderColor;
    
    // setup photo border image
    NSIndexPath *photoBorderImageIndexPath = drawState.photoBorderViewImageIndexPath;
    imageIndex = [photoBorderImageIndexPath indexAtPosition:0];
    if(imageIndex < model.photoBorderImages.count) {
        NSIndexPath *imageIndexPath = [[NSIndexPath indexPathWithIndex:1] indexPathByAddingIndex:imageIndex];
        UIImage *image = [self.currentTheme imageForImageBorderWithIndexPath:imageIndexPath];
        drawScheme.photoBorderViewImage = image;
    }
    
    // setup photo/border corner radius
    drawScheme.photoViewCornerRadius = 0.0;
    drawScheme.photoBorderViewCornerRadius = 0.0;
}

@end