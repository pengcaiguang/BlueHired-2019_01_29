//
//  LPWorkDetailHeadCell.m
//  BlueHired
//
//  Created by peng on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkDetailHeadCell.h"
#import "SDCycleScrollView.h"


@interface LPWorkDetailHeadCell ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation LPWorkDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.keyLabel.layer.masksToBounds = YES;
    self.keyLabel.layer.cornerRadius = 5.0;
    [self.imageBgView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageBgView);
    }];
    [self addShadowToView:self.BackView withColor:[UIColor colorWithHexString:@"#12598B"]];

}


/// 添加四边阴影效果
- (void)addShadowToView:(UIView *)theView withColor:(UIColor *)theColor {
    // 阴影颜色
    theView.layer.shadowColor = theColor.CGColor;
    // 阴影偏移，默认(0, -3)
    theView.layer.shadowOffset = CGSizeMake(0,3);
    // 阴影透明度，默认0
    theView.layer.shadowOpacity = 0.5;
    // 阴影半径，默认3
    theView.layer.shadowRadius = 3;
    theView.layer.cornerRadius = 4;
    theView.layer.masksToBounds = NO;
    
}

-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.data.mechanismName;
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.data.mechanismScore];
    self.postNameLabel.text = model.data.postName;
    if ([model.data.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",model.data.workMoney];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.data.wageRange];
    }
    if (model.data.status.integerValue == 1) {
        self.workTypeNameLabel.text = [NSString stringWithFormat:@"需%@：已招满",model.data.workTypeName];
    }else{
        self.workTypeNameLabel.text = [NSString stringWithFormat:@"需%@：%@人",model.data.workTypeName,model.data.maxNumber ? model.data.maxNumber : @"0"];
    }
    self.applyNumberLabel.text = [NSString stringWithFormat:@"已报名：%@人",model.data.applyNumber ? model.data.applyNumber : @"0"];
    
    if (model.data.key.length > 0) {
        self.keyLabel.text = model.data.key;
        CGRect rect = [model.data.key getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.keyLabel_constraint_width.constant = rect.size.width + 10;
    }else{
        self.keyLabel_constraint_width.constant = 0;
    }
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.workTypeNameLabel.text];
    NSRange range = [[str string] rangeOfString:[NSString stringWithFormat:@"%@人",model.data.maxNumber ? model.data.maxNumber : @"0"]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF6666"] range:range];
    self.workTypeNameLabel.attributedText = str;
    
    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:self.applyNumberLabel.text];
    NSRange range1 = [[str1 string] rangeOfString:[NSString stringWithFormat:@"%@人",model.data.applyNumber ? model.data.applyNumber : @"0"]];
    [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FF6666"] range:range1];
    self.applyNumberLabel.attributedText = str1;
    
    
    NSArray *imageArray = [model.data.imageList componentsSeparatedByString:@";"];
    self.cycleScrollView.imageURLStringsGroup = imageArray;
    
    NSString *strbackmoney = [self removeHTML2:model.data.reInstruction];
    if (strbackmoney.length>0) {
        self.BackMoneylabel.text = strbackmoney;
        CGFloat BackMoneyHeight = [self calculateRowHeight:strbackmoney fontSize:14 Width:SCREEN_WIDTH - 46];
        self.LayouConstraint_BackView_Height.constant = 124 + 56 +BackMoneyHeight;
    }else{
        self.LayouConstraint_BackView_Height.constant = 124;
    }


    [self.KeyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    NSArray * tagArr = [model.data.key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    for (int i= 0; i<tagArr.count; i++) {
        
        CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-23-23, 17)];
        if (tagBtnX+tagTextSize.width+30 > SCREEN_WIDTH-23-23) {
            
            tagBtnX = 0;
            tagBtnY += 17+8;
        }
        UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.tag = 100+i;
        tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+16, 17);
        [tagBtn setTitle:tagArr[i] forState:UIControlStateNormal];
        [tagBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tagBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        tagBtn.layer.cornerRadius = 5;
        tagBtn.layer.masksToBounds = YES;
        tagBtn.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self.KeyView addSubview:tagBtn];
        
        tagBtnX = CGRectGetMaxX(tagBtn.frame)+14;
    }
//    self.KeyView.backgroundColor = [UIColor redColor];
    self.LayoutConstraint_KeyView.constant  = tagBtnY+17;
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark lazy

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize Width:(CGFloat) W
{
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paraStyle01};
    /*计算高度要先指定宽度*/
    CGRect rect = [string boundingRectWithSize:CGSizeMake(W, 0) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return ceil(rect.size.height);
    
}

- (NSString *)removeHTML2:(NSString *)html{
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@"\n"];
    return plainText;
}

@end
