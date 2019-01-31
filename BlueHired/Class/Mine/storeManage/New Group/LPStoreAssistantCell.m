//
//  LPStoreAssistantCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPStoreAssistantCell.h"
#import "LPBonusDetailVC.h"


@implementation LPStoreAssistantCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dismissBt.layer.cornerRadius = 12;
    self.detailBt.layer.cornerRadius  = 12;
    self.detailBt.layer.borderColor = [UIColor baseColor].CGColor;
    self.detailBt.layer.borderWidth = 1;
 }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 }

- (void)setModel:(LPAssistantDataModel *)model
{
    _model = model;
    [_userimage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
     _userName.text = [LPTools isNullToString:model.userName];
    _userTel.text = [LPTools isNullToString:model.userTel];
    
    if (model.role.integerValue == 1 || model.role.integerValue == 2) {
        _dismissBt.hidden = YES;
    }else{
        _dismissBt.hidden = NO;
    }
    
    
}
- (IBAction)touchDismiss:(id)sender {
    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"是否辞退%@？",_model.userName] message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
        NSLog(@"%ld",buttonIndex);
        if (buttonIndex) {
//            [self requestQueryUpdateWorkOrderList:@"2" id:self.model.id reason:@""];
            [self requestQueryshopincome];
        }
        
    }];
    [alert show];
}
- (IBAction)touchDetail:(id)sender {
    LPBonusDetailVC *vc = [[LPBonusDetailVC alloc] init];
    vc.Assistantmodel = _model;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}


-(void)requestQueryshopincome{
    NSDictionary *dic = @{@"shopNum":_model.shopNum,
                          @"userId":_model.userId,
                          @"id":_model.id,
                          @"userName":_model.userName,
                          };
    [NetApiManager requestQueryshopdismiss:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1) {
                [[UIWindow visibleViewController].view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
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
