//
//  LPRegisterRankListCell.h
//  BlueHired
//
//  Created by iMac on 2019/11/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInviteRankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRegisterRankListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *RankBtn;
@property (weak, nonatomic) IBOutlet UIImageView *UserImage;
@property (weak, nonatomic) IBOutlet UILabel *UserName;
@property (weak, nonatomic) IBOutlet UILabel *Num;
@property (nonatomic, strong) LPInviteRankListInviteRankModel *model;

@end

NS_ASSUME_NONNULL_END
