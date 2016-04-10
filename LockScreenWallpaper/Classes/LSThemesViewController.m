//
//  LSThemesViewController.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSThemesViewController.h"
#import "LSDesignViewController.h"
#import "LSButton.h"
#import "LSThemeManager.h"
#import "UIColor+AppColors.h"
#import <QuartzCore/QuartzCore.h>
#import "LSThemeExampleCollectionView.h"
#import "LSThemesCollectionView.h"
#import <StoreKit/StoreKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

#define THEMES_COLLECTION_VIEW_TAG              876
#define THEMES_EXAMPLES_SCROLL_VIEW_TAG         356
#define PURCHASE_INFO_ALERT_TAG                 925

@interface LSThemesViewController () <LSThemesCollectionViewDelegate, LSThemeExampleCollectionViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
{    
// --- Animation
    CGRect                          _topImageViewFrame;
    CGRect                          _middleImageViewFrame;
    CGRect                          _topViewFrame;
    CGRect                          _bottomViewFrame;
    CGRect                          _backButtomFrame;
    CGRect                          _topTitleLabelFrame;
    CGRect                          _middleTitleLabelFrame;
// ---
}

@property (nonatomic, strong) LSThemeModel                      *currentTheme;
@property (nonatomic, strong) NSArray                           *themeList;
@property (nonatomic, strong) SKProduct                         *purchaseProduct;
@property (nonatomic, strong) SKPaymentQueue                    *paymentQueue;

// --- UI
@property (strong, nonatomic) UIView                            *bottomView;
@property (strong, nonatomic) UIView                            *topView;
@property (strong, nonatomic) UIScrollView                      *scrollView;
@property (strong, nonatomic) UIImageView                       *middleImageView;
@property (strong, nonatomic) UILabel                           *middleTitle;
@property (strong, nonatomic) UIImageView                       *topImageView;
@property (strong, nonatomic) LSButton                          *backButton;
@property (strong, nonatomic) UILabel                           *topTitle;

@property (nonatomic, strong) UIScrollView                      *srollView;
@property (nonatomic, strong) LSThemesCollectionView            *themesCollectionView;
@property (nonatomic, weak) LSThemeExampleCollectionView        *currentExamplesCollectionView;
// ---

@end

@implementation LSThemesViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.paymentQueue   = [SKPaymentQueue defaultQueue];
    self.currentTheme   = [[LSThemeManager sharedManager] currentThemeModel];
    self.themeList      = [[LSThemeManager sharedManager] themesList];
    
    [self createViews];
    [self createThemesCollectionView];
    [self createExamplesScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCurrentTheme];
    
    [self.paymentQueue addTransactionObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.themesCollectionView showCurrentElement];
    
    /* Used with In-App Purchases
    if(LSIsFirstLaunchWithKey(VERSION_1_0_CHECK_PURCHASES_ALERT)) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:NSLocalizedString(@"Select last item to restore previous purchases, if you have any.", @"")
                                   delegate:nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                          otherButtonTitles:nil] show];
    }
     */
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.paymentQueue removeTransactionObserver:self];
}

- (void)hideViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Appearance Animation

- (void)prepareToShowView {
    CGRect frame = self.bottomView.frame;
    frame.origin.y += CGRectGetHeight(frame);
    self.bottomView.frame = frame;
    
    frame = self.topView.frame;
    frame.origin.y -= CGRectGetHeight(frame) + 47.0;
    self.topView.frame = frame;
    
    frame = self.middleImageView.frame;
    frame.origin.y = -47.0;
    self.middleImageView.frame = frame;
    
    frame = self.backButton.frame;
    frame.origin.y -= 47.0;
    self.backButton.frame = frame;
    
    frame = self.topImageView.frame;
    frame.origin.y -= 47.0;
    self.topImageView.frame = frame;
}

- (void)showViewCompletion:(void(^)(void))completion {
    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottomView.frame           = _bottomViewFrame;
        self.topView.frame              = _topViewFrame;
        self.middleImageView.frame      = _middleImageViewFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.topImageView.frame     = _topImageViewFrame;
            self.backButton.frame       = _backButtomFrame;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            if(completion)
                completion();
        }];
        
    }];
}

