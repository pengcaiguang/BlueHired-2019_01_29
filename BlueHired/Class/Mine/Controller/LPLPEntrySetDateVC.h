//
//  LPLPEntrySetDateVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPentryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordBlock)(LPentryDataModel *M);

@interface LPLPEntrySetDateVC : LPBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *setdate;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UIButton *ClearBt;
@property (weak, nonatomic) IBOutlet UIButton *ConfirmBt;

@property (nonatomic,copy) LPAddRecordBlock BlockTL;

@property(nonatomic,strong) LPentryDataModel *model;

@end

NS_ASSUME_NONNULL_END
