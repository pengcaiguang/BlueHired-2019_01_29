//
//  LPShippingAddressCell.h
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOrderAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPShippingAddressBlock)(void);

@interface LPShippingAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *defaultAddress;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Selecticon_width;


@property (nonatomic, strong) LPOrderAddressDataModel *model;
@property (nonatomic, copy) LPShippingAddressBlock Block;

@end

NS_ASSUME_NONNULL_END
