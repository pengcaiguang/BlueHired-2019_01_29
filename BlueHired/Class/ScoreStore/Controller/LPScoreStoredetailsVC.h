//
//  LPScoreStoredetailsVC.h
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPProductListModel.h"
#import "LPCartItemListModel.h"
#import "LPStoreCartVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPScoreStoredetailsVC : LPBaseViewController
@property (nonatomic,strong) LPProductListDataModel *ListModel;
@property (nonatomic,strong) LPCartItemListDataModel *CartModel;


//SuperType = 0 ,列表进来。 SuperType = 1.购物车
@property (nonatomic,assign) NSInteger SuperType;
@property (nonatomic,strong) LPStoreCartVC *SuperVC;

@end

NS_ASSUME_NONNULL_END
