//
//  LPWBalanceModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPWBalanceDataModel;

@interface LPWBalanceModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPWBalanceDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPWBalanceDataModel : NSObject

@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *platReMoney;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *shopNum;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *totalBonusMoney;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userSex;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *workAddress;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workNum;



@end

NS_ASSUME_NONNULL_END
