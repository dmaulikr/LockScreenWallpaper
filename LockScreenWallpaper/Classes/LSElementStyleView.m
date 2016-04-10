//
//  LSElementStyleView.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSElementStyleView.h"
#import "LSStyleCollectionViewCell.h"
#import "LSCollectionViewFlowLayout.h"

@interface LSElementStyleView()

@property (nonatomic, retain) UISwipeGestureRecognizer              *changeStyleGesture;

@end

@implementation LSElementStyleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    LSCollectionViewFlowLayout *layout = [[LSCollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 1.0;
    CGFloat size = self.frame.size.height;
    layout.itemSize = CGSizeMake(size, size);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    CGFloat left = 0.0, right = -10.0;
    self.collectionView.contentInset = UIEdgeInsetsMake(0.0, left, 0.0, right);
    [self.collectionView registerClass:[LSStyleCollectionViewCell class] forCellWithReuseIdentifier:@"StyleCell"];
    
    [self addSubview:self.collectionView];
    
    self.backgroundColor = [UIColor clearColor];
    self.styleType = LSElementStyleShapes;
    self.changeGesture = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)selectCellWithIndexPath:(NSIndexPath*)indexPath animation:(BOOL)animation {
    [self.collectionView selectItemAtIndexPath:indexPath animated:animation scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    LSStyleCollectionViewCell *cell = (LSStyleCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selectWithAnimation = YES;
}

- (void)reloadElementStyleViewCompletion:(void(^)(void))completion {
    // hide cells
    NSArray *visibleCells = [self.collectionView visibleCells];
    for (int i = 0; i < visibleCells.count; i++)
    {
        LSStyleCollectionViewCell *cell = visibleCells[i];
        if (cell.showCell) cell.showCell = NO;
    }
    
    [self.collectionView reloadData];
    
    // show cells
    for (int i = 0; i < visibleCells.count; i++)
    {
        LSStyleCollectionViewCell *cell = visibleCells[i];
        if (!cell.showCell) cell.showCell = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (completion) completion();
    });
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)changeElementStyle:(UISwipeGestureRecognizer*)recognizer {
    if (self.styleType == LSElementStyleImages) self.styleType = LSElementStyleShapes;
    else self.styleType = LSElementStyleImages;
    self.userInteractionEnabled = NO;
    [self reloadElementStyleViewCompletion:^{
        self.userInteractionEnabled = YES;
        if([self.elementViewDelegate respondsToSelector:@selector(elementsStyleView:didChangeStyleType:)])
           [self.elementViewDelegate elementsStyleView:self didChangeStyleType:self.styleType];
    }];
}

- (UISwipeGestureRecognizer*)changeStyleGesture {
    if(_changeStyleGesture)
        return _changeStyleGesture;
    
    _changeStyleGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(changeElementStyle:)];
    _changeStyleGesture.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
    return _changeStyleGesture;
}

- (void)setChangeGesture:(BOOL)changeGesture {
    _changeGesture = changeGesture;
    if(_changeGesture) {
        [self addGestureRecognizer:self.changeStyleGesture];
    } else {
        if(self.gestureRecognizers.count)
           [self removeGestureRecognizer:self.changeStyleGesture];
    }
}

- (void)setImagesOnly:(BOOL)imagesOnly {
    _imagesOnly = imagesOnly;
    if(_imagesOnly) self.styleType = LSElementStyleImages;
    else self.styleType = LSElementStyleShapes;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.elementViewDelegate respondsToSelector:@selector(numberOfElementsStyleView:)])
    {
        NSInteger number = [self.elementViewDelegate numberOfElementsStyleView:self];
        CGFloat left = 0.0,
        right = -10.0,
        itemWidth = self.frame.size.height,
        viewWidth = self.frame.size.width;
        
        CGFloat dX = (viewWidth - (itemWidth * number)) / 2;
        if(dX > 0.0) {
            left += dX;
            right += dX;
        }
        
        self.collectionView.contentInset = UIEdgeInsetsMake(0.0, left, 0.0, right);
        return number;
    }
    
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *image;
    if ([self.elementViewDelegate respondsToSelector:@selector(elementsStyleView:imageForIndexPath:)])
        image = [self.elementViewDelegate elementsStyleView:self imageForIndexPath:indexPath];
    
    LSStyleCollectionViewCell *cell = (LSStyleCollectionViewCell*)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"StyleCell" forIndexPath:indexPath];
    cell.styleImage = image;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LSStyleCollectionViewCell *cell = (LSStyleCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selectWithAnimation = YES;
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.elementViewDelegate respondsToSelector:@selector(elementsStyleView:didSelectElementAtIndexPath:)])
        [self.elementViewDelegate elementsStyleView:self didSelectElementAtIndexPath:indexPath];
}

@end
