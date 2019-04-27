//
//  LPMain2Cell.m
//  BlueHired
//
//  Created by iMac on 2019/1/4.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMain2Cell.h"

@implementation LPMain2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    self.mechanismScoreView= [[XHStarRateView alloc] init];
//    self.mechanismScoreView.isAnimation = YES;
//    self.mechanismScoreView.rateStyle = HalfStar;
//    self.mechanismScoreView.delegate = self;
//    self.mechanismScoreView.backgroundColor = [UIColor redColor];
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0,0, 70, 12)];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.delegate = self;
    self.starRateView = starRateView;
    [self.mechanismScoreView addSubview:starRateView];
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor colorWithHexString:@"#FF6060"].CGColor;
}

- (void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = ![model.lendType integerValue];
    self.starRateView.currentScore = model.mechanismScore.floatValue/2;
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.mechanismScore];
    self.keyLabel.text = model.key;
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    [self.reMoneyLabel setTitle:[NSString stringWithFormat:@"返%@",model.reMoney] forState:UIControlStateNormal];
    self.maxNumberLabel.text = [NSString stringWithFormat:@"需%@%@人",model.workTypeName,model.maxNumber];
    if (model.status.integerValue == 1) {
        self.maxNumberLabel.text = @"已招满";
        self.maxNumberLabel.textColor = [UIColor colorWithHexString:@"#FF6060"];
    }else{
        self.maxNumberLabel.text = [NSString stringWithFormat:@"需%@%@人",model.workTypeName,model.maxNumber];
        self.maxNumberLabel.textColor = [UIColor blackColor];
    }
    self.applyNumberLabel.text = [NSString stringWithFormat:@"已报名:%@人",model.applyNumber ? model.applyNumber : @"0"];

    
    if (model.isApply && AlreadyLogin) {
        if ([model.isApply integerValue] == 0) {
            self.isApplyLabel.hidden = NO;
        }else{
            self.isApplyLabel.hidden = YES;
        }
    }else{
        self.isApplyLabel.hidden = YES;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
