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

@class LPSelectWorkhourDataAddHourListModel,LPSelectWorkhourDataLeaveHourListModel,LPSelectWorkhourDataNormalHourListModel;
@interface LPSelectWorkhourDataModel : NSObject

@property(nonatomic,strong) NSArray <LPSelectWorkhourDataAddHourListModel *> *addHourList;
@property(nonatomic,strong) NSArray <LPSelectWorkhourDataLeaveHourListModel *> *leaveHourList;
@property(nonatomic,strong) NSArray <LPSelectWorkhourDataNormalHourListModel *> *normalHourList;
@property(nonatomic,copy) NSString *workRecord;

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

