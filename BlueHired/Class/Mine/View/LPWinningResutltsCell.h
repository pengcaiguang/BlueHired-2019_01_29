//
//  LPWinningResutltsCell.h
//  BlueHired
//
//  Created by iMac on 2019/4/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLotteryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWinningResutltsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *Date;
@property (weak, nonatomic) IBOutlet UILabel *luckyNum;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *Score;


@property (nonatomic,strong) LPLotteryDataModel *model;

@end

NS_ASSUME_NONNULL_END
