//
//  UIImagePickerController+NavigationBar.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/24/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (NavigationBar)

- (void)showControlsWithCompletion:(void(^)(void))completion;
- (void)hideControlsWithCompletion:(void(^)(void))completion;

@end
