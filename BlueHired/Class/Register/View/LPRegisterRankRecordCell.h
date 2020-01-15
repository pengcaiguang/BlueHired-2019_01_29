//
//  LPRegisterRankRecordCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInviteRankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRegisterRankRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *RankLabel;
@property (weak, nonatomic) IBOutlet UILabel *AwardLabel;
@property (weak, nonatomic) IBOutlet UIButton *AwardBtn;
@property (nonatomic, strong) LPInviteRankListInviteRankModel *model;

@end

NS_ASSUME_NONNULL_END
