//
//  UIViewController+CreateViewController.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "UIViewController+CreateViewController.h"

@implementation UIViewController (CreateViewController)

+ (instancetype)loadViewControllerFromStoryBoardWithIdentifier:(NSString *)className
{
    UIViewController *retVC = [LSMainStoryboard() instantiateViewControllerWithIdentifier:className];
    NSAssert(retVC, @"View controller doesn't exist in story board");
    
    return retVC;
}

+ (instancetype)createViewControllerWithClassName:(NSString *)className
{
    Class vcClass = NSClassFromString(className);
    NSAssert(vcClass, @"View controller doesn't exist in project");
    
    UIViewController *retVC = [[vcClass alloc] init];
    return retVC;
}

@end
