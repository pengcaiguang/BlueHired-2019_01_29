//
//  LPAccountPriceCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPAccountPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAccountPriceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *SubBGView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Subview_constrait_height;

@property (nonatomic,strong) NSArray <LPAccountPriceDataModel *> *AccountPriceModel;

@end

NS_ASSUME_NONNULL_END
