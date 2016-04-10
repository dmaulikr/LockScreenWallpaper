//
//  UIColor+AppColors.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/16/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

- (BOOL)isEqualToColor:(UIColor *)otherColor
{
    if (self == otherColor)
        return YES;
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color)
    {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome)
        {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef colorRef = CGColorCreate(colorSpaceRGB, components);
            UIColor *color = [UIColor colorWithCGColor:colorRef];
            CGColorRelease(colorRef);
            return color;
        }
        else
            return color;
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}

+ (UIColor*)colorWithHex:(int)hexValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0];
}

static UIColor *_mainBackgroundColor;
+ (UIColor*)mainBackgroundColor {
    if (_mainBackgroundColor)
        return _mainBackgroundColor;
    _mainBackgroundColor = [UIColor colorWithRed:59.0/255 green:59.0/255 blue:59.0/255 alpha:1.0];
    return _mainBackgroundColor;
}

static UIColor *_secondBackgroundColor;
+ (UIColor*)secondBackgroundColor {
    if (_secondBackgroundColor)
        return _secondBackgroundColor;
    
    _secondBackgroundColor = [UIColor colorWithRed:60.0/255 green:184.0/255 blue:212.0/255 alpha:1.0];
    return _secondBackgroundColor;
}

static UIColor *_thirdBackgroundColor;
+ (UIColor*)thirdBackgroundColor {
    if (_thirdBackgroundColor)
        return _thirdBackgroundColor;
    
    _thirdBackgroundColor = [UIColor colorWithRed:69.0/255 green:80.0/255 blue:185.0/255 alpha:1.0];
    return _thirdBackgroundColor;
}

static UIColor *_topButtonColor;
+ (UIColor*)topButtonColor {
    if (_topButtonColor)
        return _topButtonColor;
    
    _topButtonColor = [UIColor colorWithRed:255.0/255 green:51.0/255 blue:141.0/255 alpha:1.0];
    return _topButtonColor;
}

static UIColor *_topButtonFontColor;
+ (UIColor*)topButtonFontColor {
    if (_topButtonFontColor)
        return _topButtonFontColor;
    _topButtonFontColor = [UIColor whiteColor];
    return _topButtonFontColor;
}

static UIColor *_shadowColor;
+ (UIColor*)shadowColor {
    if (_shadowColor)
        return _shadowColor;
    
    _shadowColor = [UIColor grayColor];
    return _shadowColor;
}

static UIColor *_mainBorderColor;
+ (UIColor*)mainBorderColor {
    if (_mainBorderColor)
        return _mainBorderColor;
    
    _mainBorderColor = [UIColor whiteColor];
    return _mainBorderColor;
}

#pragma mark - Color Collections

+ (NSArray*)redColors {
    NSArray *arr = @[[UIColor colorWithHex:0xe51c23],
                     [UIColor colorWithHex:0xfde0dc],
                     [UIColor colorWithHex:0xf9bdbb],
                     [UIColor colorWithHex:0xf69988],
                     [UIColor colorWithHex:0xf36c60],
                     [UIColor colorWithHex:0xe84e40],
                     [UIColor colorWithHex:0xe51c23],
                     [UIColor colorWithHex:0xdd191d],
                     [UIColor colorWithHex:0xd01716],
                     [UIColor colorWithHex:0xc41411],
                     [UIColor colorWithHex:0xb0120a],
                     [UIColor colorWithHex:0xff7997],
                     [UIColor colorWithHex:0xff5177],
                     [UIColor colorWithHex:0xff2d6f],
                     [UIColor colorWithHex:0xe00032]];
    
    return arr;
}

+ (NSArray*)pinkColors {
    NSArray *arr = @[[UIColor colorWithHex:0xe91e63],
                     [UIColor colorWithHex:0xfce4ec],
                     [UIColor colorWithHex:0xf8bbd0],
                     [UIColor colorWithHex:0xf48fb1],
                     [UIColor colorWithHex:0xf06292],
                     [UIColor colorWithHex:0xec407a],
                     [UIColor colorWithHex:0xe91e63],
                     [UIColor colorWithHex:0xd81b60],
                     [UIColor colorWithHex:0xc2185b],
                     [UIColor colorWithHex:0xad1457],
                     [UIColor colorWithHex:0x880e4f],
                     [UIColor colorWithHex:0xff80ab],
                     [UIColor colorWithHex:0xff4081],
                     [UIColor colorWithHex:0xf50057],
                     [UIColor colorWithHex:0xc51162]];
    
    return arr;
}

