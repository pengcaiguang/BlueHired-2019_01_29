//
//  LPCircleView.h
//  BlueHired
//
//  Created by iMac on 2019/12/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPCircleView : UIView
@property (nonatomic,assign) NSInteger CircleStatue;
@property (nonatomic, strong)UITableView *tableview;

- (void)GetCircleList;
- (void)GetDirectCircleList;
@end

NS_ASSUME_NONNULL_END
