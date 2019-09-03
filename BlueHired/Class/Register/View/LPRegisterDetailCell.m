//
//  LPRegisterDetailCell.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterDetailCell.h"

@implementation LPRegisterDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(LPRegisterDetailDataListModel *)model{
    _model = model;

    
    if (self.Type == 1) {
        self.phoneBtn.hidden = YES;
        self.LayoutConstraint_Label_Top.constant = 15;
        self.remarkiamge.hidden = YES;
        self.remarkLabel.text = @"";
        
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ ",[LPTools isNullToString:model.userName]];
        if (model.type.integerValue == 0) {
            self.typeLabel.text = @" 直接邀请 ";
            self.typeLabel.textColor = [UIColor baseColor];
            self.typeLabel.layer.borderColor = [UIColor baseColor].CGColor;
            self.typeLabel.layer.borderWidth = 1;
            self.typeLabel.layer.cornerRadius = 2;
        }else{
            self.typeLabel.text = @" 间接邀请 ";
            self.typeLabel.textColor = [UIColor colorWithHexString:@"#FF9445"];
            self.typeLabel.layer.borderColor = [UIColor colorWithHexString:@"#FF9445"].CGColor;
            self.typeLabel.layer.borderWidth = 1;
            self.typeLabel.layer.cornerRadius = 2;
        }
        
        self.LayoutConstraint_typeLabel_width.constant = [LPTools widthForString:self.typeLabel.text fontSize:FontSize(13) andHeight:20];

        
        if(model.delStatus.integerValue == 0){
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"未到账：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
            self.relationMoneyLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        } else if (model.delStatus.integerValue == 1){
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"待领取：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor baseColor];
            self.relationMoneyLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        } else{
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"已领取：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            self.relationMoneyLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        }
    }else{
        self.phoneBtn.hidden = NO;

        self.LayoutConstraint_Label_Top.constant = 13;
        self.remarkiamge.hidden = NO;
        self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@",[LPTools isNullToString:model.remark]];
        
        self.userNameLabel.text = [NSString stringWithFormat:@"%@ ",[LPTools isNullToString:model.userName]];
 
        self.typeLabel.text = [NSString stringWithFormat:@"%@****%@",[model.userTel substringWithRange:NSMakeRange(0, 3)],[model.userTel substringWithRange:NSMakeRange(7, 4)]];
        self.LayoutConstraint_typeLabel_width.constant = [LPTools widthForString:self.typeLabel.text fontSize:FontSize(13) andHeight:20]+8;

        if(model.status.integerValue == 1 || model.status.integerValue == 0){
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"未到账：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
            self.relationMoneyLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        }else if (model.status.integerValue == 2){
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"待领取：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor baseColor];
            self.relationMoneyLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
        } else{
            self.relationMoneyLabel.text = [NSString stringWithFormat:@"已领取：%.2f元",model.relationMoney.floatValue];
            self.relationMoneyLabel.textColor = [UIColor colorWithHexString:@"#999999"];
            self.relationMoneyLabel.font = [UIFont boldSystemFontOfSize:FontSize(14)];
        }
    }
    
    
    self.LayoutConstraint_relationMoneyLabel_width.constant = [LPTools widthForString:self.relationMoneyLabel.text fontSize:FontSize(14) andHeight:20]+10;
    

}

- (IBAction)TouchPhont:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
