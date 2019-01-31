//
//  LPAffiliationMenageCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPAffiliationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAffiliationMenageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *useriamge;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *suerTel;
@property (weak, nonatomic) IBOutlet UILabel *suerStrtus;
@property (weak, nonatomic) IBOutlet UILabel *workDate;
@property (weak, nonatomic) IBOutlet UILabel *mechanismName;

@property (weak, nonatomic) IBOutlet UILabel *reMoney;
@property (weak, nonatomic) IBOutlet UIButton *reMoneyBt;


@property (nonatomic,strong) LPAffiliationDataModel *model;

@end

NS_ASSUME_NONNULL_END
