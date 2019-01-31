//
//  LPBonusDetailVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPAssistantModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPBonusDetailVC : LPBaseViewController
@property(nonatomic,strong) LPAssistantDataModel *Assistantmodel;
@property (weak, nonatomic) IBOutlet UILabel *TotalBonusMoney;

@end

NS_ASSUME_NONNULL_END
