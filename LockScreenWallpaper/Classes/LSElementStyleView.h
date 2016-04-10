//
//  LSElementStyleView.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LSElementStyleType) {
    LSElementStyleShapes,
    LSElementStyleImages
};

@class LSElementStyleView;

@protocol LSElementStyleViewDelegate <NSObject>

- (NSInteger)numberOfElementsStyleView:(LSElementStyleView*)elementStyleView;
- (UIImage*)elementsStyleView:(LSElementStyleView*)elementStyleView imageForIndexPath:(NSIndexPath*)indexPath;
- (void)elementsStyleView:(LSElementStyleView*)elementStyleView didSelectElementAtIndexPath:(NSIndexPath*)indexPath;
- (void)elementsStyleView:(LSElementStyleView*)elementStyleView didChangeStyleType:(LSElementStyleType)newType;

@end

@interface LSElementStyleView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView                          *collectionView;
@property (nonatomic, weak) id<LSElementStyleViewDelegate>               elementViewDelegate;
@property (nonatomic, assign) LSElementStyleType                         styleType;
@property (nonatomic, assign) BOOL                                       changeGesture;
@property (nonatomic, assign) BOOL                                       imagesOnly;

- (void)selectCellWithIndexPath:(NSIndexPath*)indexPath animation:(BOOL)animation;
- (void)reloadElementStyleViewCompletion:(void(^)(void))completion;
- (void)reloadData;

@end
