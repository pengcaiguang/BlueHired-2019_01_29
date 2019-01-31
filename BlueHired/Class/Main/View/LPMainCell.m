//
//  LPMainCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMainCell.h"

@implementation LPMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.postNameLabel.layer.masksToBounds = YES;
    self.postNameLabel.layer.cornerRadius = 3.0;
    self.postNameLabel.layer.borderWidth = 0.5;
    self.postNameLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
    self.ReturnBt.contentEdgeInsets = UIEdgeInsetsMake(0,0, -7, 0);
 }

-(void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = ![model.lendType integerValue];
    
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.mechanismScore];
    
    self.keyLabel.text = model.key;
    self.postNameLabel.text = model.postName;
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    if (model.isApply && AlreadyLogin) {
        if ([model.isApply integerValue] == 0) {
            self.isApplyLabel.hidden = NO;
        }else{
            self.isApplyLabel.hidden = YES;
        }
    }else{
        self.isApplyLabel.hidden = YES;
    }
    
    if ([model.status integerValue] == 0) {
        self.workTypeNameLabel.text = [NSString stringWithFormat:@"需%@%@人",model.workTypeName,model.maxNumber];
        self.workTypeNameLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }else{
        self.workTypeNameLabel.text = @"已招满";
        self.workTypeNameLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    
    self.applyNumberLabel.text = [NSString stringWithFormat:@"已报名:%@人",model.applyNumber ? model.applyNumber : @"0"];
    
    if (kUserDefaultsValue(USERDATA).integerValue == 1 ||
        kUserDefaultsValue(USERDATA).integerValue == 2 ||
        kUserDefaultsValue(USERDATA).integerValue == 6 ) {
        self.ReMoneyLabel.hidden = NO;
        self.ReturnBt.hidden = YES;
        
        if (model.cooperateMoney == nil || model.cooperateMoney.floatValue == 0.0) {
            self.ReMoneyLabel.text = [NSString stringWithFormat:@"管理费:%.1f元/月",model.manageMoney.floatValue];
        }else{
            self.ReMoneyLabel.text = [NSString stringWithFormat:@"合作价:%.1f元/小时",model.cooperateMoney.floatValue];
        }
        
        if (model.authority !=nil &&model.workWatchStatus != nil &&
            kUserDefaultsValue(USERDATA).integerValue != 6 ) {
            if (model.authority.integerValue == 0 && model.dismountType.integerValue == 0) {
                if (model.workWatchStatus.integerValue == 0) {
                    [self.IssueBt setTitle:@"发布招聘" forState:UIControlStateNormal];
                }else{
                    [self.IssueBt setTitle:@"取消发布" forState:UIControlStateNormal];
                }
                self.IssueBt.hidden = NO;
            }else{
                self.IssueBt.hidden = YES;
            }
        }else{
            self.IssueBt.hidden = YES;
        }
    }else{
        self.IssueBt.hidden = YES;
        self.ReMoneyLabel.text = @"";
        self.ReMoneyLabel.hidden = YES;
        if ([model.reStatus integerValue] == 1) {
            self.ReturnBt.hidden = NO;
            [self.ReturnBt setTitle:[NSString stringWithFormat:@"%@",model.reMoney] forState:UIControlStateNormal];
        }else{
            self.ReturnBt.hidden = YES;
            [self.ReturnBt setTitle:@"" forState:UIControlStateNormal];
        }


    }
    
}

- (IBAction)touchIssue:(id)sender {
    [self requestQueryset_workwatchstatus];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.isApplyLabel.backgroundColor = [UIColor colorWithHexString:@"#000000"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.isApplyLabel.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    // Configure the view for the selected state
}


#pragma mark - request
-(void)requestQueryset_workwatchstatus{
    NSDictionary *dic = @{@"workId":_model.id,
                          @"workWatchStatus":_model.workWatchStatus.integerValue?@"1":@"0"};
    WEAK_SELF()
     [NetApiManager requestQueryset_workwatchstatus:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] ==0  ) {
                weakSelf.model.workWatchStatus = responseObject[@"data"];
                [weakSelf setModel:weakSelf.model];
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

         }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
