//
//  UIImagePickerController+NavigationBar.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/24/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "UIImagePickerController+NavigationBar.h"
#import <objc/runtime.h>
#import "LSButton.h"

#define OVERLAY_VIEW_HEIGHT                              90.0
#define PHOTOT_BUTTON_SIDE_SIZE                          70.0
#define SMALL_BUTTON_HEIGHT                              32.0
#define BUTTON_SIDE_OFFSET                               15.0
#define ANIMATION_DURATION                                0.2

@implementation UIImagePickerController (NavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewDidLayoutSubviews);
        SEL swizzledSelector = @selector(customViewDidLayoutSubviews);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)customViewDidLayoutSubviews {
    [self customViewDidLayoutSubviews];
    self.navigationBar.tintColor    = [UIColor topButtonFontColor];
    self.navigationBar.barTintColor = [UIColor topButtonColor];
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName:[UIColor topButtonFontColor]}];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.view.backgroundColor = [UIColor redColor];
}

- (void)showControlsWithCompletion:(void(^)(void))completion {
    CGRect screenFrame = self.view.bounds;
    if (self.cameraOverlayView == nil) {
        CGRect buttonFrame;
        
        CGFloat y = CGRectGetHeight(screenFrame) - OVERLAY_VIEW_HEIGHT;
        CGRect overlayRect = CGRectMake(0.0, y, CGRectGetWidth(screenFrame), OVERLAY_VIEW_HEIGHT);
        UIView *overlayView = [[UIView alloc] initWithFrame:overlayRect];
        overlayView.backgroundColor = [UIColor clearColor];
        self.cameraOverlayView = overlayView;
        
        buttonFrame.size = CGSizeMake(PHOTOT_BUTTON_SIDE_SIZE, PHOTOT_BUTTON_SIDE_SIZE);
        buttonFrame.origin.x = (CGRectGetWidth(overlayRect) - PHOTOT_BUTTON_SIDE_SIZE) / 2;
        buttonFrame.origin.y = CGRectGetHeight(overlayRect) - BUTTON_SIDE_OFFSET - PHOTOT_BUTTON_SIDE_SIZE;
        LSButton *takePhototButton = [LSButton buttonWithType:UIButtonTypeCustom];
        takePhototButton.frame = buttonFrame;
        [takePhototButton setupTopButton];
        [takePhototButton addTarget:self action:@selector(takePhotoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:takePhototButton];
        
        buttonFrame.size.height = SMALL_BUTTON_HEIGHT;
        buttonFrame.size.width = CGRectGetMinX(takePhototButton.frame) - 2 * BUTTON_SIDE_OFFSET;
        buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
        buttonFrame.origin.y = CGRectGetHeight(overlayRect) - BUTTON_SIDE_OFFSET - SMALL_BUTTON_HEIGHT;
        LSButton *cancelButton = [LSButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = buttonFrame;
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setupTopButton];
        [cancelButton addTarget:self action:@selector(cancelButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [overlayView addSubview:cancelButton];
        
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            buttonFrame.origin.x = CGRectGetMaxX(takePhototButton.frame) + BUTTON_SIDE_OFFSET;
            LSButton *changeCameraButton = [LSButton buttonWithType:UIButtonTypeCustom];
            [changeCameraButton setImage:[UIImage imageNamed:@"ChangeCameraButton"] forState:UIControlStateNormal];
            changeCameraButton.frame = buttonFrame;
            [changeCameraButton setupTopButton];
            [changeCameraButton addTarget:self action:@selector(changeCameraButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
            [overlayView addSubview:changeCameraButton];
        }
    }
    
    CGRect oldRect = self.cameraOverlayView.frame;
    CGRect newRect = oldRect;
    newRect.origin.y = CGRectGetHeight(screenFrame);
    self.cameraOverlayView.frame = newRect;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.cameraOverlayView.frame = oldRect;
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)hideControlsWithCompletion:(void(^)(void))completion {
    CGRect screenFrame = self.view.bounds;
    CGRect oldRect = self.cameraOverlayView.frame;
    CGRect newRect = oldRect;
    newRect.origin.y = CGRectGetHeight(screenFrame);
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        self.cameraOverlayView.frame = newRect;
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)cancelButtonPushed:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        [self.delegate imagePickerControllerDidCancel:self];
}

- (void)takePhotoButtonPushed:(UIButton*)button {
    [self takePicture];
}

- (void)changeCameraButtonPushed:(UIButton*)button {
    if (self.cameraDevice == UIImagePickerControllerCameraDeviceRear)
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    else
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
}

@end
