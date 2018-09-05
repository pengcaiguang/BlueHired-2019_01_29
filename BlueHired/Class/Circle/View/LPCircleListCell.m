//
//  LPCircleListCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleListCell.h"

@implementation LPCircleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = 20;
}

-(void)setModel:(LPMoodListDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"cricle_headimg_placeholder"]];
    self.userNameLabel.text = model.userName;
    self.gradingLabel.text = [NSString stringWithFormat:@"(%@)",model.grading];
    self.timeLabel.text = [NSString convertStringToTime:[model.time stringValue]];
    self.moodDetailsLabel.text = model.moodDetails;
    self.viewLabel.text = model.view ? [model.view stringValue] : @"0";
    self.praiseTotalLabel.text = model.praiseTotal ? [model.praiseTotal stringValue] : @"0";
    self.commentTotalLabel.text = model.commentTotal ? [model.commentTotal stringValue] : @"0";
    
    if (kStringIsEmpty(model.moodUrl)) {
        self.imageBgView.hidden = YES;
        self.imageBgView_constraint_height.constant = 0;
    }else{
        self.imageBgView.hidden = NO;
        NSArray *imageArray = [model.moodUrl componentsSeparatedByString:@";"];
        CGFloat imgw = (SCREEN_WIDTH-70 - 10)/3;
        
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