+ (NSArray*)purpleColors {
    NSArray *arr = @[[UIColor colorWithHex:0x9c27b0],
                     [UIColor colorWithHex:0xf3e5f5],
                     [UIColor colorWithHex:0xe1bee7],
                     [UIColor colorWithHex:0xce93d8],
                     [UIColor colorWithHex:0xba68c8],
                     [UIColor colorWithHex:0xab47bc],
                     [UIColor colorWithHex:0x9c27b0],
                     [UIColor colorWithHex:0x8e24aa],
                     [UIColor colorWithHex:0x7b1fa2],
                     [UIColor colorWithHex:0x6a1b9a],
                     [UIColor colorWithHex:0x4a148c],
                     [UIColor colorWithHex:0xea80fc],
                     [UIColor colorWithHex:0xe040fb],
                     [UIColor colorWithHex:0xd500f9],
                     [UIColor colorWithHex:0xaa00ff]];
    
    return arr;
}

+ (NSArray*)deepPurpleColors {
    NSArray *arr = @[[UIColor colorWithHex:0x673ab7],
                     [UIColor colorWithHex:0xede7f6],
                     [UIColor colorWithHex:0xd1c4e9],
                     [UIColor colorWithHex:0xb39ddb],
                     [UIColor colorWithHex:0x9575cd],
                     [UIColor colorWithHex:0x7e57c2],
                     [UIColor colorWithHex:0x673ab7],
                     [UIColor colorWithHex:0x5e35b1],
                     [UIColor colorWithHex:0x512da8],
                     [UIColor colorWithHex:0x4527a0],
                     [UIColor colorWithHex:0x311b92],
                     [UIColor colorWithHex:0xb388ff],
                     [UIColor colorWithHex:0x7c4dff],
                     [UIColor colorWithHex:0x651fff],
                     [UIColor colorWithHex:0x6200ea]];
    
    return arr;
}

+ (NSArray*)indigoColors {
    NSArray *arr = @[[UIColor colorWithHex:0x3f51b5],
                     [UIColor colorWithHex:0xe8eaf6],
                     [UIColor colorWithHex:0xc5cae9],
                     [UIColor colorWithHex:0x9fa8da],
                     [UIColor colorWithHex:0x7986cb],
                     [UIColor colorWithHex:0x5c6bc0],
                     [UIColor colorWithHex:0x3f51b5],
                     [UIColor colorWithHex:0x3949ab],
                     [UIColor colorWithHex:0x303f9f],
                     [UIColor colorWithHex:0x283593],
                     [UIColor colorWithHex:0x1a237e],
                     [UIColor colorWithHex:0x8c9eff],
                     [UIColor colorWithHex:0x536dfe],
                     [UIColor colorWithHex:0x3d5afe],
                     [UIColor colorWithHex:0x304ffe]];
    
    return arr;
}

+ (NSArray*)blueColors {
    NSArray *arr = @[[UIColor colorWithHex:0x5677fc],
                     [UIColor colorWithHex:0xe7e9fd],
                     [UIColor colorWithHex:0xd0d9ff],
                     [UIColor colorWithHex:0xafbfff],
                     [UIColor colorWithHex:0x91a7ff],
                     [UIColor colorWithHex:0x738ffe],
                     [UIColor colorWithHex:0x5677fc],
                     [UIColor colorWithHex:0x4e6cef],
                     [UIColor colorWithHex:0x455ede],
                     [UIColor colorWithHex:0x3b50ce],
                     [UIColor colorWithHex:0x2a36b1],
                     [UIColor colorWithHex:0xa6baff],
                     [UIColor colorWithHex:0x6889ff],
                     [UIColor colorWithHex:0x4d73ff],
                     [UIColor colorWithHex:0x4d69ff]];
    
    return arr;
}

