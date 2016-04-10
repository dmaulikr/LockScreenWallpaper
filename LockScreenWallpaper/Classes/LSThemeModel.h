//
//  LSThemeModel.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSDesignElementShape.h"
#import "LSThemeDrawState.h"

#define THEME_SHAPE_CIRCLE_CORNER_RADIUS                    9635

@class LSDrawScheme;

extern const NSString *kThemeImageNameLogo;
extern const NSString *kThemeImageNameExample;

typedef NS_ENUM(NSInteger, LSThemeType) {
    LSThemePlain,
    LSThemePinkCandy,
    LSThemeVintageMemories,
    LSThemeMetalShine,
    LSThemeWoodenWalls,
    LSThemeRestorePurchases
};

typedef NS_ENUM(NSInteger, LSThemeElement) {
    LSThemeElementClock = 0,
    LSThemeElementSlider,
    LSThemeElementPhoto,
    LSThemeElementPhotoBorder,
    LSThemeElementBackground
};

@interface LSThemeModel : NSObject

@property (nonatomic, assign) BOOL                          isLock;
@property (nonatomic, strong) NSString                      *iaThemeID;

@property (nonatomic, strong) NSString                      *themeName;
@property (nonatomic, strong) NSString                      *themeDisplayName;
@property (nonatomic, strong) NSString                      *baseImageName;

@property (nonatomic, assign) LSThemeType                   themeType;
@property (nonatomic, strong) NSArray                       *colorsCollections;
@property (nonatomic, strong) LSThemeDrawState              *initialDrawState;
@property (nonatomic, strong) LSDrawScheme                  *defaultDrawScheme;

// UI elements for themes list
@property (nonatomic, strong) UIImage                       *themeLogo;
@property (nonatomic, strong) UIImage                       *themeLockLogo;
@property (nonatomic, strong) NSArray                       *exampleWallpapers; // always 5 elements

// UI elements collection for design
// background UI elements
@property (nonatomic, strong) NSArray                       *backgroundColors;
@property (nonatomic, strong) NSMutableArray                *backgroundImages;
@property (nonatomic, strong) NSArray                       *backgroundImagesPreview;

// clock UI elements
@property (nonatomic, strong) NSArray                       *clockColors;
@property (nonatomic, strong) NSMutableArray                *clockImages;
@property (nonatomic, strong) NSArray                       *clockImagesPreview;
@property (nonatomic, strong) NSArray                       *clockShapes;

// slide UI elements
@property (nonatomic, strong) NSArray                       *slideColors;
@property (nonatomic, strong) NSMutableArray                *slideImages;
@property (nonatomic, strong) NSArray                       *slideImagesPreview;
@property (nonatomic, strong) NSArray                       *slideShapes;

// photo border UI element
@property (nonatomic, strong) NSArray                       *photoBorderColors;
@property (nonatomic, strong) NSMutableArray                *photoBorderImages;
@property (nonatomic, strong) NSArray                       *photoBorderImagesPreview;
@property (nonatomic, strong) NSArray                       *photoBorderShapes;

// photo UI element
@property (nonatomic, strong) NSArray                       *photoShapes;


+ (instancetype)themeModelWithType:(LSThemeType)type;
+ (LSThemeType)themeTypeWithIndex:(NSInteger)index;
+ (NSInteger)themeIndexWithType:(LSThemeType)type;

- (void)loadImagesForThemesScreen;
- (void)loadImagesForDesign;

- (NSArray*)colorsCollectionsForThemeElements:(LSThemeElement)themeElements;
- (NSArray*)shapesForThemeElements:(LSThemeElement)themeElements;
- (BOOL)isImagesForThemeElements:(LSThemeElement)themeElements;
- (NSArray*)imagesForThemeElements:(LSThemeElement)themeElements;
- (UIImage*)imageForThemeElements:(LSThemeElement)themeElements index:(NSInteger)index;
- (UIImage*)imageForImageBorderWithIndexPath:(NSIndexPath*)indexPath;

- (NSString*)nameForImageBorderWithIndexPath:(NSIndexPath*)indexPath;

@end
