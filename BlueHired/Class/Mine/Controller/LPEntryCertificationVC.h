//
//  LPEntryCertificationVC.h
//  BlueHired
//
//  Created by iMac on 2018/11/6.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPentryModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordCellDicBlock)(void);

@interface LPEntryCertificationVC : LPBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *BMName;

@property (weak, nonatomic) IBOutlet UILabel *BMPhone;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *Card;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property (nonatomic,strong) LPentryDataModel  *model;

@end

NS_ASSUME_NONNULL_END
