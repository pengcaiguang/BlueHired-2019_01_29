//
//  LPLandAuditModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPLandAuditDataModel;

@interface LPLandAuditModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPLandAuditDataModel *> *data;
@property (nonatomic, copy) NSString *msg;

@end

@interface LPLandAuditDataModel : NSObject

@property (nonatomic, copy) NSString *checkUserId;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *lendMoney;
@property (nonatomic, copy) NSString *mechanismId;
@property (nonatomic, copy) NSString *remarks;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *userUrl;


@property (nonatomic, copy) NSString *certNo;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *workBeginTime;
@property (nonatomic, copy) NSString *workNum;

@end


NS_ASSUME_NONNULL_END
