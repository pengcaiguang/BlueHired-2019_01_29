//
//  LPConcerNumCell.m
//  BlueHired
//
//  Created by iMac on 2019/4/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConcerNumCell.h"

@implementation LPConcerNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ConerBT.layer.borderWidth = 1;

}


- (void)setModel:(LPConcernDataModel *)model{
    _model = model;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.geadingImage.image = [UIImage imageNamed:model.grading];
    self.userName.text = [LPTools isNullToString:model.userName];
    if (self.Type ==1 ) {
        if (model.focusStatus.integerValue>0) {
            self.ConerBT.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
            self.ConerBT.selected = NO;
        }else{
            self.ConerBT.layer.borderColor = [UIColor colorWithHexString:@"#FF6060"].CGColor;
            self.ConerBT.selected = YES;
        }
    }else if (self.Type == 2){
        if (model.focusStatus.integerValue>0) {
            [self.ConerBT setTitle:@"相互关注" forState:UIControlStateNormal];
            [self.ConerBT setImage:[UIImage imageNamed:@"相互关注-1"] forState:UIControlStateNormal];
            self.ConerBT.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
            self.ConerBT.selected = NO;
        }else{
            [self.ConerBT setTitle:@"取消关注" forState:UIControlStateNormal];
            [self.ConerBT setImage:[UIImage imageNamed:@"workStatus_icon"] forState:UIControlStateNormal];
            self.ConerBT.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
            self.ConerBT.selected = NO;
        }
        
        if (model.isDelete) {
            self.ConerBT.layer.borderColor = [UIColor colorWithHexString:@"#FF6060"].CGColor;
            self.ConerBT.selected = YES;
        }
    }
    
    
    
    
}

- (IBAction)TouchBt:(UIButton *)sender {
    [self requestSetUserConcern];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)requestSetUserConcern{
    NSDictionary *dic = @{
                          @"concernUserId":self.model.userId,
                          };
    
    if (self.Type == 2) {
        dic = @{
                @"concernUserId":self.model.concernUserId,
                };
    }
    
    [NetApiManager requestSetUserConcernWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (!ISNIL(responseObject[@"data"])) {
                if (self.Type == 1) {
                    self.model.focusStatus = [responseObject[@"data"] integerValue]==0?@"1":@"0";
                }else if (self.Type == 2){
                    if ([responseObject[@"data"] integerValue]==0) {        //已关注
                        self.model.isDelete = NO;
                    }else{
                        self.model.isDelete = YES;
                    }
                }
                if (self.Block) {
                    self.Block();
                }
             }
         }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
