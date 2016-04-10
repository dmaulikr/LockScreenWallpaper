//
//  LSThemesCollectionView.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSThemesCollectionView;

@protocol LSThemesCollectionViewDelegate <NSObject>

- (NSInteger)themeCollectionViewNumberOfItems;
- (UIImage*)themeCollectionView:(LSThemesCollectionView*)collectionView imageForIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)themeCollectionView:(LSThemesCollectionView*)collectionView lockImageForIndexPath:(NSIndexPath*)indexPath;
- (BOOL)themeCollectionView:(LSThemesCollectionView *)collectionView isLockThemeForIndexPath:(NSIndexPath*)indexPath;
- (void)themeCollectionView:(LSThemesCollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)themeCollectionView:(LSThemesCollectionView *)collectionView showExamplesForIndexPath:(NSIndexPath*)indexPath;
//- (void)themeCollectionView:(LSThemesCollectionView *)collectionView doubleTapAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface LSThemesCollectionView : UICollectionView

@property (nonatomic, weak) id <LSThemesCollectionViewDelegate>             themesDelegate;

- (void)showItemAtIndexPath:(NSIndexPath*)indexPath;
- (void)unlockThemeWithCellAtindexPath:(NSIndexPath*)indexPath;
- (void)showCurrentElement;

@end
