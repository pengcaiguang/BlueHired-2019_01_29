//
//  LPHXMessageTimeCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/1.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHXMessageTimeCell.h"

@implementation LPHXMessageTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.MessageTime.layer.cornerRadius = LENGTH_SIZE(9);
    self.contentView.backgroundColor = [UIColor clearColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
