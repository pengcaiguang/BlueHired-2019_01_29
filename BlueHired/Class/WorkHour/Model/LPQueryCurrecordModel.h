//
//  LPQueryCurrecordModel.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPQueryCurrecordDataModel;
@interface LPQueryCurrecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPQueryCurrecordDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPQueryCurrecordDataModel : NSObject

@property(nonatomic,copy) NSNumber *addType;
@property(nonatomic,copy) NSNumber *addWorkHour;
@property(nonatomic,copy) NSString *dayMoney;
@property(nonatomic,copy) NSNumber *id;
@property(nonatomic,copy) NSString *labourCost;
@property(nonatomic,copy) NSNumber *leaveHour;
@property(nonatomic,copy) NSNumber *leaveType;
@property(nonatomic,copy) NSString *optType;
@property(nonatomic,copy) NSString *set_time;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *userId;
@property(nonatomic,copy) NSNumber *workNormalHour;
@property(nonatomic,copy) NSNumber *workReHour;
@property(nonatomic,copy) NSNumber *workType;

@end
