//
//  LSElementsView.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSElementsView.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>

#define kvoBackgroundViewColor                              @"mainBackgroundColor"
#define kvoBackgroundViewImage                              @"mainBackgroundImage"

#define kvoClockViewCornerRadius                            @"clockViewCornerRadius"
#define kvoClockViewColor                                   @"clockViewColor"
#define kvoClockViewImage                                   @"clockViewImage"

#define kvoSlideViewCornerRadius                            @"slideViewCornerRadius"
#define kvoSlideViewColor                                   @"slideViewColor"
#define kvoSlideViewImage                                   @"slideViewImage"

#define kvoPhotoViewCornerRadius                            @"photoViewCornerRadius"
#define kvoPhotoViewImage                                   @"photoViewImage"

#define kvoPhotoBorderViewCornerRadius                      @"photoBorderViewCornerRadius"
#define kvoPhotoBorderViewColor                             @"photoBorderViewColor"
#define kvoPhotoBorderViewImage                             @"photoBorderViewImage"

#define kvoClockViewHidden                                  @"alpha"
#define kvoSlideViewHidden                                  @"alpha"

#define CHECK_BORDER_OFFSET                                 10

@interface LSElementsView()

@property (nonatomic, strong) CABasicAnimation                      *transformAnimation;
@property (nonatomic, strong) CABasicAnimation                      *shadowAnimation;

@property (nonatomic, strong) UIImageView                           *statusBarImageView;
@property (nonatomic, strong) UIImageView                           *clockOnClockImageView;
@property (nonatomic, strong) UIImageView                           *clockOnBackgroundImageView;
@property (nonatomic, strong) UIImageView                           *slideOnSlideImageView;
@property (nonatomic, strong) UIImageView                           *slideOnBackgroundImageView;

@property (nonatomic, strong) UIView                                *shadowClockView;
@property (nonatomic, strong) UIView                                *shadowSlideView;
@property (nonatomic, strong) UIView                                *shadowPhotoView;
@property (nonatomic, strong) UIView                                *shadowPhotoBorderView;

@property (nonatomic, strong) UIColor                               *shadowColor;

@end

@implementation LSElementsView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThemeElement:)];
    gesture1.numberOfTapsRequired = 2;
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThemeElement:)];
    gesture2.numberOfTapsRequired = 2;
    UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThemeElement:)];
    gesture3.numberOfTapsRequired = 2;
    UITapGestureRecognizer *gesture4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThemeElement:)];
    gesture4.numberOfTapsRequired = 2;
    UITapGestureRecognizer *gesture5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectThemeElement:)];
    gesture5.numberOfTapsRequired = 2;
    
    [self.clockView addGestureRecognizer:gesture1];
    [self.slideView addGestureRecognizer:gesture2];
    [self.photoBorderImageView addGestureRecognizer:gesture3];
    [self.photoImageView addGestureRecognizer:gesture4];
    [self.backgroundView addGestureRecognizer:gesture5];
    
    self.currentThemeElement                = -1;
    self.shadowColor                        = [UIColor blackColor];
    self.photoImageView.layer.masksToBounds = YES;
    
    [self setupFakeElements];
    [self addUIElementsKVO];
}

- (void)setDesignViewScheme:(LSDesignViewScheme *)designViewScheme {
    if (_designViewScheme != designViewScheme) {
        _designViewScheme = designViewScheme;
        [self updateSubviews];
        [self addShadowViews];
    }
}

- (void)dealloc {
    if (_drawScheme)
        [self removeKVO];
    [self removeUIElementsKVO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateSubviews];
    [self updateFakeElements];
}

