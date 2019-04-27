//
//  LPInfoCell.m
//  BlueHired
//
//  Created by peng on 2018/9/21.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoCell.h"

@implementation LPInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
}

-(void)setModel:(LPInfoListDataModel *)model{
    _model = model;
    if ([model.status integerValue] == 0) {
        self.statusImgView.image = [UIImage imageNamed:@"info_unread"];
    }else{
        self.statusImgView.image = [UIImage imageNamed:@"info_read"];
    }
    self.informationTitleLabel.text = model.informationTitle;
    self.informationDetailsLabel .text = model.informationDetails;
    self.timeLabel.text = [NSString convertStringToTime:[model.time stringValue]];
}

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.img_contraint_width.constant = 60;
    }else{
        self.img_contraint_width.constant = 13;
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
