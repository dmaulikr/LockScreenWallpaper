//
//  LSThemesCollectionView.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemesCollectionView.h"
#import "LSThemeCollectionViewCell.h"

#define CELL_IDENTIFIER                     @"ThemeCell"
#define CELL_OFFSET                         30.0

@interface LSThemesCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate, LSThemeCollectionViewCellDelegate> {
    CGFloat                                              _oldOffset;
    LSScrollDirection                                    _scrollDirection;
}

@end

@implementation LSThemesCollectionView

- (instancetype)initWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *layout      = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection                  = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing          = 5.0;
    CGSize cellSize                         = frame.size;
    cellSize.height                        -= CELL_OFFSET * 2;
    cellSize.width                          = cellSize.height;
    layout.itemSize                         = cellSize;
    
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self registerClass:[LSThemeCollectionViewCell class] forCellWithReuseIdentifier:CELL_IDENTIFIER];
        self.delegate                           = self;
        self.dataSource                         = self;
        CGFloat contectInset                    = (CGRectGetWidth(frame) - cellSize.width) / 2;
        self.contentInset                       = UIEdgeInsetsMake(0.0, contectInset, 0.0, contectInset);
        self.showsHorizontalScrollIndicator     = NO;
    }
    
    return self;
}

- (void)showItemAtIndexPath:(NSIndexPath*)indexPath {
    CGRect cellFrame = [self layoutAttributesForItemAtIndexPath:indexPath].frame;
    CGFloat dX = (CGRectGetWidth(self.frame) - CGRectGetWidth(cellFrame)) / 2;
    CGPoint newOffset = CGPointMake((cellFrame.origin.x - dX), 0.0);
    [self setContentOffset:newOffset animated:NO];
    if([self.themesDelegate respondsToSelector:@selector(themeCollectionView:showExamplesForIndexPath:)])
        [self.themesDelegate themeCollectionView:self showExamplesForIndexPath:indexPath];
}

- (void)unlockThemeWithCellAtindexPath:(NSIndexPath*)indexPath {
    LSThemeCollectionViewCell *cell = (LSThemeCollectionViewCell*)[self cellForItemAtIndexPath:indexPath];
    [cell unlockWithAnimation];
}

- (void)showCurrentElement {    
    CGPoint middlePoint     = self.contentOffset;
    middlePoint.x          += self.frame.size.width / 2;
    middlePoint.y           = self.frame.size.height / 2;
    NSIndexPath *middleIndexPath        = [self indexPathForItemAtPoint:middlePoint];
    LSThemeCollectionViewCell *cell     = (LSThemeCollectionViewCell*)[self cellForItemAtIndexPath:middleIndexPath];
    cell.showWithAnimation              = YES;
}