- (void)setDrawScheme:(LSDrawScheme *)drawScheme {
    if(_drawScheme == drawScheme)
        return;
    
    if (_drawScheme)
        [self removeKVO];
    LSEtalonScheme *etalon = self.designViewScheme.etalonScheme;
    self.backgroundView.backgroundColor         = drawScheme.mainBackgroundColor;
    
    self.clockView.backgroundColor              = drawScheme.clockViewColor;
    self.clockView.image                        = drawScheme.clockViewImage;
    self.clockView.layer.cornerRadius           = [etalon scaleCornerRadiusFrom:drawScheme.clockViewCornerRadius];
    self.shadowClockView.layer.cornerRadius     = [etalon scaleCornerRadiusFrom:drawScheme.clockViewCornerRadius];
    
    self.slideView.backgroundColor              = drawScheme.slideViewColor;
    self.slideView.image                        = drawScheme.slideViewImage;
    self.slideView.layer.cornerRadius           = [etalon scaleCornerRadiusFrom:drawScheme.slideViewCornerRadius];
    self.slideView.layer.cornerRadius           = [etalon scaleCornerRadiusFrom:drawScheme.slideViewCornerRadius];
    
    self.photoBorderImageView.backgroundColor   = drawScheme.photoBorderViewColor;
    self.photoBorderImageView.image             = drawScheme.photoBorderViewImage;
    self.photoBorderImageView.layer.cornerRadius = [etalon scaleCornerRadiusFrom:drawScheme.photoBorderViewCornerRadius];
    self.shadowPhotoBorderView.layer.cornerRadius = [etalon scaleCornerRadiusFrom:drawScheme.photoBorderViewCornerRadius];
    
    self.photoImageView.image                   = drawScheme.photoViewImage;
    self.photoImageView.layer.cornerRadius      = [etalon scaleCornerRadiusFrom:drawScheme.photoViewCornerRadius];
    self.photoImageView.layer.cornerRadius      = [etalon scaleCornerRadiusFrom:drawScheme.photoViewCornerRadius];
    
    if(self.photoBorderImageView.layer.cornerRadius < 0.0) {
        self.shadowPhotoBorderView.alpha    = 0.0;
        self.shadowPhotoView.alpha          = 1.0;
    } else {
        self.shadowPhotoBorderView.alpha    = 1.0;
        self.shadowPhotoView.alpha          = 0.0;
    }
    
    _drawScheme = drawScheme;
    [self addKVO];
}

- (CABasicAnimation*)transformAnimation {
    if (_transformAnimation)
        return _transformAnimation;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    animation.autoreverses = YES;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)];
    
    _transformAnimation = animation;
    return _transformAnimation;
}

- (CABasicAnimation*)shadowAnimation {
    if (_shadowAnimation)
        return _shadowAnimation;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    animation.duration = 0.2;
    animation.autoreverses = YES;
    animation.toValue = @(5.0);
    
    _shadowAnimation = animation;
    return _shadowAnimation;
}

#pragma mark - Private Methods

- (void)selectThemeElement:(UITapGestureRecognizer*)recognizer {
    LSThemeElement element = [self themeElementFromGesture:recognizer];
    if (self.currentThemeElement != element) {
        self.currentThemeElement = element;
        UIView *view = [self viewFromThemeElement:self.currentThemeElement];
        view.hidden = NO;
        if ([self.delegate respondsToSelector:@selector(elementsView:willSelectThemeElements:)])
            [self.delegate elementsView:self willSelectThemeElements:self.currentThemeElement];
        
        view.layer.shadowColor = [UIColor whiteColor].CGColor;
        view.layer.shadowRadius = 20.0;
        view.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        view.layer.shadowRadius = 0.0;
        view.layer.shadowOpacity = 1.0;
        
        [view.layer addAnimation:self.transformAnimation forKey:@"TransformAnimation"];
        [view.layer addAnimation:self.shadowAnimation forKey:@"ShadowAnimation"];
        
        if(view.alpha == 0.0) {
            [UIView animateWithDuration:0.2 animations:^{
                view.alpha = 0.5;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.2 animations:^{
                    view.alpha = 0.0;
                }];
            }];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(elementsView:didSelectThemeElements:)])
                [self.delegate elementsView:self didSelectThemeElements:self.currentThemeElement];
        });
    }
}

