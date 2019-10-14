//
//  LPReMoneyDrawModel.h
//  BlueHired
//
//  Created by iMac on 2019/8/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPReMoneyDrawDataModel;
@class LPReMoneyDrawDataDetailsModel;

@interface LPReMoneyDrawModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) NSArray <LPReMoneyDrawDataModel *>*data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPReMoneyDrawDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
@property (nonatomic, copy) NSString *addWorkMoney;
@property (nonatomic, copy) NSString *endReTime;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workEndTime;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *prizeTime;
@property (nonatomic, copy) NSString *prizeNum;
@property (nonatomic, copy) NSString *diffDay;
@property (nonatomic, strong) NSArray <LPReMoneyDrawDataDetailsModel *>*reMoneyDetailsList;

@end

@interface LPReMoneyDrawDataDetailsModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *reMoneyTime;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *day;
@property (nonatomic, copy) NSString *avaTime;
@property (nonatomic, copy) NSString *workTime;
@property (nonatomic, copy) NSString *workDay;
@property (nonatomic, copy) NSString *title;


@end
NS_ASSUME_NONNULL_END
