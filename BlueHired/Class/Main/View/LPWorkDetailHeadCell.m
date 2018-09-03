//
//  LPWorkDetailHeadCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
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
}

-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    self.mechanismNameLabel.text = model.data.mechanismName;
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%@分",model.data.mechanismScore];
    self.postNameLabel.text = model.data.postName;
    self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.data.wageRange];
    
    self.workTypeNameLabel.text = [NSString stringWithFormat:@"需%@：%@人",model.data.workTypeName,model.data.maxNumber ? model.data.maxNumber : @"0"];
    self.applyNumberLabel.text = [NSString stringWithFormat:@"已报名：%@人",model.data.applyNumber ? model.data.applyNumber : @"0"];
    
    self.keyLabel.text = model.data.key;
    CGRect rect = [model.data.key getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
    self.keyLabel_constraint_width.constant = rect.size.width + 10;
    
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

}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
}

#pragma mark lazy

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
