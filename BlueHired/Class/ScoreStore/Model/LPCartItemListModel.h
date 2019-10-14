//
//  LPCartItemListModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/26.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPCartItemListDataModel;

@interface LPCartItemListModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, copy) NSArray <LPCartItemListDataModel *> *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPCartItemListDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productSkuId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *quantity;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *sp1;
@property (nonatomic, copy) NSString *sp2;
@property (nonatomic, copy) NSString *sp3;
@property (nonatomic, copy) NSString *spName1;
@property (nonatomic, copy) NSString *spName2;
@property (nonatomic, copy) NSString *spName3;
@property (nonatomic, copy) NSString *productPic;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *realStock;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *lockStock;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *postage;


@end

NS_ASSUME_NONNULL_END
