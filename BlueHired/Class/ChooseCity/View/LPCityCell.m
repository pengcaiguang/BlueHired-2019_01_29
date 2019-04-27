//
//  LPCityCell.m
//  BlueHired
//
//  Created by peng on 2018/9/4.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCityCell.h"

@implementation LPCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setArray:(NSArray<LPCityModel *> *)array{
    _array = array;
    CGFloat w = (SCREEN_WIDTH-10*7)/3;
    for (int i = 0; i < array.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(i%3 * w + (10*(2*(i%3)+1)), floor(i/3)*40 + 20, w, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitle:array[i].c_name forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btn];
    }
}
-(void)touchButton:(UIButton *)button{
    if (self.block) {
        self.block(self.array[button.tag]);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
