//
//  LPGetScoreMoneyRecordModel.h
//  BlueHired
//
//  Created by iMac on 2019/7/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPGetScoreMoneyRecordDataModel;

@interface LPGetScoreMoneyRecordModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPGetScoreMoneyRecordDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPGetScoreMoneyRecordDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;


@end
NS_ASSUME_NONNULL_END
