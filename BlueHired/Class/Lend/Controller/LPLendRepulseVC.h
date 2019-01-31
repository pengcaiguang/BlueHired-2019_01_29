//
//  LPLendRepulseVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLandAuditModel.h"
#import "LPentryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordBlock)(LPentryDataModel *M);

@interface LPLendRepulseVC : LPBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *clearBt;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;

@property (nonatomic,strong) LPLandAuditDataModel *model;
@property (nonatomic,strong) LPentryDataModel *EntryModel;
@property (nonatomic,copy) LPAddRecordBlock BlockTL;

@property (nonatomic,assign) NSInteger Type;

@end

NS_ASSUME_NONNULL_END
