//
//  LPMonthWageModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/4.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPMonthWageDataModel;
@interface LPMonthWageModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPMonthWageDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPMonthWageDataModel : NSObject
@property(nonatomic,copy) NSString *monthWage;
@property(nonatomic,copy) NSString *baseSalary;
@property(nonatomic,copy) NSString *monthSalary;
@property(nonatomic,copy) NSString *hours;
@property(nonatomic,copy) NSString *moneys;
@property(nonatomic,copy) NSString *period;
@property(nonatomic,copy) NSString *overtimeHours;
@property(nonatomic,copy) NSString *days;
@property(nonatomic,copy) NSString *productNum;

@end
NS_ASSUME_NONNULL_END
