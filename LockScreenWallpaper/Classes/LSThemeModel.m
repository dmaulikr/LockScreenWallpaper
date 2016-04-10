//
//  LSThemeModel.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemeModel.h"
#import "LSDeviceInformation.h"
#import "LSThemeModelPlain.h"
#import "LSThemeModelMetalShine.h"
#import "LSThemeModelPinkCandy.h"
#import "LSThemeModelVintageMemories.h"
#import "LSThemeModelWoodenWalls.h"
#import "UIColor+AppColors.h"
#import "UIImage+Additions.h"
#import "LSEtalonScheme.h"
#import "LSDrawScheme.h"
#import "LSThemeModelRestore.h"
#import <QuartzCore/QuartzCore.h>

const NSString *kThemeImageNameLogo                                     = @"Logo";
const NSString *kThemeImageNameExample                                  = @"Example";

@interface LSThemeModel() {
}

@property (nonatomic, strong) NSString                                  *screenSizeString;

@end

@implementation LSThemeModel

+ (instancetype)themeModelWithType:(LSThemeType)type {
    LSThemeModel *retTheme = nil;
    switch (type) {
        case LSThemePlain:
            retTheme = [[LSThemeModelPlain alloc] init];
            break;
        case LSThemePinkCandy:
            retTheme = [[LSThemeModelPinkCandy alloc] init];
            break;
        case LSThemeVintageMemories:
            retTheme = [[LSThemeModelVintageMemories alloc] init];
            break;
        case LSThemeMetalShine:
            retTheme = [[LSThemeModelMetalShine alloc] init];
            break;
        case LSThemeWoodenWalls:
            retTheme = [[LSThemeModelWoodenWalls alloc] init];
            break;
        case LSThemeRestorePurchases:
            retTheme = [[LSThemeModelRestore alloc] init];
            break;
    }
    
    return retTheme;
}

+ (LSThemeType)themeTypeWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return LSThemePlain;
        case 1:
            return LSThemePinkCandy;
        case 2:
            return LSThemeVintageMemories;
        case 3:
            return LSThemeMetalShine;
        case 4:
            return LSThemeWoodenWalls;
//        case 5: // For In-App Purchases only 
//            return LSThemeRestorePurchases;
        default:
            return LSThemePlain;
    }
}

+ (NSInteger)themeIndexWithType:(LSThemeType)type {
    switch (type) {
        case LSThemePlain:
            return 0;
        case LSThemePinkCandy:
            return 1;
        case LSThemeVintageMemories:
            return 2;
        case LSThemeMetalShine:
            return 3;
        case LSThemeWoodenWalls:
            return 4;
        case LSThemeRestorePurchases:
            return 5;
        default:
            return 0;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self populateShapesSettings];
        [self setupInitialDrawState];
    }
    
    return self;
}

- (BOOL)isLock {
    return NO;
    /* For In-App Purchases only
    NSString *key = self.iaThemeID;
    if(key)
        return ![[NSUserDefaults standardUserDefaults] boolForKey:self.iaThemeID];
    
    return NO;
     */
}

