//
//  LLPCustomerServiceCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LLPCustomerServiceCell.h"

@interface LLPCustomerServiceCell ()

@property(nonatomic,assign) BOOL isTouch;

@property(nonatomic,strong) NSArray *textArray;

@end
@implementation LLPCustomerServiceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchV)];
    [self.touchView addGestureRecognizer:tap];
}
-(void)touchV{
    self.isTouch = !self.isTouch;
    self.arrowImgView.image = self.isTouch ? [UIImage imageNamed:@"arrow_up_gray"] : [UIImage imageNamed:@"arrow_down_gray"];
    
    CGFloat num = 0;
    if (self.isTouch) {
        num = self.textArray.count * 35;
    }else{
        num = 70;
    }
    if (num < 70) {
        num = 70;
    }
    self.view_constraint_height.constant = num;
    if (self.block) {
        self.block();
    }
}
-(void)setModel:(LPCustomerServiceDataListModel *)model{
    _model = model;
    self.labelNameLabel.text = model.labelName;
    [self.labelURLImgView sd_setImageWithURL:[NSURL URLWithString:model.labelUrl]];
    
    self.textArray = [model.problemTitle componentsSeparatedByString:@"#"];
    
    self.labelBgView.clipsToBounds = YES;
    for (UILabel *label in self.labelBgView.subviews) {
        [label removeFromSuperview];
    }
    for (int i = 0; i< self.textArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(10, 35*i, SCREEN_WIDTH-100, 35);
        label.text = self.textArray[i];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = i;
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
        [label addGestureRecognizer:tap];
        [self.labelBgView addSubview:label];
    }
}

-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    NSLog(@"%ld",index);
    if (self.touchBlock) {
        self.touchBlock(self.textArray[index]);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
