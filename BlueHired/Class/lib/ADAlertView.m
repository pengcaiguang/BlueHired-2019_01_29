//
//  adAlertView.m
//  ADAlertProject
//
//  Created by xie on 2017/8/14.
//  Copyright © 2017年 xie. All rights reserved.
//



#define BaseTag      100
#define ScreenBounds [UIScreen mainScreen].bounds
#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define ScrollWidth   _scrollView.frame.size.width
#define ScrollHeight  _scrollView.frame.size.height

#import "ADAlertView.h"
#import "ADModel.h"
#import "LPAdvertModel.h"
@interface ADAlertView()<UIScrollViewDelegate>
{
    UIPageControl   *pageControl;
    UIButton        *cancelBtn;
    NSString        *placeHolderImgStr;
}
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,assign)NSInteger    itemsCount;
@property(nonatomic,strong)NSArray      *adDataList;
@property(nonatomic,assign)BOOL         hiddenPageControl;
@end
@implementation ADAlertView

+(ADAlertView *)showInView:(UIView *)view theDelegate:(id)delegate theADInfo: (NSArray *)dataList placeHolderImage: (NSString *)placeHolderStr{
    if (!dataList) {
        return nil;
    }
    
    ADAlertView *sqAlertView = [[ADAlertView alloc] initShowInView:view theDelegate:delegate theADInfo:dataList placeHolderImage:placeHolderStr];
    return sqAlertView;
}

/// 初始化、添加手势
- (instancetype)initShowInView:(UIView *)view theDelegate:(id)delegate
                     theADInfo:(NSArray *)dataList
              placeHolderImage: (NSString *)placeHolderStr{
    self = [super init];
    if (self) {
//        self.frame = view.bounds;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        
        self.backgroundColor    = [UIColor colorWithWhite:0.2 alpha:0.5];
        placeHolderImgStr       = placeHolderStr;
        self.delegate           = delegate;
        self.hiddenPageControl  = NO;
        self.adDataList         = dataList;
        
 
        [[[UIApplication sharedApplication].windows objectAtIndex:0] endEditing:YES];
//        [[[UIApplication sharedApplication].windows insertSubView:0] addSubview:self];
        [[[UIApplication sharedApplication].windows objectAtIndex:0] insertSubview:self atIndex:1 ];
        
        [self showAlertAnimation];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeFromCurrentView:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

/// 透明度动画
- (void)showAlertAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue         = [NSNumber numberWithFloat:0];
    animation.toValue           = [NSNumber numberWithFloat:1];
    animation.duration          = 0.5;
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"opacity"];
}

/// 移除广告手势
-(void)removeFromCurrentView:(UIGestureRecognizer *)gesture
{
    UIView * subView    = (UIView *)[self viewWithTag:99];
    UIView * shadowView = self;
    if (CGRectContainsPoint(subView.frame, [gesture locationInView:shadowView]))
    {}else{
        [self removeSelfFromSuperview];
    }
}

/// 移除广告
- (void)removeSelfFromSuperview
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake((ScreenWidth-293)/2, ScreenHeight/2-420/2, 293, 420)];
        _scrollView.backgroundColor         = [UIColor clearColor];
        _scrollView.userInteractionEnabled  = YES;
        _scrollView.contentSize     = CGSizeMake(293*_adDataList.count, 410);
        _scrollView.delegate        = self;
        _scrollView.pagingEnabled   = YES;
        _scrollView.bounces         = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
-(void)setAdDataList:(NSArray *)adDataList{
    
    _adDataList = adDataList;
    _itemsCount = adDataList.count;
    
    [self creatItemView];
}

/// 添加控件
-(void)creatItemView{
    
    if (_itemsCount == 0) {
        return;
    }
    if (_itemsCount == 1) {
        self.hiddenPageControl = YES;
    }
    [self addSubview:self.scrollView];
    
    /// 图片
    for ( int i = 0; i < _itemsCount; i++ ) {
        
        LPAdvertDataModel *adModel = [_adDataList objectAtIndex:i];
        ADItemView*item = [[ADItemView alloc]initWithFrame:CGRectMake(i*293,0, 293, 420)];
        item.userInteractionEnabled = YES;
        item.index  = i;
        item.tag    = BaseTag+item.index;
//        item.imageView.image      = [UIImage imageNamed:adModel.imgStr];
        [item.imageView sd_setImageWithURL:[NSURL URLWithString:adModel.activityImage] placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
        item.layer.cornerRadius = 0;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, 312, 253, 65)];
        view.backgroundColor = [UIColor whiteColor];
        view.layer.cornerRadius = 5;
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 233, 25)];
        label1.text = [NSString stringWithFormat:@"热门活动:%@",adModel.activityName];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.textColor = [UIColor colorWithHexString:@"#FFFF623D"];
        label1.font = [UIFont boldSystemFontOfSize:11];
        [view addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 243, 20)];
        label2.textColor = [UIColor colorWithHexString:@"#FFFB7657"];
        label2.font = [UIFont boldSystemFontOfSize:11];
        label2.text = [NSString stringWithFormat:@"活动时间:%@—%@",[NSString convertStringToYYYNMMYDDR:adModel.activityBeginTime],[NSString convertStringToYYYNMMYDDR:adModel.activityEndTime]];
        label2.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label2];
        [item addSubview:view];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapContentImgView:)];
        [item addGestureRecognizer:singleTap];
        [_scrollView addSubview:item];
        
    }
    ///取消按钮
    cancelBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake((ScreenWidth-293)/2+293-22, (ScreenHeight-421)/2-44, 22, 44);
    [cancelBtn setImage:[UIImage imageNamed:@"关  闭 (1)"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeSelfFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    
    //初始化pageControl
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ScreenHeight-120, ScreenWidth, 20)];
    pageControl.numberOfPages   = _itemsCount;
    pageControl.currentPage     = 0;
    [pageControl addTarget:self action:@selector(pageValueChange:) forControlEvents:UIControlEventValueChanged];
//    pageControl.hidden          = self.hiddenPageControl;
    pageControl.hidden  = YES;
    [self addSubview:pageControl];
}

/// 广告点击手势
-(void)tapContentImgView:(UITapGestureRecognizer *)gesture{
    UIView *imageView = gesture.view;
    NSInteger itemTag = (long)imageView.tag-BaseTag;
    if ([self.delegate respondsToSelector:@selector(clickAlertViewAtIndex:)]){
        [self.delegate clickAlertViewAtIndex:itemTag];
        [self removeSelfFromSuperview];
    }
}

/// 当pageControl改变的时候，判断scrollView偏移
-(void)pageValueChange:(UIPageControl*)page{
    
    [UIView animateWithDuration:.35 animations:^{
        _scrollView.contentOffset = CGPointMake(page.currentPage*293, 0);
    }];
}
#pragma mark - UIScrollViewDelegate  滑动scrollView 切换pageContrl
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index         = scrollView.contentOffset.x/293;
    pageControl.currentPage = index;
}

@end


//自定义中间主界面
@implementation ADItemView

-(id)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setSubViews];
    }
    return self;
}

-(void)setSubViews{
    self.userInteractionEnabled = YES;
    self.layer.masksToBounds    = YES;
    self.layer.cornerRadius     = 5;
    self.layer.shadowOpacity    = .2;
    self.layer.shadowOffset     = CGSizeMake(0, 2.5);
    self.layer.shadowColor      = [UIColor blackColor].CGColor;
    
    [self addSubview:self.imageView];
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.backgroundColor        = [UIColor colorWithWhite:0.1 alpha:1.0];
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.masksToBounds    = YES;
    }
    return _imageView;
}



@end


