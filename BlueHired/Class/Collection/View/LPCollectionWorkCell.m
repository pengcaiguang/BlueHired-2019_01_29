//
//  LPCollectionWorkCell.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionWorkCell.h"

@implementation LPCollectionWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0,0,  LENGTH_SIZE(85), LENGTH_SIZE(13)) isTouch:YES];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.delegate = self;
    self.starRateView = starRateView;
    [self.mechanismScoreView addSubview:starRateView];
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor baseColor].CGColor;

    self.selectButton.hidden = YES;
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
    
    self.reMoneyLabel.layer.cornerRadius = 10.5;
    self.reMoneyLabel.layer.borderWidth = 1;
    self.reMoneyLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFD291"].CGColor;

}

-(void)setModel:(LPWorkCollectionDataModel *)model{
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
        [self.reMoneyLabel setTitle:[NSString stringWithFormat:@"    %ld   ",
                                     (long)model.reMoney.integerValue]
                           forState:UIControlStateNormal];
        
        CGFloat ReMoneyWidth = [LPTools widthForString:[NSString stringWithFormat:@"    %ld   ",
                                                        (long)model.reMoney.integerValue] fontSize:16 andHeight:21];
        self.keyLabel_constraint_right.constant = 13.0+ReMoneyWidth+10;
        
        self.reMoneyLabel.hidden = NO;
        self.reMoneyImage.hidden = NO;
    }else{
        self.reMoneyLabel.hidden = YES;
        self.reMoneyImage.hidden = YES;
        self.keyLabel_constraint_right.constant = 13.0;
    }
    
    self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名:%@人",model.maxNumber,model.applyNumber ? model.applyNumber : @"0"];

    self.postNameLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    if (model.status.integerValue == 1) {
        self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人",model.maxNumber];

        self.isWorkers.hidden = NO;
    }else{
 
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
- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.isApplyLabel.backgroundColor = [UIColor colorWithHexString:@"#000000"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.isApplyLabel.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    // Configure the view for the selected state
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.selectButton.hidden = NO;
        self.label_contraint_width.constant = 60;
    }else{
        self.selectButton.hidden = YES;
        self.label_contraint_width.constant = 13;
    }
}
-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}
@end