- (void)setIsLock:(BOOL)isLock {
    [[NSUserDefaults standardUserDefaults] setBool:!isLock forKey:self.iaThemeID];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getters

- (NSString*)screenSizeString {
    if(_screenSizeString)
        return _screenSizeString;
    
    LSDeviceDisplayInch display = [LSDeviceInformation displayInch];
    switch (display) {
        case LSDeviceDisplay35:
            _screenSizeString = @"35";
            break;
        case LSDeviceDisplay40:
            _screenSizeString = @"40";
            break;
        case LSDeviceDisplay47:
            _screenSizeString = @"47";
            break;
        case LSDeviceDisplay55:
            _screenSizeString = @"55";
            break;
        default:
            _screenSizeString = @"";
            break;
    }
    
    return _screenSizeString;
}

- (NSString*)baseImageName {
    if(_baseImageName)
        return _baseImageName;
    
    _baseImageName = [NSString stringWithFormat:@"Theme%@", self.themeName];
    return _baseImageName;
}

- (UIImage*)themeLogo {
    if(_themeLogo)
        return _themeLogo;
    
    NSString *imgName = [NSString stringWithFormat:@"%@%@%@.jpg", self.baseImageName, kThemeImageNameLogo, self.screenSizeString];
    _themeLogo = [UIImage imageNamed:imgName];
    return _themeLogo;
}

- (UIImage*)themeLockLogo {
    if(_themeLockLogo)
        return _themeLockLogo;
    
    NSString *imgName = [NSString stringWithFormat:@"ThemeLockLogo%@", self.screenSizeString];
    _themeLockLogo = [UIImage imageNamed:imgName];
    return _themeLockLogo;
}

- (NSArray*)exampleWallpapers {
    if(_exampleWallpapers)
        return _exampleWallpapers;
    
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < 5; i++) {
        NSString *imgName = [NSString stringWithFormat:@"%@%@_%@_%d.jpg", self.baseImageName, kThemeImageNameExample, self.screenSizeString, i];
        UIImage *image = [UIImage imageNamed:imgName];
        [arr addObject:image];
    }
    
    _exampleWallpapers = (NSArray*)arr;
    return _exampleWallpapers;
}

- (NSArray*)colorsCollections {
    if (_colorsCollections)
        return _colorsCollections;
    
    _colorsCollections = @[[UIColor redColors],
                           [UIColor pinkColors],
                           [UIColor purpleColors],
                           [UIColor deepPurpleColors],
                           [UIColor indigoColors],
                           [UIColor blueColors],
                           [UIColor lightBlueColors],
                           [UIColor cyanColors],
                           [UIColor tealColors],
                           [UIColor greenColors],
                           [UIColor lightGreenColors],
                           [UIColor limeColors],
                           [UIColor yellowColors],
                           [UIColor amberColors],
                           [UIColor orangeColors],
                           [UIColor deepOrangeColors],
                           [UIColor brownColors],
                           [UIColor blueGrayColors],
                           [UIColor whiteColors],
                           [UIColor blackColors]];
    
    return _colorsCollections;
}

- (NSMutableArray*)backgroundImages {
    if(_backgroundImages)
        return _backgroundImages;
    
    NSNull *null = [NSNull null];
    _backgroundImages = [@[null, null, null, null, null, null] mutableCopy];
    return _backgroundImages;
}

- (NSArray*)backgroundImagesPreview {
    if(_backgroundImagesPreview)
        return _backgroundImagesPreview;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableString *imgName = [self.baseImageName mutableCopy];
    [imgName appendString:@"BackgroundPreview"];
    for (int i = 0; i < 6; i++) {
        NSString *iName = [imgName stringByAppendingFormat:@"%d.jpg", i];
        UIImage *img = [UIImage imageNamed:iName];
        [arr addObject:img];
    }
    
    _backgroundImagesPreview = arr;
    return _backgroundImagesPreview;
}

- (NSMutableArray*)clockImages {
    if(_clockImages)
        return _clockImages;
    
    NSNull *null = [NSNull null];
    _clockImages = [@[null, null, null, null, null, null, null, null] mutableCopy];
    return _clockImages;
}

- (NSArray*)clockImagesPreview {
    if(_clockImagesPreview)
        return _clockImagesPreview;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableString *imgName = [self.baseImageName mutableCopy];
    [imgName appendString:@"ClockSlidePreview"];
    for (int i = 0; i < 6; i++) {
        NSString *iName = [imgName stringByAppendingFormat:@"%d.jpg", i];
        UIImage *img = [UIImage imageNamed:iName];
        [arr addObject:img];
    }
    
    _clockImagesPreview = arr;
    return _clockImagesPreview;
}

- (NSMutableArray*)slideImages {
    if(_slideImages)
        return _slideImages;
    
    NSNull *null = [NSNull null];
    _slideImages = [@[null, null, null, null, null, null, null, null] mutableCopy];
    return _slideImages;
}

