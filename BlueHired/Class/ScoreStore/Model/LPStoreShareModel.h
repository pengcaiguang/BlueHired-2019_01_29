//
//  LPStoreShareModel.h
//  BlueHired
//
//  Created by iMac on 2019/10/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPScoreStoreDetalisModel.h"

NS_ASSUME_NONNULL_BEGIN

@class LPStoreShareDataModel;
@class LPStoreShareDataUserModel;

@interface LPStoreShareModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPStoreShareDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPStoreShareDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *totalAmount;
@property (nonatomic, copy) NSString *payType;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *deliveryCompany;
@property (nonatomic, copy) NSString *deliverySn;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, copy) NSString *receiverProvince;
@property (nonatomic, copy) NSString *receiverCity;
@property (nonatomic, copy) NSString *receiverRegion;
@property (nonatomic, copy) NSString *receiverDetailAddress;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, copy) NSString *confirmStatus;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *paymentTime;
@property (nonatomic, copy) NSString *deliveryTime;
@property (nonatomic, copy) NSString *receiveTime;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *orderItemList;
@property (nonatomic, copy) NSString *totalQuantity;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *serviceTel;
@property (nonatomic, copy) NSString *backTime;
@property (nonatomic, copy) NSString *shareNum;
@property (nonatomic, copy) NSString *discountNum;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *userUrl;
@property (nonatomic, copy) NSString *isLike;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *postage;
@property (nonatomic, copy) NSString *productSkuId;
@property (nonatomic, copy) NSString *sp1;
@property (nonatomic, copy) NSString *sp2;
@property (nonatomic, copy) NSString *sp3;
@property (nonatomic, copy) NSString *spName1;
@property (nonatomic, copy) NSString *spName2;
@property (nonatomic, copy) NSString *spName3;


@property (nonatomic, copy) NSArray <ProductSkuListModel *> *mProductSkuList;
@property (nonatomic, copy) NSArray <LPStoreShareDataUserModel *> *shareUserList;

@end
@interface LPStoreShareDataUserModel : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userImage;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *identity;
@property (nonatomic, copy) NSString *upIdentity;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *workStatus;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *grading;
@property (nonatomic, copy) NSString *origin;
 

@end

NS_ASSUME_NONNULL_END
