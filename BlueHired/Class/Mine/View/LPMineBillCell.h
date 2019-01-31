//
//  LPMineBillCell.h
//  BlueHired
//
//  Created by iMac on 2019/1/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserMaterialModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMineBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMoneyButton;
@property (weak, nonatomic) IBOutlet UIView *backView2;
@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;

@end

NS_ASSUME_NONNULL_END
