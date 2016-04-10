//
//  LSOnboardView.m
//  LockScreenWallpaper
//
//  Created by ZZI on 21/05/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSOnboardView.h"
#import <QuartzCore/QuartzCore.h>

#define TAP_ANIMATION_DURATION                          0.3
#define SHOW_INSTRUCTION_LABEL_ANIMATION_DURATION       0.2

@interface LSFingerMarkLayer : CALayer

@end

@implementation LSFingerMarkLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    size_t gradLocationsNum = 2;
    CGFloat gradLocations[2] = {0.0f, 0.3f};
    CGFloat gradColors[8] = {1.0f,1.0f,1.0f,1.0f,0.0f,0.0f,0.0f,0.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsBeforeStartLocation);
    
    
    CGGradientRelease(gradient);
}

@end

@interface LSOnboardView()

@property (nonatomic, weak) LSDesignViewController          *designVC;
@property (nonatomic, strong) UIView                        *fingerMark;
@property (nonatomic, strong) UIView                        *backgroundView;
@property (nonatomic, strong) UILabel                       *instructionLabel;

@end

@implementation LSOnboardView

#pragma mark - Publick Methods

- (instancetype)initWithDesignViewController:(LSDesignViewController*)vc {
    CGRect frame = vc.view.bounds;
    self = [self initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.75;
        self.backgroundView = backgroundView;
        [self addSubview:backgroundView];
        self.designVC = vc;
        self.alpha = 0.0;
    }
    
    return self;
}

- (void)showInstruction {
    [self.designVC.view addSubview:self];
    
    [UIView animateWithDuration:ONBOARD_VIEW_SHOW_ANIMATION_DURATION
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self showThemeSelection];
                     }];
}

- (void)showTips {
    [self.designVC.view addSubview:self];
    
    [UIView animateWithDuration:ONBOARD_VIEW_SHOW_ANIMATION_DURATION
                     animations:^{
                         self.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         [self showTipsOne];
                     }];
}

#pragma mark - Private Methods

- (UIView*)fingerMark {
    if(_fingerMark)
        return _fingerMark;
    
    CGRect frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    _fingerMark = [[UIView alloc] initWithFrame:frame];
    _fingerMark.backgroundColor = [UIColor clearColor];
    LSFingerMarkLayer *layer = [LSFingerMarkLayer layer];
    layer.frame = frame;
    _fingerMark.alpha = 0.0;
    [_fingerMark.layer addSublayer:layer];
    [self addSubview:_fingerMark];
    
    return _fingerMark;
}

- (UILabel*)instructionLabel {
    if(_instructionLabel)
        return _instructionLabel;
    
    CGFloat height, width, x, y;
    height = CGRectGetHeight(self.frame)/2;
    width = CGRectGetWidth(self.frame)/3*2;
    x = (CGRectGetWidth(self.frame) - width)/2;
    y = (CGRectGetHeight(self.frame) - height)/2;
    CGRect frame = CGRectMake(x, y, width, height);
    _instructionLabel = [[UILabel alloc] initWithFrame:frame];
    _instructionLabel.textAlignment = NSTextAlignmentCenter;
    _instructionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _instructionLabel.numberOfLines = 0;
    _instructionLabel.textColor = [UIColor whiteColor];
    _instructionLabel.alpha = 0.0;
    _instructionLabel.shadowColor = [UIColor blackColor];
    
    CGFloat fontSize = 0.0;
    LSDeviceDisplayInch screen = [LSDeviceInformation displayInch];
    switch (screen) {
        case LSDeviceDisplay35:
        case LSDeviceDisplay40:
            fontSize = 28.0; break;
        case LSDeviceDisplay47:
            fontSize = 32.0; break;
        case LSDeviceDisplay55:
            fontSize = 38.0; break;
        default:
            break;
    }
    _instructionLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:fontSize];
    
    [self addSubview:_instructionLabel];
    
    return _instructionLabel;
}

- (void)showThemeSelection {
    self.fingerMark.center = self.designVC.themesButton.center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Tap to choose theme for your wallpaper", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fingerMarkTap:^{
                [self hideInstructionLabelWithComletion:^{
                    [self showElementSelection];
                }];
            }];
        });
    }];
}

- (void)showElementSelection {
    CGPoint center = self.designVC.elementsView.clockView.center;
    center.x += CGRectGetMinX(self.designVC.elementsView.frame);
    center.y += CGRectGetMinY(self.designVC.elementsView.frame);
    self.fingerMark.center = center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Double tap to select wallpaper element", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fingerMarkDoubleTap:^{
                [self hideInstructionLabelWithComletion:^{
                    [self showColorSelection];
                }];
            }];
        });
    }];
}

- (void)showColorSelection {
    __block CGPoint center = self.designVC.elementsColorView.center;
    center.y += 60.0;
    self.fingerMark.center = center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Swipe to select color", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                self.fingerMark.alpha = 1.0;
            } completion:^(BOOL finished) {
                center.y -= 120.0;
                [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.fingerMark.center = center;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                        self.fingerMark.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        center.x = self.designVC.elementsColorCollectionView.center.x;
                        self.fingerMark.center = center;
                        [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                            self.fingerMark.alpha = 1.0;
                        } completion:^(BOOL finished) {
                            center.y += 120.0;
                            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.fingerMark.center = center;
                            } completion:^(BOOL finished) {
                                [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                                    self.fingerMark.alpha = 0.0;
                                } completion:^(BOOL finished) {
                                    [self hideInstructionLabelWithComletion:^{
                                        [self showShapeSelection];
                                    }];
                                }];
                            }];
                        }];
                    }];
                }];
            }];
        });
    }];
}

