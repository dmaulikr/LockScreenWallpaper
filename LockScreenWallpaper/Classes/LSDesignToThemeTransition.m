//
//  LSDesignToThemeTransition.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/18/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDesignToThemeTransition.h"
#import "LSDesignViewController.h"
#import "LSThemesViewController.h"

@interface LSDesignAnimatedTransitioning : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL      reverse;

@end

@implementation LSDesignAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *container = [transitionContext containerView];
    if(!self.reverse) {
        LSDesignViewController *fromViewController  = (LSDesignViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        LSThemesViewController *toViewController    = (LSThemesViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        
        toViewController.view.backgroundColor = [UIColor clearColor];
        [toViewController prepareToShowView];
        [fromViewController showControls:NO completion:^{
            [container addSubview:toViewController.view];
            [toViewController showViewCompletion:^{
                [transitionContext completeTransition:YES];
            }];
        }];
    } else {
        LSThemesViewController *fromViewController  = (LSThemesViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        LSDesignViewController *toViewController    = (LSDesignViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        
        [container insertSubview:toViewController.view atIndex:0];
        fromViewController.view.backgroundColor = [UIColor clearColor];
        [fromViewController hideViewCompletion:^{
            [fromViewController.view removeFromSuperview];
            [toViewController showControls:YES completion:^{
                [transitionContext completeTransition:YES];
            }];            
        }];
    }
    
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 1.2;
}

@end

@implementation LSDesignToThemeTransition

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    LSDesignAnimatedTransitioning *transitioning = [LSDesignAnimatedTransitioning new];
    return transitioning;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    LSDesignAnimatedTransitioning *transitioning = [LSDesignAnimatedTransitioning new];
    transitioning.reverse = YES;
    return transitioning;
}

@end
