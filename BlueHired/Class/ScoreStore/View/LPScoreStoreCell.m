//
//  LPScoreStoreCell.m
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreCell.h"

@implementation LPScoreStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commodityImage.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
    self.commodityImage.layer.borderWidth = LENGTH_SIZE(1);
    
}

- (void)setModel:(LPProductListDataModel *)model{
    _model = model;
    self.commodityName.text = model.name;
    
    NSArray *imageArr = [model.pic componentsSeparatedByString:@","];
    
    if (imageArr.count > 0 ) {
        [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:imageArr[0]]
                                    placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
    }

    self.commodityUnit.text = model.price;
}

@end