- (NSArray*)slideImagesPreview {
    if(_slideImagesPreview)
        return _slideImagesPreview;
    
    _slideImagesPreview = self.clockImagesPreview;
    return _slideImagesPreview;
}

- (NSMutableArray*)photoBorderImages {
    if(_photoBorderImages)
        return _photoBorderImages;
    
    NSNull *null = [NSNull null];
    _photoBorderImages = [@[null, null, null, null, null] mutableCopy];
    return _photoBorderImages;
}

- (NSArray*)photoBorderImagesPreview {
    if(_photoBorderImagesPreview)
        return _photoBorderImagesPreview;
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:6];
    NSMutableString *imgName = [self.themeName mutableCopy];
    [imgName appendString:@"BorderPreview"];
    for (int i = 0; i < 5; i++) {
        NSString *iName = [imgName stringByAppendingFormat:@"%d.jpg", i+1];
        UIImage *img = [UIImage imageNamed:iName];
        [arr addObject:img];
    }
    
    _photoBorderImagesPreview = arr;
    return _photoBorderImagesPreview;
}

- (NSArray*)backgroundColors {
    if (_backgroundColors)
        return _backgroundColors;
    
    _backgroundColors = self.colorsCollections;
    return _backgroundColors;
}

- (NSArray*)clockColors {
    if (_clockColors)
        return _clockColors;
    
    _clockColors = self.colorsCollections;
    return _clockColors;
}

- (NSArray*)slideColors {
    if (_slideColors)
        return _slideColors;
    
    _slideColors = self.colorsCollections;
    return _slideColors;
}

- (NSArray*)photoBorderColors {
    if (_photoBorderColors)
        return _photoBorderColors;
    
    _photoBorderColors = self.colorsCollections;
    return _photoBorderColors;
}

#pragma mark - Publick Methods

- (void)loadImagesForThemesScreen {
    id obj = self.themeName;
    obj = self.exampleWallpapers;
}

- (void)loadImagesForDesign {
//    self.backgroundImages;
//    self.backgroundImagesPreview;
//    
//    self.clockColors;
//    self.clockImages;
//    self.clockImagesPreview;
//    
//    self.slideColors;
//    self.slideImages;
//    self.slideImagesPreview;
//    
//    self.photoBorderColors;
//    self.photoBorderImages;
//    self.photoBorderImagesPreview;
//    
//    self.elementCornerRadiuses;
}
#pragma clang diagnostic pop

- (NSArray*)colorsCollectionsForThemeElements:(LSThemeElement)themeElements {
    switch (themeElements) {
        case LSThemeElementClock:
            return self.clockColors;
        case LSThemeElementSlider:
            return self.slideColors;
        case LSThemeElementPhotoBorder:
            return self.photoBorderColors;
        case LSThemeElementBackground:
            return self.backgroundColors;
        default:
            return @[];
    }
}

- (NSArray*)shapesForThemeElements:(LSThemeElement)themeElements {
    switch (themeElements) {
        case LSThemeElementClock:
            return self.clockShapes;
        case LSThemeElementSlider:
            return self.slideShapes;
        case LSThemeElementPhotoBorder:
            return self.photoBorderShapes;
        case LSThemeElementPhoto:
            return self.photoShapes;
        default:
            return @[];
    }
}

- (BOOL)isImagesForThemeElements:(LSThemeElement)themeElements {
    NSInteger count = 0;
    switch (themeElements) {
        case LSThemeElementBackground:
            count = self.backgroundImagesPreview.count;
            break;
        case LSThemeElementClock:
            count = self.clockImagesPreview.count;
            break;
        case LSThemeElementSlider:
            count = self.slideImagesPreview.count;
            break;
        case LSThemeElementPhotoBorder:
            count = self.photoBorderImagesPreview.count;
            break;
        default:
            return NO;
    }
    
    if(count) return YES;
    else return NO;
}

- (NSArray*)imagesForThemeElements:(LSThemeElement)themeElements {
    if(self.themeType == LSThemePlain)
        return @[];
    
    switch (themeElements) {
        case LSThemeElementBackground:
            return self.backgroundImagesPreview;
        case LSThemeElementClock:
            return self.clockImagesPreview;
        case LSThemeElementSlider:
            return self.slideImagesPreview;
        case LSThemeElementPhotoBorder:
            return self.photoBorderImagesPreview;
        default:
            return @[];
    }
}

