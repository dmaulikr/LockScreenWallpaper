//
//  LSThemeCollectionViewCell.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeCollectionViewCell.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>

#define SHOW_ANIMATION_DURATION                             0.2
#define UNLOCK_ANIMATION_DURATION                           0.5
#define SELECT_ANIMATION_DURATION                           0.4

@interface LSThemeCollectionViewCell() {
    CABasicAnimation                    *_animationWithDelegate;
}

@property (nonatomic, strong) UIImageView                       *imageView;
@property (nonatomic, strong) UIImageView                       *lockImageView;
@property (nonatomic, assign) CATransform3D                      originalTransform;

@end

@implementation LSThemeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.contentView.bounds;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        
        imgView.layer.cornerRadius   = 20.0;
        imgView.layer.borderColor    = [UIColor whiteColor].CGColor;
        imgView.layer.borderWidth    = 1.0;
        
        self.imageView                  = imgView;
        self.imageView.backgroundColor  = [UIColor purpleColor];
        self.imageView.clipsToBounds    = YES;
        [self.contentView addSubview:self.imageView];
        
        self.lockImageView                      = [[UIImageView alloc] initWithFrame:rect];
        self.lockImageView.layer.cornerRadius   = 20.0;
        self.lockImageView.clipsToBounds        = YES;
        self.lockImageView.alpha                = 0.7;
        [self.imageView addSubview:self.lockImageView];
        
        self.originalTransform              = self.imageView.layer.transform;
        self.showWithoutAnimation           = NO;
        self.backgroundColor                = [UIColor clearColor];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        gesture.numberOfTapsRequired    = 2;
        [self.contentView addGestureRecognizer:gesture];
        
        self.contentView.layer.shadowColor    = [UIColor shadowColor].CGColor;
        self.contentView.layer.shadowRadius   = 3.0;
        self.contentView.layer.shadowOpacity  = 0.7;
        self.contentView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
    }
    
    return self;
}

- (void)setThemeImage:(UIImage *)themeImage {
    _themeImage = themeImage;
    self.imageView.image = themeImage;
}

- (void)setThemeLockImage:(UIImage *)themeLockImage {
    _themeLockImage = themeLockImage;
    self.lockImageView.image = themeLockImage;
}

- (void)setShowWithAnimation:(BOOL)showWithAnimation {
    if (_showWithAnimation != showWithAnimation) {
        _showWithAnimation = showWithAnimation;
        _showWithoutAnimation = showWithAnimation;
        if (_showWithAnimation) {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = SHOW_ANIMATION_DURATION;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:self.originalTransform];
            [self.imageView.layer addAnimation:animation forKey:@"ShowAnimation"];
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = SHOW_ANIMATION_DURATION;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.originalTransform, 0.7, 0.7, 1.0)];
            [self.imageView.layer addAnimation:animation forKey:@"HideAnimation"];
        }
    }
}

- (void)setShowWithoutAnimation:(BOOL)showWithoutAnimation {
    _showWithoutAnimation    = showWithoutAnimation;
    _showWithAnimation      = showWithoutAnimation;
    
    if (_showWithoutAnimation) {
        self.imageView.layer.transform = self.originalTransform;
    } else {
        self.imageView.layer.transform = CATransform3DScale(self.originalTransform, 0.7, 0.7, 1.0);
    }
}

- (void)setSelectWithAnimation:(BOOL)selectWithAnimation {
    _selectWithAnimation = selectWithAnimation;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = SHOW_ANIMATION_DURATION;
    animation.autoreverses = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.originalTransform, 1.1, 1.1, 1.0)];
    [self.imageView.layer addAnimation:animation forKey:@"SelectAnimation"];
}

- (void)setLockCell:(BOOL)lockCell {
    _lockCell = lockCell;
    self.lockImageView.hidden = !_lockCell;
}

- (void)unlockWithAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = SHOW_ANIMATION_DURATION;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(self.originalTransform, 1.5, 1.5, 1.0)];
    [self.lockImageView.layer addAnimation:animation forKey:@"TransformUnlock"];
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = SHOW_ANIMATION_DURATION;
    opacityAnimation.delegate = self;
    opacityAnimation.toValue = @(0.0);
    [self.lockImageView.layer addAnimation:opacityAnimation forKey:@"OpacityUnlock"];
    _animationWithDelegate = opacityAnimation;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    if (flag)
        self.lockCell = NO;
    _animationWithDelegate.delegate = nil;
    _animationWithDelegate = nil;
}

- (void)doubleTap:(UITapGestureRecognizer*)gesture {
    if (self.lockCell) {
        if ([self.delegate respondsToSelector:@selector(doubleTapDidDetectedInCell:)])
            [self.delegate doubleTapDidDetectedInCell:self];
    }
}

@end
