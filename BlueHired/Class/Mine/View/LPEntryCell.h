//
//  LPEntryCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPentryModel.h"
typedef void(^LPAddRecordCellDicBlock)(void);
typedef void(^LPAddRecordBlock)(LPentryDataModel *M);

NS_ASSUME_NONNULL_BEGIN

@interface LPEntryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *suerType;
@property (weak, nonatomic) IBOutlet UILabel *isReal;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UIButton *setdate;
@property (weak, nonatomic) IBOutlet UIButton *Give;
@property (weak, nonatomic) IBOutlet UIButton *SHield;
@property (nonatomic,copy) LPAddRecordCellDicBlock Block;
@property (nonatomic,copy) LPAddRecordBlock BlockTL;

@property (nonatomic,strong) LPentryDataModel  *model;

@end

NS_ASSUME_NONNULL_END
