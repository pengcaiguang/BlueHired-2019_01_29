//
//  LPCollectionEssayCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionEssayCell.h"

@implementation LPCollectionEssayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.hidden = YES;
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
}

-(void)setModel:(LPEssayCollectionDataModel *)model{
    _model = model;
    self.essayNameLabel.text = model.essayName;
    NSArray *imageArray = [model.essayUrl componentsSeparatedByString:@";"];
    [self.essayUrlImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]]];
    self.essayAuthorLabel.text = model.essayAuthor;
    
    self.viewLabel.text = model.view ? [model.view stringValue] : @"0";
    self.commentTotalLabel.text = model.commentTotal ? [model.commentTotal stringValue] : @"0";
    self.praiseTotalLabel.text = model.praiseTotal ? [model.praiseTotal stringValue] : @"0";
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
