//
//  LPPraiseListModel.h
//  BlueHired
//
//  Created by iMac on 2018/12/22.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPPraiseListDataModel;
@class LPPraiseDataModel;

@interface LPPraiseListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPPraiseListDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPPraiseListDataModel : NSObject
@property (nonatomic, strong) NSArray <LPPraiseDataModel *>*list;
@property (nonatomic, strong) NSString *num;

@end

@interface LPPraiseDataModel : NSObject
@property(nonatomic,copy) NSString *concernNum;
@property(nonatomic,copy) NSString *dayScore;
@property(nonatomic,copy) NSString *delStatus;
@property(nonatomic,copy) NSString *grading;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *identity;
@property(nonatomic,copy) NSString *inScore;
@property(nonatomic,copy) NSString *lendMoney;
@property(nonatomic,copy) NSString *moodNum;
@property(nonatomic,copy) NSString *openId;
@property(nonatomic,copy) NSString *role;
@property(nonatomic,copy) NSString *score;
@property(nonatomic,copy) NSString *setTime;
@property(nonatomic,copy) NSString *signNumber;
@property(nonatomic,copy) NSString *signStatus;
@property(nonatomic,copy) NSString *time;
@property(nonatomic,copy) NSString *userName;
@property(nonatomic,copy) NSString *userPassword;
@property(nonatomic,copy) NSString *userSex;
@property(nonatomic,copy) NSString *userTel;
@property(nonatomic,copy) NSString *userType;
@property(nonatomic,copy) NSString *userUrl;
@property(nonatomic,copy) NSString *workAddress;
@property(nonatomic,copy) NSString *workStatus;
@property(nonatomic,copy) NSString *workType;

@end

NS_ASSUME_NONNULL_END
