//
//  LPBonusDetailModel.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPBonusDetailDataModel;

@interface LPBonusDetailModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPBonusDetailDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@class LPBonusDetailListModel;
@interface LPBonusDetailDataModel : NSObject
@property (nonatomic, copy) NSArray <LPBonusDetailListModel *> *bonusList;
@property (nonatomic, copy) NSString *totalBonusMoney;

@end

@interface LPBonusDetailListModel : NSObject
@property (nonatomic, copy) NSString *bonusMoney;
@property (nonatomic, copy) NSString *bonusNum;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mechanismName;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *up_user;
@property (nonatomic, copy) NSString *userCardNumber;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *workTime;
@property (nonatomic, copy) NSString *workType;
 
@end
NS_ASSUME_NONNULL_END
