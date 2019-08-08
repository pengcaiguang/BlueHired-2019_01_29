//
//  LPRegisterEntryCell.m
//  BlueHired
//
//  Created by iMac on 2019/8/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRegisterEntryCell.h"

@implementation LPRegisterEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}

- (void)setModel:(LPInviteWorkListDataModel *)model{
    _model = model;
    if (model.inviteType.integerValue == 0) {
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
    
    self.userNameLabel.text = model.userName;
    self.AddresLabel.text = [NSString stringWithFormat:@"入职企业：%@",model.mechanismName];
    
    self.TimeLabel.text = [NSString convertStringToYYYMMDD:model.time];
    self.numLabel.text = [NSString stringWithFormat:@"%ld人",(long)model.num.integerValue];
    
    if (model.status.integerValue == 0) {       //面试预约中
        self.StatusLabel.text = @"已报名";
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF9445"];
    }else if (model.status.integerValue == 1){      //面试通过
        self.StatusLabel.text = @"待入职";
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF9445"];
    }else if (model.status.integerValue == 2){      //面试失败
        self.StatusLabel.text = @"面试失败";
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }else if (model.status.integerValue == 4){      //放弃入职
        self.StatusLabel.text = @"放弃入职";
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }else if (model.status.integerValue == 5){      //入职成功
        self.StatusLabel.text = @"在职";
        self.StatusLabel.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 6){      //离职
        self.StatusLabel.text = @"离职";
        self.StatusLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }
    
    
}


- (IBAction)TouchPhont:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}


@end
