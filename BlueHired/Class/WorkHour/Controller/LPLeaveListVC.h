//
//  LPLeaveListVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageDetailsModel.h"
typedef void(^LPLeaveListVCBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LPLeaveListVC : LPBaseViewController
@property (nonatomic, strong)LPMonthWageDetailsModel *WageDetailsModel;
@property (nonatomic, copy) LPLeaveListVCBlock Toblock;
@property (nonatomic, assign) NSInteger WorkHourType;

@end

NS_ASSUME_NONNULL_END
