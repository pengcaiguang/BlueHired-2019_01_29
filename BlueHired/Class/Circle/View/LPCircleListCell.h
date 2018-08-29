//
//  LPCircleListCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPMoodListModel.h"

@interface LPCircleListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userUrlImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UILabel *praiseTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_height;


@property(nonatomic,strong) LPMoodListDataModel *model;
@end
