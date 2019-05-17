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
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0,0, 100, 17) isTouch:YES];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.delegate = self;
    self.starRateView = starRateView;
    [self.mechanismScoreView addSubview:starRateView];
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor baseColor].CGColor;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subview in self.contentView.superview.subviews) {
        if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
            subview.hidden = NO;
        }
    }
}


- (void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = ![model.lendType integerValue];
    self.starRateView.currentScore = model.mechanismScore.floatValue/2;
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.mechanismScore];
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    if (model.reMoney.integerValue>0) {
        [self.reMoneyLabel setTitle:[NSString stringWithFormat:@"返%ld",(long)model.reMoney.integerValue] forState:UIControlStateNormal];
        self.reMoneyLabel.hidden = NO;
        CGSize tagTextSize = [self.reMoneyLabel.currentTitle sizeWithFont:[UIFont systemFontOfSize:11] maxSize:CGSizeMake(SCREEN_WIDTH-230, 17)];
        self.keyLabel_constraint_right.constant = 13.0+tagTextSize.width+10;
    }else{
        self.reMoneyLabel.hidden = YES;
        self.keyLabel_constraint_right.constant = 13.0;
    }
    
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    if (model.status.integerValue == 1) {
//        self.maxNumberLabel.text = @"已招满";
        self.isWorkers.hidden = NO;
    }else{
//        self.maxNumberLabel.text = [NSString stringWithFormat:@"需%@%@人",model.workTypeName,model.maxNumber];
        self.isWorkers.hidden = YES;
    }
    
    if (model.isApply && AlreadyLogin) {
        if ([model.isApply integerValue] == 0) {
            self.isApplyLabel.hidden = NO;
        }else{
            self.isApplyLabel.hidden = YES;
        }
    }else{
        self.isApplyLabel.hidden = YES;
    }
    
    
    
    self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名:%@人",model.maxNumber,model.applyNumber ? model.applyNumber : @"0"];
    
    
    self.keyLabel.text = @" ";
    [self.keyLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //动态计算key标签宽度
        NSArray * tagArr = [model.key componentsSeparatedByString:@"|"];
        CGFloat tagBtnX = 0;
//        CGFloat tagBtnY = 0;
        for (int i= 0; i<tagArr.count; i++) {
            CGSize tagTextSize = [[NSString stringWithFormat:@"%@",tagArr[i]] sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-116, 17)];
            if (tagBtnX+tagTextSize.width < SCREEN_WIDTH-116) {
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tagBtn.tag = 100+i;
                tagBtn.frame = CGRectMake(tagBtnX, 0, tagTextSize.width+8, 17);
                [tagBtn setTitle:tagArr[i] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
                tagBtn.titleLabel.font = [UIFont systemFontOfSize:11];
                tagBtn.layer.cornerRadius = 2;
                tagBtn.layer.masksToBounds = YES;
                tagBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
                [self.keyLabel addSubview:tagBtn];
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+4;
                
            }
     
        }

 
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
