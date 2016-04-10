//
//  LSCollectionViewFlowLayout.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/18/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSCollectionViewFlowLayout.h"

#define CELL_SPACE              0.0

@implementation LSCollectionViewFlowLayout

- (CGSize)collectionViewContentSize {
    CGSize retSize = self.itemSize;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    retSize.width = retSize.width * count + count * CELL_SPACE + 10.0;
    return retSize;
}

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    for(int i = 0; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        NSInteger item = currentLayoutAttributes.indexPath.row;
        if(item == 0) {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = CELL_SPACE/2.0;
            currentLayoutAttributes.frame = frame;
        } else {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = (frame.size.width + CELL_SPACE) * item + CELL_SPACE/2.0;
            currentLayoutAttributes.frame = frame;
        }
    }
    
    return answer;
}

@end
