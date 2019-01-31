//
//  LPMoodDetailHeaderCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/18.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPMoodDetailHeaderCell.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/Photos.h>

@interface LPMoodDetailHeaderCell ()<UIScrollViewDelegate>
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;

@end

@implementation LPMoodDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = 20.0;
    self.userConcernButton.layer.masksToBounds = YES;
    self.userConcernButton.layer.cornerRadius = 10.0;
    [self.userConcernButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.userConcernButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.userConcernButton setImage:[UIImage imageNamed:@"user_concern_normal"] forState:UIControlStateNormal];
    [self.userConcernButton setImage:[UIImage imageNamed:@"user_concern_selected"] forState:UIControlStateSelected];
    [self.userConcernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.userConcernButton setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateSelected];
    UITapGestureRecognizer *TapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchUpInside:)];
    [self.userUrlImgView addGestureRecognizer:TapGestureRecognizer];
}

-(void)TouchUpInside:(UITapGestureRecognizer *)recognizer{
    
    //    if ([LoginUtils validationLogin:[UIWindow visibleViewController]]) {
//    if (self.ContentType == 0) {
//        LPReportVC *vc = [[LPReportVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.MoodModel = self.model;
//        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
//    }
    
}

-(void)setModel:(LPGetMoodModel *)model{
    _model = model;
    
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.data.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.userNameLabel.text = model.data.userName;
    self.gradingLabel.text = [NSString stringWithFormat:@"(%@)",model.data.grading];
    self.timeLabel.text = [NSString convertStringToTime:[model.data.time stringValue]];
    self.AddressLabel.text = model.data.address;
    self.moodDetailsLabel.text = model.data.moodDetails;
    self.viewLabel.text = model.data.view ? [model.data.view stringValue] : @"0";
    if ([[LPTools isNullToString:model.data.address] isEqualToString:@""] || [model.data.address isEqualToString:@"保密"]) {
        self.AddressLabel.text = @"";
        self.AddressImage.hidden = YES;
    }else{
        self.AddressLabel.text = model.data.address;
        self.AddressImage.hidden = NO;
    }
    
    self.gradingiamge.image = [UIImage imageNamed:model.data.grading];
//    if (model.data.score.integerValue >=0 && model.data.score.integerValue <3000) {
//        self.gradingiamge.image = [UIImage imageNamed:@"见习职工"];
//
//    }else if (model.data.score.integerValue >= 3000 && model.data.score.integerValue < 6000){
//        self.gradingiamge.image = [UIImage imageNamed:@"初级职工"];
//
//    }else if (model.data.score.integerValue >= 6000 && model.data.score.integerValue < 12000){
//        self.gradingiamge.image = [UIImage imageNamed:@"中级职工"];
//
//    }else if (model.data.score.integerValue >= 12000 && model.data.score.integerValue < 18000){
//        self.gradingiamge.image = [UIImage imageNamed:@"高级职工"];
//
//    }else if (model.data.score.integerValue >= 18000 && model.data.score.integerValue < 24000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门精英"];
//
//    }else if (model.data.score.integerValue >= 24000 && model.data.score.integerValue < 30000){
//        self.gradingiamge.image = [UIImage imageNamed:@"部门经理"];
//
//    }else if (model.data.score.integerValue >= 30000 && model.data.score.integerValue < 36000){
//        self.gradingiamge.image = [UIImage imageNamed:@"区域经理"];
//
//    }else if (model.data.score.integerValue >= 36000 && model.data.score.integerValue < 45000){
//        self.gradingiamge.image = [UIImage imageNamed:@"总经理"];
//
//    }else{
//        self.gradingiamge.image = [UIImage imageNamed:@"董事长"];
//     }
    
    
    for (UIView *view in self.imageBgView.subviews) {
        [view removeFromSuperview];
    }
    if (kStringIsEmpty(model.data.moodUrl)) {
        self.imageBgView.hidden = YES;
        self.imageBgView_constraint_height.constant = 0;
    }else{
        self.imageBgView.hidden = NO;
        NSArray *imageArray = [model.data.moodUrl componentsSeparatedByString:@";"];
        CGFloat imgw = (SCREEN_WIDTH-22 - 10)/3;
        CGFloat imageHeight = 250.0;
        self.imageViewsRectArray = [NSMutableArray new];
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = imageArray.count ==1?CGRectMake(0,0,imageHeight,imageHeight): CGRectMake((imgw + 5)* (i%3), floor(i/3)*(imgw + 5), imgw, imgw);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"NoImage"]];
            [imageView yy_setImageWithURL:[NSURL URLWithString:imageArray[i]]
                              placeholder:[UIImage imageNamed:@"NoImage"]
                                  options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                     
                                 }
                                transform:nil
                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
                                   if (stage == YYWebImageStageFinished) {
                                       
                                   }
                               }];
            [self.imageBgView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
            [imageView addGestureRecognizer:tap];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [self.imageViewsRectArray addObject:imageView];
            
        }
        self.imageArray = imageArray;
        
        if (imageArray.count ==1)
        {
            self.imageBgView_constraint_height.constant = imageHeight;
        }
        else
        {
            self.imageBgView_constraint_height.constant = ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
        }
        
        LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:self.imageArray originImageViews:self.imageViewsRectArray originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
            NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
        }];
        _imageBrowserManger = imageBrowserManger;
    }
    
    if ([model.data.userId integerValue] ==[kUserDefaultsValue(LOGINID) integerValue])
    {
        [self.userConcernButton setTitle:@"删除" forState:UIControlStateNormal];
        [self.userConcernButton setImage:nil forState:UIControlStateNormal];
        CGRect rect = [@"已关注" getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.userConcern_constraint_width.constant = rect.size.width + 15;
        self.userConcernButton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        [self.userConcernButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    }
    else
    {
        [self.userConcernButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        if (model.data.isConcern) {
            if ([model.data.isConcern integerValue] == 0) {
                self.isUserConcern = YES;
            }else{
                self.isUserConcern = NO;
            }
        }else{
            self.isUserConcern = NO;
        }
    }
    

    
}

-(void)setIsUserConcern:(BOOL)isUserConcern{
    _isUserConcern = isUserConcern;
    if (isUserConcern) {
        CGRect rect = [@"已关注" getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.userConcern_constraint_width.constant = rect.size.width + 10 + 15;
        self.userConcernButton.selected = YES;
        self.userConcernButton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    }else{
        CGRect rect = [@"关注" getStringSize:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:12]];
        self.userConcern_constraint_width.constant = rect.size.width + 10 + 15;
        self.userConcernButton.selected = NO;
        self.userConcernButton.backgroundColor = [UIColor baseColor];
    }
}

- (IBAction)touchUserConcernButton:(UIButton *)sender {
    if (self.userConcernBlock) {
        self.userConcernBlock();
    }
}

-(void)selectImage:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"menues = %ld",[singleTap view].tag);
    _imageBrowserManger.selectPage = singleTap.view.tag;
    [_imageBrowserManger showImageBrowser];
    
//
//    if (self.viewController) {
//        if ([self.viewController isKindOfClass:[UIViewController class]]) {
//            UITableView* tableView = self.tableView;
//            UIWindow* window = [UIApplication sharedApplication].keyWindow;
//
//            CGRect rectInbg = [self.imageBgView convertRect:[singleTap view].frame toView:self];
//
//            // convert rect to self(cell)
//            CGRect rectInCell = [self.contentView convertRect:rectInbg toView:self];
//
//            // convert rect to tableview
//            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
//
//            // convert rect to window
//            self.imageRect  = [tableView convertRect:rectInTableView toView:window];
//        }
//    }
//    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    self.scrollView.backgroundColor = [UIColor blackColor];
//    self.scrollView.alpha = 0;
//    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
//
//    self.touchImage = [UIImageView new];
//    self.touchImage.frame = self.imageRect;
//    self.touchImage.contentMode = UIViewContentModeScaleAspectFit;
//    NSString *imageStr = self.imageArray[[singleTap view].tag];
//    NSURL *imageUrl = [NSURL URLWithString:imageStr];
////    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:nil];
//    [self.touchImage yy_setImageWithURL:imageUrl
//                      placeholder:[UIImage imageNamed:@"NoImage"]
//                                options:YYWebImageOptionShowNetworkActivity |
//     YYWebImageOptionIgnoreImageDecoding |
//     YYWebImageOptionIgnoreAnimatedImage
//                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                         }
//                        transform:nil
//                       completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//                           if (stage == YYWebImageStageFinished) {
//
//                           }
//                       }];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.touchImage];
//
//    [UIView animateWithDuration:0.5 animations:^{
//        self.touchImage.contentMode = UIViewContentModeScaleAspectFit;
//        self.touchImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//        self.scrollView.alpha = 1;
//    } completion:^(BOOL finished){
//        self.touchImage.hidden = YES;
//
//        self.scrollView.delegate                       = self;
//        self.scrollView.bounces                        = YES;
//        self.scrollView.pagingEnabled                  = YES;
//        self.scrollView.showsHorizontalScrollIndicator = FALSE;
//        self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, 0);
//        for (int i = 0; i < self.imageArray.count; ++i) {
//            UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//            //            activityIndicator.frame = CGRectMake(0, 0, 100, 100);
//            activityIndicator.center = imageView.center;
//            [imageView addSubview:activityIndicator];
//
//            NSString *imageStr = self.imageArray[i];
//            NSURL *imageUrl = [NSURL URLWithString:imageStr];
////            [imageView sd_setImageWithURL:imageUrl];
//
//            [imageView yy_setImageWithURL:imageUrl
//                              placeholder:[UIImage imageNamed:@"NoImage"]
//                                  options:  YYWebImageOptionShowNetworkActivity |
//             YYWebImageOptionIgnoreImageDecoding |
//             YYWebImageOptionIgnoreAnimatedImage
//                                 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//
//                                 }
//                                transform:nil
//                               completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
//                                   if (stage == YYWebImageStageFinished) {
//
//                                   }
//                               }];
//
//            imageView.tag = i;
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.userInteractionEnabled = YES;
//            [self.scrollView addSubview:imageView];
//            NSLog(@"%.f  %.f",imageView.frame.size.width,imageView.frame.size.height);
//
//            UIView *v = [[UIView alloc] initWithFrame:imageView.frame];
//            v.clipsToBounds = YES;
//            imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//            imageView.tag = 100;
//            [v addSubview:imageView];
//
//            UIButton *DownBt = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 150, 40, 40)];
//            [DownBt setImage:[UIImage imageNamed:@"xiazai"] forState:UIControlStateNormal];
//            [DownBt addTarget:self action:@selector(DownLoadImage:) forControlEvents:UIControlEventTouchUpInside];
//            [v addSubview:DownBt];
//
//            [self.scrollView addSubview:v];
//                        UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageScroll)];
//                        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
//
//            //            [imageView addGestureRecognizer:panGestureRecognizer];
//            [imageView addGestureRecognizer:pinchGestureRecognizer];
//            [imageView addGestureRecognizer:tap];
//        }
//        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * [singleTap view].tag , 0)];
//
//        if (self.imageArray.count > 1) {
//            self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
//            self.pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 50);
//            self.pageControl.numberOfPages = self.imageArray.count;
//            self.pageControl.currentPage = [singleTap view].tag;
//            self.pageControl.tintColor = [UIColor lightGrayColor];
//            self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//            [[UIApplication sharedApplication].keyWindow addSubview:self.pageControl];
//        }
//    }];
    
}
- (UIViewController *)viewController
{
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass:[UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}



-(void)DownLoadImage:(UIButton *)sender{
    UIImageView *V =(UIImageView *)[sender.superview viewWithTag:100];
    [self saveImage:V.image];
}

// 处理拖拉手势
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = panGestureRecognizer.view;
    if (view.frame.size.width<=SCREEN_WIDTH) {
        return;
    }
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x, view.center.y + translation.y}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
}
// 处理缩放手势
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = pinchGestureRecognizer.view;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"%f",scrollView.contentOffset.x);
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    NSString *imageStr = self.imageArray[index];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"headPlaceholder"]];
    self.pageControl.currentPage = index;
    
    if (self.viewController) {
        if ([self.viewController isKindOfClass:[UIViewController class]]) {
            UITableView* tableView = self.tableView;
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            CGRect rectInbg = [self.imageBgView convertRect:self.imageViewsRectArray[index].frame toView:self];
            
            // convert rect to self(cell)
            CGRect rectInCell = [self.contentView convertRect:rectInbg toView:self];
            
            // convert rect to tableview
            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
            
            // convert rect to window
            self.imageRect  = [tableView convertRect:rectInTableView toView:window];
        }
    }
    
}
-(void)closeImageScroll{
    self.touchImage.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.alpha = 0;
        for (UIView *view in self.scrollView.subviews) {
            [view removeFromSuperview];
        }
        self.touchImage.frame = self.imageRect;
        [self.pageControl removeFromSuperview];
        
    } completion:^(BOOL finished) {
        [self.scrollView removeFromSuperview];
        [self.touchImage removeFromSuperview];
        
    }];
    
}


- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    if (image) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied
            )
        {
            // 无权限
            [LPTools AlertMessageView:@"您没有开启相册访问权限,请您去手机设置页面开启"];
            //                 [[UIWindow visibleViewController].view showLoadingMeg:@"您没有开启相册访问权限,请您去手机设置页面开启" time:2.0];
            return;
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
//        [self loadImageFinished:image];
    };
}

//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存图片出错%@", error.localizedDescription);
        [[UIWindow visibleViewController].view showLoadingMeg:@"保存图片失败,请稍后再试" time:2.0];
        [LPTools AlertMessageView:@"保存图片失败,请稍后再试"];
    }
    else {
        NSLog(@"保存图片成功");
        [LPTools AlertMessageView:@"保存图片成功"];
    }
}



@end
