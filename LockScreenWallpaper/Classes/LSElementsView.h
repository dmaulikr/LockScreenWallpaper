//
//  LSElementsView.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDesignViewScheme.h"
#import "LSDrawScheme.h"
#import "LSThemeModel.h"

@class LSElementsView;

@protocol LSElementsViewDelegate <NSObject>

- (void)elementsView:(LSElementsView*)elementsView willSelectThemeElements:(LSThemeElement)themeElements;
- (void)elementsView:(LSElementsView*)elementsView didSelectThemeElements:(LSThemeElement)themeElements;

@end

@interface LSElementsView : UIView

@property (nonatomic, weak) IBOutlet UIImageView                *slideView;
@property (nonatomic, weak) IBOutlet UIImageView                *clockView;
@property (nonatomic, weak) IBOutlet UIImageView                *backgroundView;
@property (nonatomic, weak) IBOutlet UIImageView                *photoImageView;
@property (nonatomic, weak) IBOutlet UIImageView                *photoBorderImageView;

@property (nonatomic, strong) LSDrawScheme                      *drawScheme;
@property (nonatomic, strong) LSDesignViewScheme                *designViewScheme;
@property (nonatomic, assign) LSThemeElement                     currentThemeElement;

@property (nonatomic, weak) id<LSElementsViewDelegate>           delegate;

@end
