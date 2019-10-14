//
//  LPScoreStoreDetalisModel.h
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class LPScoreStoreDetalisDataModel;
@class ProductSkuListModel;

@interface LPScoreStoreDetalisModel : NSObject
@property (nonatomic, copy) NSNumber *code;
@property (nonatomic, strong) LPScoreStoreDetalisDataModel *data;
@property (nonatomic, copy) NSString *msg;
@end

@interface LPScoreStoreDetalisDataModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *productSn;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *publishStatus;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *sale;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *postage;
@property (nonatomic, copy) NSString *cartItemNum;

@property (nonatomic, copy) NSArray <ProductSkuListModel *> *mProductSkuList;

@end

@interface ProductSkuListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *skuCode;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *stock;
@property (nonatomic, copy) NSString *sp1;
@property (nonatomic, copy) NSString *sp2;
@property (nonatomic, copy) NSString *sp3;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *sale;
@property (nonatomic, copy) NSString *delStatus;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *setTime;
@property (nonatomic, copy) NSString *spName1;
@property (nonatomic, copy) NSString *spName2;
@property (nonatomic, copy) NSString *spName3;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *postage;


@end

NS_ASSUME_NONNULL_END
