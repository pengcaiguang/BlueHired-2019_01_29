//
//  LPStoreCartCell.h
//  BlueHired
//
//  Created by iMac on 2019/9/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCartItemListModel.h"
#import "LPScoreStoreDetalisModel.h"
#import "LPOrderGenerateModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPStoreCartCelBlock)(LPCartItemListDataModel *model);
typedef void(^LPStoreCartCelAddRoSubBlock)(void);

@interface LPStoreCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *commoditySize;
@property (weak, nonatomic) IBOutlet UILabel *commodityUnit;
@property (weak, nonatomic) IBOutlet UILabel *commodityCount;
@property (weak, nonatomic) IBOutlet UILabel *BuyCount;

@property (weak, nonatomic) IBOutlet UIButton *Add_Btn;
@property (weak, nonatomic) IBOutlet UIButton *Sub_Btn;
@property (weak, nonatomic) IBOutlet UILabel *NorStock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_selectBtn_Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Content_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Content_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Content_bottom;


@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic,copy) LPStoreCartCelBlock selectBlock;
@property (nonatomic,copy) LPStoreCartCelAddRoSubBlock AddroSubBlock;

//type = 1 购物车加减   type = 2 购物车没有库存 type = 3 确认订单
@property (nonatomic,assign) NSInteger Type;

@property (nonatomic,assign) BOOL selectAll;
@property(nonatomic,assign) BOOL selectStatus;


@property (nonatomic,strong) LPCartItemListDataModel *model;

@property (nonatomic,strong) LPCartItemListDataModel *CartModel;

@property (nonatomic,strong) LPOrderGenerateDataItemModel *GenerateModel;

@property (nonatomic,strong) ProductSkuListModel *BuyModel;
@property (nonatomic,assign) NSInteger BuyNumber;

@end

NS_ASSUME_NONNULL_END
