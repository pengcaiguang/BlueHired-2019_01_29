//
//  LPMyOrderView.h
//  BlueHired
//
//  Created by iMac on 2019/9/24.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMyOrderView : UIView
@property (nonatomic,assign) NSInteger MyOrderStatus;
@property (nonatomic,strong) NSMutableArray <LPMyOrderView *>*superViewArr;
@property (nonatomic,strong) UITableView *tableview;
@property (nonatomic,strong) NSMutableArray <LPOrderGenerateDataorderModel *>*listArray;

- (void)GetOrderList;
-(void)setNodataViewHidden;
@end

NS_ASSUME_NONNULL_END
