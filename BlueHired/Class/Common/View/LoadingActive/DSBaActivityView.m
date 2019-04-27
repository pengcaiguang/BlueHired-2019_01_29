//
//  DSBaActivityView.m
//  DDemo
//
//  Created by deng shu on 2017/5/11.
//  Copyright © 2017年 deng shu. All rights reserved.
//

#import "DSBaActivityView.h"


static DSBaActivityView *activiyView;
@interface DSBaActivityView()
@property (nonatomic, strong) CAReplicatorLayer *reaplicator;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) CALayer *showlayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) NSInteger showTimes;
@property (nonatomic, strong) UIImageView *GIFImageView;

@end
@implementation DSBaActivityView

+ (void)showActiviTy {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (activiyView == nil) {
            CGRect rect = [UIScreen mainScreen].bounds;
            activiyView = [[DSBaActivityView alloc] initWithFrame:rect];
            activiyView.backgroundColor = [UIColor clearColor];
        }
    });
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:activiyView];
    activiyView.showTimes += 1;
    activiyView.alpha = 1;
}

+ (void)hideActiviTy {
    if (activiyView.showTimes > 0) {
        activiyView.showTimes -= 1;
    }
    if (activiyView.showTimes == 0){
        [UIView animateWithDuration:0.25f animations:^{
            activiyView.alpha = 0;
        }];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.showTimes = 0;
        [self.contentView addSubview:self.label];
//        [self.contentView.layer addSublayer:self.reaplicator];
        [self addSubview:self.contentView];
        [self startAnimation];
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        self.alpha = 0;
     }
    return self;
}

- (void)startAnimation {
    
    //对layer进行动画设置
    CABasicAnimation *animaiton = [CABasicAnimation animation];
    //设置动画所关联的路径属性
    animaiton.keyPath = @"transform.scale";
    //设置动画起始和终结的动画值
    animaiton.fromValue = @(1);
    animaiton.toValue = @(0.1);
    //设置动画时间
    animaiton.duration = 1.0f;
    //填充模型
    animaiton.fillMode = kCAFillModeForwards;
    //不移除动画
    animaiton.removedOnCompletion = NO;
    //设置动画次数
    animaiton.repeatCount = INT_MAX;
    //添加动画
    [self.showlayer addAnimation:animaiton forKey:@"anmation"];
}
- (UIView *)contentView {
    if (_contentView == nil) {
        UIView *contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        contentView.layer.cornerRadius = 10.0f;
        contentView.layer.borderColor = [UIColor colorWithWhite:0.926 alpha:1.000].CGColor;
        contentView.layer.shadowColor = [UIColor blackColor].CGColor;
        contentView.layer.shadowOpacity = 0.5;
        contentView.layer.shadowOffset = CGSizeMake(1, 1);
        contentView.center = self.center;
        contentView.backgroundColor = SetColor(1, 1, 1, 0.5);
//        contentView.backgroundColor = [UIColor redColor];
        _contentView = contentView;
        
        // 创建一个显示图片的imageView   // viewController创建
        UIImageView *showGifImageView = [[UIImageView alloc] initWithFrame:CGRectMake((contentView.frame.size.width-80)/2, (contentView.frame.size.height-80)/2, 80, 80)];
        self.GIFImageView = showGifImageView;
        [contentView addSubview:showGifImageView];
        
        
        //创建一个存储图片的数组
        NSMutableArray *saveImageViewArray = [NSMutableArray array];
        
        for (int i = 1; i < 11; i++) {
            NSString *imageName = [NSString stringWithFormat:@"组%d.png",i];
            UIImage *image = [UIImage imageNamed:imageName];
            [saveImageViewArray addObject:image];
        }
        
        // 设置gif图片组
        showGifImageView.animationImages = saveImageViewArray;
        // 设置播放速率
        showGifImageView.animationDuration = 1.5f;
        // 设置播放次数(设置动态图重复次数)
        showGifImageView.animationRepeatCount = -1;// -1无限为播放
        // 动画需要设置开辟
        [showGifImageView startAnimating];
        
    }
    return _contentView;
}
- (UILabel *)label {
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.reaplicator.frame)+5, CGRectGetWidth(self.contentView.frame), 20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = GreenColor;
//        label.text = @"加载中。。。";
        label.font = [UIFont systemFontOfSize:12];
        _label = label;
    }
    return _label;
}
- (CAReplicatorLayer *)reaplicator{
    if (_reaplicator == nil) {
        int numofInstance = 10;
        CGFloat duration = 1.0f;
        //创建repelicator对象
        CAReplicatorLayer *repelicator = [CAReplicatorLayer layer];
        repelicator.bounds = CGRectMake(0, 0, 50, 50);
        repelicator.position = CGPointMake(self.contentView.bounds.size.width * 0.5, self.contentView.bounds.size.height * 0.5);
        repelicator.instanceCount = numofInstance;
        repelicator.instanceDelay = duration / numofInstance;
        //设置每个实例的变换样式
        repelicator.instanceTransform = CATransform3DMakeRotation(M_PI * 2.0 / 10.0, 0, 0, 1);
        //创建repelicator对象的子图层，repelicator会利用此子图层进行高效复制。并绘制到自身图层上
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 8, 8);
        //子图层的仿射变换是基于repelicator图层的锚点，因此这里将子图层的位置摆放到此
        CGPoint point = [repelicator convertPoint:repelicator.position fromLayer:self.layer];
        layer.position = CGPointMake(point.x, point.y - 20);
//        layer.backgroundColor = GreenColor.CGColor;
        layer.backgroundColor = [UIColor baseColor].CGColor;
        layer.cornerRadius = layer.frame.size.width/2;
        layer.transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showlayer = layer;

        [repelicator addSublayer:layer];
        _reaplicator = repelicator;
    }
    return _reaplicator;
}


-(void)loadGIFWithWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:_contentView.frame];
//    [webView setCenter:_contentView.center];
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"logo-2" ofType:@"gif"]];
    webView.userInteractionEnabled = NO;
    [webView loadData:gif MIMEType:@"image/gif" textEncodingName:@"UTF-8" baseURL:nil];
    //设置webview背景透明，能看到gif的透明层
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    [self addSubview:webView];
    
}

@end
