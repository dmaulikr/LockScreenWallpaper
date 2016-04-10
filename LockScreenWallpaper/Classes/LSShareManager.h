//
//  LSShareManager.h
//  LockScreenWallpaper
//
//  Created by ZZI on 12/06/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LSShareCompletion)(NSError* error, BOOL success);

@interface LSShareManager : UIView

- (void)shareToFacebookImage:(UIImage*)image fromViewController:(UIViewController*)vc withCompletion:(LSShareCompletion)completion;

@end
