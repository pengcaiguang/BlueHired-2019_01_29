//
//  LPCollectionEssayCell.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionEssayCell.h"

@implementation LPCollectionEssayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.hidden = YES;
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    self.essayUrlImageView.layer.cornerRadius = LENGTH_SIZE(6);
}

-(void)setModel:(LPEssayCollectionDataModel *)model{
    _model = model;
    self.essayNameLabel.text = model.essayName;
    NSArray *imageArray = [model.essayUrl componentsSeparatedByString:@";"];
    [self.essayUrlImageView yy_setImageWithURL:[NSURL URLWithString:imageArray[0]]
    placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#E0E0E0"]]];

    self.Time.text = [NSString stringWithFormat:@"发布时间：%@",[NSString convertStringToTime:model.time]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}
-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.selectButton.hidden = NO;
        self.label_contraint_width.constant = LENGTH_SIZE(60) ;
    }else{
        self.selectButton.hidden = YES;
        self.label_contraint_width.constant = LENGTH_SIZE(13);
    }
}
-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}
@end
