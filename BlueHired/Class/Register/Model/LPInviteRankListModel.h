//
//  LPInviteRankListModel.h
//  BlueHired
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPInviteRankListDataModel;
@class LPInviteRankListInviteRankModel;

@interface LPInviteRankListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPInviteRankListDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPInviteRankListDataModel : NSObject
@property (nonatomic, strong) LPInviteRankListInviteRankModel *inviteRank;
@property (nonatomic, copy) NSArray <LPInviteRankListInviteRankModel *> *inviteRankList;
@property (nonatomic, copy) NSString *unGainNum;
@end

@interface LPInviteRankListInviteRankModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, copy) NSString *rank;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *score;

@end

NS_ASSUME_NONNULL_END
