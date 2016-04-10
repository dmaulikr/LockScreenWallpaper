//
//  LSImagePickerToImageEditorTransition.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/24/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSImagePickerToImageEditorTransition.h"
#import "LSImageEditorViewController.h"
#import "LSDesignViewController.h"
#import "LSDesignViewController.h"
#import "LSDesignViewScheme.h"

@interface LSImagePickerToImageEditorTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL      reverse;

@end

@implementation LSImagePickerToImageEditorTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    if(!self.reverse) {
        LSImageEditorViewController *toViewController           = (LSImageEditorViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        CGRect toOldFrame = [[[LSDesignViewScheme alloc] initWithDeviceType:[LSDeviceInformation currentDeviceType]] originViewFrame];
        CGRect toNewFrame = toOldFrame;
        toNewFrame.origin.y = -CGRectGetHeight(toOldFrame);
        toViewController.view.frame = toNewFrame;
        [container addSubview:toViewController.view];
        [toViewController prepareControlsView];
        [UIView animateWithDuration:0.5 animations:^{
            toViewController.view.frame = toOldFrame;
        } completion:^(BOOL finished) {
            [toViewController showControlsWithCompletion:^{
                [transitionContext completeTransition:YES];
            }];
        }];
    } else {
        LSImageEditorViewController *fromViewController         = (LSImageEditorViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        LSDesignViewController *toViewController                = (LSDesignViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [container insertSubview:toViewController.view atIndex:0];
        CGRect toOldFrame = fromViewController.view.frame;
        CGRect toNewFrame = fromViewController.view.frame;
        toNewFrame.origin.y = -CGRectGetHeight(toNewFrame);
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        [fromViewController hideControlsWithCompletion:^{
            [UIView animateWithDuration:0.5 animations:^{
                fromViewController.view.frame = toNewFrame;
            } completion:^(BOOL finished) {
                [fromViewController.view removeFromSuperview];
                fromViewController.view.frame = toOldFrame;
                [transitionContext completeTransition:YES];
            }];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

@end

@implementation LSImagePickerToImageEditorTransition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    LSImagePickerToImageEditorTransitioning *transitioning = [LSImagePickerToImageEditorTransitioning new];
    return transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    LSImagePickerToImageEditorTransitioning *transitioning = [LSImagePickerToImageEditorTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
