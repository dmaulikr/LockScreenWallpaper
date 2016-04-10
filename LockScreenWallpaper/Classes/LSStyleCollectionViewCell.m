//
//  LSStyleCollectionViewCell.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/18/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSStyleCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

#define IMAGE_CELL_INSET                        5.0
#define CELL_SELECTED_BORDER_WIDTH              3.0
#define CELL_SELECTION_ANIMATION_DURATION       0.2
#define CELL_APPEARENCE_ANIMATION_DURATION      0.3

@interface LSStyleCollectionViewCell()

@property (nonatomic, strong) UIImageView                       *styleImageView;

@end

@implementation LSStyleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.contentView.bounds;
        rect.origin.x       += IMAGE_CELL_INSET;
        rect.origin.y       += IMAGE_CELL_INSET;
        rect.size.height    -= IMAGE_CELL_INSET * 2;
        rect.size.width     -= IMAGE_CELL_INSET * 2;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        imgView.backgroundColor         = [UIColor topButtonColor];
        imgView.layer.borderColor       = [UIColor mainBorderColor].CGColor;
        imgView.layer.borderWidth       = [LSUIDesign mainBorderWidth];
        imgView.layer.cornerRadius      = [LSUIDesign mainRoundCorner];
        
        imgView.layer.shadowColor    = [UIColor shadowColor].CGColor;
        imgView.layer.shadowRadius   = 3.0;
        imgView.layer.shadowOpacity  = 0.7;
        imgView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
        
        imgView.clipsToBounds        = YES;
        
        self.styleImageView             = imgView;
        self.showCell                   = YES;
        [self.contentView addSubview:self.styleImageView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)setStyleImage:(UIImage *)styleImage {
    _styleImage = styleImage;
    self.styleImageView.image = _styleImage;
}

- (void)setShowCell:(BOOL)showCell {
    _showCell = showCell;
    if (_showCell) {
        [UIView animateWithDuration:CELL_APPEARENCE_ANIMATION_DURATION animations:^{
            self.styleImageView.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:CELL_APPEARENCE_ANIMATION_DURATION animations:^{
            self.styleImageView.alpha = 0.0;
        }];
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.styleImageView.layer.borderWidth = CELL_SELECTED_BORDER_WIDTH;
    } else {
        self.styleImageView.layer.borderWidth = [LSUIDesign mainBorderWidth];
    }
}

- (void)setSelectWithAnimation:(BOOL)selectWithAnimation {
    _selectWithAnimation = selectWithAnimation;
    
    if (_selectWithAnimation) {
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        transformAnimation.duration         = CELL_SELECTION_ANIMATION_DURATION;
        transformAnimation.autoreverses     = YES;
        transformAnimation.toValue          = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.18, 1.18, 1.0)];
        
        CABasicAnimation *borderWidthAnimation  = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        borderWidthAnimation.duration           = CELL_SELECTION_ANIMATION_DURATION;
        borderWidthAnimation.toValue            = @(CELL_SELECTED_BORDER_WIDTH);
        
        CABasicAnimation *borderColorAnimation  = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        borderColorAnimation.duration           = CELL_SELECTION_ANIMATION_DURATION;
        borderColorAnimation.autoreverses       = YES;
        borderColorAnimation.toValue            = (id)[UIColor blackColor].CGColor;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = CELL_SELECTION_ANIMATION_DURATION;
        group.animations = @[transformAnimation, borderColorAnimation, borderWidthAnimation];
        [self.styleImageView.layer addAnimation:transformAnimation forKey:@"SelectAnimation"];
        [self.styleImageView.layer addAnimation:borderColorAnimation forKey:@"SelectAnimation1"];
        [self.styleImageView.layer addAnimation:borderWidthAnimation forKey:@"SelectAnimation12"];
    } else {
        CABasicAnimation *borderWidthAnimation      = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
        borderWidthAnimation.fillMode               = kCAFillModeForwards;
        borderWidthAnimation.removedOnCompletion    = NO;
        borderWidthAnimation.toValue                = @([LSUIDesign mainBorderWidth]);
        [self.styleImageView.layer addAnimation:borderWidthAnimation forKey:@"DeselectAnimation"];
    }
}

@end
