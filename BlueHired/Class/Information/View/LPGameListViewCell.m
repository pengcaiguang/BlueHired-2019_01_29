//
//  LPGameListViewCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPGameListViewCell.h"
#import "LPShanDWVC.h"

@implementation LPGameListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.GameBtn.layer.cornerRadius = LENGTH_SIZE(6);
    self.GameBtn.layer.borderColor = [UIColor baseColor].CGColor;
    self.GameBtn.layer.borderWidth = LENGTH_SIZE(1);
    [self.GameBtn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPShanDWLIistDataModel *)model{
    _model = model;
    [self.GameImage yy_setImageWithURL:[NSURL URLWithString:model.bIcon] placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"]]];
    self.GameName.text = model.name;
    self.GameSub.text = model.sub;
    NSString *vPvStr = @"";
    if (model.vPv.integerValue>10000) {
        vPvStr = [NSString stringWithFormat:@"%ld万",model.vPv.integerValue/10000];
    }else{
        vPvStr = model.vPv;
    }
    
    self.GameTyep.text = [NSString stringWithFormat:@"%@  |  %@人在玩",model.type,vPvStr];

    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.GameTyep.text];

    [string addAttributes:@{NSForegroundColorAttributeName: [UIColor baseColor]} range:[self.GameTyep.text rangeOfString:vPvStr]];

    self.GameTyep.attributedText = string;
    
}

- (IBAction)TouchBtn:(id)sender {
    LPShanDWVC *vc = [[LPShanDWVC alloc] init];
    vc.model = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
}

@end
