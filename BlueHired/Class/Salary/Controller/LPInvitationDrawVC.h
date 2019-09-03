//
//  LPInvitationDrawVC.h
//  BlueHired
//
//  Created by iMac on 2019/8/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPrizeMoney.h"
#import "LPReMoneyDrawModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^LPInvitationDrawBlock)(void);

@interface LPInvitationDrawVC : LPBaseViewController
@property(nonatomic,strong) LPPrizeDataMoney *model;
@property(nonatomic,strong) LPReMoneyDrawDataDetailsModel *ReMoneyModel;

@property(nonatomic,strong) LPInvitationDrawBlock block;

@end

NS_ASSUME_NONNULL_END
