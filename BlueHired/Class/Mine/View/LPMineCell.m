//
//  LPMineCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMineCell.h"
#import "LPSetVC.h"

@implementation LPMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.showMoneyButton setImage:[UIImage imageNamed:@"view_eye_selected"] forState:UIControlStateSelected];
    [self.showMoneyButton setImage:[UIImage imageNamed:@"hidden_eye"] forState:UIControlStateNormal];
    self.showMoneyButton.selected = YES;
}
-(void)setUserMaterialModel:(LPUserMaterialModel *)userMaterialModel{
    _userMaterialModel = userMaterialModel;
    [self.user_urlImgView sd_setImageWithURL:[NSURL URLWithString:userMaterialModel.data.user_url] placeholderImage:[UIImage imageNamed:@"mine_headimg_placeholder"]];
    self.user_nameLabel.text = userMaterialModel.data.user_name;
    self.gradingLabel.text = userMaterialModel.data.grading;
    self.moodNumLabel.text = [NSString stringWithFormat:@"帖子：%@",userMaterialModel.data.moodNum];
    self.concernNumLabel.text = [NSString stringWithFormat:@"粉丝：%@",userMaterialModel.data.concernNum];
    self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.1f",userMaterialModel.data.money.floatValue];

    if ([userMaterialModel.data.user_sex integerValue] == 0) {//0未知1男2女
        self.user_sexImgView.hidden = YES;
    }else if ([userMaterialModel.data.user_sex integerValue] == 1) {
        self.user_sexImgView.image = [UIImage imageNamed:@"male"];
    }else if ([userMaterialModel.data.user_sex integerValue] == 2) {
        self.user_sexImgView.hidden = [UIImage imageNamed:@"female"];
    }
    
    if ([userMaterialModel.data.workStatus integerValue] == 0) { //0待业1在职2入职中
        self.workStatusLabel.text = @"状态：待业";
    } else if ([userMaterialModel.data.workStatus integerValue] == 1){
        self.workStatusLabel.text = @"状态：在职";
    } else if ([userMaterialModel.data.workStatus integerValue] == 2){
        self.workStatusLabel.text = @"状态：入职中";
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",userMaterialModel.data.score];
}
- (IBAction)selectShowMoneyButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.moneyLabel.text = [NSString stringWithFormat:@"账户余额：%.1f",self.userMaterialModel.data.money.floatValue];
    }else{
        self.moneyLabel.text = @"账户余额：--";
    }
}


- (IBAction)touchSetButton:(id)sender {
    LPSetVC *vc = [[LPSetVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
