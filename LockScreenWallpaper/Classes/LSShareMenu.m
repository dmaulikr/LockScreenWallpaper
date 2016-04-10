//
//  LSShareMenu.m
//  LockScreenWallpaper
//
//  Created by ZZI on 10/06/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSShareMenu.h"
#import "LSButton.h"

#define BUTTON_SIDE_OFFSET                              30.0
#define BUTTON_VERTICAL_OFFSET                          15.0

@interface LSShareMenu()

@property (nonatomic, strong) LSButton          *facebookButton;
@property (nonatomic, strong) LSButton          *cancelButton;
@property (nonatomic, strong) UIView            *backgroundView;

@end

@implementation LSShareMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        self.backgroundView.alpha = 0.0;
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0.5f, 0.7);
        gradientLayer.endPoint = CGPointMake(0.5f, -0.5f);
        [self.backgroundView.layer addSublayer:gradientLayer];
        
        [self addSubview:self.backgroundView];
    }
    
    return self;
}

- (LSButton*)facebookButton {
    if (_facebookButton)
        return _facebookButton;
    LSButton *button = [LSButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    button.frame = buttonFrame;
    [button setTitle:@"Facebook" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(facebookButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [button setupTopButton];
    [self addSubview:button];
    _facebookButton = button;
    
    return _facebookButton;
}

- (LSButton*)cancelButton {
    if (_cancelButton)
        return _cancelButton;
    LSButton *button = [LSButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    button.frame = buttonFrame;
    [button setTitle:@"Complete" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [button setupTopButton];
    [self addSubview:button];
    _cancelButton = button;
    
    return _cancelButton;
}

#pragma mark - Publick Methods

- (void)showShareMenuWithCompletion:(void(^)(void))completion {
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    self.facebookButton.frame = buttonFrame;
    self.cancelButton.frame = buttonFrame;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
                CGFloat y = self.cancelButton.frame.size.height + BUTTON_VERTICAL_OFFSET;
                y *= 2;
                CGRect frame = self.facebookButton.frame;
                frame.origin.y = CGRectGetHeight(self.bounds) - y;
                self.facebookButton.frame = frame;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                CGFloat y = self.cancelButton.frame.size.height + BUTTON_VERTICAL_OFFSET;
                y *= 1;
                CGRect frame = self.facebookButton.frame;
                frame.origin.y = CGRectGetHeight(self.bounds) - y;
                self.cancelButton.frame = frame;
            }];
        } completion:^(BOOL finished) {
            if(completion)
                completion();
        }];
    }];
}

- (void)hideShareMenuWithCompletion:(void(^)(void))completion {
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations:^{
            self.cancelButton.frame = buttonFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            self.facebookButton.frame = buttonFrame;
        }];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if(completion)
                completion();
        }];
    }];
}

#pragma mark - Private Methods

- (void)facebookButtonPushed:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(didPressFacebookButtonShareMenu:)])
        [self.delegate didPressFacebookButtonShareMenu:self];
}

- (void)cancelButtonPushed:(UIButton*)button {
    [self hideShareMenuWithCompletion:^{
        [self removeFromSuperview];
    }];
}

- (CGSize)buttonSize {
    CGFloat width = self.bounds.size.width - 2 * BUTTON_SIDE_OFFSET;
    return CGSizeMake(width, 32.0);
}

@end
