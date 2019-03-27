//
//  LPAddSubsidiesVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddSubsidiesVCBlock)(void);

@interface LPAddSubsidiesVC : LPBaseViewController
@property (nonatomic, strong)LPMonthWageDetailsModel *WageDetailsModel;
@property (nonatomic, assign) NSInteger ClassType;

@property (nonatomic, strong) NSString *row;
@property (nonatomic, strong) NSString *KQDateString;
@property (nonatomic, strong) UITableView *SuperTableView;
@property (nonatomic, copy) LPAddSubsidiesVCBlock block;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
