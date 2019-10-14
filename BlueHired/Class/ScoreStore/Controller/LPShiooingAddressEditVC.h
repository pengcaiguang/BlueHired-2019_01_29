//
//  LPShiooingAddressEditVC.h
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOrderAddressModel.h"
#import "LPShippingAddressVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPShiooingAddressEditVC : LPBaseViewController

@property (nonatomic, strong) LPOrderAddressDataModel *ListModel;
@property (nonatomic, strong) LPShippingAddressVC *SuperVC;
@property (nonatomic, assign) NSInteger Type;


@end

NS_ASSUME_NONNULL_END
