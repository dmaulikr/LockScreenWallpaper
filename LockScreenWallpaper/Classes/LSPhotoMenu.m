//
//  LSPhotoMenu.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/24/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSPhotoMenu.h"
#import "LSButton.h"

#define BUTTON_SIDE_OFFSET                              30.0
#define BUTTON_VERTICAL_OFFSET                          15.0

@interface LSPhotoMenu()

@property (nonatomic, strong) LSButton          *photoButton;
@property (nonatomic, strong) LSButton          *galleryButton;
@property (nonatomic, strong) LSButton          *cancelButton;
@property (nonatomic, strong) UIView            *backgroundView;

@end

@implementation LSPhotoMenu

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

- (LSButton*)photoButton {
    if (_photoButton)
        return _photoButton;
    LSButton *button = [LSButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    button.frame = buttonFrame;
    [button setTitle:@"Photo From Camera" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(photoButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [button setupTopButton];
    [self addSubview:button];
    _photoButton = button;
    
    return _photoButton;
}

- (LSButton*)galleryButton {
    if (_galleryButton)
        return _galleryButton;
    LSButton *button = [LSButton buttonWithType:UIButtonTypeCustom];
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    button.frame = buttonFrame;
    [button setTitle:@"Photo From Gallery" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(galleryButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [button setupTopButton];
    [self addSubview:button];
    _galleryButton = button;
    
    return _galleryButton;
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
    [button setTitle:@"Cancel" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cancelButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
    [button setupTopButton];
    [self addSubview:button];
    _cancelButton = button;
    
    return _cancelButton;
}

#pragma mark - Public Methods

- (void)showPhotoMenuWithCompletion:(void(^)(void))completion {
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    self.photoButton.frame = buttonFrame;
    self.galleryButton.frame = buttonFrame;
    self.cancelButton.frame = buttonFrame;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.backgroundView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
                CGFloat y = self.cancelButton.frame.size.height + BUTTON_VERTICAL_OFFSET;
                y *= 3;
                CGRect frame = self.photoButton.frame;
                frame.origin.y = CGRectGetHeight(self.bounds) - y;
                self.photoButton.frame = frame;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.33 animations:^{
                CGFloat y = self.cancelButton.frame.size.height + BUTTON_VERTICAL_OFFSET;
                y *= 2;
                CGRect frame = self.photoButton.frame;
                frame.origin.y = CGRectGetHeight(self.bounds) - y;
                self.galleryButton.frame = frame;
            }];
            [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.33 animations:^{
                CGFloat y = self.cancelButton.frame.size.height + BUTTON_VERTICAL_OFFSET;
                y *= 1;
                CGRect frame = self.photoButton.frame;
                frame.origin.y = CGRectGetHeight(self.bounds) - y;
                self.cancelButton.frame = frame;
            }];
        } completion:^(BOOL finished) {
            if(completion)
                completion();
        }];
    }];
}

- (void)hidePhotoMenuWithCompletion:(void(^)(void))completion {
    CGRect buttonFrame;
    buttonFrame.size = [self buttonSize];
    buttonFrame.origin.x = BUTTON_SIDE_OFFSET;
    buttonFrame.origin.y = self.bounds.size.height + 1;
    
    [UIView animateKeyframesWithDuration:0.5 delay:0.0 options:0 animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.33 animations:^{
            self.cancelButton.frame = buttonFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.33 animations:^{
            self.galleryButton.frame = buttonFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.33 animations:^{
            self.photoButton.frame = buttonFrame;
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

- (void)photoButtonPushed:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(didPressPhototButtonPhotoMenu:)])
        [self.delegate didPressPhototButtonPhotoMenu:self];
}

- (void)galleryButtonPushed:(UIButton*)button {
    if ([self.delegate respondsToSelector:@selector(didPressGalleryButtonPhotoMenu:)])
        [self.delegate didPressGalleryButtonPhotoMenu:self];
}

- (void)cancelButtonPushed:(UIButton*)button {
    [self hidePhotoMenuWithCompletion:^{
        [self removeFromSuperview];
    }];
}

- (CGSize)buttonSize {
    CGFloat width = self.bounds.size.width - 2 * BUTTON_SIDE_OFFSET;
    return CGSizeMake(width, 32.0);
}

@end
