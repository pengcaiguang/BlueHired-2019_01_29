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
 
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0,0, LENGTH_SIZE(85), LENGTH_SIZE(13)) isTouch:YES];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;
    starRateView.delegate = self;
    self.starRateView = starRateView;
    [self.mechanismScoreView addSubview:starRateView];
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = LENGTH_SIZE(3.0);
    self.lendTypeLabel.layer.borderWidth = LENGTH_SIZE(0.5);
    self.lendTypeLabel.layer.borderColor = [UIColor baseColor].CGColor;
    
    self.reMoneyLabel.layer.cornerRadius = LENGTH_SIZE(10.5);
    self.reMoneyLabel.layer.borderWidth = LENGTH_SIZE(1);
    self.reMoneyLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFD291"].CGColor;
    self.AgeLabel.layer.cornerRadius = 2;
    self.AgeLabel.layer.borderColor = [UIColor baseColor].CGColor;
    self.AgeLabel.layer.borderWidth = 0.5;
    self.AgeLabel.textColor = [UIColor baseColor];
}



- (void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
    
    if (self.CellType == 0) {
        [self.lendTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(LENGTH_SIZE(45));
            make.height.mas_offset(LENGTH_SIZE(17));
            make.left.equalTo(self.mechanismNameLabel.mas_left);
            make.top.equalTo(self.applyNumberLabel.mas_bottom).offset(LENGTH_SIZE(8));
        }];
        self.keyLabel.hidden = NO;
        self.AgeLabel.hidden = NO;
        
        [self.mechanismScoreImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.centerY.equalTo(self.lendTypeLabel);
        }];
        
    }else if (self.CellType == 1){
        [self.lendTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(LENGTH_SIZE(45));
            make.height.mas_offset(LENGTH_SIZE(17));
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.centerY.equalTo(self.applyNumberLabel);
        }];
        self.keyLabel.hidden = YES;
        self.AgeLabel.hidden = YES;
        
        [self.mechanismScoreImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.centerY.equalTo(self.wageRangeLabel);
        }];
    }
    
    if (model.age.length && self.CellType == 0) {
        self.AgeLabel.text = [NSString stringWithFormat:@" %@ ", model.age];
        self.AgeLabel.hidden = NO;
    }else{
        self.AgeLabel.hidden = YES;
    }
    
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = ![model.lendType integerValue];
    self.starRateView.currentScore = model.mechanismScore.floatValue/2;
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%.1f分",model.mechanismScore.floatValue];
    
    if (model.lendType.integerValue) {
        self.lendTypeLabel_constraint_Width.constant = LENGTH_SIZE(50);
    }else{
        self.lendTypeLabel_constraint_Width.constant = LENGTH_SIZE(0);
    }
    
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(model.workMoney)];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
     }
    
    self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名%@人",model.maxNumber,model.applyNumber ? model.applyNumber : @"0"];
 
    self.maxNumberLabel.text = [NSString stringWithFormat:@"%@",model.workTypeName];
    if (model.status.integerValue == 1) {
        self.applyNumberLabel.text = [NSString stringWithFormat:@"招%@人",model.maxNumber];
        self.isWorkers.hidden = NO;
    }else{
    
        self.isWorkers.hidden = YES;
    }
    
    if (model.reMoney.integerValue>0) {
        [self.reMoneyLabel setTitle:[NSString stringWithFormat:@"    %ld   ",
                                     (long)model.reMoney.integerValue]
                           forState:UIControlStateNormal];

        CGFloat ReMoneyWidth = [LPTools widthForString:[NSString stringWithFormat:@"    %ld   ",
                                                        (long)model.reMoney.integerValue] fontSize:FontSize(16) andHeight:LENGTH_SIZE(21)];
         self.keyLabel_constraint_right.constant = LENGTH_SIZE(13.0+ReMoneyWidth+10);
        
        self.reMoneyLabel.hidden = NO;
        self.reMoneyImage.hidden = NO;
        
        if (self.CellType == 0) {
            [self.wageRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(LENGTH_SIZE(-13));
                make.centerY.equalTo(self.applyNumberLabel);
            }];
        }else if (self.CellType == 1){
            [self.wageRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mechanismNameLabel.mas_left);
                make.top.equalTo(self.applyNumberLabel.mas_bottom).offset(LENGTH_SIZE(8));
            }];
        }
        
       
        
    }else{
        self.reMoneyLabel.hidden = YES;
        self.reMoneyImage.hidden = YES;
        self.keyLabel_constraint_right.constant = LENGTH_SIZE(13);
        
        if (self.CellType == 0) {
            [self.wageRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(LENGTH_SIZE(-13));
                make.centerY.equalTo(self.maxNumberLabel);
            }];
        }else if (self.CellType == 1){
            [self.wageRangeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mechanismNameLabel.mas_left);
                make.top.equalTo(self.applyNumberLabel.mas_bottom).offset(LENGTH_SIZE(8));
            }];
        }

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
     model.key = [model.key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

        NSArray * tagArr = [model.key componentsSeparatedByString:@"|"];
        CGFloat tagBtnX = 0;
        CGFloat tagBtnY = 0;
    if (model.key.length>0) {
        for (int i= 0; i<tagArr.count; i++) {
            CGSize tagTextSize = [[NSString stringWithFormat:@"%@",tagArr[i]] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH - LENGTH_SIZE(153) , LENGTH_SIZE(17))];
            if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH - LENGTH_SIZE(153)) {
                tagBtnX = 0;
                tagBtnY += LENGTH_SIZE(17)+8;
                break;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = 100+i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+LENGTH_SIZE(8), LENGTH_SIZE(17));
            [tagBtn setTitle:tagArr[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
            tagBtn.layer.cornerRadius = LENGTH_SIZE(2);
            tagBtn.layer.masksToBounds = YES;
            tagBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
            [self.keyLabel addSubview:tagBtn];
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+LENGTH_SIZE(4);
            
        }
        self.keyLabel_constraint_Height.constant = LENGTH_SIZE(17);

    }else{
        self.keyLabel_constraint_Height.constant = 0;
    }
    
}

-(void)setIscornerRadius:(BOOL )iscornerRadius{
    _iscornerRadius = iscornerRadius;
    if (iscornerRadius) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
