//
//  LSThemeCollectionViewCell.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/23/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSThemeCollectionViewCell;

@protocol LSThemeCollectionViewCellDelegate <NSObject>

- (void)doubleTapDidDetectedInCell:(LSThemeCollectionViewCell*)cell;

@end

@interface LSThemeCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <LSThemeCollectionViewCellDelegate>      delegate;

@property (nonatomic, strong) UIImage               *themeImage;
@property (nonatomic, strong) UIImage               *themeLockImage;
@property (nonatomic, assign) BOOL                   lockCell;
@property (nonatomic, assign) BOOL                   showWithAnimation;
@property (nonatomic, assign) BOOL                   showWithoutAnimation;
@property (nonatomic, assign) BOOL                   selectWithAnimation;

- (void)unlockWithAnimation;

@end
