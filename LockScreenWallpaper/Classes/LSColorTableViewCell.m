//
//  LSColorTableViewCell.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/14/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSColorTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define SELECT_ANIMATION_DURATION                       0.1
#define CELL_APPEARENCE_ANIMATION_DURATION              0.2

@interface LSColorTableViewCell()

@property (nonatomic, strong) UIView                        *colorView;
@property (nonatomic, assign) CATransform3D                  originalTransform;

@end

@implementation LSColorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor    = [UIColor clearColor];
        self.colorView          = [[UIView alloc] initWithFrame:CGRectZero];
        self.colorView.layer.borderColor    = [UIColor mainBorderColor].CGColor;
        self.colorView.layer.borderWidth    = [LSUIDesign mainBorderWidth];
        self.colorView.layer.cornerRadius   = [LSUIDesign mainRoundCorner];
        
        self.colorView.layer.shadowColor    = [UIColor shadowColor].CGColor;
        self.colorView.layer.shadowRadius   = 3.0;
        self.colorView.layer.shadowOpacity  = 0.7;
        self.colorView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
        
        [self.contentView addSubview:self.colorView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.alpha = 0.0;
    }
    
    return self;
}

- (void)setCellColor:(UIColor *)cellColor {
    _cellColor = cellColor;
    self.colorView.backgroundColor = _cellColor;
}

- (void)setSelectCell:(BOOL)selectCell {
    if (_selectCell != selectCell) {
        _selectCell = selectCell;
        
        if (_selectCell) {
            self.originalTransform = self.layer.transform;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = SELECT_ANIMATION_DURATION;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.18, 1.18, 1.0)];
            [self.layer addAnimation:animation forKey:@"SelectAnimation"];
            
            CABasicAnimation *animationColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animationColor.duration = SELECT_ANIMATION_DURATION;
            animationColor.autoreverses = YES;
            animationColor.toValue = (id)[UIColor blackColor].CGColor;
            [self.colorView.layer addAnimation:animationColor forKey:@"ColorSelectAnimation"];
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = SELECT_ANIMATION_DURATION;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:self.originalTransform];
            [self.layer addAnimation:animation forKey:@"DeselectAnimation"];
            
            CABasicAnimation *animationColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animationColor.duration = SELECT_ANIMATION_DURATION;
            animationColor.fillMode = kCAFillModeForwards;
            animationColor.removedOnCompletion = NO;
            animationColor.toValue = (id)[UIColor mainBorderColor].CGColor;
            [self.colorView.layer addAnimation:animationColor forKey:@"ColorDeselectAnimation"];
        }
    }
}

- (void)setShowCell:(BOOL)showCell {
    _showCell = showCell;
    if (_showCell) {
        [UIView animateWithDuration:CELL_APPEARENCE_ANIMATION_DURATION animations:^{
            self.contentView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:CELL_APPEARENCE_ANIMATION_DURATION animations:^{
            self.contentView.alpha = 0.0;
        }];
    }
}

- (void)setShowCellWithoutAnimation:(BOOL)showCellWithoutAnimation {
    _showCellWithoutAnimation = showCellWithoutAnimation;
    if (_showCellWithoutAnimation)
        self.contentView.alpha = 1.0;
    else
        self.contentView.alpha = 0.0;
}

- (void)setSelected:(BOOL)selected {
    // to deactivate standart selection
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // to deactivate standart selection
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.bounds;
    self.colorView.frame = CGRectMake((bounds.origin.x + 3), (bounds.origin.y + 3), (bounds.size.width - 6), (bounds.size.height - 6));

}

- (void)selectCellWithoutAnimation:(BOOL)selectCell; {
    if (_selectCell != selectCell) {
        _selectCell = selectCell;
        
        if (_selectCell) {
            self.originalTransform = self.layer.transform;
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.0001;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.18, 1.18, 1.0)];
            [self.layer addAnimation:animation forKey:@"SelectAnimation"];
            
            CABasicAnimation *animationColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animationColor.duration = 0.0001;
            animationColor.autoreverses = YES;
            animationColor.toValue = (id)[UIColor blackColor].CGColor;
            [self.colorView.layer addAnimation:animationColor forKey:@"ColorSelectAnimation"];
        } else {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.0001;
            animation.fillMode = kCAFillModeForwards;
            animation.removedOnCompletion = NO;
            animation.toValue = [NSValue valueWithCATransform3D:self.originalTransform];
            [self.layer addAnimation:animation forKey:@"DeselectAnimation"];
            
            CABasicAnimation *animationColor = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animationColor.duration = 0.0001;
            animationColor.fillMode = kCAFillModeForwards;
            animationColor.removedOnCompletion = NO;
            animationColor.toValue = (id)[UIColor mainBorderColor].CGColor;
            [self.colorView.layer addAnimation:animationColor forKey:@"ColorDeselectAnimation"];
        }

    }
}

@end
