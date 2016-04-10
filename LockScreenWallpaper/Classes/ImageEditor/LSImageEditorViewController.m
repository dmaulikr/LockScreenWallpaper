//
//  LSImageEditorViewController.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/26/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSImageEditorViewController.h"
#import "LSButton.h"

@interface LSImageEditorViewController()

@property (weak, nonatomic) IBOutlet LSButton *retakeButton;
@property (weak, nonatomic) IBOutlet LSButton *useImageButton;
@property (weak, nonatomic) IBOutlet UIView *controlsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retakeButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useImageButtonConstraint;

@end

@implementation LSImageEditorViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self.minimumScale = 0.2;
        self.maximumScale = 10;
        self.rotateEnabled = NO;
        self.checkBounds = YES;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.retakeButton setupTopButton];
    [self.useImageButton setupTopButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat size = CGRectGetWidth(self.view.frame);
    self.cropSize = CGSizeMake(size, size);
}

- (void)prepareControlsView {
    self.retakeButtonConstraint.constant = -50.0;
    self.useImageButtonConstraint.constant = -50.0;
    [self.controlsView layoutIfNeeded];
}

- (void)showControlsWithCompletion:(void(^)(void))completion {
    self.retakeButtonConstraint.constant = 15.0;
    self.useImageButtonConstraint.constant = 15.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.retakeButton layoutIfNeeded];
        [self.useImageButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (void)hideControlsWithCompletion:(void(^)(void))completion {
    self.retakeButtonConstraint.constant = -50.0;
    self.useImageButtonConstraint.constant = -50.0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.retakeButton layoutIfNeeded];
        [self.useImageButton layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion)
            completion();
    }];
}

- (IBAction)retakeButtonPushed:(LSButton *)sender {
    if([self.delegate respondsToSelector:@selector(editImageViewController:didPressRetakeButton:)])
        [self.delegate editImageViewController:self didPressRetakeButton:sender];
}

- (IBAction)useImageButtonPushed:(LSButton *)sender {
    HFImageEditorDoneCallback callback = ^(UIImage *image, BOOL canceled){
        if([self.delegate respondsToSelector:@selector(editImageViewController:didPressUseImageButton:withImage:)])
            [self.delegate editImageViewController:self didPressUseImageButton:sender withImage:image];
    };
    self.doneCallback = callback;
    [self doneAction:nil];
}

@end
