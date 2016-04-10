//
//  LSDesignToImagePickerTransition.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/24/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDesignToImagePickerTransition.h"
#import "LSDesignViewController.h"
#import "UIImagePickerController+NavigationBar.h"

@interface LSDesignToImagePickerTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL      reverse;

@end

@implementation LSDesignToImagePickerTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    if(!self.reverse) {
        UIImagePickerController *toViewController    = (UIImagePickerController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        BOOL isCamera = toViewController.sourceType == UIImagePickerControllerSourceTypeCamera ? YES : NO;
        
        CGRect toOldFrame = toViewController.view.frame;
        CGRect toNewFrame = toOldFrame;
        toNewFrame.origin.y = -CGRectGetHeight(toOldFrame);
        toViewController.view.frame = toNewFrame;
        [container addSubview:toViewController.view];
        
        if(isCamera) {
            [UIView animateWithDuration:0.5 animations:^{
                toViewController.view.frame = toOldFrame;
            } completion:^(BOOL finished) {
                [toViewController showControlsWithCompletion:^{
                    [transitionContext completeTransition:YES];
                }];
            }];
        } else {
            [UIView animateWithDuration:0.7 animations:^{
                toViewController.view.frame = toOldFrame;
            } completion:^(BOOL finished) {
                [transitionContext completeTransition:YES];
            }];
        }
    } else {
        UIImagePickerController *fromViewController  = (UIImagePickerController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        LSDesignViewController *toViewController    = (LSDesignViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        BOOL isCamera = fromViewController.sourceType == UIImagePickerControllerSourceTypeCamera ? YES : NO;
        
        [container insertSubview:toViewController.view atIndex:0];
        fromViewController.view.backgroundColor = [UIColor clearColor];
        CGRect toOldFrame = fromViewController.view.frame;
        CGRect toNewFrame = fromViewController.view.frame;
        toNewFrame.origin.y = -CGRectGetHeight(toNewFrame);
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
        if(isCamera) {
            [fromViewController hideControlsWithCompletion:^{
                [UIView animateWithDuration:0.5 animations:^{
                    fromViewController.view.frame = toNewFrame;
                } completion:^(BOOL finished) {
                    [fromViewController.view removeFromSuperview];
                    fromViewController.view.frame = toOldFrame;
                    [transitionContext completeTransition:YES];
                }];
            }];
        } else {
            [UIView animateWithDuration:0.7 animations:^{
                fromViewController.view.frame = toNewFrame;
            } completion:^(BOOL finished) {
                [fromViewController.view removeFromSuperview];
                fromViewController.view.frame = toOldFrame;
                [transitionContext completeTransition:YES];
            }];
        }
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.7;
}

@end

@implementation LSDesignToImagePickerTransition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    LSDesignToImagePickerTransitioning *transitioning = [LSDesignToImagePickerTransitioning new];
    return transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    LSDesignToImagePickerTransitioning *transitioning = [LSDesignToImagePickerTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
