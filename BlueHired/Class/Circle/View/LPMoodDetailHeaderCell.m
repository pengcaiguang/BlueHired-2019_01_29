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
    self.userConcernButton.layer.masksToBounds = YES;
    self.userConcernButton.layer.cornerRadius = 10.0;
    [self.userConcernButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.userConcernButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.userConcernButton setImage:[UIImage imageNamed:@"user_concern_normal"] forState:UIControlStateNormal];
    [self.userConcernButton setImage:[UIImage imageNamed:@"user_concern_selected"] forState:UIControlStateSelected];
    [self.userConcernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.userConcernButton setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateSelected];
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
    
    if ([model.data.isConcern integerValue] == 0) {
        self.isUserConcern = YES;
    }else{
        self.isUserConcern = NO;
    }
}

-(void)setIsUserConcern:(BOOL)isUserConcern{
    _isUserConcern = isUserConcern;
    if (isUserConcern) {
        CGRect rect = [@"已关注" getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.userConcern_constraint_width.constant = rect.size.width + 10 + 15;
        self.userConcernButton.selected = YES;
        self.userConcernButton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }else{
        CGRect rect = [@"关注" getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.userConcern_constraint_width.constant = rect.size.width + 10 + 15;
        self.userConcernButton.selected = NO;
        self.userConcernButton.backgroundColor = [UIColor baseColor];
    }
}

- (IBAction)touchUserConcernButton:(UIButton *)sender {
    if (self.userConcernBlock) {
        self.userConcernBlock();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
