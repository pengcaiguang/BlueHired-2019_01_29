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
 
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = LENGTH_SIZE(3.0);
    self.lendTypeLabel.layer.borderWidth = LENGTH_SIZE(0.5);
    self.lendTypeLabel.layer.borderColor = [UIColor baseColor].CGColor;
 
}



- (void)setModel:(LPWorklistDataWorkListModel *)model{
    _model = model;
 
    self.mechanismNameLabel.text = model.mechanismName;
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    if ([model.lendType integerValue] == 1) {
        self.ayoutConstraint_Lend_Right.constant = LENGTH_SIZE(8);
        self.ayoutConstraint_Lend_width.constant = LENGTH_SIZE(38);
    }else{
        self.ayoutConstraint_Lend_Right.constant = LENGTH_SIZE(0);
        self.ayoutConstraint_Lend_width.constant = LENGTH_SIZE(0);
    }
    
    if (model.age.length) {
        NSString *WorkTypeNameStr = [NSString stringWithFormat:@"%@  %@",model.workTypeName,model.age];
        NSMutableAttributedString *WorkTypeString = [[NSMutableAttributedString alloc] initWithString:WorkTypeNameStr];
        [WorkTypeString addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"],
                                        NSFontAttributeName: FONT_SIZE(11),}
                                range:[WorkTypeNameStr rangeOfString:model.age]];
        self.maxNumberLabel.attributedText = WorkTypeString;
    }else{
        self.maxNumberLabel.text = model.workTypeName;
    }
    
    if (model.status.integerValue == 1) {
         self.isWorkers.hidden = NO;
    }else{
        self.isWorkers.hidden = YES;
    }
    
    if ([model.postType integerValue] == 1) {
        if (model.addWorkMoney.floatValue>0.0 && model.reStatus.integerValue == 1 && model.reTime.integerValue>0) {
            NSString *WmonryStr = [NSString stringWithFormat:@"%@元/时",reviseString(model.workMoney)];
            NSString *addWorkMoneyStr = [NSString stringWithFormat:@"返%.1f元/时",model.addWorkMoney.floatValue];

            NSString *str = [NSString stringWithFormat:@"%@  |  %@",WmonryStr,addWorkMoneyStr];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#CCCCCC"],NSFontAttributeName: FONT_SIZE(13)} range:[str rangeOfString:@"|"]];
 
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF8F3C"]} range:[str rangeOfString:addWorkMoneyStr]];
            self.wageRangeLabel.attributedText = string;
        }else{
           self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(model.workMoney)];
        }
    }else{
        if (model.reMoney.integerValue>0 && model.reStatus.integerValue == 1 && model.reTime.integerValue>0) {
             NSString *WmonryStr = [NSString stringWithFormat:@"%@元/月",model.wageRange];
            NSString *addWorkMoneyStr = [NSString stringWithFormat:@"返%@元",model.reMoney];
            NSString *str = [NSString stringWithFormat:@"%@  |  %@",WmonryStr,addWorkMoneyStr];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:str];
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#CCCCCC"],NSFontAttributeName: FONT_SIZE(13)} range:[str rangeOfString:@"|"]];
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF8F3C"]} range:[str rangeOfString:addWorkMoneyStr]];
            self.wageRangeLabel.attributedText = string;
        }else{
            self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
        }
    }
      
}

- (void)setCmodel:(LPWorkCollectionDataModel *)Cmodel{
    _Cmodel = Cmodel;
    LPWorklistDataWorkListModel *m = [LPWorklistDataWorkListModel mj_objectWithKeyValues:[Cmodel mj_JSONObject]];
    [self setModel:m]; 
}


-(void)setIscornerRadius:(BOOL )iscornerRadius{
    _iscornerRadius = iscornerRadius;
    if (iscornerRadius) {
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }

}

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.Cmodel);
    }
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.selectButton.hidden = NO;
        self.ayoutConstraint_WorkImage_left.constant = LENGTH_SIZE(60);
    }else{
        self.selectButton.hidden = YES;
        self.ayoutConstraint_WorkImage_left.constant = LENGTH_SIZE(13);
    }
}
-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
