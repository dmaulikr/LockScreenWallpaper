//
//  LSThemeExampleCollectionView.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSThemeExampleCollectionView;

@protocol LSThemeExampleCollectionViewDelegate <NSObject>

- (NSArray*)imagesListForExamplesCollectionView:(LSThemeExampleCollectionView*)collectionView;

@end

@interface LSThemeExampleCollectionView : UICollectionView

@property (nonatomic, weak) id <LSThemeExampleCollectionViewDelegate>           themeExamplesDelegate;

@end
