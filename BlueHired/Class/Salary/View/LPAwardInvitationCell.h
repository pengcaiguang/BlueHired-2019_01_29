//
//  LPAwardInvitationCell.h
//  BlueHired
//
//  Created by iMac on 2019/8/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPrizeMoney.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAwardInvitationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *InVitationTypeLable;
@property (weak, nonatomic) IBOutlet UILabel *InVitationMoneyLable;
@property (weak, nonatomic) IBOutlet UILabel *UserNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *drawBtn;

@property(nonatomic,strong) LPPrizeDataMoney *model;

@end

NS_ASSUME_NONNULL_END
