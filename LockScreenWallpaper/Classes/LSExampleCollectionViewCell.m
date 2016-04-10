//
//  LSExampleCollectionViewCell.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSExampleCollectionViewCell.h"

@interface LSExampleCollectionViewCell()

@property (nonatomic, strong) UIImageView                       *imageView;

@end


@implementation LSExampleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = self.contentView.bounds;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
        
        imgView.layer.shadowColor    = [UIColor shadowColor].CGColor;
        imgView.layer.shadowRadius   = 3.0;
        imgView.layer.shadowOpacity  = 0.7;
        imgView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
        
        self.imageView                  = imgView;
        self.imageView.backgroundColor  = [UIColor purpleColor];
        self.imageView.clipsToBounds    = NO;
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

- (void)setExampleImage:(UIImage *)exampleImage {
    _exampleImage = exampleImage;
    self.imageView.image = _exampleImage;
}

@end
