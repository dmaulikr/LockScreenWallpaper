//
//  LSDesignViewSheme.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/11/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSEtalonScheme.h"
#import "LSDrawScheme.h"

@interface LSDesignViewScheme : NSObject

@property (nonatomic, strong) LSEtalonScheme        *etalonScheme;
@property (nonatomic, strong) LSDrawScheme          *drawScheme;
@property (nonatomic, assign) CGRect                 designViewFrame;
@property (nonatomic, assign) CGRect                 originViewFrame;

- (instancetype)initWithDeviceType:(LSDeviceType)type;

@end
