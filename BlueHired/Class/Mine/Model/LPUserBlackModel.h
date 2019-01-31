//
//  LPUserBlackModel.h
//  BlueHired
//
//  Created by iMac on 2018/11/19.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPUserBlackDataModel;
@interface LPUserBlackModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPUserBlackDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end


@interface LPUserBlackDataModel : NSObject
@property (nonatomic, copy) NSString *defriendUserIdentity;
@property (nonatomic, copy) NSString *defriendUserName;
@property (nonatomic, copy) NSString *defriendUserSex;
@property (nonatomic, copy) NSString *defriendUserUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *userId;

@end
NS_ASSUME_NONNULL_END
