//
//  LPTLendAuditCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPTLendAuditCell.h"
#import "LPLendRepulseVC.h"
#import "LPLendAuditAgreeVC.h"
#import "RSAEncryptor.h"

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";

@implementation LPTLendAuditCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.useriamge.layer.cornerRadius = 55.0/2;
    self.agreeBt.layer.cornerRadius = 12.0;
    self.repulseBt.layer.cornerRadius = 12.0;
    self.repulseBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.repulseBt.layer.borderWidth = 1;
}

-(void)setModel:(LPLandAuditDataModel *)model
{
    _model = model;
    [_useriamge sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    _userName.text = [LPTools isNullToString:model.userName];
    _userTel.text = [RSAEncryptor decryptString:self.model.certNo privateKey:RSAPrivateKey];
    _lendmoney.text = [LPTools isNullToString:model.lendMoney];
    if (model.status.integerValue == 0) {
        _agreeBt.hidden = NO;
        _repulseBt.hidden = NO;
        _statueLabel.hidden = YES;
    }else if (model.status.integerValue == 1){
        _agreeBt.hidden = YES;
        _repulseBt.hidden = YES;
        _statueLabel.hidden = NO;
        _statueLabel.text = @"已通过";
        _statueLabel.textColor = [UIColor baseColor];
    }else if (model.status.integerValue == 2){
        _agreeBt.hidden = YES;
        _repulseBt.hidden = YES;
        _statueLabel.hidden = NO;
        _statueLabel.text = @"已拒绝";
        _statueLabel.textColor = [UIColor blackColor];
    }
    
}
- (IBAction)touchRepulseBt:(id)sender {
    LPLendRepulseVC *vc = [[LPLendRepulseVC alloc] init];
    vc.model = self.model;
    vc.Type = 1;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
- (IBAction)touchAgreeBt:(id)sender {
//    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"请仔细检核对借支信息，是否提交至系统进行账户转账" message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//        NSLog(@"%ld",buttonIndex);
//        if (buttonIndex) {
//            [self requestQueryUpdateMoneyList];
//        }
//     }];
//    [alert show];
    
    LPLendAuditAgreeVC *vc = [[LPLendAuditAgreeVC alloc] init];
    vc.model = self.model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - request
-(void)requestQueryUpdateMoneyList{
    NSDictionary *dic = @{@"status":@"1",
                          @"id":self.model.id};
    
    [NetApiManager requestQueryUpdateLandMoneyList:dic withHandle:^(BOOL isSuccess, id responseObject) {
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
