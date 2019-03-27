//
//  LPWorkHourTallyBookCell.m
//  BlueHired
//
//  Created by iMac on 2019/2/21.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourTallyBookCell.h"

@implementation LPWorkHourTallyBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
 }

 

- (void)setAccountList:(NSArray<LPOverTimeAccountDataaccountListModel *> *)accountList{
    _accountList = accountList;
    [self.BookContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSInteger RoeCount = accountList.count>3?3:accountList.count;
    
    if (accountList.count>3) {
        [self.TallyButton setTitle:@"更多消费记录" forState:UIControlStateNormal];
    }else{
        [self.TallyButton setTitle:@"编辑消费记录" forState:UIControlStateNormal];
    }
    
    UILabel *TopLabel;
    for (int i =0 ; i< RoeCount; i++) {
        LPOverTimeAccountDataaccountListModel *m = accountList[i];
        UILabel *lable = [[UILabel alloc] init];
        [self.BookContentView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make){
            if (TopLabel) {
                make.top.equalTo(TopLabel.mas_bottom).offset(0);
            }else{
                make.top.mas_equalTo(0);
            }
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(41);
        }];
        lable.font = [UIFont systemFontOfSize:13];
        lable.text = m.accountName;
        
        
        UILabel *moneyLabel = [[UILabel alloc] init];
        [self.BookContentView addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lable.mas_top).offset(0);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(41);
        }];
        moneyLabel.text = [NSString stringWithFormat:@"%.2f元",m.accountPrice.floatValue];
        UIView *lineView =[[UIView alloc] init];
        [self.BookContentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lable.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        lineView.backgroundColor = [UIColor colorWithHexString:@"#FFE6E6E6"];
        TopLabel = lable;
    }
    
    
    
    self.ContentView_Height.constant = RoeCount*41;
    [self.BookContentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