- (LSThemeElement)themeElementFromGesture:(UITapGestureRecognizer*)recognizer {
    UIView *view = recognizer.view;
    LSThemeElement element = -1;
    if (view == self.slideView) {
        element = LSThemeElementSlider;
    } else if (view == self.clockView) {
        element = LSThemeElementClock;
    } else if (view == self.photoImageView) {
        if ([self photoBorderFromGesture:recognizer])
            element = LSThemeElementPhotoBorder;
        else
            element = LSThemeElementPhoto;
    } else if (view == self.photoBorderImageView) {
        element = LSThemeElementPhotoBorder;
    } else if (view == self.backgroundView) {
        if ([self hiddenViewFromGesture:recognizer view:self.clockView]) {
            element = LSThemeElementClock;
        } else if ([self hiddenViewFromGesture:recognizer view:self.slideView]) {
            element = LSThemeElementSlider;
        } else if ([self hiddenViewFromGesture:recognizer view:self.photoImageView]) {
            element = LSThemeElementPhoto;
        } else if ([self hiddenViewFromGesture:recognizer view:self.photoBorderImageView]) {
            element = LSThemeElementPhotoBorder;
        } else if ([self photoBorderFromGesture:recognizer]) {
            element = LSThemeElementPhotoBorder;
        }
        else {
            element = LSThemeElementBackground;
        }
    }
    
    return element;
}

- (BOOL)photoBorderFromGesture:(UITapGestureRecognizer*)recognizer {
    UIView *view = recognizer.view;
    BOOL retFlag = NO;
    if (view == self.backgroundView) {
        CGPoint location = [recognizer locationInView:view];
        CGRect checkRect = self.photoBorderImageView.frame;
        
        checkRect.origin.x      -= CHECK_BORDER_OFFSET;
        checkRect.origin.y      -= CHECK_BORDER_OFFSET;
        checkRect.size.width    += CHECK_BORDER_OFFSET*2;
        checkRect.size.height   += CHECK_BORDER_OFFSET*2;
        
        retFlag = CGRectContainsPoint(checkRect, location);
    } else if (view == self.photoImageView) {
        CGPoint location = [recognizer locationInView:view];
        CGRect checkRect = self.photoImageView.bounds;
        
        checkRect.origin.x      += CHECK_BORDER_OFFSET*2;
        checkRect.origin.y      += CHECK_BORDER_OFFSET*2;
        checkRect.size.width    -= CHECK_BORDER_OFFSET*4;
        checkRect.size.height   -= CHECK_BORDER_OFFSET*4;
        
        retFlag = !CGRectContainsPoint(checkRect, location);
    }
    
    return retFlag;
}

- (BOOL)hiddenViewFromGesture:(UITapGestureRecognizer*)recognizer view:(UIView*)view {
    BOOL retFlag = NO;
    CGPoint location = [recognizer locationInView:recognizer.view];
    if ((view == self.clockView) || (view == self.slideView)) {
        retFlag = CGRectContainsPoint(view.frame, location);
    } else if (view == self.photoImageView) {
        CGRect checkRect = self.photoImageView.frame;
        
        checkRect.origin.x      += CHECK_BORDER_OFFSET*2;
        checkRect.origin.y      += CHECK_BORDER_OFFSET*2;
        checkRect.size.width    -= CHECK_BORDER_OFFSET*4;
        checkRect.size.height   -= CHECK_BORDER_OFFSET*4;
        
        retFlag = CGRectContainsPoint(view.frame, location);
    } else if (view == self.photoBorderImageView) {
        CGRect checkRect1 = self.photoBorderImageView.frame;
        checkRect1.origin.x      -= CHECK_BORDER_OFFSET;
        checkRect1.origin.y      -= CHECK_BORDER_OFFSET;
        checkRect1.size.width    += CHECK_BORDER_OFFSET*2;
        checkRect1.size.height   += CHECK_BORDER_OFFSET*2;
        
        CGRect checkRect2 = self.photoBorderImageView.frame;
        checkRect2.origin.x      += CHECK_BORDER_OFFSET*2;
        checkRect2.origin.y      += CHECK_BORDER_OFFSET*2;
        checkRect2.size.width    -= CHECK_BORDER_OFFSET*4;
        checkRect2.size.height   -= CHECK_BORDER_OFFSET*4;
        
        retFlag = (CGRectContainsPoint(checkRect1, location) && !CGRectContainsPoint(checkRect2, location));
    }
    
    return retFlag;
}