- (UIImage*)imageForThemeElements:(LSThemeElement)themeElements index:(NSInteger)index {
    UIImage *img = [self _imageForThemeElements:themeElements index:index];
    if(![img isKindOfClass:[NSNull class]])
        return img;
    
    NSMutableString *imageName = [self.baseImageName mutableCopy];
    NSString *elementName;
    
    switch (themeElements) {
        case LSThemeElementBackground:
            elementName = [self elementNameForCurrentBackgroundImage];
            break;
        case LSThemeElementClock:
            elementName = @"Clock";
            break;
        case LSThemeElementSlider:
            elementName = @"Slide";
            break;
        case LSThemeElementPhotoBorder:
            elementName = @"PhotoBorder";
            break;
        default:
            elementName = @"";
    }
    
    [imageName appendString:elementName];
    [imageName appendFormat:@"%ld.jpg", (long)index];
    UIImage *image = [UIImage imageNamed:imageName];
    
    [self _setImageForThemeElements:themeElements image:image index:index];
    
    return image;
}

- (UIImage*)imageForImageBorderWithIndexPath:(NSIndexPath*)indexPath {
    NSString *imageName = [[self nameForImageBorderWithIndexPath:indexPath] mutableCopy];
    NSString *imageCornerString = @"1234";
    
    imageName = [imageName stringByReplacingOccurrencesOfString:@"@" withString:imageCornerString];
    UIImage *retImage = [UIImage imageNamed:imageName];
    return retImage;

    return nil;
}

- (NSString*)nameForImageBorderWithIndexPath:(NSIndexPath*)indexPath {
    NSString *deviceType;
    LSDeviceDisplayInch inches = [LSDeviceInformation displayInch];
    switch (inches) {
        case LSDeviceDisplay35: deviceType = @"35"; break;
        case LSDeviceDisplay40: deviceType = @"40"; break;
        case LSDeviceDisplay47: deviceType = @"47"; break;
        case LSDeviceDisplay55: deviceType = @"55"; break;
        default: deviceType = nil;
    }

    NSString *imageName = [NSString stringWithFormat:@"%@Border_%d_@_%@.jpg", self.themeName, ((int)[indexPath indexAtPosition:1]+1), deviceType];
    return imageName;
}

- (NSString*)elementNameForCurrentBackgroundImage {
    LSDeviceDisplayInch inches = [LSDeviceInformation displayInch];
    switch (inches) {
        case LSDeviceDisplay35: return @"Background35";
        case LSDeviceDisplay40: return @"Background40";
        case LSDeviceDisplay47: return @"Background47";
        case LSDeviceDisplay55: return @"Background55";
        default: return @"";
    }
}

- (LSDrawScheme*)defaultDrawScheme {
    if(_defaultDrawScheme)
        return _defaultDrawScheme;
    
    LSDrawScheme *drawScheme = [LSDrawScheme new];
    drawScheme.mainBackgroundColor      = self.backgroundColors[[self.initialDrawState.mainBackgroundColorIndexPath indexAtPosition:0]]
                                                                [[self.initialDrawState.mainBackgroundColorIndexPath indexAtPosition:1]+1];
    drawScheme.clockViewColor           = self.clockColors[[self.initialDrawState.clockViewColorIndexPath indexAtPosition:0]]
                                                            [[self.initialDrawState.clockViewColorIndexPath indexAtPosition:1]+1];
    drawScheme.slideViewColor           = self.slideColors[[self.initialDrawState.slideViewColorIndexPath indexAtPosition:0]]
                                                            [[self.initialDrawState.slideViewColorIndexPath indexAtPosition:1]+1];
    drawScheme.photoBorderViewColor     = self.photoBorderColors[[self.initialDrawState.photoBorderViewColorIndexPath indexAtPosition:0]]
                                                                [[self.initialDrawState.photoBorderViewColorIndexPath indexAtPosition:1]+1];
    drawScheme.photoViewImage           = [UIImage imageNamed:@"PhotoImageDefault.jpg"];
    
    _defaultDrawScheme = drawScheme;
    return _defaultDrawScheme;
}

