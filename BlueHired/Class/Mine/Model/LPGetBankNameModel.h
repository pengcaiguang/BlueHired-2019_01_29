//
//  LPGetBankNameModel.h
//  BlueHired
//
//  Created by iMac on 2019/7/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LPGetBankNameDataModel;

@interface LPGetBankNameModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPGetBankNameDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end



@interface LPGetBankNameDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *bankNumber;
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *identityNo;
@property (nonatomic, copy) NSString *bankUserTel;
@property (nonatomic, copy) NSString *openBankAddr;
@property (nonatomic, copy) NSString *cardType;
@property (nonatomic, copy) NSString *moneyPassword;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *set_time;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *id_card_side;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *virValue;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *chargeMoney;



@end

NS_ASSUME_NONNULL_END
