//
//  LSElementColorView.m
//  LockScreenWallpaper
//
//  Created by Eugene Zozulya on 2/10/15.
//  Copyright (c) 2015 Eugene Zozulya. All rights reserved.
//

#import "LSElementColorView.h"
#import "LSColorTableViewCell.h"
#import "LSDesignViewScheme.h"
#import <QuartzCore/QuartzCore.h>

#define GRADIENT_OFFSET             5.0

@interface LSElementColorView() <UITableViewDataSource, UITableViewDelegate> {
    CGFloat                                              _oldOffset;
    BOOL                                                 _autoScroll;
    __weak LSColorTableViewCell                         *_oldSelectedCell;
}

@property (nonatomic, strong) UITableView               *tableView;
@property (nonatomic, assign) CGPoint                    markPoint;
@property (nonatomic, strong) LSDesignViewScheme        *viewScheme;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation LSElementColorView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[LSColorTableViewCell class] forCellReuseIdentifier:@"ColorCell"];
    
    self.tableView.backgroundColor    = [UIColor clearColor];
    self.tableView.clipsToBounds      = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    _oldOffset = 0.0;
    _autoScroll = NO;
    
    if ([LSDeviceInformation displayInch] != LSDeviceDisplay35) {
        CGRect viewFrame = self.viewScheme.originViewFrame;
        CGFloat height = 0.0;
        CGFloat midY = CGRectGetMidY(viewFrame);
        CGFloat dMinY = viewFrame.size.height - 160.0;
        height = (dMinY - midY) * 2;
        self.heightConstraint.constant = height;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width;
    CGFloat top = (self.frame.size.height - width) / 2;
    CGFloat bottom = (self.frame.size.height - width) / 2;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0.0, bottom, 0.0);
    
    self.tableView.frame = self.bounds;
}

- (LSDesignViewScheme*)viewScheme {
    if (_viewScheme)
        return _viewScheme;
    
    _viewScheme = [[LSDesignViewScheme alloc] initWithDeviceType:[LSDeviceInformation currentDeviceType]];
    return _viewScheme;
}

- (void)reloadColorViewCompletion:(void(^)(void))completion {
    // hide cells
    NSArray *visibleCells = [self.tableView visibleCells];
    for (int i = 0; i < visibleCells.count; i++)
    {
        LSColorTableViewCell *cell = visibleCells[i];
        if (!cell.showCell) cell.showCell = NO;
        cell.selectCell = NO;
    }
    
    [self.tableView reloadData];
    
    // show cells
    for (int i = 0; i < visibleCells.count; i++)
    {
        LSColorTableViewCell *cell = visibleCells[i];
        if (!cell.showCell) cell.showCell = YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self selectMiddleCellWithAnimation:YES];
        if (completion) completion();
    });
}

- (void)reloadData {
    [self.tableView reloadData];
    [self selectMiddleCellWithAnimation:NO];
}

- (void)showCells {
    CGPoint currentOffset = self.tableView.contentOffset;
    currentOffset.y += 3.0;
    [self.tableView setContentOffset:currentOffset animated:NO];
}

#pragma mark - Private Methods

- (void)selectMiddleCellWithAnimation:(BOOL)animation {
    @try {
        CGPoint middlePoint     = self.tableView.contentOffset;
        middlePoint.y          += self.frame.size.height / 2;
        NSIndexPath *middleIndexPath        = [self.tableView indexPathForRowAtPoint:middlePoint];
        LSColorTableViewCell *middleCell    = (LSColorTableViewCell*)[self.tableView cellForRowAtIndexPath:middleIndexPath];
        if (middleCell) {
            if (!middleCell.selectCell) {
                if(animation)
                    middleCell.selectCell       = YES;
                else
                    [middleCell selectCellWithoutAnimation:YES];
                if (middleCell != _oldSelectedCell) {
                    if(animation)
                        _oldSelectedCell.selectCell = NO;
                    else
                        [_oldSelectedCell selectCellWithoutAnimation:NO];
                    _oldSelectedCell            = middleCell;
                }
                
                self.selectedIndexPath = middleIndexPath;
                
                if ([self.colorViewDelegate respondsToSelector:@selector(elementsColorView:didSelectColorWithindexPath:)])
                    [self.colorViewDelegate elementsColorView:self didSelectColorWithindexPath:middleIndexPath];
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"Exception %@", exception);
    }
}

- (void)selectCellWithIndexPath:(NSIndexPath*)indexPath animation:(BOOL)animation {
    @try {
        _autoScroll = YES;
        CGRect cellFrame = [self.tableView rectForRowAtIndexPath:indexPath];
        CGFloat y = cellFrame.origin.y - (self.frame.size.height - cellFrame.size.height) / 2;
        CGPoint newOffset = CGPointMake(0.0, y);
        [self.tableView setContentOffset:newOffset animated:animation];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            _autoScroll = NO;
        });
    }
    @catch (NSException *exception) {
        DLog(@"Exception %@", exception);
    }
}

