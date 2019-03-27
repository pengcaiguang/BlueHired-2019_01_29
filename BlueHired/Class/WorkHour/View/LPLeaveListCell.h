//
//  LPLeaveListCell.h
//  BlueHired
//
//  Created by iMac on 2019/3/12.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMonthWageDetailsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPLeaveListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UILabel *Money;

@property (nonatomic,strong) LPMonthWageDetailsDataleaveListModel *model;

@end

NS_ASSUME_NONNULL_END