- (void)hideViewCompletion:(void(^)(void))completion {
    CGRect bottomViewFrame = self.bottomView.frame;
    bottomViewFrame.origin.y += CGRectGetHeight(bottomViewFrame);
    
    CGRect topViewFrame = self.topView.frame;
    topViewFrame.origin.y -= CGRectGetHeight(topViewFrame) + 47.0;
    
    CGRect backButtonFrame = self.backButton.frame;
    backButtonFrame.origin.y -= 47.0;
    
    CGRect topImageViewFrame = self.topImageView.frame;
    topImageViewFrame.origin.y -= 47.0;
    
    CGRect middleViewFrame = self.middleImageView.frame;
    middleViewFrame.origin.y = -47.0;

    self.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.topImageView.frame     = topImageViewFrame;
        self.backButton.frame       = backButtonFrame;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.bottomView.frame       = bottomViewFrame;
            self.topView.frame          = topViewFrame;
            self.middleImageView.frame  = middleViewFrame;
        } completion:^(BOOL finished) {
            self.view.userInteractionEnabled = YES;
            if (completion)
                completion();
        }];
        
    }];
}

#pragma mark - LSThemesCollectionViewDelegate

- (NSInteger)themeCollectionViewNumberOfItems {
    return self.themeList.count;
}

- (UIImage*)themeCollectionView:(LSThemesCollectionView*)collectionView imageForIndexPath:(NSIndexPath*)indexPath {
    LSThemeModel *model = self.themeList[indexPath.row];
    return model.themeLogo;
}

- (UIImage*)themeCollectionView:(LSThemesCollectionView*)collectionView lockImageForIndexPath:(NSIndexPath*)indexPath {
    LSThemeModel *model = self.themeList[indexPath.row];
    return model.themeLockLogo;
}

- (BOOL)themeCollectionView:(LSThemesCollectionView *)collectionView isLockThemeForIndexPath:(NSIndexPath*)indexPath {
    LSThemeModel *model = self.themeList[indexPath.row];
    return model.isLock;
}

/* Version for In-App Purchases
- (void)themeCollectionView:(LSThemesCollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    NSInteger themeIndex = indexPath.row;
    if((themeIndex+1) == self.themeList.count) { // restore purchases
        self.view.userInteractionEnabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.paymentQueue restoreCompletedTransactions];
    } else {
        LSThemeModel *model = self.themeList[themeIndex];
        if(model.isLock) { // unlock locked theme
            if([SKPaymentQueue canMakePayments]) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.view.userInteractionEnabled = NO;
                LSThemeModel *model = self.themeList[themeIndex];
                SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:model.iaThemeID]];
                request.delegate = self;
                [request start];
            } else {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sorry", @"")
                                                             message:NSLocalizedString(@"You can't make payments", @"")
                                                            delegate:nil
                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                                   otherButtonTitles:nil];
                [av show];
            }
        } else { // use current theme
            [[LSThemeManager sharedManager] setCurrentThemeModel:model];
            [self hideViewController];
        }
    }
}
*/

- (void)themeCollectionView:(LSThemesCollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
    NSInteger themeIndex = indexPath.row;
    LSThemeModel *model = self.themeList[themeIndex];
    [[LSThemeManager sharedManager] setCurrentThemeModel:model];
    [self hideViewController];
}

- (void)themeCollectionView:(LSThemesCollectionView *)collectionView showExamplesForIndexPath:(NSIndexPath*)indexPath {
    NSInteger item = indexPath.row;
    LSThemeModel *model = self.themeList[item];
    
    CGPoint newOffset = CGPointZero;
    newOffset.x = item * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:newOffset animated:YES];
    
    if (![model.themeDisplayName isEqualToString:self.middleTitle.text]) {
        [UIView animateWithDuration:0.1 animations:^{
            self.middleTitle.alpha = 0.0;
        } completion:^(BOOL finished) {
           self.middleTitle.text = model.themeDisplayName;
            [UIView animateWithDuration:0.1 animations:^{
                self.middleTitle.alpha = 1.0;
            }];
        }];
    }
}

#pragma mark - LSThemeExampleCollectionViewDelegate

