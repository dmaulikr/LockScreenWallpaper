//
//  UIViewController+CreateViewController.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (CreateViewController)

+ (instancetype)loadViewControllerFromStoryBoardWithIdentifier:(NSString *)className;
+ (instancetype)createViewControllerWithClassName:(NSString *)className;

@end