- (void)updateSubviews {
    if (!_designViewScheme) return;
    
    LSEtalonScheme *etalon = self.designViewScheme.etalonScheme;
    self.backgroundView.frame           = self.bounds;
    self.slideView.frame                = [etalon scaledFrameForSlideView];
    self.clockView.frame                = [etalon scaledFrameForClockView];
    self.photoImageView.frame           = [etalon scaledFrameForPhotoView];
    self.photoBorderImageView.frame     = [etalon scaledFrameForPhotoBorderView];
    
    self.backgroundView.contentMode         = UIViewContentModeScaleAspectFill;
    self.clockView.contentMode              = UIViewContentModeScaleAspectFill;
    self.photoBorderImageView.contentMode   = UIViewContentModeScaleAspectFill;
    self.photoImageView.contentMode         = UIViewContentModeScaleAspectFill;
    self.slideView.contentMode              = UIViewContentModeScaleAspectFill;
    
    self.backgroundView.layer.masksToBounds         = YES;
    self.clockView.layer.masksToBounds              = YES;
    self.photoBorderImageView.layer.masksToBounds   = YES;
    self.photoImageView.layer.masksToBounds         = YES;
    self.slideView.layer.masksToBounds              = YES;
    
    self.backgroundColor = [UIColor whiteColor];
}

- (UIView*)viewFromThemeElement:(LSThemeElement)elements {
    switch (elements) {
        case LSThemeElementBackground:
            return self.backgroundView;
            break;
        case LSThemeElementClock:
            return self.clockView;
            break;
        case LSThemeElementPhoto:
            return self.photoImageView;
            break;
        case LSThemeElementPhotoBorder:
            return self.photoBorderImageView;
            break;
        case LSThemeElementSlider:
            return self.slideView;
            break;
    }
}

- (void)animateView:(UIView*)view cornerRadius:(CGFloat)radius {
    LSEtalonScheme *etalon = self.designViewScheme.etalonScheme;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    animation.duration = 0.15;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(view.layer.cornerRadius);
    animation.toValue = @([etalon scaleCornerRadiusFrom:radius]);
    [view.layer addAnimation:animation forKey:@"animation"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        view.layer.cornerRadius = [etalon scaleCornerRadiusFrom:radius];
    });
}

- (void)setupView:(UIView*)view cornerRadius:(CGFloat)radius animation:(BOOL)animation {
    if (radius == -1.0) {
        if(animation)
            [UIView animateWithDuration:0.15 animations:^{
                view.alpha = 0.0;
            }];
        else
            view.alpha = 0.0;
    } else {
        if(view.alpha == 0.0) {
            if(animation)
                [UIView animateWithDuration:0.05 animations:^{
                    view.alpha = 1.0;
                } completion:^(BOOL finished) {
                    [self animateView:view cornerRadius:radius];
                }];
            else {
                view.alpha = 1.0;
                view.layer.cornerRadius = radius;
            }
        } else {
            if(animation)
                [self animateView:view cornerRadius:radius];
            else
                view.layer.cornerRadius = radius;
        }
    }
}