- (BOOL)isCenterCell:(LSThemeCollectionViewCell*)cell {
    CGPoint middlePoint     = self.contentOffset;
    middlePoint.x          += self.frame.size.width / 2;
    middlePoint.y           = self.frame.size.height / 2;
    CGRect cellFrame        = cell.frame;
    return CGRectContainsPoint(cellFrame, middlePoint);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.themesDelegate respondsToSelector:@selector(themeCollectionViewNumberOfItems)])
        return [self.themesDelegate themeCollectionViewNumberOfItems];
    
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LSThemeCollectionViewCell *cell = (LSThemeCollectionViewCell*)[self dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    cell.delegate = self;
    if (cell.showWithoutAnimation) cell.showWithoutAnimation = NO;

    if ([self.themesDelegate respondsToSelector:@selector(themeCollectionView:isLockThemeForIndexPath:)])
        cell.lockCell = [self.themesDelegate themeCollectionView:self isLockThemeForIndexPath:indexPath];
    
    if(cell.lockCell) {
        if([self.themesDelegate respondsToSelector:@selector(themeCollectionView:lockImageForIndexPath:)])
            cell.themeLockImage = [self.themesDelegate themeCollectionView:self lockImageForIndexPath:indexPath];
    }
    
    if ([self.themesDelegate respondsToSelector:@selector(themeCollectionView:imageForIndexPath:)])
        cell.themeImage = [self.themesDelegate themeCollectionView:self imageForIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LSThemeCollectionViewCell *cell = (LSThemeCollectionViewCell*)[self cellForItemAtIndexPath:indexPath];
    if(![self isCenterCell:cell]) return;
    
    cell.selectWithAnimation = YES;
    
    if([self.themesDelegate respondsToSelector:@selector(themeCollectionView:didSelectItemAtIndexPath:)])
        [self.themesDelegate themeCollectionView:self didSelectItemAtIndexPath:indexPath];
}

#pragma mark - LSThemeCollectionViewCellDelegate

- (void)doubleTapDidDetectedInCell:(LSThemeCollectionViewCell *)cell {
//    if(![self isCenterCell:cell]) return;
//    
//    NSIndexPath *indexPath = [self indexPathForCell:cell];
//    if ([self.themesDelegate respondsToSelector:@selector(themeCollectionView:doubleTapAtIndexPath:)])
//        [self.themesDelegate themeCollectionView:self doubleTapAtIndexPath:indexPath];
}

#pragma mark - UISCrollView Methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self moveToNearestCellWithAnimation:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self moveToNearestCellWithAnimation:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat newOffset       = scrollView.contentOffset.x;
    
    CGPoint middlePoint     = scrollView.contentOffset;
    middlePoint.x          += self.frame.size.width / 2;
    middlePoint.y           = self.frame.size.height / 2;

    CGPoint oldCellPoint = middlePoint;
    if (_oldOffset < newOffset) { // Scroll to right
        _scrollDirection = LSScrollDirectionRight;
        oldCellPoint.x -= 50.0;
    } else { // Scroll to left
        _scrollDirection = LSScrollDirectionLeft;
        oldCellPoint.x += 50.0;
    }
    
    if([self.visibleCells count])
    {
        NSIndexPath *middleIndexPath                    = [self indexPathForItemAtPoint:middlePoint];
        if (middleIndexPath) {
            LSThemeCollectionViewCell *middleCell       = (LSThemeCollectionViewCell*)[self cellForItemAtIndexPath:middleIndexPath];
            if (!middleCell.showWithAnimation) {
                middleCell.showWithAnimation = YES;
                NSIndexPath *oldIndexPath               = [self indexPathForItemAtPoint:oldCellPoint];
                LSThemeCollectionViewCell *oldCell      = (LSThemeCollectionViewCell*)[self cellForItemAtIndexPath:oldIndexPath];
                if (oldCell.showWithAnimation) {
                    oldCell.showWithAnimation = NO;
                }
                
                if([self.themesDelegate respondsToSelector:@selector(themeCollectionView:showExamplesForIndexPath:)])
                    [self.themesDelegate themeCollectionView:self showExamplesForIndexPath:middleIndexPath];
            }
        }
    }
    
    _oldOffset = newOffset;
}

#pragma mark - Private Methods 

- (void)moveToNearestCellWithAnimation:(BOOL)animation {
    CGPoint middlePoint     = self.contentOffset;
    middlePoint.x          += self.frame.size.width / 2;
    middlePoint.y           = self.frame.size.height / 2;
    NSIndexPath *middleIndexPath        = [self indexPathForItemAtPoint:middlePoint];
    if (!middleIndexPath) {
        CGPoint movePoint = self.contentOffset;
        movePoint.y = 0.0;
        if (_scrollDirection == LSScrollDirectionLeft && self.contentOffset.x > 50.0)
            movePoint.x -= 30.0;
        else if ((self.contentOffset.x + 50.0) < self.contentSize.width)
            movePoint.x += 30.0;
        [self setContentOffset:movePoint animated:YES];
        
        middlePoint = movePoint;
        middlePoint.x          += self.frame.size.width / 2;
        middlePoint.y           = self.frame.size.height / 2;
        middleIndexPath        = [self indexPathForItemAtPoint:middlePoint];
    }
    
    CGRect cellFrame = [self layoutAttributesForItemAtIndexPath:middleIndexPath].frame;
    CGPoint newOffset = CGPointMake((cellFrame.origin.x - (self.frame.size.width - cellFrame.size.width) / 2), 0.0);
    [self setContentOffset:newOffset animated:animation];
    
    if([self.themesDelegate respondsToSelector:@selector(themeCollectionView:showExamplesForIndexPath:)])
        [self.themesDelegate themeCollectionView:self showExamplesForIndexPath:middleIndexPath];
}

@end
