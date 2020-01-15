//
//  LPHXMessageTxtCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHXMessageTxtCell.h"

@implementation LPHXMessageTxtCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftTxtView.layer.cornerRadius = LENGTH_SIZE(6);
    self.leftTxtView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.leftTxtView.layer.borderWidth = LENGTH_SIZE(0.5);
    
    self.RightTxtView.layer.cornerRadius = LENGTH_SIZE(6);
    self.RightTxtView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    self.RightTxtView.layer.borderWidth = LENGTH_SIZE(0.5);
    
    self.leftUserImage.layer.cornerRadius = LENGTH_SIZE(18);
    self.RightUserImage.layer.cornerRadius = LENGTH_SIZE(18);
}

- (void)setModel:(id<HDIMessageModel>)model{
    _model = model;
//    发送的消息
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

    if (model.isSender) {
        self.leftUserImage.hidden = YES;
        self.leftUserName.hidden = YES;
        self.leftTxtView.hidden = YES;
        
        self.RightUserImage.hidden = NO;
        self.RightUserName.hidden = NO;
        self.RightTxtView.hidden = NO;
        self.RightUserName.text = user.data.user_name;
        self.RightTxtLabel.text = model.text;
        [self.RightUserImage sd_setImageWithURL:[NSURL URLWithString:user.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
    }else{
        self.leftUserImage.hidden = NO;
        self.leftUserName.hidden = NO;
        self.leftTxtView.hidden = NO;
        
        self.RightUserImage.hidden = YES;
        self.RightUserName.hidden = YES;
        self.RightTxtView.hidden = YES;
        self.leftUserName.text = model.nickname;
        self.leftTxtLabel.text = model.text;
        [self.leftUserImage sd_setImageWithURL:[NSURL URLWithString:model.avatarURLPath] placeholderImage:[UIImage imageNamed:@"adv_robot"]];

        

    }
}


- (void)setCustonModel:(LPCustomMessageModel *)CustonModel{
    _CustonModel = CustonModel;
    
    //    发送的消息
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

    if (CustonModel.isSender) {
        self.leftUserImage.hidden = YES;
        self.leftUserName.hidden = YES;
        self.leftTxtView.hidden = YES;
        
        self.RightUserImage.hidden = NO;
        self.RightUserName.hidden = NO;
        self.RightTxtView.hidden = NO;
        self.RightUserName.text = user.data.user_name;
        self.RightTxtLabel.text = CustonModel.text;
        [self.RightUserImage sd_setImageWithURL:[NSURL URLWithString:user.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
    }else{
        self.leftUserImage.hidden = NO;
        self.leftUserName.hidden = NO;
        self.leftTxtView.hidden = NO;
        
        self.RightUserImage.hidden = YES;
        self.RightUserName.hidden = YES;
        self.RightTxtView.hidden = YES;
        self.leftUserName.text = @"智能客服";
        self.leftTxtLabel.text = CustonModel.text;
        self.leftUserImage.image = [UIImage imageNamed:@"adv_robot"];

    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
