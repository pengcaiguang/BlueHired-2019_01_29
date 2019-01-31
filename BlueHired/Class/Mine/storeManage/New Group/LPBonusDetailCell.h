//
//  LPBonusDetailCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPBonusDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LPBonusDetailCell : UITableViewCell


@property(nonatomic,strong) LPBonusDetailListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *MechanismName;
@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *BonusMoney;
@property (weak, nonatomic) IBOutlet UILabel *BonusNum;
@property (weak, nonatomic) IBOutlet UILabel *workTime;
@property (weak, nonatomic) IBOutlet UILabel *workType;

@end

NS_ASSUME_NONNULL_END
