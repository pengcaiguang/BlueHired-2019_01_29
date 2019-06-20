//
//  LPAddressBookCell.m
//  BlueHired
//
//  Created by iMac on 2019/6/11.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAddressBookCell.h"
#import "LPInviteVC.h"

@implementation LPAddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Button.layer.cornerRadius = LENGTH_SIZE(27.0/2);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 }

- (void)setModel:(LPUserConcernListDataModel *)model{
    _model = model;
    if (model.status.integerValue == 1) { //已注册
        self.userImage.hidden = NO;
        self.userName.hidden = NO;
        self.BookName.hidden = NO;
        self.userName2.hidden = YES;
        
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"UserImage"]];
        self.userName.text = model.nickName;
        self.BookName.text = [NSString stringWithFormat:@"通讯录名称：%@",model.userName.length?model.userName:model.userTel];

        if (model.focusStatus.integerValue == 0) {  //已关注
 
            self.Button.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
            self.Button.layer.borderWidth = 1;
            [self.Button setTitle:@" 取消关注" forState:UIControlStateNormal];
            [self.Button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            [self.Button setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            self.Button.backgroundColor = [UIColor whiteColor];
            self.Button.titleLabel.font = FONT_SIZE(12);
        }else if (model.focusStatus.integerValue == 1){     //相互关注
 
            self.Button.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
            self.Button.layer.borderWidth = 1;
            [self.Button setTitle:@" 互相关注" forState:UIControlStateNormal];
            [self.Button setImage:[UIImage imageNamed:@"each"] forState:UIControlStateNormal];
            [self.Button setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            self.Button.backgroundColor = [UIColor whiteColor];
            self.Button.titleLabel.font = FONT_SIZE(12);

        }else if (model.focusStatus.integerValue == 2){             //未关注
 
            self.Button.layer.borderColor = [UIColor clearColor].CGColor;
            self.Button.layer.borderWidth = 1;
            [self.Button setTitle:@" 关注" forState:UIControlStateNormal];
            [self.Button setImage:[UIImage imageNamed:@"focus"] forState:UIControlStateNormal];
            [self.Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.Button.backgroundColor = [UIColor baseColor];
            self.Button.titleLabel.font = FONT_SIZE(14);

        }
        
    }else{          //未注册
        self.userImage.hidden = YES;
        self.userName.hidden = YES;
        self.BookName.hidden = YES;
        self.userName2.hidden = NO;
        
        self.userName2.text = model.userName.length?model.userName:model.userTel;
        self.Button.layer.borderWidth = 1;
        self.Button.layer.borderColor = [UIColor baseColor].CGColor;
        [self.Button setTitle:@"邀请" forState:UIControlStateNormal];
        [self.Button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
        [self.Button setImage:nil forState:UIControlStateNormal];
        self.Button.backgroundColor = [UIColor whiteColor];
    }
}

- (IBAction)TouchBT:(id)sender {
    if (self.model.status.integerValue == 1) {
            [self requestSetUserConcern];
    }else{
        LPInviteVC *vc = [[LPInviteVC alloc] init];
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

-(void)requestSetUserConcern{
    NSDictionary *dic = @{
                          @"concernUserId":self.model.userId,
                          @"type":@"1"
                          };
 
    
    [NetApiManager requestSetUserConcernWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if (!ISNIL(responseObject[@"data"])) {
                    self.model.focusStatus = [NSString stringWithFormat:@"%ld",(long)[responseObject[@"data"] integerValue]];
                    if (self.Block) {
                        self.Block();
                    }
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



@end
