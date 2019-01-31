//
//  LZImageBrowserMainView.m
//  LZImageDetail
//
//  Created by shenzhenshihua on 2018/4/28.
//  Copyright © 2018年 shenzhenshihua. All rights reserved.
//

#import "LZImageBrowserMainView.h"
#import "LZImageBrowserHeader.h"
#import "LZImageBrowserModel.h"
#import "LZImageBrowserSubView.h"

@interface LZImageBrowserMainView ()<UIScrollViewDelegate,LZImageBrowserSubViewDelegate>
@property(nonatomic,strong)UIScrollView * mainScrollView;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,copy)NSArray * imageUrls;
@property(nonatomic,copy)NSArray * originImageViews;

@end

@implementation LZImageBrowserMainView

+ (id)imageBrowserMainViewUrlStr:(NSArray<NSString *>*)imageUrls originImageViews:(NSArray<UIImageView *>*)originImageViews selectPage:(NSInteger)selectPage {
    LZImageBrowserMainView * imageBrowserMainView = [[LZImageBrowserMainView alloc] initWithFrame:Screen_Frame];
    imageBrowserMainView.imageUrls = imageUrls;
    imageBrowserMainView.originImageViews = originImageViews;
    imageBrowserMainView.selectPage = selectPage;
    [imageBrowserMainView initData];
    [imageBrowserMainView initView];
    return imageBrowserMainView;
}

- (void)initData {
    for (NSInteger i = 0; i < self.imageUrls.count; i++) {
        NSString * urlStr = self.imageUrls[i];
        UIImageView * imageView = self.originImageViews[i];
        LZImageBrowserModel * imageBrowserModel = [[LZImageBrowserModel alloc] init];
        imageBrowserModel.smallImageView = imageView;
        imageBrowserModel.urlStr = urlStr;
        [self.dataSource addObject:imageBrowserModel];
    }
}

- (void)initView {
    
    
    //1.初始化 mianScrollView
    [self addSubview:self.mainScrollView];
    //加入子视图
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
         LZImageBrowserSubView * imageBrowserSubView = [[LZImageBrowserSubView alloc] initWithFrame:CGRectMake((Screen_Width + SpaceWidth)*i, 0, Screen_Width, Screen_Height) ImageBrowserModel:self.dataSource[i]];
        imageBrowserSubView.delegate = self;
        [self.mainScrollView addSubview:imageBrowserSubView];
    }
    [self.mainScrollView setContentSize:CGSizeMake((Screen_Width + SpaceWidth)*self.dataSource.count, 0)];
    [self.mainScrollView setContentOffset:CGPointMake((Screen_Width + SpaceWidth)*_selectPage, 0)];
    //2.设置 pagecontel
    [self addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.dataSource.count;
    CGSize size = [self.pageControl sizeForNumberOfPages:self.dataSource.count];
    self.pageControl.frame = CGRectMake(Screen_Width/2-size.width/2, Screen_Height-size.height-20, size.width, size.height);
    self.pageControl.currentPage = _selectPage;
    
//    UIButton *DownBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 150, 40, 40)];
//    [DownBt setImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
//    [DownBt addTarget:self action:@selector(DownLoadImage:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:DownBt];
}

- (void)subViewHidden:(BOOL)isHidden {
    if (isHidden) {
        self.mainScrollView.hidden = YES;
        self.pageControl.hidden = YES;
    } else {
        self.mainScrollView.hidden = NO;
        self.pageControl.hidden = NO;
    }
}

#pragma mark -LZImageBrowserSubViewDelegate
- (void)imageBrowserSubViewSingleTapWithModel:(LZImageBrowserModel *)imageBrowserModel {
    if ([self.delegate respondsToSelector:@selector(imageBrowserMianViewSingleTapWithModel:)]) {
        [self.delegate imageBrowserMianViewSingleTapWithModel:imageBrowserModel];
    }
}

- (void)imageBrowserSubViewTouchMoveChangeMainViewAlpha:(CGFloat)alpha {
    if ([self.delegate respondsToSelector:@selector(imageBrowserMainViewTouchMoveChangeMainViewAlpha:)]) {
        [self.delegate imageBrowserMainViewTouchMoveChangeMainViewAlpha:alpha];
    }
}

#pragma mark -scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    _selectPage = currentPage;
    [self.pageControl setCurrentPage:currentPage];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat currentX = scrollView.contentOffset.x;
    NSInteger currentPage = currentX / (Screen_Width + SpaceWidth);
    [self.pageControl setCurrentPage:currentPage];
}

#pragma mark  -lazy
- (UIScrollView *)mainScrollView {
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width + SpaceWidth, Screen_Height)];
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor clearColor];
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

- (UIPageControl *)pageControl {
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        //如果只有一页就隐藏
        _pageControl.hidesForSinglePage = YES;
        //设置page的颜色
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        //设置当前page的颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


-(void)DownLoadImage:(UIButton *)sender{
    
    LZImageBrowserModel * imageBrowserModel = self.dataSource[_selectPage];
    [self saveImage:imageBrowserModel.getCurrentImage];
}


//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);

//        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied
//            )
//        {
//            // 无权限
//            [LPTools AlertMessageView:@"您没有开启相册访问权限,请您去手机设置页面开启"];
//            return;
//        }
        
    };
}
//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
//        [[UIWindow visibleViewController].view showLoadingMeg:@"保存图片失败,请稍后再试" time:2.0];
        [LPTools AlertMessageView:@"保存图片失败,请检查是否开启相册访问权限"];
    }
    else {
        NSLog(@"保存图片成功");
        [LPTools AlertMessageView:@"保存图片成功"];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