#pragma mark - Private Methods

- (UIImage*)_imageForThemeElements:(LSThemeElement)themeElements index:(NSInteger)index {
    NSArray *elementImages;
    switch (themeElements) {
        case LSThemeElementBackground:
            elementImages = self.backgroundImages;
            break;
        case LSThemeElementClock:
            elementImages = self.clockImages;
            break;
        case LSThemeElementSlider:
            elementImages = self.slideImages;
            break;
        case LSThemeElementPhotoBorder:
            elementImages = self.photoBorderImages;
            break;
        default:
            elementImages = @[];
            break;
    }
    
    return elementImages[index];
}

- (void)_setImageForThemeElements:(LSThemeElement)themeElements image:(UIImage*)image index:(NSInteger)index {
    if(image) {
        NSMutableArray *elementImages;
        switch (themeElements) {
            case LSThemeElementBackground:
                elementImages = self.backgroundImages;
                break;
            case LSThemeElementClock:
                elementImages = self.clockImages;
                break;
            case LSThemeElementSlider:
                elementImages = self.slideImages;
                break;
            case LSThemeElementPhotoBorder:
                elementImages = self.photoBorderImages;
                break;
            default:
                elementImages = [@[] mutableCopy];
                break;
        }
        
        elementImages[index] = image;
    }
}

