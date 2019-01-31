//
//  LPAffiliationMenageCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPAffiliationMenageCell.h"
#import "LPSetReMoneyVC.h"

@implementation LPAffiliationMenageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPAffiliationDataModel *)model
{
    _model = model;
    
    _model = model;
    [_useriamge sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
     _userName.text = _model.userName;
    _suerTel.text = _model.userTel;
    _workDate.text =   @"";

    
    _mechanismName.text = _model.mechanismName;
 
 
    if (kUserDefaultsValue(USERDATA).integerValue == 1 || kUserDefaultsValue(USERDATA).integerValue ==2) {
        [self.reMoneyBt setTitle:@"设置返费" forState:UIControlStateNormal];
        if ([[LPTools isNullToString:_model.reMoney] isEqualToString:@""] || _model.reMoney.floatValue == 0.0) {
            self.reMoneyBt.hidden = NO;
            self.reMoney.hidden = YES;
        }else{
            self.reMoneyBt.hidden  = YES;
            self.reMoney.hidden = NO;
            self.reMoney.text = [NSString stringWithFormat:@"返费金额:%@元",[LPTools isNullToString:_model.reMoney]];
        }
    }else if (kUserDefaultsValue(USERDATA).integerValue == 6) {
        [self.reMoneyBt setTitle:@"返费提醒" forState:UIControlStateNormal];

        if ([[LPTools isNullToString:_model.reMoney] isEqualToString:@""] || _model.reMoney.floatValue == 0.0) {
            self.reMoneyBt.hidden = NO;
            self.reMoney.hidden = YES;
        }else{
            self.reMoneyBt.hidden  = YES;
            self.reMoney.hidden = NO;
            self.reMoney.text = [NSString stringWithFormat:@"返费金额:%@元",[LPTools isNullToString:_model.reMoney]];
        }
    }else{
        self.reMoney.hidden = YES;
        self.reMoneyBt.hidden = YES;
    }
    
    
    
    if ([_model.status integerValue]  ==1) {
        _suerStrtus.text = @"在职";
        _workDate.text = _model.time ? [NSString stringWithFormat:@"入职日期:%@",[NSString convertStringToYYYMMDD:_model.time]] : @"";
    }else if ([_model.status integerValue]  == 0){
        _suerStrtus.text = @"待业";
        self.reMoney.hidden = YES;
        self.reMoneyBt.hidden = YES;
    }else if ([_model.status integerValue] == 2){
        _suerStrtus.text = @"入职中";
    }
    
}

- (IBAction)touchRemoneyBt:(id)sender {
    
    if (kUserDefaultsValue(USERDATA).integerValue == 1 || kUserDefaultsValue(USERDATA).integerValue ==2) {
        LPSetReMoneyVC *vc = [[LPSetReMoneyVC alloc] init];
        vc.model = _model;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否提醒店主进行返费设置？" message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            NSLog(@"%ld",buttonIndex);
            if (buttonIndex) {
                //            [self requestQueryUpdateWorkOrderList:@"2" id:self.model.id reason:@""];
                [self requestQueryremind_shopkeeper];
            }
            
        }];
        [alert show];
    }

}


-(void)requestQueryremind_shopkeeper{
    NSDictionary *dic = @{@"status":@"true",
                          @"reminder":_model.userName
                          };
    [NetApiManager requestQueryremind_shopkeeper:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
//                if (self.Block) {
//                    self.Block();
//                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
