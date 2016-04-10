//
//  LSOnboardView.h
//  LockScreenWallpaper
//
//  Created by ZZI on 21/05/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSDesignViewController.h"

#define ONBOARD_VIEW_SHOW_ANIMATION_DURATION                0.5

@interface LSOnboardView : UIView

- (instancetype)initWithDesignViewController:(LSDesignViewController*)vc;
- (void)showInstruction;

- (void)showTips;

@end