+ (NSArray*)lightBlueColors {
    NSArray *arr = @[[UIColor colorWithHex:0x03a9f4],
                     [UIColor colorWithHex:0xe1f5fe],
                     [UIColor colorWithHex:0xb3e5fc],
                     [UIColor colorWithHex:0x81d4fa],
                     [UIColor colorWithHex:0x4fc3f7],
                     [UIColor colorWithHex:0x29b6f6],
                     [UIColor colorWithHex:0x03a9f4],
                     [UIColor colorWithHex:0x039be5],
                     [UIColor colorWithHex:0x0288d1],
                     [UIColor colorWithHex:0x0277bd],
                     [UIColor colorWithHex:0x01579b],
                     [UIColor colorWithHex:0x80d8ff],
                     [UIColor colorWithHex:0x40c4ff],
                     [UIColor colorWithHex:0x00b0ff],
                     [UIColor colorWithHex:0x0091ea]];
    
    return arr;
}

+ (NSArray*)cyanColors {
    NSArray *arr = @[[UIColor colorWithHex:0x00bcd4],
                     [UIColor colorWithHex:0xe0f7fa],
                     [UIColor colorWithHex:0xb2ebf2],
                     [UIColor colorWithHex:0x80deea],
                     [UIColor colorWithHex:0x4dd0e1],
                     [UIColor colorWithHex:0x26c6da],
                     [UIColor colorWithHex:0x00bcd4],
                     [UIColor colorWithHex:0x00acc1],
                     [UIColor colorWithHex:0x0097a7],
                     [UIColor colorWithHex:0x00838f],
                     [UIColor colorWithHex:0x006064],
                     [UIColor colorWithHex:0x84ffff],
                     [UIColor colorWithHex:0x18ffff],
                     [UIColor colorWithHex:0x00e5ff],
                     [UIColor colorWithHex:0x00b8d4]];
    
    return arr;
}

+ (NSArray*)tealColors {
    NSArray *arr = @[[UIColor colorWithHex:0x009688],
                     [UIColor colorWithHex:0xe0f2f1],
                     [UIColor colorWithHex:0xb2dfdb],
                     [UIColor colorWithHex:0x80cbc4],
                     [UIColor colorWithHex:0x4db6ac],
                     [UIColor colorWithHex:0x26a69a],
                     [UIColor colorWithHex:0x009688],
                     [UIColor colorWithHex:0x00897b],
                     [UIColor colorWithHex:0x00796b],
                     [UIColor colorWithHex:0x00695c],
                     [UIColor colorWithHex:0x004d40],
                     [UIColor colorWithHex:0xa7ffeb],
                     [UIColor colorWithHex:0x64ffda],
                     [UIColor colorWithHex:0x1de9b6],
                     [UIColor colorWithHex:0x00bfa5]];
    
    return arr;
}

+ (NSArray*)greenColors {
    NSArray *arr = @[[UIColor colorWithHex:0x259b24],
                     [UIColor colorWithHex:0xd0f8ce],
                     [UIColor colorWithHex:0xa3e9a4],
                     [UIColor colorWithHex:0x72d572],
                     [UIColor colorWithHex:0x42bd41],
                     [UIColor colorWithHex:0x2baf2b],
                     [UIColor colorWithHex:0x259b24],
                     [UIColor colorWithHex:0x0a8f08],
                     [UIColor colorWithHex:0x0a7e07],
                     [UIColor colorWithHex:0x056f00],
                     [UIColor colorWithHex:0x0d5302],
                     [UIColor colorWithHex:0xa2f78d],
                     [UIColor colorWithHex:0x5af158],
                     [UIColor colorWithHex:0x14e715],
                     [UIColor colorWithHex:0x12c700]];
    
    return arr;
}

