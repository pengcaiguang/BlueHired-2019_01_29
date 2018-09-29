//
//  LPMineCell.h
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPUserMaterialModel.h"

@interface LPMineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *user_urlImgView;
@property (weak, nonatomic) IBOutlet UIImageView *user_sexImgView;

@property (weak, nonatomic) IBOutlet UILabel *gradingLabel;

@property (weak, nonatomic) IBOutlet UILabel *moodNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *concernNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *workStatusLabel; //工作状态0待业1在职2入职中
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *showMoneyButton;

@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property(nonatomic,strong) LPUserMaterialModel *userMaterialModel;
@property(nonatomic,assign) BOOL signin;

@end