- (NSArray*)imagesListForExamplesCollectionView:(LSThemeExampleCollectionView*)collectionView {
    LSThemeModel *model = self.themeList[collectionView.tag];
    return model.exampleWallpapers;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    if(response.products.count) {
        SKProduct *product = response.products.firstObject;
        self.purchaseProduct = product;
        NSString *title = product.localizedTitle;
        NSString *message = [NSString stringWithFormat:@"%@ %@", product.localizedDescription, NSLocalizedString(@"Do you want purchase them?", @"")];
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"YES", @"")
                                           otherButtonTitles:NSLocalizedString(@"NO", @""), nil];
        av.tag = PURCHASE_INFO_ALERT_TAG;
        av.delegate = self;
        [av show];
    } else {
        DLog(@"No Products Available");
    }
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for(SKPaymentTransaction *transaction in transactions){
        switch(transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: DLog(@"Transaction state - Purchasing");
                break;
            case SKPaymentTransactionStatePurchased:
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.view.userInteractionEnabled = YES;
                DLog(@"Transaction state - Purchased");
                [self.paymentQueue finishTransaction:transaction];
                [self unlockThemeWithID:transaction.payment.productIdentifier updateUI:YES];
                break;
            case SKPaymentTransactionStateRestored:
                DLog(@"Transaction state - Restored");
                [self.paymentQueue finishTransaction:transaction];
                [self unlockThemeWithID:transaction.payment.productIdentifier updateUI:NO];
                break;
            case SKPaymentTransactionStateFailed:
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                self.view.userInteractionEnabled = YES;
                if(transaction.error.code == SKErrorPaymentCancelled){
                    NSLog(@"Transaction state - Cancelled");
                }
                [self.paymentQueue finishTransaction:transaction];
                break;
            default: [self.paymentQueue finishTransaction:transaction];
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    DLog(@"Error %@", error);
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.view.userInteractionEnabled = YES;
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
                                message:NSLocalizedString(@"Failed to restore previous purchases.", @"")
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                      otherButtonTitles:nil] show];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"received restored transactions: %d", (int)queue.transactions.count);
    
    [self.themesCollectionView reloadData];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.view.userInteractionEnabled = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == PURCHASE_INFO_ALERT_TAG) {
        if(buttonIndex == 0) {
            SKPayment *payment = [SKPayment paymentWithProduct:self.purchaseProduct];
            [self.paymentQueue addPayment:payment];
        } else {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.view.userInteractionEnabled = YES;
        }
    }
}

#pragma mark - Private Methods

- (void)showCurrentTheme {
    LSThemeModel *model = [[LSThemeManager sharedManager] currentThemeModel];
    NSInteger themeIndex = [LSThemeModel themeIndexWithType:model.themeType];
    [self.themesCollectionView showItemAtIndexPath:[NSIndexPath indexPathForItem:themeIndex inSection:0]];
}

- (void)createViews {
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor thirdBackgroundColor];
    [self.view addSubview:self.bottomView];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor mainBorderColor];
    [self.bottomView addSubview:lineView];
    
    self.middleImageView = [[UIImageView alloc] init];
    self.middleImageView.layer.shadowColor    = [UIColor shadowColor].CGColor;
    self.middleImageView.layer.shadowRadius   = 3.0;
    self.middleImageView.layer.shadowOpacity  = 0.7;
    self.middleImageView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
    [self.view addSubview:self.middleImageView];
    
    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = [UIColor secondBackgroundColor];
    [self.view addSubview:self.topView];
    
    self.topImageView = [[UIImageView alloc] init];
    self.topImageView.layer.shadowColor    = [UIColor shadowColor].CGColor;
    self.topImageView.layer.shadowRadius   = 3.0;
    self.topImageView.layer.shadowOpacity  = 0.7;
    self.topImageView.layer.shadowOffset   = CGSizeMake(2.0, 2.0);
    [self.topView addSubview:self.topImageView];

    self.topTitle = [[UILabel alloc] init];
    self.topTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    self.topTitle.textAlignment = NSTextAlignmentCenter;
    self.topTitle.textColor = [UIColor topButtonFontColor];
    self.topTitle.text = @"Themes";
    [self.topImageView addSubview:self.topTitle];
    
    self.middleTitle = [[UILabel alloc] init];
    self.middleTitle.font = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    self.middleTitle.textAlignment = NSTextAlignmentCenter;
    self.middleTitle.textColor = [UIColor topButtonFontColor];
    self.middleTitle.text = @"Current Theme";
    [self.middleImageView addSubview:self.middleTitle];
    
    self.backButton = [LSButton buttonWithType:UIButtonTypeRoundedRect];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    self.backButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [self.backButton addTarget:self action:@selector(hideViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton setupTopButton];
    [self.view addSubview:self.backButton];
    
    CGRect screenFrame = self.view.bounds;
    
    _topImageViewFrame               = screenFrame;
    _topImageViewFrame.size.height   = 32.0;
    
    _middleImageViewFrame            = _topImageViewFrame;
    _middleImageViewFrame.origin.y   = (CGRectGetHeight(screenFrame) - CGRectGetHeight(_topImageViewFrame))/2 - (CGRectGetHeight(_topImageViewFrame)) + CGRectGetHeight(_topImageViewFrame);
    
    _topViewFrame                    = screenFrame;
    _topViewFrame.size.height        = _middleImageViewFrame.origin.y;
    
    _bottomViewFrame                 = screenFrame;
    _bottomViewFrame.origin.y        = CGRectGetHeight(_topViewFrame);
    _bottomViewFrame.size.height     = CGRectGetHeight(screenFrame) - CGRectGetMinY(_bottomViewFrame);
    CGRect lineRect                  = _bottomViewFrame;
    lineRect.size.height             = 1.0;
    lineRect.origin                  = CGPointMake(0.0, 0.0);
    lineView.frame                   = lineRect;
    
    _backButtomFrame                 = CGRectMake(15.0, 15.0, 90.0, 32.0);
    
    CGRect labelFrame                = CGRectMake(172.0, 2.0, 133, 27);
    LSDeviceDisplayInch display = [LSDeviceInformation displayInch];
    if(display == LSDeviceDisplay35 || display == LSDeviceDisplay40) {
        self.topImageView.image         = [UIImage imageNamed:@"ThemeTopBar640"];
        self.middleImageView.image      = [UIImage imageNamed:@"ThemeMiddleBar640"];
    } else if (display == LSDeviceDisplay47) {
        self.topImageView.image         = [UIImage imageNamed:@"ThemeTopBar750"];
        self.middleImageView.image      = [UIImage imageNamed:@"ThemeMiddleBar750"];
    } else if (display == LSDeviceDisplay55) {
        self.topImageView.image         = [UIImage imageNamed:@"ThemeTopBar3x"];
        self.middleImageView.image      = [UIImage imageNamed:@"ThemeMiddleBar3x"];
    }
    labelFrame.size.width            = CGRectGetWidth(screenFrame) - 150.0;
    labelFrame.origin.x              = 135.0;
    _topTitleLabelFrame              = labelFrame;
    _middleTitleLabelFrame           = labelFrame;
    
    self.topImageView.frame          = _topImageViewFrame;
    self.middleImageView.frame       = _middleImageViewFrame;
    self.topView.frame               = _topViewFrame;
    self.bottomView.frame            = _bottomViewFrame;
    self.backButton.frame            = _backButtomFrame;
    self.topTitle.frame              = _topTitleLabelFrame;
    self.middleTitle.frame           = _middleTitleLabelFrame;
}