- (void)populateShapesSettings {
    LSEtalonScheme *etalon = [LSEtalonScheme createForDeviceType:[LSDeviceInformation currentDeviceType]
                                                 designViewFrame:CGRectZero
                                                   originalFrame:[[UIScreen mainScreen] bounds]];
    CGFloat cornerRadiusLarge = CGRectGetHeight(etalon.frameForSlideView) / 2.0;
    CGFloat cornerRadiusSmall = cornerRadiusLarge / 2.0;
    CGFloat imageSize = 80.0;
    
    LSDesignElementShape *shapeNone         = [LSDesignElementShape new];
    shapeNone.shapeType     = LSElementShapeNone;
    shapeNone.curveRadius   = -1.0;
    UIView *shapeNoneView           = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize)];
    shapeNoneView.backgroundColor   = [UIColor thirdBackgroundColor];
    UIImage *shapeNoneImage         = [UIImage  imageWithView:shapeNoneView];
    shapeNone.previewImage          = shapeNoneImage;
    
    LSDesignElementShape *shapeCurveNone    = [LSDesignElementShape new];
    shapeCurveNone.shapeType    = LSElementShapeCurveNone;
    shapeCurveNone.curveRadius  = 0.0;
    UIView *shapeCurveNoneView                  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize)];
    shapeCurveNoneView.backgroundColor          = [UIColor thirdBackgroundColor];
    UIView *shapeCurveNoneSecondView            = [[UIView alloc] initWithFrame:CGRectMake(cornerRadiusLarge, cornerRadiusLarge, imageSize, imageSize)];
    shapeCurveNoneSecondView.backgroundColor    = [UIColor secondBackgroundColor];
    [shapeCurveNoneView addSubview:shapeCurveNoneSecondView];
    UIImage *shapeCurveNoneImage                = [UIImage  imageWithView:shapeCurveNoneView];
    shapeCurveNone.previewImage                 = shapeCurveNoneImage;

    LSDesignElementShape *shapeCurveSmall   = [LSDesignElementShape new];
    shapeCurveSmall.shapeType   = LSElementShapeCurveSmall;
    shapeCurveSmall.curveRadius = cornerRadiusSmall;
    UIView *shapeCurveSmallView                  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize)];
    shapeCurveSmallView.backgroundColor          = [UIColor thirdBackgroundColor];
    UIView *shapeCurveSmallSecondView            = [[UIView alloc] initWithFrame:CGRectMake(cornerRadiusLarge, cornerRadiusLarge, imageSize, imageSize)];
    shapeCurveSmallSecondView.backgroundColor    = [UIColor secondBackgroundColor];
    shapeCurveSmallSecondView.layer.cornerRadius  = cornerRadiusSmall;
    [shapeCurveSmallView addSubview:shapeCurveSmallSecondView];
    UIImage *shapeCurveSmallImage                = [UIImage  imageWithView:shapeCurveSmallView];
    shapeCurveSmall.previewImage                 = shapeCurveSmallImage;
    
    LSDesignElementShape *shapeCurveLarge   = [LSDesignElementShape new];
    shapeCurveLarge.shapeType   = LSElementShapeCurveLarge;
    shapeCurveLarge.curveRadius = cornerRadiusLarge;
    UIView *shapeCurveLargeView                  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize)];
    shapeCurveLargeView.backgroundColor          = [UIColor thirdBackgroundColor];
    UIView *shapeCurveLargeSecondView            = [[UIView alloc] initWithFrame:CGRectMake(cornerRadiusLarge, cornerRadiusLarge, imageSize, imageSize)];
    shapeCurveLargeSecondView.backgroundColor    = [UIColor secondBackgroundColor];
    shapeCurveLargeSecondView.layer.cornerRadius = cornerRadiusLarge;
    [shapeCurveLargeView addSubview:shapeCurveLargeSecondView];
    UIImage *shapeCurveLargeImage                = [UIImage  imageWithView:shapeCurveLargeView];
    shapeCurveLarge.previewImage                 = shapeCurveLargeImage;
    
    LSDesignElementShape *shapeCircle       = [LSDesignElementShape new];
    shapeCircle.shapeType   = LSElementShapeCircle;
    shapeCircle.curveRadius = CGFLOAT_MAX;
    UIView *shapeCirclelView                  = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, imageSize, imageSize)];
    shapeCirclelView.backgroundColor          = [UIColor thirdBackgroundColor];
    UIView *shapeCircleSecondView             = [[UIView alloc] initWithFrame:CGRectMake(cornerRadiusLarge, cornerRadiusLarge, imageSize, imageSize)];
    shapeCircleSecondView.backgroundColor     = [UIColor secondBackgroundColor];
    shapeCircleSecondView.layer.cornerRadius  = imageSize / 2.0;
    [shapeCirclelView addSubview:shapeCircleSecondView];
    UIImage *shapeCircleImage                 = [UIImage  imageWithView:shapeCirclelView];
    shapeCircle.previewImage                  = shapeCircleImage;
    
    self.clockShapes        = @[shapeNone, shapeCurveNone, shapeCurveSmall, shapeCurveLarge];
    self.slideShapes        = @[shapeNone, shapeCurveNone, shapeCurveSmall, shapeCurveLarge];
    self.photoBorderShapes  = @[shapeNone, shapeCurveNone, shapeCurveSmall, shapeCurveLarge, shapeCircle];
    self.photoShapes        = @[shapeNone, shapeCurveNone, shapeCurveSmall, shapeCurveLarge, shapeCircle];
}

- (void)setupInitialDrawState {
    LSThemeDrawState *drawState = [LSThemeDrawState new];
    
    drawState.mainBackgroundColorIndexPath = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.mainBackgroundImageIndexPath = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.clockViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.clockViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.clockViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.slideViewColorIndexPath           = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.slideViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    drawState.slideViewImageIndexPath           = [[NSIndexPath alloc] initWithIndex:0];
    
    drawState.photoViewCornerRadiusIndexPath    = [[NSIndexPath alloc] initWithIndex:1];
    
    drawState.photoBorderViewColorIndexPath         = [[[NSIndexPath alloc] initWithIndex:0] indexPathByAddingIndex:0];
    drawState.photoBorderViewCornerRadiusIndexPath  = [[NSIndexPath alloc] initWithIndex:1];
    drawState.photoBorderViewImageIndexPath         = [[NSIndexPath alloc] initWithIndex:0];
    
    self.initialDrawState = drawState;
}

@end
