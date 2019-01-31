//
//  LPLendAuditAgreeVC.h
//  BlueHired
//
//  Created by iMac on 2019/1/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLandAuditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPLendAuditAgreeVC : LPBaseViewController
@property (nonatomic,strong) LPLandAuditDataModel *model;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *CertNo;
@property (weak, nonatomic) IBOutlet UITextField *LendMoney;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIButton *TouchBt;

@end

NS_ASSUME_NONNULL_END
