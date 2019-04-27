//
//  LLPCustomerServiceCell.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LLPCustomerServiceCell.h"

@interface LLPCustomerServiceCell ()

@property(nonatomic,assign) BOOL isTouch;
@property(nonatomic,assign) BOOL isrefresh;

@property(nonatomic,strong) NSArray *textArray;
@property(nonatomic,strong) NSMutableArray <UILabel *>*LabelArray;

@end
@implementation LLPCustomerServiceCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.LabelArray = [[NSMutableArray alloc] init];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchV)];
//    [self.touchView addGestureRecognizer:tap];
}



- (void)setFrame:(CGRect)frame{
    frame.origin.x += 10;
    frame.origin.y += 5;
    frame.size.height -= 5;
    frame.size.width -= 20;
    [super setFrame:frame];
}


-(void)touchV{
    self.isTouch = !self.isTouch;
    self.arrowImgView.image = self.isTouch ? [UIImage imageNamed:@"arrow_up_gray"] : [UIImage imageNamed:@"arrow_down_gray"];
    
    CGFloat num = 0;
    if (self.isTouch) {
        UILabel *label = [self.labelBgView viewWithTag:self.textArray.count-1];
        [self.labelBgView layoutIfNeeded];

        num = label.frame.size.height+label.frame.origin.y;
    }else{
        if (self.textArray.count>1) {
            UILabel *label = [self.labelBgView viewWithTag:1];
            [self.labelBgView layoutIfNeeded];

            num = label.frame.size.height+label.frame.origin.y;

        }else{
            num = 70;
        }
    }
    
    if (num < 70) {
        num = 70;
    }
    
    self.view_constraint_height.constant = num -14;
    if (self.block) {
        self.block();
    }
}
-(void)setModel:(LPCustomerServiceDataListModel *)model{
    _model = model;
    self.labelNameLabel.text = model.labelName;
    [self.labelURLImgView sd_setImageWithURL:[NSURL URLWithString:model.labelUrl]];
    
    self.textArray = [[NSString stringWithFormat:@"%@",model.problemTitle] componentsSeparatedByString:@"#"];
    
    self.labelBgView.clipsToBounds = YES;
    [self.labelBgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self.LabelArray removeAllObjects];
    UILabel *subLabel = nil;
    for (int i = 0; i< self.textArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        [self.labelBgView addSubview:label];
//         if (subLabel) {
//            [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(10);
//                make.right.mas_equalTo(-35);
//                make.top.mas_equalTo(subLabel.mas_bottom).offset(10);
//            }];
//
//        }else{
//             [label mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(10);
//                make.right.mas_equalTo(-35);
//                make.top.mas_equalTo(self.labelBgView.mas_top).offset(10);;
//            }];
//        }
        
        
        
        UIView *lineview = [[UIView alloc] init];
        [self.labelBgView addSubview:lineview];
        [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
            make.top.mas_equalTo(label.mas_bottom).offset(0);
        }];
        lineview.backgroundColor =[UIColor colorWithHexString:@"#EEEEEE"];
        lineview.tag = i+10;
        
//        label.frame = CGRectMake(10, 35*i, SCREEN_WIDTH-100, 35);
        label.numberOfLines = 0;
        label.text = self.textArray[i];
        label.font = [UIFont systemFontOfSize:16];
        label.tag = i;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [label sizeThatFits:CGSizeMake(SCREEN_WIDTH-120, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
        if (size.height<40) {
            size.height = 40;
        }else{
            size.height +=10;
        }
        if (subLabel) {
            label.frame = CGRectMake(10, subLabel.frame.origin.y+subLabel.frame.size.height+5, SCREEN_WIDTH-120, size.height);

        }else{
            label.frame = CGRectMake(10, 5, SCREEN_WIDTH-120, size.height);
        }
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
        [label addGestureRecognizer:tap];
        subLabel = label;
        [self.LabelArray addObject:label];
    }
    
    [self.labelBgView layoutIfNeeded];

    CGFloat num = 0;
    if (!self.isTouch)
    {
        if (self.textArray.count>1) {
            UILabel *view = [self.LabelArray objectAtIndex:1];

             num =  view.frame.origin.y + view.frame.size.height;
         }else{
            num = 70;
        }
        

        
        UILabel *label = [self.labelBgView viewWithTag:self.textArray.count-1];
        [self.labelBgView layoutIfNeeded];
        
        num = label.frame.size.height+label.frame.origin.y+5;
        if (num < 81) {
            num = 81;
        }
        
        self.view_constraint_height.constant = num-14;
    }

    if (!self.isrefresh) {
        if (self.block) {
            self.block();
        }
        self.isrefresh = YES;
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
