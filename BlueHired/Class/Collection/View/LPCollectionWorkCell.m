//
//  LPCollectionWorkCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionWorkCell.h"

@implementation LPCollectionWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization codeself.postNameLabel.layer.masksToBounds = YES;
    self.postNameLabel.layer.cornerRadius = 3.0;
    self.postNameLabel.layer.borderWidth = 0.5;
    self.postNameLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
    self.lendTypeLabel.layer.masksToBounds = YES;
    self.lendTypeLabel.layer.cornerRadius = 3.0;
    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.borderColor = [UIColor colorWithHexString:@"#0CAFFF"].CGColor;
    
    self.selectButton.hidden = YES;
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
}

-(void)setModel:(LPWorkCollectionDataModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.mechanismName;
    self.lendTypeLabel.hidden = !model.lendType;
    
    [self.mechanismUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.mechanismUrl]];
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.mechanismScore];
    
    self.keyLabel.text = model.key;
    self.postNameLabel.text = model.postName;
    if ([model.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.wageRange];
    }
    if (model.isApply) {
        if ([model.isApply integerValue] == 0) {
            self.isApplyLabel.hidden = NO;
        }else{
            self.isApplyLabel.hidden = YES;
        }
    }else{
        self.isApplyLabel.hidden = YES;
    }
    
    if ([model.status integerValue] == 0) {
        self.workTypeNameLabel.text = [NSString stringWithFormat:@"需%@%@人",model.workTypeName,model.maxNumber];
        self.workTypeNameLabel.textColor = [UIColor colorWithHexString:@"#444444"];
    }else{
        self.workTypeNameLabel.text = @"已招满";
        self.workTypeNameLabel.textColor = [UIColor colorWithHexString:@"#FF6666"];
    }
    
    self.applyNumberLabel.text = [NSString stringWithFormat:@"已报名：%@人",model.applyNumber ? model.applyNumber : @"0"];
    
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
