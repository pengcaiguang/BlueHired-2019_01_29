//
//  LPPieceListCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/14.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPPieceListCell.h"

@implementation LPPieceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(LPProRecirdDataModel *)model{
    _model = model;
    self.Name.text = [NSString stringWithFormat:@"%ld.%@",self.row+1,model.productName];
    self.Unit.text = [NSString stringWithFormat:@"%.2f",model.productPrice.floatValue];
    self.Number.text = [NSString stringWithFormat:@"%ld",(long)model.productNum.integerValue];
    self.Money.text = [NSString stringWithFormat:@"%.2f",model.totalPrice.floatValue];

    
}

@end
