//
//  LSButton.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/16/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSButton.h"

@interface LSButtonSelectionLayer : CALayer

@end

@implementation LSButtonSelectionLayer

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
    CGFloat gradLocations[2] = {0.0f, 0.5f};
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.8f,0.0f,0.0f,0.0f,0.0f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    CGColorSpaceRelease(colorSpace);
    
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    
    CGContextDrawRadialGradient (ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
    
    
    CGGradientRelease(gradient);
}

@end

#define SELECT_ANIMATION_DERATION           0.05
#define DESELECT_ANIMATION_DERATION         0.2

@interface LSButton()

@property (nonatomic, strong) LSButtonSelectionLayer                *gradientLayer;

@property (nonatomic, strong) CABasicAnimation                      *selectAnimation;
@property (nonatomic, strong) CABasicAnimation                      *deselectAnimation;
@property (nonatomic, strong) CABasicAnimation                      *selectBorderAnimation;
@property (nonatomic, strong) CABasicAnimation                      *deselectBorderAnimation;

@end

@implementation LSButton

- (void)setupTopButton {
    self.backgroundColor      = [UIColor topButtonColor];
    [self setTitleColor:[UIColor topButtonFontColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.0];
    
    self.layer.cornerRadius   = [LSUIDesign mainRoundCorner];
    
    self.layer.shadowColor    = [UIColor shadowColor].CGColor;
    self.layer.shadowRadius   = 3.0;
    self.layer.shadowOpacity  = 0.7;
    self.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
    
    self.layer.borderColor    = [UIColor mainBorderColor].CGColor;
    self.layer.borderWidth    = [LSUIDesign mainBorderWidth];
}

- (LSButtonSelectionLayer*)gradientLayer {
    if (_gradientLayer)
        return _gradientLayer;
    
    CGFloat size = MAX(self.frame.size.height, self.frame.size.width) * 2;
    LSButtonSelectionLayer *layer = [LSButtonSelectionLayer layer];
    layer.frame = CGRectMake(0.0, 0.0, size, size);
    layer.opacity = 0.0;
    _gradientLayer = layer;
    [self.layer addSublayer:_gradientLayer];
    self.clipsToBounds = YES;
    return layer;
}

- (CABasicAnimation*)selectBorderAnimation {
    if (_selectBorderAnimation)
        return _selectBorderAnimation;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    animation.duration = SELECT_ANIMATION_DERATION;
    animation.fromValue = (__bridge id)([UIColor mainBorderColor].CGColor);
    animation.toValue = (__bridge id)([UIColor blackColor].CGColor);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    _selectBorderAnimation = animation;
    return _selectBorderAnimation;
}

- (CABasicAnimation*)deselectBorderAnimation {
    if (_deselectBorderAnimation)
        return _deselectBorderAnimation;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    animation.duration = SELECT_ANIMATION_DERATION;
    animation.fromValue = (__bridge id)([UIColor blackColor].CGColor);
    animation.toValue = (__bridge id)([UIColor mainBorderColor].CGColor);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    _deselectBorderAnimation = animation;
    return _deselectBorderAnimation;
}


- (CABasicAnimation*)selectAnimation {
    if (_selectAnimation)
        return _selectAnimation;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = SELECT_ANIMATION_DERATION;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    _selectAnimation = animation;
    return _selectAnimation;
}

- (CABasicAnimation*)deselectAnimation {
    if (_deselectAnimation)
        return _deselectAnimation;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = SELECT_ANIMATION_DERATION;
    animation.fromValue = @(1.0);
    animation.toValue = @(0.0);
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    _deselectAnimation = animation;
    return _deselectAnimation;
}


- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL flag = [super beginTrackingWithTouch:touch withEvent:event];
    CGPoint location = [touch locationInView:self];
    if(flag) {
        [self selectAnimation:location];
    }
    
    return flag;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL flag = [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint location = [touch locationInView:self];
    self.gradientLayer.position = location;
    
    return flag;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    CGPoint location = [touch locationInView:self];
    [self deselectAnimation:location];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
    [super cancelTrackingWithEvent:event];
    [self deselectAnimation:CGPointZero];
}

- (void)selectAnimation:(CGPoint)location {
    self.gradientLayer.position = location;
    [self.gradientLayer addAnimation:self.selectAnimation forKey:@"SelectAnimation"];
    [self.layer addAnimation:self.selectBorderAnimation forKey:@"SelectBorderColor"];
}

- (void)deselectAnimation:(CGPoint)loaction {
    [self.gradientLayer addAnimation:self.deselectAnimation forKey:@"DeselectAnimation"];
    [self.layer addAnimation:self.deselectBorderAnimation forKey:@"DeselectBorderColor"];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

@end
