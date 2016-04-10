//
//  LSElementColorView.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSElementColorView;

@protocol LSElementColorViewDelegate <NSObject>

- (NSInteger)numberOfColorElementsColorView:(LSElementColorView*)elementsColorView;
- (UIColor*)elementsColorView:(LSElementColorView*)elementsColorView colorForIndexPath:(NSIndexPath*)indexPath;
- (void)elementsColorView:(LSElementColorView*)elementsColorView didSelectColorWithindexPath:(NSIndexPath*)indexPath;

@end

@interface LSElementColorView : UIView

@property (nonatomic, weak) id<LSElementColorViewDelegate>              colorViewDelegate;
@property (nonatomic, strong) NSIndexPath                               *selectedIndexPath;

- (void)showCells;
- (void)selectMiddleCellWithAnimation:(BOOL)animation;
- (void)selectCellWithIndexPath:(NSIndexPath*)indexPath animation:(BOOL)animation;
- (void)reloadColorViewCompletion:(void(^)(void))completion;
- (void)reloadData;

@end
