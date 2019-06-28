//
//  LPInfoMationVideoCell.m
//  BlueHired
//
//  Created by iMac on 2018/11/20.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInfoMationVideoCell.h"

@implementation LPInfoMationVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = LENGTH_SIZE(9.5);
    self.TitleBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
 }

- (void)setModel:(LPVideoListDataModel *)model{
    _model = model;
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.videoImage] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.labelUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.Videotittle.text = [LPTools isNullToString:model.videoName];
    if (model.view.integerValue > 10000) {
        self.commentTotal.text = [NSString stringWithFormat:@"%.1fw",model.view.integerValue/10000.0];
    }else{
        self.commentTotal.text = [LPTools isNullToString:model.view];
    }

}

@end
