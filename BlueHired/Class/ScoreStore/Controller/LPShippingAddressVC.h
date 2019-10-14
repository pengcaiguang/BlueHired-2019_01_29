//
//  LPShippingAddressVC.h
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOrderAddressModel.h"
#import "LPConfirmAnOrderVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPShippingAddressVC : LPBaseViewController

//Type==1 确认订单
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, assign) LPOrderAddressDataModel *SelectModel;
@property (nonatomic, strong) LPConfirmAnOrderVC *SupreVC;


@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray <LPOrderAddressDataModel *>*listArray;

-(void)addNodataViewHidden:(BOOL)hidden;



@end

NS_ASSUME_NONNULL_END
