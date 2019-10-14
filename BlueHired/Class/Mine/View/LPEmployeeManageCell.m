//
//  LPEmployeeManageCell.m
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPEmployeeManageCell.h"
#import "LPEmployeeWorkListVC.h"
#import "LPWorkRecordListVC.h"

@implementation LPEmployeeManageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recommendBtn.layer.borderColor = [UIColor baseColor].CGColor;
    [self.recommendBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    self.recommendBtn.layer.borderWidth = LENGTH_SIZE(1);
    self.recommendBtn.layer.cornerRadius = LENGTH_SIZE(6);
    
    self.UserImage.layer.cornerRadius = LENGTH_SIZE(17);
}

- (void)setModel:(LPLPEmployeeDataModel *)model{
    _model = model;
    self.UserNameLabel.text = model.userName;
    self.NumLabel.text = [NSString stringWithFormat:@"%@人",model.num];
    self.remarkLabel.text = model.remark;
    [self.UserImage yy_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholder:[UIImage imageNamed:@"avatar"]];
    self.recommendBtn.hidden = model.recStatus.integerValue;

//    self.WorkNameLabel.text = model.mechanismName;
//    self.PostLabel.text = model.workTypeName.length>0?[NSString stringWithFormat:@"（岗位：%@）",model.workTypeName]:@"（岗位：-）";
//
//    self.TimeLabel.text = [NSString convertStringToTime:model.setTime];
//    if (model.status.integerValue == 0) {
//         self.StatusLabel.text = @"已报名 ";
//        self.StatusLabel.textColor = [UIColor baseColor];
//    }else if (model.status.integerValue == 1){
//        self.StatusLabel.text = @"面试通过 ";
//        self.StatusLabel.textColor = [UIColor baseColor];
//    }else if (model.status.integerValue == 2){
//        self.StatusLabel.text = @"面试失败 ";
//        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
//    }else if (model.status.integerValue == 4){
//        self.StatusLabel.text = @"放弃入职 ";
//        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
//    }else if (model.status.integerValue == 5){
//        self.StatusLabel.text = @"在职 ";
//        self.StatusLabel.textColor = [UIColor baseColor];
//    }else if (model.status.integerValue == 6){
//        self.StatusLabel.text = @"离职 ";
//        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
//    }else if (model.status.integerValue == 7){
//        self.StatusLabel.text = @"未报名 ";
//        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FFAE3D"];
//
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TouchPhone:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (IBAction)TouchRemark:(id)sender {
    if (self.remarkBlock) {
        self.remarkBlock();
    }
}

- (IBAction)TouchRecommend:(id)sender {
    LPEmployeeWorkListVC *vc = [[LPEmployeeWorkListVC alloc] init];
    vc.Empmodel = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (IBAction)ToWorkRecordVC:(id)sender {
    
    LPWorkRecordListVC *vc = [[LPWorkRecordListVC alloc] init];
    vc.Emodel = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
}
@end
