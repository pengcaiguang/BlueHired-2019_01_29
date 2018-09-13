//
//  LPQueryCurrecordHourlyModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPQueryCurrecordHourlyDataModel;
@interface LPQueryCurrecordHourlyModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPQueryCurrecordHourlyDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPQueryCurrecordHourlyDataModel : NSObject

@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSNumber *userId;
@property(nonatomic,copy) NSNumber *workTypeHour;
@property(nonatomic,copy) NSNumber *labourCost;
@property(nonatomic,copy) NSNumber *dayMoney;
@property(nonatomic,copy) NSNumber *workType;
@property(nonatomic,copy) NSNumber *addType;
@property(nonatomic,copy) NSNumber *addWorkHour;
@property(nonatomic,copy) NSNumber *leaveType;
@property(nonatomic,copy) NSNumber *leaveHour;
@property(nonatomic,copy) NSNumber *del_status;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *set_time;
@property(nonatomic,copy) NSNumber *type;
@property(nonatomic,copy) NSNumber *optType;

@end