- (void)showShapeSelection {
    CGPoint center = self.designVC.elementsStyleView.center;
    center.x -= 40.0;
    self.fingerMark.center = center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Tap to select element shape", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fingerMarkTap:^{
                [self hideInstructionLabelWithComletion:^{
                    [self showSwitchingToImages];
                }];
            }];
        });
    }];
}

- (void)showSwitchingToImages {
    __block CGPoint center = self.fingerMark.center;
    center.x += 40.0;
    center.y = CGRectGetHeight(self.frame) - 80.0;
    self.fingerMark.center = center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Vertical swipe to switch to images", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                self.fingerMark.alpha = 1.0;
            } completion:^(BOOL finished) {
                center.y += 100.0;
                [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.fingerMark.center = center;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:TAP_ANIMATION_DURATION/2 animations:^{
                        self.fingerMark.alpha = 0.0;
                    } completion:^(BOOL finished) {
                        [self hideInstructionLabelWithComletion:^{
                            [self showPreviewWallpaper];
                        }];
                    }];
                }];
            }];
        });
    }];
}

- (void)showPreviewWallpaper {
    self.fingerMark.center = self.designVC.fullScreenButton.center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Tap to see wallpaper in full size", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fingerMarkTap:^{
                [self hideInstructionLabelWithComletion:^{
                    [self showSaveWallpaper];
                }];
            }];
        });
    }];
}

- (void)showSaveWallpaper {
    self.fingerMark.center = self.designVC.saveButton.center;
    [self showInstructionLabelWithText:NSLocalizedString(@"Tap to save your wallpaper", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fingerMarkTap:^{
                [self hideInstructionLabelWithComletion:^{
                    [self showFinalMessage];
                }];
            }];
        });
    }];
}

- (void)showFinalMessage {
    [self showInstructionLabelWithText:NSLocalizedString(@"You can disable parallax effect for the best view", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hideInstructionLabelWithComletion:^{
                [self showInstructionLabelWithText:NSLocalizedString(@"Go to Settings - General - Accessibility - Reduce Motion", @"") comletion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self hideInstructionLabelWithComletion:^{
                            [self showInstructionLabelWithText:NSLocalizedString(@"After you can setup your new lock screen wallpaper", @"") comletion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                    [self hideInstructionLabelWithComletion:^{
                                        [self showTipsOne];
                                    }];
                                });
                            }];
                        }];
                    });
                }];
            }];
        });
    }];
}

- (void)showTipsOne {
    [self showInstructionLabelWithText:NSLocalizedString(@"If you like your parallax effect with moving icons and animations, you can still use LockyS", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hideInstructionLabelWithComletion:^{
                [self showInstructionLabelWithText:NSLocalizedString(@"You need just hide Clock element view and Slide element view while edit wallpaper", @"") comletion:^{
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self hideInstructionLabelWithComletion:^{
                            [self showInstructionLabelWithText:NSLocalizedString(@"You can edit other elements as you wish and get your awesome LockyS", @"") comletion:^{
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                    [self hideInstructionLabelWithComletion:^{
                                        [self showEnjoyMessage];
                                    }];
                                });
                            }];
                            
                        }];
                    });
                }];
            }];
        });
    }];
}

- (void)showEnjoyMessage {
    CGFloat fontSize = self.instructionLabel.font.pointSize;
    self.instructionLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:fontSize*2];
    [self showInstructionLabelWithText:NSLocalizedString(@"Enjoy!", @"") comletion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hideInstructionLabelWithComletion:^{
                [self hideOnboardView];
            }];
        });
    }];
}

- (void)hideOnboardView {
    [UIView animateWithDuration:ONBOARD_VIEW_SHOW_ANIMATION_DURATION animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)fingerMarkTap:(void(^)(void))completion {
    self.fingerMark.alpha = 0.0;
    [UIView animateWithDuration:TAP_ANIMATION_DURATION animations:^{
        self.fingerMark.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:TAP_ANIMATION_DURATION animations:^{
            self.fingerMark.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.fingerMark.alpha = 0.0;
            if(completion)
                completion();
        }];
    }];
}

- (void)fingerMarkDoubleTap:(void(^)(void))completion {
    [self fingerMarkTap:^{
        [self fingerMarkTap:^{
            if(completion)
                completion();
        }];
    }];
}

- (void)showInstructionLabelWithText:(NSString*)text comletion:(void(^)(void))completion {
    self.instructionLabel.text = text;
    [UIView animateWithDuration:SHOW_INSTRUCTION_LABEL_ANIMATION_DURATION animations:^{
        self.instructionLabel.alpha = 1.0;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

- (void)hideInstructionLabelWithComletion:(void(^)(void))completion {
    [UIView animateWithDuration:SHOW_INSTRUCTION_LABEL_ANIMATION_DURATION animations:^{
        self.instructionLabel.alpha = 0.0;
    } completion:^(BOOL finished) {
        if(completion)
            completion();
    }];
}

@end
