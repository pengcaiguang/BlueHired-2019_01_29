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

@end
