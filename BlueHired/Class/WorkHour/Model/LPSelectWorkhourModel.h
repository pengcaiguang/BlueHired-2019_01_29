//
//  LPSelectWorkhourModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPSelectWorkhourDataModel;
@interface LPSelectWorkhourModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPSelectWorkhourDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPSelectWorkhourDataAddHourListModel,LPSelectWorkhourDataLeaveHourListModel,LPSelectWorkhourDataNormalHourListModel,LPSelectWorkhourDataWorkRecordModel;
@interface LPSelectWorkhourDataModel : NSObject

@property(nonatomic,strong) NSArray <LPSelectWorkhourDataAddHourListModel *> *addHourList;
@property(nonatomic,strong) NSArray <LPSelectWorkhourDataLeaveHourListModel *> *leaveHourList;
@property(nonatomic,strong) NSArray <LPSelectWorkhourDataNormalHourListModel *> *normalHourList;
@property(nonatomic,strong) LPSelectWorkhourDataWorkRecordModel *workRecord;

@end

@interface LPSelectWorkhourDataAddHourListModel : NSObject
@property(nonatomic,strong) NSNumber *addType;
@property(nonatomic,strong) NSNumber *totalAddHour;
@end


@interface LPSelectWorkhourDataLeaveHourListModel : NSObject
@property(nonatomic,strong) NSNumber *leaveType;
@property(nonatomic,strong) NSNumber *totalLeaveHour;


@end

@interface LPSelectWorkhourDataNormalHourListModel : NSObject

@property(nonatomic,strong) NSNumber *totalWorkHour;
@property(nonatomic,strong) NSNumber *workType;

@end


@interface LPSelectWorkhourDataWorkRecordModel : NSObject

@property(nonatomic,copy) NSNumber *addWorkSalary;
@property(nonatomic,copy) NSNumber *basicSalary;
@property(nonatomic,copy) NSNumber *delStatus;
@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *month;
@property(nonatomic,copy) NSString *normlDeductLabel;
@property(nonatomic,copy) NSNumber *normlDeductMoney;
@property(nonatomic,copy) NSString *normlSubsidyLabel;
@property(nonatomic,copy) NSNumber *normlSubsidyMoney;
@property(nonatomic,copy) NSString *reDeductLabel;
@property(nonatomic,copy) NSNumber *reDeductMoney;
@property(nonatomic,copy) NSString *reSubsidyLabel;
@property(nonatomic,copy) NSNumber *reSubsidyMoney;
@property(nonatomic,copy) NSString *set_time;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSNumber *totalMoney;
@property(nonatomic,copy) NSNumber *type;
@property(nonatomic,copy) NSNumber *userId;

@end
