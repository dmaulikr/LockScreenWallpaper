//
//  LSColorTableViewCell.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/14/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSColorTableViewCell : UITableViewCell

@property (nonatomic, strong) UIColor               *cellColor;
@property (nonatomic, assign) BOOL                   selectCell;
@property (nonatomic, assign) BOOL                   showCell;
@property (nonatomic, assign) BOOL                   showCellWithoutAnimation;

- (void)selectCellWithoutAnimation:(BOOL)select;

@end
