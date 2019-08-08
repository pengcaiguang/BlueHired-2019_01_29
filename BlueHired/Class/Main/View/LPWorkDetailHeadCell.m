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
    self.keyLabel.layer.cornerRadius = LENGTH_SIZE(5.0) ;
    [self.imageBgView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.imageBgView);
    }];
    self.cycleScrollView.delegate = self;
    
//    self.lendTypeLabel.layer.borderColor = [UIColor baseColor].CGColor;
//    self.lendTypeLabel.layer.borderWidth = 0.5;
    self.lendTypeLabel.layer.cornerRadius = 2;
    self.lendTypeLabel.backgroundColor = [UIColor baseColor];
    [self.lendTypeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self addShadowToView:self.BackView withColor:[UIColor colorWithHexString:@"#12598B"]];

    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0,0, LENGTH_SIZE(85), LENGTH_SIZE(13)) isTouch:YES];
    starRateView.isAnimation = YES;
    starRateView.rateStyle = HalfStar;

    self.starRateView = starRateView;
    [self.mechanismScoreView addSubview:starRateView];
    
    self.reMoneyLabel.layer.cornerRadius =  LENGTH_SIZE(10.5);
    self.reMoneyLabel.layer.borderWidth = 1;
    self.reMoneyLabel.layer.borderColor = [UIColor colorWithHexString:@"#FFD291"].CGColor;

    [LPTools setViewShapeLayer:self.ReMoneyDeclare CornerRadii:6 byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    
    self.AgeLabel.layer.cornerRadius = 2;
    self.AgeLabel.layer.borderColor = [UIColor baseColor].CGColor;
    self.AgeLabel.layer.borderWidth = 1;
    self.AgeLabel.textColor = [UIColor baseColor];
    
    
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
    self.mechanismScoreLabel.text = [NSString stringWithFormat:@"%.1f分",model.data.mechanismScore.floatValue];
    self.postNameLabel.text = model.data.postName;
    self.starRateView.currentScore = model.data.mechanismScore.floatValue/2;

    if (model.data.age.length) {
        self.AgeLabel.text = [NSString stringWithFormat:@" %@ ", model.data.age];
        self.AgeLabel.hidden = NO;
    }else{
        self.AgeLabel.hidden = YES;
    }
    
    
    if (model.data.reMoney.integerValue>0) {
        [self.reMoneyLabel setTitle:[NSString stringWithFormat:@"    %ld   ",
                                     (long)model.data.reMoney.integerValue]
                           forState:UIControlStateNormal];
        CGFloat ReMoneyWidth = [LPTools widthForString:[NSString stringWithFormat:@"    %ld   ",
                                                        (long)model.data.reMoney.integerValue] fontSize:FontSize(16) andHeight:LENGTH_SIZE(21)];
        self.keyLabel_constraint_right.constant = LENGTH_SIZE(13.0 +10 ) +ReMoneyWidth;
      
        self.reMoneyLabel.hidden = NO;
        self.reMoneyImage.hidden = NO;

    }else{
        self.reMoneyLabel.hidden = YES;
        self.reMoneyImage.hidden = YES;
        self.keyLabel_constraint_right.constant = LENGTH_SIZE(13);
    }
    
    if ([model.data.postName isEqualToString:@"小时工"]) {
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/时",reviseString(model.data.workMoney)];
        [self.ReMoneyDeclare setTitle:@"奖励说明" forState:UIControlStateNormal];
    }else{
        self.wageRangeLabel.text = [NSString stringWithFormat:@"%@元/月",model.data.wageRange];
        [self.ReMoneyDeclare setTitle:@"奖励说明" forState:UIControlStateNormal];
    }
    
    self.workTypeNameLabel.text = [NSString stringWithFormat:@"招%@人 / 已报名%@人",model.data.maxNumber,model.data.applyNumber];
    self.workName.text = model.data.workTypeName;
    self.lendTypeLabel.hidden = ![model.data.lendType integerValue];
    self.LayouConstraint_lendTypeLabel_Width.constant = ![model.data.lendType integerValue] ? 0 : LENGTH_SIZE(43);
    self.LayouConstraint_AgeLabel_left.constant = ![model.data.lendType integerValue] ? LENGTH_SIZE(13) : LENGTH_SIZE(64);
    if (model.data.status.integerValue == 1) {
        self.workTypeNameLabel.text = [NSString stringWithFormat:@"招%@人",model.data.maxNumber];
        self.applyNumberLabel.hidden = NO;
    }else{
        self.applyNumberLabel.hidden = YES;
    }
 
 
    NSArray *imageStrArray = [model.data.imageList componentsSeparatedByString:@";"];
    NSMutableArray *imageUrlArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0 ; i < imageStrArray.count ;i++) {
        NSString *str = imageStrArray[i];
        if (![str containsString:@".jpg"]&&
            ![str containsString:@".jpeg"]&&
            ![str containsString:@".png"]&&
            ![str containsString:@".gif"]) {
             [imageUrlArray addObject:[NSString stringWithFormat:@"%@?vframe/png/offset/0.001",str]];
        }else{
            [imageUrlArray addObject:str];
        }
    }
