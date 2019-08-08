//
//  LPWorklistModel.h
//  BlueHired
//
//  Created by peng on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPWorklistDataModel;
@interface LPWorklistModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPWorklistDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPWorklistDataSlideshowListModel,LPWorklistDataWorkListModel,LPWorklistDataWorkBarsListModel;
@interface LPWorklistDataModel : NSObject
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSArray <LPWorklistDataWorkListModel *> *slideshowList;
@property (nonatomic, copy) NSArray <LPWorklistDataWorkListModel *> *workList;
@property (nonatomic, copy) NSArray <LPWorklistDataWorkBarsListModel *> *workBarsList;

@end


@interface LPWorklistDataSlideshowListModel : NSObject
@property (nonatomic, copy) NSNumber *applyNumber;
@property (nonatomic, copy) NSString *authority;
@property (nonatomic, copy) NSString *collectId;
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
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSNumber *postType;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
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
@property (nonatomic, copy) NSString *workWatchStatus;
@end


@interface LPWorklistDataWorkListModel : NSObject
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
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *mechanismScore;
@property (nonatomic, copy) NSString *mechanismUrl;
@property (nonatomic, copy) NSString *postName;
@property (nonatomic, copy) NSNumber *postType;
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
@property (nonatomic, copy) NSString *workWatchStatus;
@property (nonatomic, copy) NSString *reStatus;
@property (nonatomic, copy) NSString *age;

@end
@interface LPWorklistDataWorkBarsListModel : NSObject
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *interviewTime;
@property (nonatomic, copy) NSString *mechanismId;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
@property (nonatomic, copy) NSString *recruitAddress;
@property (nonatomic, copy) NSString *recruitStatus;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *set_status;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *teacherList;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *x;
@property (nonatomic, copy) NSString *y;


@end
