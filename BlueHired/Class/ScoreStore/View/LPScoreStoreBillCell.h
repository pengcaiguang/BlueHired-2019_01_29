//
//  LPScoreStoreBillCell.h
//  BlueHired
//
//  Created by iMac on 2019/9/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPScoreStoreBillModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPScoreStoreBillCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;

@property (nonatomic, strong) LPScoreStoreBillDataModel *model;

@end

NS_ASSUME_NONNULL_END
