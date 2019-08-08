//
//  LPPrizeMoney.h
//  BlueHired
//
//  Created by iMac on 2019/7/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPPrizeDataMoney;

@interface LPPrizeMoney : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LPPrizeDataMoney *>*data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPPrizeDataMoney : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *relationMoneyTime;
@property (nonatomic, copy) NSString *relationMoney;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *mechanismName;


@end


NS_ASSUME_NONNULL_END
