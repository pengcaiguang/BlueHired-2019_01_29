//
//  LPTLendAuditCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLandAuditModel.h"
typedef void(^LPAddRecordCellDicBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface LPTLendAuditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *useriamge;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *lendmoney;
@property (weak, nonatomic) IBOutlet UILabel *statueLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBt;
@property (weak, nonatomic) IBOutlet UIButton *repulseBt;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;

@property (nonatomic,strong) LPLandAuditDataModel *model;

@end

NS_ASSUME_NONNULL_END