- (void)setupFakeElements {
    self.statusBarImageView = [[UIImageView alloc] init];
    LSDeviceDisplayInch screenInfo = [LSDeviceInformation displayInch];
    NSString *imgName = @"";
    switch (screenInfo) {
        case LSDeviceDisplay55:
            imgName = @"MStatusBar6P";
            break;
        case LSDeviceDisplay47:
            imgName = @"MStatusBar6";
            break;
        default:
            imgName = @"MStatusBar";
            break;
    }
    
    self.statusBarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.statusBarImageView.image = [UIImage imageNamed:imgName];
    self.statusBarImageView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.statusBarImageView];
    
    self.clockOnBackgroundImageView = [[UIImageView alloc] init];
    self.clockOnBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.clockOnBackgroundImageView.image = [UIImage imageNamed:@"MClockImage"];
    self.clockOnBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.clockOnBackgroundImageView.alpha = 0.0;
    [self.backgroundView addSubview:self.clockOnBackgroundImageView];
    
    self.clockOnClockImageView = [[UIImageView alloc] init];
    self.clockOnClockImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.clockOnClockImageView.image = [UIImage imageNamed:@"MClockImage"];
    self.clockOnClockImageView.backgroundColor = [UIColor clearColor];
    [self.clockView addSubview:self.clockOnClockImageView];
    
    self.slideOnBackgroundImageView = [[UIImageView alloc] init];
    self.slideOnBackgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.slideOnBackgroundImageView.image = [UIImage imageNamed:@"MSlideImage"];
    self.slideOnBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.slideOnBackgroundImageView.alpha = 0.0;
    [self.backgroundView addSubview:self.slideOnBackgroundImageView];
    
    self.slideOnSlideImageView = [[UIImageView alloc] init];
    self.slideOnSlideImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.slideOnSlideImageView.image = [UIImage imageNamed:@"MSlideImage"];
    self.slideOnSlideImageView.backgroundColor = [UIColor clearColor];
    [self.slideView addSubview:self.slideOnSlideImageView];
}

- (void)updateFakeElements {
    CGFloat width, height;
    width = CGRectGetWidth(self.frame);
    height = 20.0 * (width / CGRectGetWidth([UIScreen mainScreen].bounds));
    CGRect statusBarFrame = CGRectMake(0.0, 0.0, width, height);
    self.statusBarImageView.frame = statusBarFrame;
    
    self.clockOnBackgroundImageView.frame = self.clockView.frame;
    self.clockOnClockImageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.clockView.frame), CGRectGetHeight(self.clockView.frame));
    self.slideOnBackgroundImageView.frame = self.slideView.frame;
    self.slideOnSlideImageView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.slideView.frame), CGRectGetHeight(self.slideView.frame));
}

- (void)addShadowViews {
    if(!self.shadowClockView) {
        LSEtalonScheme *etalon = self.designViewScheme.etalonScheme;
        
        self.shadowClockView        = [etalon scaledShadowViewForClockOrSlideView];
        self.shadowClockView.frame  = self.clockView.frame;
        [self insertSubview:self.shadowClockView belowSubview:self.clockView];
        
        self.shadowSlideView        = [etalon scaledShadowViewForClockOrSlideView];
        self.shadowSlideView.frame  = self.slideView.frame;
        [self insertSubview:self.shadowSlideView belowSubview:self.slideView];
        
        self.shadowPhotoBorderView  = [etalon scaledShadowViewForPhotoOrBorderView];
        self.shadowPhotoBorderView.frame  = self.photoBorderImageView.frame;
        [self insertSubview:self.shadowPhotoBorderView belowSubview:self.photoBorderImageView];
        
        self.shadowPhotoView        = [etalon scaledShadowViewForPhotoOrBorderView];
        self.shadowPhotoView.frame  = self.photoImageView.frame;
        [self insertSubview:self.shadowPhotoView belowSubview:self.photoImageView];
        
        [self updateShadowColor];
    }
}

