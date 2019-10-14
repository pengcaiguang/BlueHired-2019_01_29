//
//  LPOrderGenerateModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPOrderGenerateDataModel;
@class LPOrderGenerateDataItemModel;
@class LPOrderGenerateDataorderModel;

@interface LPOrderGenerateModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPOrderGenerateDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPOrderGenerateDataModel : NSObject
@property (nonatomic, copy) NSArray <LPOrderGenerateDataItemModel *> *orderItemList;
@property (nonatomic, strong) LPOrderGenerateDataorderModel *order;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *serviceTel;

@end

@interface LPOrderGenerateDataItemModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderSn;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPrice;
@property (nonatomic, copy) NSString *productQuantity;
@property (nonatomic, copy) NSString *productSkuId;
@property (nonatomic, copy) NSString *sp1;
@property (nonatomic, copy) NSString *sp2;
@property (nonatomic, copy) NSString *sp3;
@property (nonatomic, copy) NSString *spName1;
@property (nonatomic, copy) NSString *spName2;
@property (nonatomic, copy) NSString *spName3;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *postage;

@end

@interface LPOrderGenerateDataorderModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
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
@property (nonatomic, copy) NSString *backTime;
@property (nonatomic, copy) NSString *totalQuantity;
@property (nonatomic, copy) NSString *userTel;
@property (nonatomic, copy) NSString *serviceTel;
@property (nonatomic, copy) NSArray <LPOrderGenerateDataItemModel *> *orderItemList;

@end


NS_ASSUME_NONNULL_END