+ (NSArray*)lightGreenColors {
    NSArray *arr = @[[UIColor colorWithHex:0x8bc34a],
                     [UIColor colorWithHex:0xf1f8e9],
                     [UIColor colorWithHex:0xdcedc8],
                     [UIColor colorWithHex:0xc5e1a5],
                     [UIColor colorWithHex:0xaed581],
                     [UIColor colorWithHex:0x9ccc65],
                     [UIColor colorWithHex:0x8bc34a],
                     [UIColor colorWithHex:0x7cb342],
                     [UIColor colorWithHex:0x689f38],
                     [UIColor colorWithHex:0x558b2f],
                     [UIColor colorWithHex:0x33691e],
                     [UIColor colorWithHex:0xccff90],
                     [UIColor colorWithHex:0xb2ff59],
                     [UIColor colorWithHex:0x76ff03],
                     [UIColor colorWithHex:0x64dd17]];
    
    return arr;
}

+ (NSArray*)limeColors {
    NSArray *arr = @[[UIColor colorWithHex:0xcddc39],
                     [UIColor colorWithHex:0xf9fbe7],
                     [UIColor colorWithHex:0xf0f4c3],
                     [UIColor colorWithHex:0xe6ee9c],
                     [UIColor colorWithHex:0xdce775],
                     [UIColor colorWithHex:0xd4e157],
                     [UIColor colorWithHex:0xcddc39],
                     [UIColor colorWithHex:0xc0ca33],
                     [UIColor colorWithHex:0xafb42b],
                     [UIColor colorWithHex:0x9e9d24],
                     [UIColor colorWithHex:0x827717],
                     [UIColor colorWithHex:0xf4ff81],
                     [UIColor colorWithHex:0xeeff41],
                     [UIColor colorWithHex:0xc6ff00],
                     [UIColor colorWithHex:0xaeea00]];
    
    return arr;
}

+ (NSArray*)yellowColors {
    NSArray *arr = @[[UIColor colorWithHex:0xffeb3b],
                     [UIColor colorWithHex:0xfffde7],
                     [UIColor colorWithHex:0xfff9c4],
                     [UIColor colorWithHex:0xfff59d],
                     [UIColor colorWithHex:0xfff176],
                     [UIColor colorWithHex:0xffee58],
                     [UIColor colorWithHex:0xffeb3b],
                     [UIColor colorWithHex:0xfdd835],
                     [UIColor colorWithHex:0xfbc02d],
                     [UIColor colorWithHex:0xf9a825],
                     [UIColor colorWithHex:0xf57f17],
                     [UIColor colorWithHex:0xffff8d],
                     [UIColor colorWithHex:0xffff00],
                     [UIColor colorWithHex:0xffea00],
                     [UIColor colorWithHex:0xffd600]];
    
    return arr;
}

+ (NSArray*)amberColors {
    NSArray *arr = @[[UIColor colorWithHex:0xffc107],
                     [UIColor colorWithHex:0xfff8e1],
                     [UIColor colorWithHex:0xffecb3],
                     [UIColor colorWithHex:0xffe082],
                     [UIColor colorWithHex:0xffd54f],
                     [UIColor colorWithHex:0xffca28],
                     [UIColor colorWithHex:0xffc107],
                     [UIColor colorWithHex:0xffb300],
                     [UIColor colorWithHex:0xffa000],
                     [UIColor colorWithHex:0xff8f00],
                     [UIColor colorWithHex:0xff6f00],
                     [UIColor colorWithHex:0xffe57f],
                     [UIColor colorWithHex:0xffd740],
                     [UIColor colorWithHex:0xffc400],
                     [UIColor colorWithHex:0xffab00]];
    
    return arr;
}

+ (NSArray*)orangeColors {
    NSArray *arr = @[[UIColor colorWithHex:0xff9800],
                     [UIColor colorWithHex:0xfff3e0],
                     [UIColor colorWithHex:0xffe0b2],
                     [UIColor colorWithHex:0xffcc80],
                     [UIColor colorWithHex:0xffb74d],
                     [UIColor colorWithHex:0xffa726],
                     [UIColor colorWithHex:0xff9800],
                     [UIColor colorWithHex:0xfb8c00],
                     [UIColor colorWithHex:0xf57c00],
                     [UIColor colorWithHex:0xef6c00],
                     [UIColor colorWithHex:0xe65100],
                     [UIColor colorWithHex:0xffd180],
                     [UIColor colorWithHex:0xffab40],
                     [UIColor colorWithHex:0xff9100],
                     [UIColor colorWithHex:0xff6d00]];
    
    return arr;
}

