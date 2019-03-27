//
//  LPWorkHourBaseSalaryVC.h
//  BlueHired
//
//  Created by iMac on 2019/3/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPWorkHourBaseSalaryVCBlock)(void);

@interface LPWorkHourBaseSalaryVC : LPBaseViewController
@property (nonatomic, assign) NSInteger WorkHourType;


@property (nonatomic,copy) LPWorkHourBaseSalaryVCBlock Block;

@end

NS_ASSUME_NONNULL_END
