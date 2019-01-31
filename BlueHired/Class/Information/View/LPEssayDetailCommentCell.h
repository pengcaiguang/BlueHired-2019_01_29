//
//  LPEssayDetailCommentCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/3.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPCommentListModel.h"

@protocol LPEssayDetailCommentCellDelegate<NSObject>

-(void)touchReplyButton:(LPCommentListDataModel *)model;

@end

@interface LPEssayDetailCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userUrlImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gradingiamge;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIView *replyBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyBgView_constraint_height;
@property(nonatomic,strong) LPCommentListDataModel *model;

@property (nonatomic,assign)id <LPEssayDetailCommentCellDelegate>delegate;

@end
