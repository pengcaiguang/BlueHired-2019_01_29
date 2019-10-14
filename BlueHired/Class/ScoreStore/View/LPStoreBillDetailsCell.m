//
//  LPStoreBillDetailsCell.m
//  BlueHired
//
//  Created by iMac on 2019/10/9.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPStoreBillDetailsCell.h"

@implementation LPStoreBillDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commodityImage.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
    self.commodityImage.layer.borderWidth = LENGTH_SIZE(1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPOrderGenerateDataItemModel *)model{
    _model = model;
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:model.productPic]
                                placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
    self.commodityName.text = model.productName;
    NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:model.sp1],
                                                                      [LPTools isNullToString:model.sp2],
                                                                      [LPTools isNullToString:model.sp3]]];
    [SizeArr removeObject:@""];
    
    self.commoditySize.text = [NSString stringWithFormat:@"规格:%@",
                               [SizeArr componentsJoinedByString:@","]];
    self.commodityUnit.text = [NSString stringWithFormat:@"单价:%@积分  数量：x%@",model.productPrice,model.productQuantity];
    self.SumUnit.text = [NSString stringWithFormat:@"%ld积分",model.productPrice.integerValue*model.productQuantity.integerValue];
}

@end
