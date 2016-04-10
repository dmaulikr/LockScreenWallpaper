//
//  LSDesignViewSheme.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/11/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSDesignViewScheme.h"

@interface LSDesignViewScheme() {
    LSDeviceType                _currentType;
}

@end

@implementation LSDesignViewScheme

- (instancetype)initWithDeviceType:(LSDeviceType)type {
    self = [super init];
    
    if (self) {
        _currentType        = type;
        _designViewFrame    = CGRectZero;
        _originViewFrame    = CGRectZero;
        _etalonScheme       = [LSEtalonScheme createForDeviceType:_currentType designViewFrame:self.designViewFrame originalFrame:self.originViewFrame];
    }
    
    return self;
}

- (CGRect)designViewFrame {
    
    if (_designViewFrame.size.height > 0.0)
        return _designViewFrame;
    
    switch (_currentType) {
        case LSDevice_iPod4:
            _designViewFrame = CGRectMake(52.5, 71.0, 216.0, 324.0);
            break;
        case LSDevice_iPhone4:
            _designViewFrame = CGRectMake(62.0, 90.0, 200.0, 300.0);
            break;
        case LSDevice_iPhone5c:
            _designViewFrame = CGRectMake(50.5, 85.5, 223.0, 396.0);
            break;
        case LSDevice_iPhone5s:
            _designViewFrame = CGRectMake(50.5, 88.0, 223.0, 396.0);
            break;
        case LSDevice_iPod5:
            _designViewFrame = CGRectMake(49.5, 87.0, 224.5, 398.0);
            break;
        case LSDevice_iPhone6:
            _designViewFrame = CGRectMake(45.0, 77.0, 284.0, 505.0);
            break;
        case LSDevice_iPhone6P:
            _designViewFrame = CGRectMake(51.0, 89.0, 311.5, 554.0);
            break;
        default: break;
    }
    
    return  _designViewFrame;
}

- (CGRect)originViewFrame {
    
    if (_originViewFrame.size.height > 0.0)
        return _originViewFrame;
    
    switch (_currentType) {
        case LSDevice_iPod4:
        case LSDevice_iPhone4:
            _originViewFrame = CGRectMake(0.0, 0.0, 320.0, 480.0);
            break;
        case LSDevice_iPhone5c:
        case LSDevice_iPhone5s:
        case LSDevice_iPod5:
            _originViewFrame = CGRectMake(0.0, 0.0, 320.0, 568.0);
            break;
        case LSDevice_iPhone6:
            _originViewFrame = CGRectMake(0.0, 0.0, 375.0, 667.0);
            break;
        case LSDevice_iPhone6P:
            _originViewFrame = CGRectMake(0.0, 0.0, 414.0, 736.0);
            break;
        default: break;
    }
    
    return _originViewFrame;
}

@end
