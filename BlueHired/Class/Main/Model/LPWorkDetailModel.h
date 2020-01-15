//
//  LPWorkDetailModel.h
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPWorkDetailDataModel;

@interface LPWorkDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPWorkDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPWorkDetailDataModel : NSObject

@property (nonatomic, copy) NSNumber *applyNumber;
@property (nonatomic, copy) NSString *authority;
@property (nonatomic, copy) NSNumber *collectId;
@property (nonatomic, copy) NSNumber *cooperateMoney;
@property (nonatomic, copy) NSNumber *dismountType;
@property (nonatomic, copy) NSString *eatSleep;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *imageList;
@property (nonatomic, copy) NSString *interviewTime;
@property (nonatomic, copy) NSNumber *isApply;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSNumber *lendType;
@property (nonatomic, copy) NSNumber *manageMoney;
@property (nonatomic, copy) NSNumber *maxNumber;
@property (nonatomic, copy) NSString *mechanismAddress;
@property (nonatomic, copy) NSString *mechanismDetails;
@property (nonatomic, copy) NSNumber *mechanismId;
@property (nonatomic, copy) NSString *mechanismLogo;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSNumber *postType;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSNumber *reMoney;
@property (nonatomic, copy) NSNumber *reTime;
@property (nonatomic, copy) NSString *recruitAddress;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *wageRange;
@property (nonatomic, copy) NSString *workDemand;
@property (nonatomic, copy) NSString *workKnow;
@property (nonatomic, copy) NSString *workMoney;
@property (nonatomic, copy) NSString *workSalary;
@property (nonatomic, copy) NSString *workTime;
@property (nonatomic, copy) NSString *workTypeName;
@property (nonatomic, copy) NSString *workUrl;
@property (nonatomic, copy) NSNumber *workWatchStatus;
@property (nonatomic, copy) NSString *reInstruction;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;
@property (nonatomic, copy) NSString *addWorkMoney;
@property (nonatomic, copy) NSString *reStatus;

@property (nonatomic, copy) NSString *sexAge;  //性别年龄
@property (nonatomic, copy) NSString *tattooHair;  //纹身染发
@property (nonatomic, copy) NSString *medicalFee;  //体检
@property (nonatomic, copy) NSString *vision;  //视力
@property (nonatomic, copy) NSString *culturalSkills;  //文化技能
@property (nonatomic, copy) NSString *nation;  //民族
@property (nonatomic, copy) NSString *idCard;  //身份证
@property (nonatomic, copy) NSString *postOther; //岗位其他要求
@property (nonatomic, copy) NSString *workingPrice;  //工价
@property (nonatomic, copy) NSString *hoursPrice;  //小时工价
@property (nonatomic, copy) NSString *overtimeDetails;  //加班费说明
@property (nonatomic, copy) NSString *subsidyDetails;  //补贴说明
@property (nonatomic, copy) NSString *payrollTime; //发薪时间
@property (nonatomic, copy) NSString *salaryOther; //薪资福利其他说明
@property (nonatomic, copy) NSString *accConditions; //住宿
@property (nonatomic, copy) NSString *diet;  //饮食
@property (nonatomic, copy) NSString *accOther;  //食宿条件其他说明
@property (nonatomic, copy) NSString *workSystem;  //工作制度
@property (nonatomic, copy) NSString *shiftTime; //班次时间
@property (nonatomic, copy) NSString *workOther; //工作时间其他说明
@property (nonatomic, copy) NSString *interviewData; //面试资料
@property (nonatomic, copy) NSString *interviewOther;  //面试其他说明


@end
