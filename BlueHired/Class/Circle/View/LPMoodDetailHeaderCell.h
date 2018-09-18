//
//  LPMoodDetailHeaderCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPGetMoodModel.h"

typedef void(^LPMoodDetailHeaderCellUserConcernBlock)(void);

@interface LPMoodDetailHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userUrlImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moodDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgView_constraint_height;

@property (weak, nonatomic) IBOutlet UIButton *userConcernButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userConcern_constraint_width;


@property(nonatomic,strong) LPGetMoodModel *model;

@property (nonatomic,copy) LPMoodDetailHeaderCellUserConcernBlock userConcernBlock;

@property(nonatomic,assign) BOOL isUserConcern;

@end


