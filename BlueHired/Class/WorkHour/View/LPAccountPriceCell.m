//
//  LPAccountPriceCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPAccountPriceCell.h"

@implementation LPAccountPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self addShadowToView:self.BgView withColor:[UIColor colorWithHexString:@"#12598B"]];

}
/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 4;
    theView.layer.masksToBounds = NO;
 
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setAccountPriceModel:(NSArray<LPAccountPriceDataModel *> *)AccountPriceModel{
    _AccountPriceModel = AccountPriceModel;
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat NumMoney = 0.0;
    UIView *TopLineView;
    for (int i = 0; i <AccountPriceModel.count; i++) {
        LPAccountPriceDataModel *m = AccountPriceModel[i];
        NumMoney += m.accountPrice.floatValue;
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(48);
                make.left.mas_equalTo(33);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(33);
            make.height.mas_equalTo(48);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:14];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        if (m.conType.integerValue == 1){
            SubTypeLabel.text  = [NSString stringWithFormat:@"饮食消费"];
        }else if (m.conType.integerValue == 2){
            SubTypeLabel.text  = [NSString stringWithFormat:@"交通消费"];
        }else if (m.conType.integerValue == 3){
            SubTypeLabel.text  = [NSString stringWithFormat:@"日常消费"];
        }else if (m.conType.integerValue == 4){
            SubTypeLabel.text  = [NSString stringWithFormat:@"购物消费"];
        }else if (m.conType.integerValue == 5){
            SubTypeLabel.text  = [NSString stringWithFormat:@"娱乐消费"];
        }else if (m.conType.integerValue == 6){
            SubTypeLabel.text  = [NSString stringWithFormat:@"其他消费"];
        }
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-32);
            make.height.mas_equalTo(48);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:14];
        SubMoneyLabel.textColor = [UIColor baseColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%.2f",m.accountPrice.floatValue];
        
        UIImageView *SubimageView = [[UIImageView alloc] init];
        [self.SubBGView addSubview:SubimageView];
        [SubimageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-11);
            make.width.mas_equalTo(0);
            make.height.mas_equalTo(48);
        }];
        SubimageView.contentMode = UIViewContentModeScaleAspectFit;
        SubimageView.image = [UIImage imageNamed:@"WorkHourBackImage_icon"];
        
//        UIButton *TouchBt = [[UIButton alloc] init];
//        [self.SubBGView addSubview:TouchBt];
//        [TouchBt mas_makeConstraints:^(MASConstraintMaker *make){
//            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
//            make.right.mas_equalTo(0);
//            make.left.mas_equalTo(0);
//            make.height.mas_equalTo(48);
//        }];
//        TouchBt.tag = 1000+i;
//        [TouchBt addTarget:self action:@selector(SubTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        TopLineView = lineV;
    }
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f",NumMoney];
    self.Subview_constrait_height.constant =48*AccountPriceModel.count;
}
-(void)SubTouch:(UIButton *)sender{
    NSLog(@"点击第%ld行",(long)sender.tag);
//    if (self.block) {
//        self.block(sender.tag-1000);
//    }
}
@end
