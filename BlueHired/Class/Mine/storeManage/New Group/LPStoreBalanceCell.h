//
//  LPStoreBalanceCell.h
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWBalanceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPStoreBalanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userNum;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (nonatomic,strong) LPWBalanceDataModel *model;

@end

NS_ASSUME_NONNULL_END
