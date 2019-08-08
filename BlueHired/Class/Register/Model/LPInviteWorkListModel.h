//
//  LPInviteWorkListModel.h
//  BlueHired
//
//  Created by iMac on 2019/8/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPInviteWorkListDataModel;

@interface LPInviteWorkListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPInviteWorkListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPInviteWorkListDataModel : NSObject
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
@property (nonatomic, copy) NSString *inviteType;
@property (nonatomic, copy) NSString *num;


@end

NS_ASSUME_NONNULL_END
