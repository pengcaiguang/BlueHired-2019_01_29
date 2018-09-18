//
//  LPSelectWorkhourHourlyModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPSelectWorkhourHourlyDataModel;

@interface LPSelectWorkhourHourlyModel : NSObject

@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPSelectWorkhourHourlyDataModel *data;
@property (nonatomic, copy) NSString *msg;

@end


@class LPSelectWorkhourHourlyDataListModel,LPSelectWorkhourHourlyDataWorkRecordModel;

@interface LPSelectWorkhourHourlyDataModel : NSObject
@property (nonatomic, copy) NSArray <LPSelectWorkhourHourlyDataListModel *> *workHourList;
@property (nonatomic, strong) LPSelectWorkhourHourlyDataWorkRecordModel *workRecord;

@end

@interface LPSelectWorkhourHourlyDataListModel : NSObject
@property (nonatomic, copy) NSString *dayMoney;
@property (nonatomic, copy) NSString *labourCost;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *workReHour;
@end

@interface LPSelectWorkhourHourlyDataWorkRecordModel : NSObject
@property (nonatomic, copy) NSString *addWorkSalary;
@property (nonatomic, copy) NSString *basicSalary;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *month;
@property (nonatomic, copy) NSString *normlDeductLabel;
@property (nonatomic, copy) NSNumber *normlDeductMoney;
@property (nonatomic, copy) NSString *normlSubsidyLabel;
@property (nonatomic, copy) NSNumber *normlSubsidyMoney;
@property (nonatomic, copy) NSString *reDeductLabel;
@property (nonatomic, copy) NSNumber *reDeductMoney;
@property (nonatomic, copy) NSString *reSubsidyLabel;
@property (nonatomic, copy) NSNumber *reSubsidyMoney;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *totalMoney;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *userId;
@end
