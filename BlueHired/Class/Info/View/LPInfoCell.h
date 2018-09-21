//
//  LPInfoCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPInfoListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;
@property (weak, nonatomic) IBOutlet UILabel *informationTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *informationDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(nonatomic,strong) LPInfoListDataModel *model;
@end

NS_ASSUME_NONNULL_END