- (void)createThemesCollectionView {
    CGRect frame = _topViewFrame;
    frame.origin.y = CGRectGetMaxY(_backButtomFrame);
    frame.size.height -= frame.origin.y;
    self.themesCollectionView = [[LSThemesCollectionView alloc] initWithFrame:frame];
    self.themesCollectionView.themesDelegate = self;
    self.themesCollectionView.tag = THEMES_COLLECTION_VIEW_TAG;
    [self.topView addSubview:self.themesCollectionView];
}

- (void)createExamplesScrollView {
    NSInteger sectionsCount = self.themeList.count;
    CGRect frame = _bottomViewFrame;
    frame.origin.y = CGRectGetHeight(_middleImageViewFrame);
    frame.size.height -= CGRectGetHeight(_middleImageViewFrame);
    CGSize contentSize = frame.size;
    contentSize.width *= sectionsCount;
    
    UIScrollView *examplesScrollView = [[UIScrollView alloc] initWithFrame:frame];
    examplesScrollView.contentSize = contentSize;
    examplesScrollView.scrollEnabled = NO;
    examplesScrollView.pagingEnabled = YES;
    examplesScrollView.tag = THEMES_EXAMPLES_SCROLL_VIEW_TAG;
    
    for (int i = 0; i < sectionsCount; i++) {
        CGRect rect = frame;
        rect.origin.y = 0.0;
        rect.origin.x += CGRectGetWidth(frame)  * i;
        LSThemeExampleCollectionView *collectionView = [[LSThemeExampleCollectionView alloc] initWithFrame:rect];
        collectionView.themeExamplesDelegate = self;
        collectionView.tag = i;
        [examplesScrollView addSubview:collectionView];
    }
    
    [self.bottomView addSubview:examplesScrollView];
    self.scrollView = examplesScrollView;
}

- (void)unlockThemeWithID:(NSString*)themeID updateUI:(BOOL)updateUI {
    for(int i = 0; i < self.themeList.count; i++) {
        LSThemeModel *model = self.themeList[i];
        if([model.iaThemeID isEqualToString:themeID]) {
            model.isLock = NO;
            if(updateUI) {
                NSIndexPath *indexPath = [[NSIndexPath indexPathWithIndex:0] indexPathByAddingIndex:i];
                [self.themesCollectionView unlockThemeWithCellAtindexPath:indexPath];
            }
            break;
        }
    }
}

@end
