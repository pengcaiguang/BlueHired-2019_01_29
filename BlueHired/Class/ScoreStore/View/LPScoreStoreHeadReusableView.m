//
//  LPScoreStoreHeadReusableView.m
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoreHeadReusableView.h"
#import "SDCycleScrollView.h"
#import "LPStoreCartVC.h"
#import "LPMyOrderVC.h"
#import "LPScoreStoredetailsVC.h"
#import "LPScoreStoreBillVC.h"
#import "LPStoreShareVC.h"
#import "LPIntegralDrawVC.h"

@interface LPScoreStoreHeadReusableView ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation LPScoreStoreHeadReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self addSubview:self.cycleScrollView];
//    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.imageBgView);
//    }];
//    self.cycleScrollView.delegate = self;
    
}

- (void)setModel:(LPProductListModel *)model{
    _model = model;
//    NSMutableArray *array = [NSMutableArray array];
//    for (LPProductListDataModel *model in self.model.data.slideList) {
//        NSArray *imageArr = [model.pic componentsSeparatedByString:@","];
//        if (imageArr.count > 0 ) {
//             [array addObject:imageArr[0]];
//        }
//
//    }
//    self.cycleScrollView.imageURLStringsGroup = array;
}

- (IBAction)TouchBill:(id)sender {  //积分账单
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPScoreStoreBillVC *vc = [[LPScoreStoreBillVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
    
}

- (IBAction)TouchCart:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPIntegralDrawVC *vc = [[LPIntegralDrawVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)TouchOrder:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPMyOrderVC *vc = [[LPMyOrderVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)TouchShare:(id)sender {
    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
        LPStoreShareVC *vc = [[LPStoreShareVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}



#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    LPScoreStoredetailsVC *vc = [[LPScoreStoredetailsVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.ListModel = self.model.data.slideList[index];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
 
}

#pragma mark lazy
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(120)) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.delegate = self;
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//        _cycleScrollView.autoScroll = NO;
//        _cycleScrollView.infiniteLoop = NO;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

@end
