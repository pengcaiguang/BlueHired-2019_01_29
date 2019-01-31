//
//  LPFirmModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPFirmDataModel;

@interface LPFirmModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPFirmDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPFirmDataModel : NSObject
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *enrollTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *nowReTime;
@property (nonatomic, copy) NSString *postType;
@property (nonatomic, copy) NSString *reMoney;
@property (nonatomic, copy) NSString *reTime;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *upUserId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workEndTime;
@property (nonatomic, copy) NSString *workId;
@property (nonatomic, copy) NSString *workMechanismId;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *workTypeId;

@end
NS_ASSUME_NONNULL_END
