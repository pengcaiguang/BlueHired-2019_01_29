//
//  LPInfoCell.m
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoCell.h"
#import "NSDate+HXExtension.h"

@implementation LPInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    
    self.RedLabel.layer.cornerRadius = LENGTH_SIZE(5);
    self.RedLabel.layer.borderWidth = LENGTH_SIZE(1);
    self.RedLabel.layer.borderColor = [UIColor whiteColor].CGColor;
}

-(void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    if ([model.status integerValue] == 0) {
        self.RedLabel.hidden = NO;
    }else{
        self.RedLabel.hidden = YES;
    }
    self.informationTitleLabel.text = model.informationTitle;
    self.informationDetailsLabel .text = model.informationDetails;
    self.timeLabel.text = [NSString timeStringWithTimeInterval:[model.time stringValue]];
    
    self.Time_contraint_width.constant = [LPTools widthForString:self.timeLabel.text fontSize:FontSize(11) andHeight:LENGTH_SIZE(20)] + LENGTH_SIZE(6);
    if ([model.informationTitle isEqualToString:@"入职报名"] ||
        [model.informationTitle isEqualToString:@"企业推荐"]) {
        self.statusImgView.image = [UIImage imageNamed:@"news_person"];
    }else{
        self.statusImgView.image = [UIImage imageNamed:@"news_system"];
    }
    
}

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.img_contraint_width.constant = LENGTH_SIZE(60);
    }else{
        self.img_contraint_width.constant = LENGTH_SIZE(13);
    }
}
-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
