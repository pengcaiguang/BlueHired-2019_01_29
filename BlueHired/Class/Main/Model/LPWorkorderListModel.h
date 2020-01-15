//
//  LPWorkorderListModel.h
//  BlueHired
//
//  Created by peng on 2018/9/7.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPWorkorderListDataModel;
@interface LPWorkorderListModel : NSObject

@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPWorkorderListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;

@end


@class LPWorkorderListDataTeacherListModel;

@interface LPWorkorderListDataModel : NSObject

@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *interviewTime;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *postType;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
@property (nonatomic, copy) NSString *recruitAddress;
@property (nonatomic, copy) NSNumber *recruitStatus;
@property (nonatomic, copy) NSNumber *role;
@property (nonatomic, copy) NSNumber *set_time;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSArray <LPWorkorderListDataTeacherListModel *> *teacherList;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *upUserId;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSNumber *workId;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *applyNumber;
@property (nonatomic, copy) NSNumber *isApply;
@property (nonatomic, copy) NSString *maxNumber;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *set_status;
@property (nonatomic, copy) NSString *wageRange;
@property (nonatomic, copy) NSString *workMoney;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSString *remarkStatus;
@property (nonatomic, copy) NSString *restTime;
@property (nonatomic, copy) NSString *restRemark;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *addWorkMoney;
@property (nonatomic, copy) NSString *workHourMoney;
@property (nonatomic, copy) NSString *lendType;
@property (nonatomic, copy) NSString *age;

@end

@interface LPWorkorderListDataTeacherListModel : NSObject

@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSNumber *set_time;
@property (nonatomic, copy) NSString *teacherName;
@property (nonatomic, copy) NSString *teacherTel;
@property (nonatomic, copy) NSNumber *time;
@property (nonatomic, copy) NSNumber *userId;

@end



