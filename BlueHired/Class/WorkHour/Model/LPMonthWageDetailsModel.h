//
//  LPMonthWageDetailsModel.h
//  BlueHired
//
//  Created by iMac on 2019/3/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPMonthWageDetailsDataModel;
@class LPMonthWageDetailsDataleaveListModel;
@class LPMonthWageDetailsDatamonthWageModel;

@interface LPMonthWageDetailsModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPMonthWageDetailsDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPMonthWageDetailsDataModel : NSObject
@property(nonatomic,strong) NSArray <LPMonthWageDetailsDataleaveListModel *> *leaveList;
@property (nonatomic, strong) LPMonthWageDetailsDatamonthWageModel *monthWage;
@property (nonatomic, copy) NSString *moneys;
@property (nonatomic, copy) NSString *productNum;
@property (nonatomic, copy) NSString *salary;



@property(nonatomic,strong) NSArray *MoneyList;         //总工资列表
@property(nonatomic,strong) NSString *MoneyNum;         //总工资

@property(nonatomic,assign) BOOL IsShow1;         //是否展开
@property(nonatomic,assign) BOOL IsShow2;         //是否展开
@property(nonatomic,assign) BOOL IsShow3;         //是否展开
@property(nonatomic,assign) BOOL IsShow4;         //是否展开
@property(nonatomic,assign) BOOL IsShow5;         //是否展开

@end

@interface LPMonthWageDetailsDatamonthWageModel : NSObject
@property (nonatomic, copy) NSString *deductContent;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *otherContent;
@property (nonatomic, copy) NSString *overtimeSalary;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *subsidy;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *autoSalary;
@property (nonatomic, copy) NSString *autoOvertimeSalary;
@property (nonatomic, copy) NSString *autoSalaryStatus;      //企业底薪开关 0为开启 1为关闭
@property (nonatomic, copy) NSString *autoOvertimeSalaryStatus;     //加班工资开关 0为开启1为关闭

@property (nonatomic, copy) NSString *reserve;     //公积金

@property (nonatomic, copy) NSString *personalTax;     //个人所得税

@property (nonatomic, copy) NSString *ShowpersonalTax;     //显示个人所得税

@property (nonatomic, copy) NSString *socialInsurance;     //社保

@property (nonatomic, copy) NSString *taxStatus;     //个人所得税自动获取状态 0为关闭1为自动获取

@property (nonatomic, copy) NSString *autoPersonalTax;  //自动获取的个人所得税

@end

@interface LPMonthWageDetailsDataleaveListModel : NSObject
@property (nonatomic, copy) NSString *baseSalaryId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *holidayOvertime;
@property (nonatomic, copy) NSString *holidayOvertimeMultiples;
@property (nonatomic, copy) NSString *hours;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *leaveMoney;
@property (nonatomic, copy) NSString *leaveTime;
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
@property (nonatomic, copy) NSString *leaveMoneyTotal;

@end
NS_ASSUME_NONNULL_END
