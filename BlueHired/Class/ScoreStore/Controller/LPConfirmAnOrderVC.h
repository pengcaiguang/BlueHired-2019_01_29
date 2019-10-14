//
//  LPConfirmAnOrderVC.h
//  BlueHired
//
//  Created by iMac on 2019/9/23.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPScoreStoreDetalisModel.h"
#import "LPCartItemListModel.h"
#import "LPOrderAddressModel.h"
#import "LPOrderGenerateModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^OrderModelStatusBlock)(LPOrderGenerateDataorderModel *OrderModel,NSInteger Type);
typedef void(^CartVCBlock)(void);

@interface LPConfirmAnOrderVC : LPBaseViewController

//type == 0 ,确认订单      type == 1 ,订单详情
@property (nonatomic,assign) NSInteger Type;

//BuyType == 0 ,直接购买     BuyType == 1 ,购物车
@property (nonatomic,assign) NSInteger BuyType;
@property (nonatomic,strong) ProductSkuListModel *BuyModel;
@property (nonatomic,assign) NSInteger BuyNumber;

@property (nonatomic, strong) NSMutableArray <LPCartItemListDataModel *>*CartArray;

@property (nonatomic, strong) LPOrderAddressModel *AddressModel;
@property (nonatomic, strong) LPOrderGenerateModel *GenerateModel;

//列表过来
@property (nonatomic, strong) LPOrderGenerateDataorderModel *OrderModel;

@property (nonatomic, copy) OrderModelStatusBlock OrderBlock;
@property (nonatomic, copy) CartVCBlock CartBlock;


@end

NS_ASSUME_NONNULL_END
