//
//  LPHoursWorkListModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/5.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPHoursWorkListDataModel;
@class LPHoursWorkListOverTimeModel;
@class LPHoursWorkListLeaveModel;
@class LPHoursWorkListShiftModel;

@interface LPHoursWorkListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPHoursWorkListDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end
@interface LPHoursWorkListDataModel : NSObject
@property(nonatomic,strong) NSArray <LPHoursWorkListOverTimeModel *> *overtimeList;
@property(nonatomic,strong) NSArray <LPHoursWorkListLeaveModel *> *leaveList;
@property(nonatomic,strong) NSArray <LPHoursWorkListShiftModel *> *shiftList;

@end

@interface LPHoursWorkListOverTimeModel : NSObject
@property (nonatomic, copy) NSString *baseSalaryId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *moneyType;
@property (nonatomic, copy) NSString *mulAmount;
@property (nonatomic, copy) NSString *mulName;
@property (nonatomic, copy) NSString *overtime;
@property (nonatomic, copy) NSString *overtimeMultiples;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *shift;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *weekendOvertime;
@property (nonatomic, copy) NSString *weekendOvertimeMultiples;
@property (nonatomic, copy) NSString *workHours;

@end

@interface LPHoursWorkListLeaveModel : NSObject
@property (nonatomic, copy) NSString *baseSalaryId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *moneyType;
@property (nonatomic, copy) NSString *mulAmount;
@property (nonatomic, copy) NSString *mulName;
@property (nonatomic, copy) NSString *overtime;
@property (nonatomic, copy) NSString *overtimeMultiples;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *shift;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *weekendOvertime;
@property (nonatomic, copy) NSString *weekendOvertimeMultiples;
@property (nonatomic, copy) NSString *leaveMoney;
@property (nonatomic, copy) NSString *leaveMoneyTotal;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *productNum;

@end
@interface LPHoursWorkListShiftModel : NSObject
@property (nonatomic, copy) NSString *baseSalaryId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *leaveType;
@property (nonatomic, copy) NSString *moneyType;
@property (nonatomic, copy) NSString *mulAmount;
@property (nonatomic, copy) NSString *mulName;
@property (nonatomic, copy) NSString *overtime;
@property (nonatomic, copy) NSString *overtimeMultiples;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *shift;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *weekendOvertime;
@property (nonatomic, copy) NSString *weekendOvertimeMultiples;


@end
NS_ASSUME_NONNULL_END
