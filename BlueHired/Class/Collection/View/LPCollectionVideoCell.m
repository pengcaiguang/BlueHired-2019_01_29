//
//  LPCollectionVideoCell.m
//  BlueHired
//
//  Created by iMac on 2018/12/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionVideoCell.h"

@implementation LPCollectionVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImage.layer.cornerRadius = 9.5;
    self.TitleBackView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    self.selectButton.hidden = YES;
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_normal"] forState:UIControlStateNormal];
    [self.selectButton setImage:[UIImage imageNamed:@"add_ record_selected"] forState:UIControlStateSelected];
}


- (void)setModel:(LPVideoCollectionDataModel *)model{
    _model = model;
    [self.videoImage sd_setImageWithURL:[NSURL URLWithString:model.videoImage] placeholderImage:[UIImage imageNamed:@"NoImage"]];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.labelUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.Videotittle.text = [LPTools isNullToString:model.videoName];
    self.commentTotal.text = [LPTools isNullToString:model.view];
}

- (IBAction)touchSelectButton:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}

-(void)setSelectStatus:(BOOL)selectStatus{
    if (selectStatus) {
        self.selectButton.hidden = NO;
        self.label_contraint_width.constant = 60;
    }else{
        self.selectButton.hidden = YES;
        self.label_contraint_width.constant = 2;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
