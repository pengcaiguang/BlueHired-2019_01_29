//
//  LPByThePieceCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPByThePieceCell.h"

@implementation LPByThePieceCell

- (void)awakeFromNib {
    [super awakeFromNib];
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



- (void)setModel:(NSArray<LPHoursWorkListLeaveModel *> *)model{
    _model = model;
    [self.SubBGView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat NumMoney = 0.0;
    UIView *TopLineView;
    for (int i = 0; i <model.count; i++) {
        LPHoursWorkListLeaveModel *m = model[i];
        NumMoney += m.productNum.floatValue;
        UIView *lineV = [[UIView alloc] init];
        [self.SubBGView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make){
            if (i == 0) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(13);
            }else{
                make.top.equalTo(TopLineView.mas_bottom).offset(40);
                make.left.mas_equalTo(13);
            }
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *SubTypeLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubTypeLabel];
        [SubTypeLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(40);
        }];
        SubTypeLabel.font = [UIFont systemFontOfSize:15];
        SubTypeLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        
        SubTypeLabel.text  = m.productName;
        
        
        UILabel *SubUnitLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubUnitLabel];
        [SubUnitLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.height.mas_equalTo(40);
            make.centerX.equalTo(self.SubBGView);
        }];
        SubUnitLabel.font = [UIFont systemFontOfSize:15];
        SubUnitLabel.textColor = [UIColor colorWithHexString:@"#444444"];
        SubUnitLabel.text  = [NSString stringWithFormat:@"%.2f",m.productPrice.floatValue];
        
        
        UILabel *SubMoneyLabel = [[UILabel alloc] init];
        [self.SubBGView addSubview:SubMoneyLabel];
        [SubMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(lineV.mas_bottom).offset(0);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(40);
        }];
        SubMoneyLabel.font = [UIFont systemFontOfSize:15];
        SubMoneyLabel.textColor = [UIColor baseColor];
        SubMoneyLabel.text  = [NSString stringWithFormat:@"%@件",reviseString(m.productNum)];
        
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
 
        TopLineView = lineV;
    }
    
    if (model.count ==0) {
        self.TitleLable1.hidden = YES;
        self.TitleLable2.hidden = YES;
        self.TitleLable3.hidden = YES;
    }else{
        self.TitleLable1.hidden = NO;
        self.TitleLable2.hidden = NO;
        self.TitleLable3.hidden = NO;
    }
    
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.0f件",NumMoney];
    self.Subview_constrait_height.constant =40*model.count;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
