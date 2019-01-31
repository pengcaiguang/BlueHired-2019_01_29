//
//  LPSetReMoneyVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPAffiliationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPSetReMoneyVC : LPBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *MechanismName;
@property (nonatomic,strong) LPAffiliationDataModel *model;
@property (weak, nonatomic) IBOutlet UITextField *textTF;

@end

NS_ASSUME_NONNULL_END
