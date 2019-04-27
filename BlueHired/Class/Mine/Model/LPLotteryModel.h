//
//  LPLotteryModel.h
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPLotteryDataModel;

@interface LPLotteryModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPLotteryDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPLotteryDataModel : NSObject
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *getScore;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *luckyNum;
@property (nonatomic, copy) NSString *periodNum;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *totalScore;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *winNum;


@end

NS_ASSUME_NONNULL_END
