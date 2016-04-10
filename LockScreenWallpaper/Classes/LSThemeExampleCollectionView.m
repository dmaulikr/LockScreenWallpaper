//
//  LSThemeExampleCollectionView.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeExampleCollectionView.h"
#import "LSExampleCollectionViewCell.h"

#define CELL_IDENTIFIER                     @"ExampleCell"
#define CELL_OFFSET                         10.0
#define CELL_COUNT                          2

@interface LSThemeExampleCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate> {
    NSArray                         *_imagesList;
}

@end

@implementation LSThemeExampleCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout      = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection                  = UICollectionViewScrollDirectionHorizontal;
    CGSize itemSize                         = [self rectForCellSize:frame];
    CGFloat spacing                         = [self cellSpacingForSize:itemSize frame:frame];
    layout.itemSize                         = itemSize;
    layout.minimumLineSpacing               = spacing;
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[LSExampleCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        self.delegate                           = self;
        self.dataSource                         = self;
        CGFloat contectInset                    = spacing / 2;
        self.contentInset                       = UIEdgeInsetsMake(0.0, contectInset, 0.0, contectInset);
        self.showsHorizontalScrollIndicator     = NO;
    }
    
    return self;
}

- (CGSize)rectForCellSize:(CGRect)frame {
    CGSize retSize;
    float ratio = [LSDeviceInformation displayRatio];
    
    retSize.width = CGRectGetWidth(frame) / CELL_COUNT;
    retSize.width -= CELL_OFFSET;
    retSize.height = retSize.width * ratio;
    if(retSize.height < (CGRectGetHeight(frame) - 2 * CELL_OFFSET))
        return retSize;
    
    retSize.height = CGRectGetHeight(frame) - 2 * CELL_OFFSET;
    retSize.width = retSize.height / ratio;
    
    if ((retSize.width + 2 * CELL_OFFSET) * 2 <= CGRectGetWidth(frame))
        return retSize;
    
    return retSize;
}

- (CGFloat)cellSpacingForSize:(CGSize)size frame:(CGRect)frame {
    CGFloat widthItem, widthView, retSpacing;
    widthItem = size.width;
    widthView = CGRectGetWidth(frame);
    
    retSpacing = (widthView - CELL_COUNT * widthItem) / CELL_COUNT;
    return retSpacing;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_imagesList) {
        return _imagesList.count;
    } else {
        if ([self.themeExamplesDelegate respondsToSelector:@selector(imagesListForExamplesCollectionView:)]) {
            _imagesList = [self.themeExamplesDelegate imagesListForExamplesCollectionView:self];
            return _imagesList.count;
        }
    }
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSExampleCollectionViewCell *cell = (LSExampleCollectionViewCell*)[self dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.exampleImage = _imagesList[indexPath.row];
    return cell;
}

@end
