//
//  LPFirmCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPFirmCell.h"
#import "LPFirmDetailsVC.h"

@implementation LPFirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPFirmDataModel *)model
{
    _model = model;
    [_useriamge sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
     _userName.text = _model.userName;
    _seurtel.text = _model.userTel;
    
    if (model.workStatus.integerValue == 0) {
        _isStatus.text = @"待业";
    }else if (model.workStatus.integerValue == 1){
        _isStatus.text = @"已入职";
    }else if (model.workStatus.integerValue == 2){
        _isStatus.text = @"入职中";
    }
}

- (IBAction)touchDetail:(id)sender {
    LPFirmDetailsVC *vc = [[LPFirmDetailsVC alloc] init];
    vc.model = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    vc.Block = ^(void){
        if (self.BlockTL) {
            self.BlockTL(self.model);
        }
    };
}

- (IBAction)touchTel:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
@end
