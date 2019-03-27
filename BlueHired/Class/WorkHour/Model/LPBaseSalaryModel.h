//
//  LPBaseSalaryModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPBaseSalaryDataModel;

@interface LPBaseSalaryModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property(nonatomic,strong) NSArray <LPBaseSalaryDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPBaseSalaryDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *overtimeMultiples;
@property (nonatomic, copy) NSString *overtime;
@property (nonatomic, copy) NSString *weekendOvertimeMultiples;
@property (nonatomic, copy) NSString *weekendOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;

@end
NS_ASSUME_NONNULL_END
