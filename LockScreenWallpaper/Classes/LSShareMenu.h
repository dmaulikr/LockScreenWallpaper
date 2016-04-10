//
//  LSShareMenu.h
//  LockScreenWallpaper
//
//  Created by ZZI on 10/06/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSShareMenu;

@protocol LSShareMenuDelegate <NSObject>

- (void)didPressFacebookButtonShareMenu:(LSShareMenu*)shareMenu;

@end

@interface LSShareMenu : UIView

@property (nonatomic, weak) id<LSShareMenuDelegate>             delegate;

- (void)showShareMenuWithCompletion:(void(^)(void))completion;
- (void)hideShareMenuWithCompletion:(void(^)(void))completion;

@end