+ (NSArray*)deepOrangeColors {
    NSArray *arr = @[[UIColor colorWithHex:0xff5722],
                     [UIColor colorWithHex:0xfbe9e7],
                     [UIColor colorWithHex:0xffccbc],
                     [UIColor colorWithHex:0xffab91],
                     [UIColor colorWithHex:0xff8a65],
                     [UIColor colorWithHex:0xff7043],
                     [UIColor colorWithHex:0xff5722],
                     [UIColor colorWithHex:0xf4511e],
                     [UIColor colorWithHex:0xe64a19],
                     [UIColor colorWithHex:0xd84315],
                     [UIColor colorWithHex:0xbf360c],
                     [UIColor colorWithHex:0xff9e80],
                     [UIColor colorWithHex:0xff6e40],
                     [UIColor colorWithHex:0xff3d00],
                     [UIColor colorWithHex:0xdd2c00]];
    
    return arr;
}

+ (NSArray*)brownColors {
    NSArray *arr = @[[UIColor colorWithHex:0x795548],
                     [UIColor colorWithHex:0xefebe9],
                     [UIColor colorWithHex:0xd7ccc8],
                     [UIColor colorWithHex:0xbcaaa4],
                     [UIColor colorWithHex:0xa1887f],
                     [UIColor colorWithHex:0x8d6e63],
                     [UIColor colorWithHex:0x795548],
                     [UIColor colorWithHex:0x6d4c41],
                     [UIColor colorWithHex:0x5d4037],
                     [UIColor colorWithHex:0x4e342e],
                     [UIColor colorWithHex:0x3e2723]];
    
    return arr;
}

+ (NSArray*)whiteColors {
    NSArray *arr = @[[UIColor colorWithHex:0xffffff],
                     [UIColor colorWithHex:0xffffff],
                     [UIColor colorWithHex:0xfafafa],
                     [UIColor colorWithHex:0xf5f5f5],
                     [UIColor colorWithHex:0xeeeeee],
                     [UIColor colorWithHex:0xe0e0e0],
                     [UIColor colorWithHex:0xbdbdbd],
                     [UIColor colorWithHex:0x9e9e9e],
                     [UIColor colorWithHex:0x757575],
                     [UIColor colorWithHex:0x616161],
                     [UIColor colorWithHex:0x424242],
                     [UIColor colorWithHex:0x212121],
                     [UIColor colorWithHex:0x000000]];
    
    return arr;
}

+ (NSArray*)blackColors {
    NSArray *arr = @[[UIColor colorWithHex:0x000000],
                     [UIColor colorWithHex:0xfafafa],
                     [UIColor colorWithHex:0xf5f5f5],
                     [UIColor colorWithHex:0xeeeeee],
                     [UIColor colorWithHex:0xe0e0e0],
                     [UIColor colorWithHex:0xbdbdbd],
                     [UIColor colorWithHex:0x9e9e9e],
                     [UIColor colorWithHex:0x757575],
                     [UIColor colorWithHex:0x616161],
                     [UIColor colorWithHex:0x424242],
                     [UIColor colorWithHex:0x212121],
                     [UIColor colorWithHex:0x000000]];
    
    return arr;
}

+ (NSArray*)blueGrayColors {
    NSArray *arr = @[[UIColor colorWithHex:0x607d8b],
                     [UIColor colorWithHex:0xeceff1],
                     [UIColor colorWithHex:0xcfd8dc],
                     [UIColor colorWithHex:0xb0bec5],
                     [UIColor colorWithHex:0x90a4ae],
                     [UIColor colorWithHex:0x78909c],
                     [UIColor colorWithHex:0x607d8b],
                     [UIColor colorWithHex:0x546e7a],
                     [UIColor colorWithHex:0x455a64],
                     [UIColor colorWithHex:0x37474f],
                     [UIColor colorWithHex:0x263238]];
    
    return arr;
}

@end
