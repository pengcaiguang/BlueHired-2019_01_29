//
//  LPOverTimeAccountModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/4.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPOverTimeAccountDataModel;
@class LPOverTimeAccountDataRecordListModel;
@class LPOverTimeAccountDataaccountListModel;

@interface LPOverTimeAccountModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPOverTimeAccountDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPOverTimeAccountDataModel : NSObject
@property(nonatomic,strong) NSArray <LPOverTimeAccountDataRecordListModel *> *overtimeRecordList;
@property(nonatomic,strong) NSArray <LPOverTimeAccountDataaccountListModel *> *accountList;
@property (nonatomic, copy) NSString *monthHours;
@property (nonatomic, copy) NSString *accountPrice;
@end

@interface LPOverTimeAccountDataRecordListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *leaveTime;
@property (nonatomic, copy) NSString *leaveMoney;
@property (nonatomic, copy) NSString *baseSalaryId;
@property (nonatomic, copy) NSString *moneyType;
@property (nonatomic, copy) NSString *shift;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *overtimeMultiples;
@property (nonatomic, copy) NSString *overtime;
@property (nonatomic, copy) NSString *weekendOvertimeMultiples;
@property (nonatomic, copy) NSString *weekendOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *mulAmount;
@property (nonatomic, copy) NSString *workHours;
@property (nonatomic, copy) NSString *workMoney;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *productNum;

@end


@interface LPOverTimeAccountDataaccountListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *accountName;
@property (nonatomic, copy) NSString *accountPrice;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *conType;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;

@end



NS_ASSUME_NONNULL_END
