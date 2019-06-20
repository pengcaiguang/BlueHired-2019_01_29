//
//  LPUserBlackCell.m
//  BlueHired
//
//  Created by iMac on 2018/11/19.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPUserBlackCell.h"

@implementation LPUserBlackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = 15.5;
 }

-(void)setModel:(LPUserBlackDataModel *)model{
    _model = model;
    self.userName.text = [LPTools isNullToString:model.defriendUserName];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.defriendUserUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
}

- (IBAction)touchDelete:(id)sender {
    [self requestQueryDefriendPullBlack];
}

-(void)requestQueryDefriendPullBlack{
    NSDictionary *dic = @{@"identity":[LPTools isNullToString:self.model.defriendUserIdentity],
                          @"type":@"2"
                          };
    WEAK_SELF()
    [NetApiManager requestQueryDefriendPullBlack:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1 && [responseObject[@"code"] integerValue] == 0) {
                if (weakSelf.Block) {
                    weakSelf.Block(weakSelf.model);
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
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
