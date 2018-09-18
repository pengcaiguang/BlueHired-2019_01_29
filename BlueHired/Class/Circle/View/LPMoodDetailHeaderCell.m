//
//  LPMoodDetailHeaderCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMoodDetailHeaderCell.h"

@implementation LPMoodDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(LPGetMoodModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.data.userUrl] placeholderImage:[UIImage imageNamed:@"cricle_headimg_placeholder"]];
    self.userNameLabel.text = model.data.userName;
    self.gradingLabel.text = [NSString stringWithFormat:@"(%@)",model.data.grading];
    self.timeLabel.text = [NSString convertStringToTime:[model.data.time stringValue]];
    self.moodDetailsLabel.text = model.data.moodDetails;
    self.viewLabel.text = model.data.view ? [model.data.view stringValue] : @"0";
    
    for (UIView *view in self.imageBgView.subviews) {
        [view removeFromSuperview];
    }
    if (kStringIsEmpty(model.data.moodUrl)) {
        self.imageBgView.hidden = YES;
        self.imageBgView_constraint_height.constant = 0;
    }else{
        self.imageBgView.hidden = NO;
        NSArray *imageArray = [model.data.moodUrl componentsSeparatedByString:@";"];
        CGFloat imgw = (SCREEN_WIDTH-22 - 10)/3;
        
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake((imgw + 5)* (i%3), floor(i/3)*(imgw + 5), imgw, imgw);
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
            [self.imageBgView addSubview:imageView];
        }
        self.imageBgView_constraint_height.constant = ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
