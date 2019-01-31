//
//  LPFirmDetailsVC.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPFirmModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^LPAddRecordCellDicBlock)(void);

@interface LPFirmDetailsVC : LPBaseViewController
@property (nonatomic,strong) LPFirmDataModel *model;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@end

NS_ASSUME_NONNULL_END
