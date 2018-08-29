//
//  LPInformationSingleCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSingleCell.h"

@implementation LPInformationSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LPEssaylistDataModel *)model{
    _model = model;
    self.essayNameLabel.text = model.essayName;
    [self.essayUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.essayUrl]];
    self.essayAuthorLabel.text = model.essayAuthor;
    self.viewLabel.text = model.view;
    self.commentTotalLabel.text = model.commentTotal;
    self.praiseTotalLabel.text = model.praiseTotal;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
