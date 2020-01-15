//
//  LPGameListView.h
//  BlueHired
//
//  Created by iMac on 2019/11/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPGameListView : UIView
@property (nonatomic,assign) NSInteger GameStatus;
@property (nonatomic,strong) UITableView *tableview;
- (void)GetList;
@end

NS_ASSUME_NONNULL_END
