//
//  LPScoreMoneyModel.h
//  BlueHired
//
//  Created by iMac on 2019/7/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPScoreMoneyDataModel;
@interface LPScoreMoneyModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPScoreMoneyDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPScoreMoneyDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *totalMoney;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *ableScore;
@property (nonatomic, copy) NSString *consumeScore;
@property (nonatomic, copy) NSString *remainMoney;
@property (nonatomic, copy) NSString *RealityremainMoney;
@property (nonatomic, copy) NSString *rule;
@property (nonatomic, copy) NSString *activityTime;
@property (nonatomic, copy) NSString *activityStatus;//


@end
NS_ASSUME_NONNULL_END
