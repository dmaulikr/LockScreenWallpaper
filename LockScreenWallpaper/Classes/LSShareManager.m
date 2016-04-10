//
//  LSShareManager.m
//  LockScreenWallpaper
//
//  Created by ZZI on 12/06/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSShareManager.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface LSShareManager() <FBSDKSharingDelegate>

@property (nonatomic, copy) LSShareCompletion               completion;

@end

@implementation LSShareManager

#pragma mark - Facebook Methods

- (void)shareToFacebookImage:(UIImage*)image fromViewController:(UIViewController*)vc withCompletion:(LSShareCompletion)completion {
    self.completion = completion;
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:vc
                                 withContent:content
                                    delegate:self];
}

#pragma mark - FBSDKSharingDelegate

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    DLog(@"---> %@", results);
    if(self.completion)
        self.completion(nil, YES);
    self.completion = nil;
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    DLog(@"---> %@", error);
    if(self.completion)
        self.completion(error, NO);
    self.completion = nil;
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    DLog(@"--->");
    if(self.completion)
        self.completion(nil, NO);
    self.completion = nil;
}

@end
