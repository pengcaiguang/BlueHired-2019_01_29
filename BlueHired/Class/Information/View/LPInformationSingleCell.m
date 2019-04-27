//
//  LPInformationSingleCell.m
//  BlueHired
//
//  Created by peng on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationSingleCell.h"

@implementation LPInformationSingleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.essayUrlImageView.layer.cornerRadius = 6;
}
-(void)setModel:(LPEssaylistDataModel *)model{
    _model = model;
    self.essayNameLabel.text = model.essayName;
    NSArray *imageArray = [model.essayUrl componentsSeparatedByString:@";"];
    if (imageArray.count) {
        [self.essayUrlImageView sd_setImageWithURL:[NSURL URLWithString:imageArray[0]] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    }
    
    
    self.essayAuthorLabel.text = model.essayAuthor;
    
    if (model.view.integerValue>10000) {
        self.viewLabel.text = [NSString stringWithFormat:@"%.1fw", model.view.integerValue/10000.0] ;
     }else{
        self.viewLabel.text = model.view ? [model.view stringValue] : @"0";
     }
    
    self.commentTotalLabel.text = model.commentTotal ? [model.commentTotal stringValue] : @"0";
    self.praiseTotalLabel.text = model.praiseTotal ? [model.praiseTotal stringValue] : @"0";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