- (void)updateShadowColor {
    CGColorRef shadowColor = self.shadowColor.CGColor;
    self.shadowClockView.layer.shadowColor = shadowColor;
    self.shadowSlideView.layer.shadowColor = shadowColor;
    self.shadowPhotoBorderView.layer.shadowColor = shadowColor;
    self.shadowPhotoView.layer.shadowColor = shadowColor;
}

#pragma mark - KVO

- (void)addUIElementsKVO {
    [self.clockView addObserver:self forKeyPath:kvoClockViewHidden options:NSKeyValueObservingOptionNew context:nil];
    [self.slideView addObserver:self forKeyPath:kvoSlideViewHidden options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeUIElementsKVO {
    [self.clockView removeObserver:self forKeyPath:kvoClockViewHidden];
    [self.slideView removeObserver:self forKeyPath:kvoSlideViewHidden];
}

- (void)addKVO {
    [_drawScheme addObserver:self forKeyPath:kvoBackgroundViewColor             options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoBackgroundViewImage             options:NSKeyValueObservingOptionNew context:nil];
    
    [_drawScheme addObserver:self forKeyPath:kvoClockViewCornerRadius           options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoClockViewColor                  options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoClockViewImage                  options:NSKeyValueObservingOptionNew context:nil];
    
    [_drawScheme addObserver:self forKeyPath:kvoSlideViewCornerRadius           options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoSlideViewColor                  options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoSlideViewImage                  options:NSKeyValueObservingOptionNew context:nil];
    
    [_drawScheme addObserver:self forKeyPath:kvoPhotoViewCornerRadius           options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoPhotoViewImage                  options:NSKeyValueObservingOptionNew context:nil];
    
    [_drawScheme addObserver:self forKeyPath:kvoPhotoBorderViewCornerRadius     options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoPhotoBorderViewColor            options:NSKeyValueObservingOptionNew context:nil];
    [_drawScheme addObserver:self forKeyPath:kvoPhotoBorderViewImage            options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeKVO {
    [_drawScheme removeObserver:self forKeyPath:kvoBackgroundViewColor];
    [_drawScheme removeObserver:self forKeyPath:kvoBackgroundViewImage];
    
    [_drawScheme removeObserver:self forKeyPath:kvoClockViewCornerRadius];
    [_drawScheme removeObserver:self forKeyPath:kvoClockViewColor];
    [_drawScheme removeObserver:self forKeyPath:kvoClockViewImage];
    
    [_drawScheme removeObserver:self forKeyPath:kvoSlideViewCornerRadius];
    [_drawScheme removeObserver:self forKeyPath:kvoSlideViewColor];
    [_drawScheme removeObserver:self forKeyPath:kvoSlideViewImage];
    
    [_drawScheme removeObserver:self forKeyPath:kvoPhotoViewCornerRadius];
    [_drawScheme removeObserver:self forKeyPath:kvoPhotoViewImage];
    
    [_drawScheme removeObserver:self forKeyPath:kvoPhotoBorderViewCornerRadius];
    [_drawScheme removeObserver:self forKeyPath:kvoPhotoBorderViewColor];
    [_drawScheme removeObserver:self forKeyPath:kvoPhotoBorderViewImage];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[LSDrawScheme class]]) {
        if ([keyPath isEqualToString:kvoClockViewCornerRadius]) {
            CGFloat radius = [change[NSKeyValueChangeNewKey] floatValue];
            [self setupView:self.clockView cornerRadius:radius animation:YES];
            [self setupView:self.shadowClockView cornerRadius:radius animation:YES];
            
        } else if ([keyPath isEqualToString:kvoClockViewColor]) {
            UIColor *color = change[NSKeyValueChangeNewKey];
            self.clockView.backgroundColor = color;
            
        } else if ([keyPath isEqualToString:kvoClockViewImage]) {
            UIImage *image = change[NSKeyValueChangeNewKey];
            self.clockView.image = [image isKindOfClass:[NSNull class]] ? nil : image;
            
        } else if ([keyPath isEqualToString:kvoSlideViewCornerRadius]) {
            CGFloat radius = [change[NSKeyValueChangeNewKey] floatValue];
            [self setupView:self.slideView cornerRadius:radius animation:YES];
            [self setupView:self.shadowSlideView cornerRadius:radius animation:YES];
            
        } else if ([keyPath isEqualToString:kvoSlideViewColor]) {
            UIColor *color = change[NSKeyValueChangeNewKey];
            self.slideView.backgroundColor = color;
            
        } else if ([keyPath isEqualToString:kvoSlideViewImage]) {
            UIImage *image = change[NSKeyValueChangeNewKey];
            self.slideView.image = [image isKindOfClass:[NSNull class]] ? nil : image;
            
        } else if ([keyPath isEqualToString:kvoPhotoViewCornerRadius]) {
            CGFloat radius = [change[NSKeyValueChangeNewKey] floatValue];
            [self setupView:self.photoImageView cornerRadius:radius animation:YES];
            if(self.photoBorderImageView.alpha <= 0.0)
                [self setupView:self.shadowPhotoView cornerRadius:radius animation:YES];
            else
                [self setupView:self.shadowPhotoView cornerRadius:-1 animation:NO];
            
        } else if ([keyPath isEqualToString:kvoPhotoViewImage]) {
            UIImage *image = change[NSKeyValueChangeNewKey];
            self.photoImageView.image = [image isKindOfClass:[NSNull class]] ? nil : image;
            
        } else if ([keyPath isEqualToString:kvoPhotoBorderViewCornerRadius]) {
            CGFloat radius = [change[NSKeyValueChangeNewKey] floatValue];
            [self setupView:self.photoBorderImageView cornerRadius:radius animation:YES];
            [self setupView:self.shadowPhotoBorderView cornerRadius:radius animation:YES];
            if(radius-1)
                [self setupView:self.shadowPhotoView cornerRadius:self.photoImageView.layer.cornerRadius animation:NO];
            if(radius >= 0)
                self.shadowPhotoView.alpha = 0.0;
            
        } else if ([keyPath isEqualToString:kvoPhotoBorderViewColor]) {
            UIColor *color = change[NSKeyValueChangeNewKey];
            self.photoBorderImageView.backgroundColor = color;
            
        } else if ([keyPath isEqualToString:kvoPhotoBorderViewImage]) {
            UIImage *image = change[NSKeyValueChangeNewKey];
            self.photoBorderImageView.image = [image isKindOfClass:[NSNull class]] ? nil : image;
            
        } else if ([keyPath isEqualToString:kvoBackgroundViewColor]) {
            UIColor *color= change[NSKeyValueChangeNewKey];
            self.backgroundView.backgroundColor = color;
            if([color isEqualToColor:[UIColor blackColor]])
                self.shadowColor = [UIColor grayColor];
            else
                self.shadowColor = [UIColor blackColor];
            [self updateShadowColor];
            
        } else if ([keyPath isEqualToString:kvoBackgroundViewImage]) {
            UIImage *image= change[NSKeyValueChangeNewKey];
            self.backgroundView.image = [image isKindOfClass:[NSNull class]] ? nil : image;
        }
    } else if ([object isKindOfClass:[UIImageView class]]) {
        if ([keyPath isEqualToString:kvoClockViewHidden] && (object == self.clockView)) {
            CGFloat alpha = [change[NSKeyValueChangeNewKey] floatValue];
            self.clockOnBackgroundImageView.alpha = 1.0 - alpha;
        } else if ([keyPath isEqualToString:kvoSlideViewHidden] && (object == self.slideView)) {
            CGFloat alpha = [change[NSKeyValueChangeNewKey] floatValue];
            self.slideOnBackgroundImageView.alpha = 1.0 - alpha;
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
