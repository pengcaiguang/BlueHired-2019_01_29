//
//  LPWork_ListModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPWork_ListDataModel;
@interface LPWork_ListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPWork_ListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPWork_ListDataModel : NSObject
@property (nonatomic, strong) NSString *applyNumber;
@property (nonatomic, strong) NSString *authority;
@property (nonatomic, strong) NSString *collectId;
@property (nonatomic, strong) NSString *cooperateMoney;
@property (nonatomic, strong) NSString *dismountType;
@property (nonatomic, strong) NSString *eatSleep;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imageList;
@property (nonatomic, strong) NSString *interviewTime;
@property (nonatomic, strong) NSString *isApply;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *lendType;
@property (nonatomic, strong) NSString *manageMoney;
@property (nonatomic, strong) NSString *maxNumber;
@property (nonatomic, strong) NSString *mechanismAddress;
@property (nonatomic, strong) NSString *mechanismDetails;
@property (nonatomic, strong) NSString *mechanismId;
@property (nonatomic, strong) NSString *mechanismLogo;
@property (nonatomic, strong) NSString *mechanismName;
@property (nonatomic, strong) NSString *mechanismScore;
@property (nonatomic, strong) NSString *mechanismUrl;
@property (nonatomic, strong) NSString *postName;
@property (nonatomic, strong) NSString *postType;
@property (nonatomic, strong) NSString *reMoney;
@property (nonatomic, strong) NSString *reTime;
@property (nonatomic, strong) NSString *recruitAddress;
@property (nonatomic, strong) NSString *remarks;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *wageRange;
@property (nonatomic, strong) NSString *workDemand;
@property (nonatomic, strong) NSString *workKnow;
@property (nonatomic, strong) NSString *workMoney;
@property (nonatomic, strong) NSString *workSalary;
@property (nonatomic, strong) NSString *workTime;
@property (nonatomic, strong) NSString *workTypeName;
@property (nonatomic, strong) NSString *workUrl;
@property (nonatomic, strong) NSString *workWatchStatus;
@end


