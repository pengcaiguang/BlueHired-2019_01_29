//
//  LPEmployeeWorkListCell.m
//  BlueHired
//
//  Created by iMac on 2019/8/28.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPEmployeeWorkListCell.h"

@implementation LPEmployeeWorkListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.Workimage.layer.cornerRadius = LENGTH_SIZE(6);
    self.Workimage.layer.borderWidth = 1;
    self.Workimage.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(LPMechanismcommentMechanismlistDataModel *)model{
    _model = model;
    self.WorkName.text = model.mechanismName;
    [self.Workimage sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.PostType.text = [NSString stringWithFormat:@"%@(%@)",model.workTypeName,model.postType.integerValue == 0?@"正式工":@"小时工"];
    if (model.recommendType.integerValue == 0) {        //未推荐
        [self.noteBtn setImage:[UIImage imageNamed:@"NoteMessage"] forState:UIControlStateNormal];
        [self.noteBtn setTitle:@"" forState:UIControlStateNormal];
        self.Layout_noteBtn_right.constant = LENGTH_SIZE(0);
    }else{
        [self.noteBtn setImage:[UIImage new] forState:UIControlStateNormal];
        [self.noteBtn setTitle:@"已推荐" forState:UIControlStateNormal];
        self.Layout_noteBtn_right.constant = LENGTH_SIZE(13);

    }
}

- (IBAction)TouchNote:(UIButton *)sender { 
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    if (self.model.recommendType.integerValue == 0) {        //未推荐
        [self requestSendMechanism];
    }
 
}

-(void)requestSendMechanism{
    NSDictionary *dic = @{
                          @"id":self.Empmodel.id,
                          @"type":self.Empmodel.type,
                          @"workId":self.model.id
                          };
    
    [NetApiManager requestSendMechanism:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.model.recommendType = @"1";
                    [self setModel:self.model];
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"推荐成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"推荐失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
