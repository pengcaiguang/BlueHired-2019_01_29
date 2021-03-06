//
//  LPUserMaterialModel.h
//  BlueHired
//
//  Created by peng on 2018/9/6.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LPUserMaterialDataModel;
@class LPUserMaterialPlanDataModel;
@interface LPUserMaterialModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPUserMaterialDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPUserMaterialDataModel : NSObject
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSNumber *concernNum;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *ideal_money;
@property (nonatomic, copy) NSString *ideal_post;
@property (nonatomic, copy) NSString *isConcern;
@property (nonatomic, copy) NSNumber *marry_status;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSNumber *money;
@property (nonatomic, copy) NSNumber *moodNum;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSNumber *score;
@property (nonatomic, copy) NSString *shipping_address;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSNumber *user_sex;
@property (nonatomic, copy) NSString *user_url;
@property (nonatomic, copy) NSNumber *workStatus;
@property (nonatomic, copy) NSString *work_type;
@property (nonatomic, copy) NSNumber *work_years;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *attentionNum;
@property (nonatomic, copy) NSString *isUserProblem;
@property (nonatomic, copy) NSString *emValue;
@property (nonatomic, copy) NSString *upEmValue;
@property (nonatomic, copy) NSString *downEmValue;
@property (nonatomic, copy) NSString *isReal;
@property (nonatomic, copy) NSString *isBank;
@property (nonatomic, copy) NSString *dataComplete;
@property (nonatomic, copy) NSString *rewardRecord;
 

@property (nonatomic, strong) NSMutableArray <LPUserMaterialPlanDataModel *> *userMaterialPlanList;

@end


@interface LPUserMaterialPlanDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *plan;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;

@end
