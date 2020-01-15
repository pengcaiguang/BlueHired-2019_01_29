//
//  LPSelectBindbankcardModel.h
//  BlueHired
//
//  Created by peng on 2018/9/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPSelectBindbankcardDataModel;
@interface LPSelectBindbankcardModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPSelectBindbankcardDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPSelectBindbankcardDataModel : NSObject
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *bankUserTel;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSNumber *delStatus;
@property (nonatomic, copy) NSNumber *id;
@property (nonatomic, copy) NSString *identityNo;
@property (nonatomic, copy) NSNumber *moneyPassword;
@property (nonatomic, copy) NSString *openBankAddr;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSNumber *type;
@property (nonatomic, copy) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *accountBalance;
@property (nonatomic, copy) NSString *chargeMoney;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *bankNumArr;

@end

