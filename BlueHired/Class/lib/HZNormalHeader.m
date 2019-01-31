//
//  HZNormalHeader.m
//  BlueHired
//
//  Created by iMac on 2018/11/15.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "HZNormalHeader.h"
#import "MJRefresh.h"
#define BALLOON_GIF_DURATION 0.15

@interface HZNormalHeader()
@property (strong, nonatomic) UIImageView *stateGIFImageView;
@property (strong, nonatomic) NSMutableDictionary *stateImages;
@end

@implementation HZNormalHeader
#pragma mark - 懒加载
- (UIImageView *)stateGIFImageView{
    if (!_stateGIFImageView) {
        _stateGIFImageView = [[UIImageView alloc] init];
        [self addSubview:_stateGIFImageView];
    }
    return _stateGIFImageView;
}

- (NSMutableDictionary *)stateImages {
    if (!_stateImages) {
        self.stateImages = [NSMutableDictionary dictionary];
    }
    return _stateImages;
}

#pragma mark - 公共方法
- (void)setImages:(NSArray *)images forState:(MJRefreshState)state {
    
    if (images == nil) {
        return;
    }
    self.stateImages[@(state)] = images;
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
//        self.mj_h = image.size.height;
        self.mj_h = image.size.height;
    }
    
}

#pragma mark - 实现父类的方法
- (void)prepare {
    
    [super prepare];
    // 初始化间距
    self.labelLeftInset = 20;
    // 资源数据（GIF每一帧）
    NSArray *idleImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:1];
    NSArray *refreshingImages = [self getRefreshingImageArrayWithStartIndex:1 endIndex:1];
    // 普通状态
    [self setImages:idleImages forState:MJRefreshStateIdle];
    // 即将刷新状态
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    // 正在刷新状态
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
}

- (void)setPullingPercent:(CGFloat)pullingPercent {
    
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.stateImages[@(MJRefreshStateIdle)];
    if (self.state != MJRefreshStateIdle || images.count == 0) {
        return;
    }
    [self.stateGIFImageView stopAnimating];
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) {
        index = images.count - 1;
    }
    self.stateGIFImageView.image = images[index];
    
}

- (void)placeSubviews{
    
    [super placeSubviews];
    if (self.stateGIFImageView.constraints.count) {
        return;
    }
    self.stateLabel.hidden = YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateGIFImageView.frame = self.bounds;
    self.stateGIFImageView.contentMode = UIViewContentModeCenter;
    
}

- (void)setState:(MJRefreshState)state{
    
    MJRefreshCheckState
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.stateImages[@(state)];
        [self startGIFViewAnimationWithImages:images];
    } else if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing && state == MJRefreshStateIdle) {
            NSArray *endImages = [self getRefreshingImageArrayWithStartIndex:2 endIndex:10];
            
            [self startGIFViewAnimationWithImages:endImages];
        }else{
            [self.stateGIFImageView stopAnimating];
        }
    }
    
}

#pragma mark - 开始动画
- (void)startGIFViewAnimationWithImages:(NSArray *)images{
    
    if (images.count <= 0){
        return;
    }
    [self.stateGIFImageView stopAnimating];
    // 单张
    if (images.count == 1) {
        self.stateGIFImageView.image = [images lastObject];
        return;
    }
    // 多张
    self.stateGIFImageView.animationImages = images;
    self.stateGIFImageView.animationDuration = images.count * BALLOON_GIF_DURATION;
    [self.stateGIFImageView startAnimating];
    
}


#pragma mark - 获取资源图片
- (NSArray *)getRefreshingImageArrayWithStartIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex{
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = startIndex; i <= endIndex; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"组%lu.png", (unsigned long)i]];
        if (image) {
            [result addObject:[self reSizeImage:image toSize:CGSizeMake( 40, 40)]];
        }
    }
    return result;
    
}
 
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return reSizeImage;
}
@end
