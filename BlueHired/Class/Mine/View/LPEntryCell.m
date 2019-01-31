//
//  LPEntryCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPEntryCell.h"
#import "LPLendRepulseVC.h"
#import "LPLPEntrySetDateVC.h"
#import "LPEntryCertificationVC.h"

@implementation LPEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _setdate.layer.borderColor = [UIColor baseColor].CGColor;
    _Give.layer.borderColor = [UIColor baseColor].CGColor;
    _SHield.layer.borderColor = [UIColor baseColor].CGColor;
    
    _setdate.layer.borderWidth = 1;
    _Give.layer.borderWidth = 1;
    _SHield.layer.borderWidth = 1;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LPentryDataModel *)model
{
    _model = model;
    [_userimage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
     _name.text = [NSString stringWithFormat:@"%@(%@_%@)",[LPTools isNullToString:_model.userName],[LPTools isNullToString:_model.workName],[LPTools isNullToString:_model.postName]];
    _userTel.text = _model.userTel;
    
    if (_model.isReal.integerValue ==1) {
        _isReal.text = @"已实名";
    }else{
        _isReal.text = @"未实名";
    }
    
    if (_model.status.integerValue == 1) {
        _suerType.text = @"通过";
        [_setdate setTitle:@"设置入职日期" forState:UIControlStateNormal];
        [_Give setTitle:@"放弃入职" forState:UIControlStateNormal];
        _SHield.hidden = YES;
    }else{
        _suerType.text = @"";
        [_setdate setTitle:@"面试通过" forState:UIControlStateNormal];
        [_Give setTitle:@"面试失败" forState:UIControlStateNormal];
        _SHield.hidden = NO;
    }

}

- (IBAction)touchTel:(UIButton *)sender {
    sender.enabled = NO;
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_model.userTel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}
- (IBAction)touchsetdate:(id)sender {
    if (_model.status.integerValue == 1) {
        LPLPEntrySetDateVC *vc = [[LPLPEntrySetDateVC alloc] init];
        vc.model = self.model;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        vc.BlockTL = ^(LPentryDataModel *M){
            if (self.BlockTL) {
                self.BlockTL(self.model);
            }
        };
        
    }else{
        if (self.model.isReal.integerValue == 1) {
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"是否确定%@员工面试通过？",_model.userName] message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                NSLog(@"%ld",buttonIndex);
                if (buttonIndex) {
                    [self requestQueryupdate_interview];
                    //                [self requestQueryUpdateWorkOrderList:@"1" id:self.model.id reason:self.model.userName];
                }
            }];
            [alert show];
        }else{
            LPEntryCertificationVC *vc = [[LPEntryCertificationVC alloc] init];
            vc.model = self.model;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
            vc.Block = ^(void){
                if (self.Block) {
                    self.Block();
                }
            };
        }
    }
}
- (IBAction)touchGive:(id)sender {
    if (_model.status.integerValue == 1) {
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"是否确定%@员工放弃入职？",_model.userName] message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            NSLog(@"%ld",buttonIndex);
            if (buttonIndex) {
                [self requestQueryUpdateWorkOrderList:@"4" id:self.model.id reason:@""];
            }
            
        }];
        [alert show];
    }else{
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"请仔细核查%@员工的面试结果，是否确定为面试失败？",_model.userName] message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            NSLog(@"%ld",buttonIndex);
            if (buttonIndex) {
                [self requestQueryUpdateWorkOrderList:@"2" id:self.model.id reason:@""];
            }
            
        }];
        [alert show];
    }
}
- (IBAction)touchSHield:(id)sender {
    LPLendRepulseVC *vc = [[LPLendRepulseVC alloc] init];
    vc.EntryModel = self.model;
    vc.Type = 2;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    vc.BlockTL = ^(LPentryDataModel *M){
        if (self.BlockTL) {
            self.BlockTL(self.model);
        }
    };
}

#pragma mark - request
-(void)requestQueryUpdateWorkOrderList:(NSString *)status id:(NSString *) ID  reason:(NSString *) reason{
    NSDictionary *dic = @{@"id":ID,
                          @"reason":reason,
                          @"status":status};
    
    [NetApiManager requestQueryUodateWorkOrderList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                self.model.status = status;
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                if (self.BlockTL) {
                    self.BlockTL(self.model);
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark - request
-(void)requestQueryupdate_interview{
    
 
    NSDictionary *dic = @{@"id":_model.id};
    [NetApiManager requestQueryupdate_interview:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                self.model.status = @"1";
                if (self.Block) {
                    self.Block();
                }
             }else{
                [[UIWindow visibleViewController].view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