- (void)moveToSelectedCell {
    CGPoint middlePoint     = self.tableView.contentOffset;
    middlePoint.y          += self.frame.size.height / 2;
    NSIndexPath *middleIndexPath        = [self.tableView indexPathForRowAtPoint:middlePoint];
    CGRect cellFrame = [self.tableView rectForRowAtIndexPath:middleIndexPath];
    CGPoint newOffset = CGPointMake(0.0, (cellFrame.origin.y - self.frame.size.height / 2 + self.frame.size.width / 2));
    [self.tableView setContentOffset:newOffset animated:YES];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LSColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorCell"];
    [cell selectCellWithoutAnimation:NO];
    if([self.colorViewDelegate respondsToSelector:@selector(elementsColorView:colorForIndexPath:)]) {
        UIColor *color = [self.colorViewDelegate elementsColorView:self colorForIndexPath:indexPath];
        if(color)
            cell.cellColor = color;
    }
    else {
        cell.cellColor = [UIColor topButtonColor];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.colorViewDelegate respondsToSelector:@selector(numberOfColorElementsColorView:)])
        return [self.colorViewDelegate numberOfColorElementsColorView:self];
    
    return 0;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size.width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectCellWithIndexPath:indexPath animation:YES];
}

#pragma mark - UISCrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self moveToSelectedCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self moveToSelectedCell];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint topPoint        = scrollView.contentOffset;
    CGPoint bottomPoint     = scrollView.contentOffset;
    bottomPoint.y          += self.frame.size.height;
    CGFloat newOffset       = scrollView.contentOffset.y;
    CGFloat rowHeight       = self.frame.size.width;
    
    NSIndexPath *topIndexPath           = [self.tableView indexPathForRowAtPoint:topPoint];
    NSIndexPath *bottomIndexPath        = [self .tableView indexPathForRowAtPoint:bottomPoint];
    LSColorTableViewCell *topCell       = (LSColorTableViewCell*)[self.tableView cellForRowAtIndexPath:topIndexPath];
    LSColorTableViewCell *bottomCell    = (LSColorTableViewCell*)[self.tableView cellForRowAtIndexPath:bottomIndexPath];
    
    CGFloat topCellMiddle               = 0.0;
    CGFloat bottomCellMiddle            = 0.0;
    
    @try {
        topCellMiddle               = [self.tableView rectForRowAtIndexPath:topIndexPath].origin.y + rowHeight/2;
        bottomCellMiddle            = [self.tableView rectForRowAtIndexPath:bottomIndexPath].origin.y + rowHeight/2;
    }
    @catch (NSException *exception) {
        topCellMiddle               = 0.0;
        bottomCellMiddle            = 0.0;
    }

    
    void(^checkCells)() = ^{
        NSArray *visibleCells = [self.tableView visibleCells];
        if (visibleCells.count) {
            //            for (int i = 1; i < (visibleCells.count - 1); i++)
            for (int i = 0; i < visibleCells.count; i++)
            {
                LSColorTableViewCell *cell = visibleCells[i];
                if (!cell.showCell) cell.showCellWithoutAnimation = YES;
            }
        }
    };
    
    if (_oldOffset < newOffset) { // Scroll to top
        if (topCell && (newOffset > topCellMiddle)) if (topCell.showCell) topCell.showCell = NO;
        if (bottomCell && (bottomPoint.y  > bottomCellMiddle)) if(!bottomCell.showCell) bottomCell.showCell = YES;
    } else { // Scroll to bottom
        if (topCell && (newOffset < topCellMiddle)) if (!topCell.showCell) topCell.showCell = YES;
        if (bottomCell && (bottomPoint.y < bottomCellMiddle)) if(bottomCell.showCell) bottomCell.showCell = NO;
    }
    
    checkCells();
    [self selectMiddleCellWithAnimation:YES];
    
    _oldOffset = newOffset;
}

@end
