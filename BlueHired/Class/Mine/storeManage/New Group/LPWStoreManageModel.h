//
//  LPWStoreManageModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPWStoreManageDataModel;

@interface LPWStoreManageModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPWStoreManageDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPWStoreManageDataModel : NSObject
@property (nonatomic, copy) NSString *authority;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *roleName;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *shopLabourNum;
@property (nonatomic, copy) NSString *shopNum;
@property (nonatomic, copy) NSString *shopType;
@property (nonatomic, copy) NSString *shopUserNum;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *totalBonusMoney;
@property (nonatomic, copy) NSString *userCardNumber;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;

@end
NS_ASSUME_NONNULL_END
