//
//  LPConsumeTypeCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPOverTimeAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPConsumeTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *NameLable;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *DetailsLabel;

@property (nonatomic,strong) LPOverTimeAccountDataaccountListModel *model;
@end

NS_ASSUME_NONNULL_END
