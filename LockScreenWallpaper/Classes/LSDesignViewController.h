//
//  LSDesignViewController.h
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSThemeModel.h"
#import "LSButton.h"
#import "LSElementsView.h"
#import "LSElementStyleView.h"
#import "LSElementColorView.h"

@interface LSDesignViewController : UIViewController

//---- View Outlets
@property (weak, nonatomic) IBOutlet LSButton           *fullScreenButton;
@property (weak, nonatomic) IBOutlet UIImageView        *phoneImageView;
@property (weak, nonatomic) IBOutlet LSButton           *themesButton;
@property (weak, nonatomic) IBOutlet LSButton           *saveButton;
@property (weak, nonatomic) IBOutlet LSElementsView     *elementsView;
@property (weak, nonatomic) IBOutlet LSElementStyleView *elementsStyleView;
@property (weak, nonatomic) IBOutlet LSElementColorView *elementsColorView;
@property (weak, nonatomic) IBOutlet LSElementColorView *elementsColorCollectionView;
@property (weak, nonatomic) IBOutlet LSButton           *photoButton;
//----

@property (nonatomic, strong) LSThemeModel              *currentTheme;

- (void)showControls:(BOOL)show completion:(void(^)(void))completion;

@end
