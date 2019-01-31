//
//  LPInviteUpUserVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWStoreManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPInviteUpUserVC : LPBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property(nonatomic,strong) LPWStoreManageModel *Assistantmodel;

@end

NS_ASSUME_NONNULL_END