//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.imageBgView.frame imageNamesGroup:imageArray];
    self.cycleScrollView.imageURLStringsGroup = imageUrlArray;
 
 
    self.keyLabel.text = @"";
    [self.keyLabel.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    model.data.key = [model.data.key stringByReplacingOccurrencesOfString:@"丨" withString:@"|"];

    NSArray * tagArr = [model.data.key componentsSeparatedByString:@"|"];
    CGFloat tagBtnX = 0;
    CGFloat tagBtnY = 0;
    
    if (model.data.key.length >0) {
        for (int i= 0; i<tagArr.count; i++) {
            
            CGSize tagTextSize = [tagArr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(12)] maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(![self.model.data.lendType integerValue]?73:26), LENGTH_SIZE(17))];
            if (tagBtnX+tagTextSize.width+14 > SCREEN_WIDTH-LENGTH_SIZE(![self.model.data.lendType integerValue]?73:26)) {
                tagBtnX = 0;
                tagBtnY += LENGTH_SIZE(17)+8;
            }
            UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tagBtn.tag = 100+i;
            tagBtn.frame = CGRectMake(tagBtnX, tagBtnY, tagTextSize.width+LENGTH_SIZE(8), LENGTH_SIZE(17));
            [tagBtn setTitle:tagArr[i] forState:UIControlStateNormal];
            [tagBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
            tagBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(11)];
            tagBtn.layer.cornerRadius = LENGTH_SIZE(2);
            tagBtn.layer.masksToBounds = YES;
            tagBtn.backgroundColor = [UIColor colorWithHexString:@"#F5F6F7"];
            [self.keyLabel addSubview:tagBtn];
            
            tagBtnX = CGRectGetMaxX(tagBtn.frame)+LENGTH_SIZE(4);
        }
 
        self.LayoutConstraint_KeyView.constant  = tagBtnY+LENGTH_SIZE(17);
    }else{
        self.LayoutConstraint_KeyView.constant  = LENGTH_SIZE(17);
    }
    self.LayouConstraint_lendTypeLabel_Bottom.constant = 9;

//    if (self.model.data.key.length == 0 && ![self.model.data.lendType integerValue]) {
//        self.LayoutConstraint_KeyView.constant  = 0;
//    }
    
    
    NSString *strbackmoney = [self removeHTML2:model.data.reInstruction];
    if (strbackmoney.length>0) {
        self.BackMoneylabel.text = strbackmoney;
        CGFloat BackMoneyHeight = [LPTools calculateRowHeight:strbackmoney fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(26)];
        self.LayouConstraint_BackView_Height.constant = LENGTH_SIZE(128 + 36 +20) + BackMoneyHeight + self.LayoutConstraint_KeyView.constant;
    }else{
        self.LayouConstraint_BackView_Height.constant = LENGTH_SIZE(128) + self.LayoutConstraint_KeyView.constant;
    }
    
    
    
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片 ", (long)index);
    NSArray *imageStrArray = [self.model.data.imageList componentsSeparatedByString:@";"];
  
    NSString *url = imageStrArray[index];
    if (![url containsString:@".jpg"]&&
        ![url containsString:@".jpeg"]&&
        ![url containsString:@".png"]&&
        ![url containsString:@".gif"]) {
        WJMoviePlayerView *playerView = [[WJMoviePlayerView alloc] init];
        playerView.movieURL = [NSURL URLWithString:url];
        [playerView.coverView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?vframe/png/offset/0.001",url]]
                          placeholder:[UIImage imageNamed:@"NoImage"]];
        [playerView show];
    }
}

#pragma mark lazy

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
//        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:nil];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScroll = NO;
        _cycleScrollView.infiniteLoop = NO;
    }
    return _cycleScrollView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
 

- (NSString *)removeHTML2:(NSString *)html{
//    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    NSMutableArray *componentsToKeep = [NSMutableArray array];
//    for (int i = 0; i < [components count]; i = i + 2) {
//        [componentsToKeep addObject:[components objectAtIndex:i]];
//    }
//    NSString *plainText = [componentsToKeep componentsJoinedByString:@"\n"];
//    return plainText;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *string = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    return string;
}

@end
