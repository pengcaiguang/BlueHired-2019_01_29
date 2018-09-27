//
//  LPBusinessReviewDetailSalaryCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBusinessReviewDetailSalaryCell.h"
@interface LPBusinessReviewDetailSalaryCell ()<UIScrollViewDelegate>

@end
@implementation LPBusinessReviewDetailSalaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = 20;
    self.imageViewsRectArray = [NSMutableArray array];
}
-(void)setModel:(LPMechanismcommentDetailDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"cricle_headimg_placeholder"]];
    self.userNameLabel.text = model.userName;
    self.commentContentLabel.text = model.commentContent;
    
    self.workEnvironScoreLabel.text = [NSString stringWithFormat:@"%@",model.workEnvironScore];
    self.foodEnvironScoreLabel.text = [NSString stringWithFormat:@"%@",model.foodEnvironScore];
    self.moneyEnvironScoreLabel.text = [NSString stringWithFormat:@"%@",model.moneyEnvironScore];
    
    
    [self.commentUrlImg sd_setImageWithURL:[NSURL URLWithString:model.commentUrl] placeholderImage:nil];
    
    NSArray *imageArray = [model.commentUrl componentsSeparatedByString:@","];
    self.imageArray = imageArray;

    [self.imageViewsRectArray addObject:self.commentUrlImg];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    [self.commentUrlImg addGestureRecognizer:tap];
    
//    if (kStringIsEmpty(model.commentUrl)) {
//        self.imageBgView.hidden = YES;
//        self.imageBgView_constraint_height.constant = 0;
//    }else{
//        self.imageBgView.hidden = NO;
//        NSArray *imageArray = [model.commentUrl componentsSeparatedByString:@","];
//        CGFloat imgw = (SCREEN_WIDTH-28 - 10)/3;
//
//        for (int i = 0; i < imageArray.count; i++) {
//            UIImageView *imageView = [[UIImageView alloc]init];
//            imageView.frame = CGRectMake((imgw + 5)* (i%3), floor(i/3)*(imgw + 5), imgw, imgw);
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
//            imageView.clipsToBounds = YES;
//            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]]];
//            [self.imageBgView addSubview:imageView];
//
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
//            [imageView addGestureRecognizer:tap];
//            imageView.tag = i;
//            imageView.userInteractionEnabled = YES;
//            [self.imageViewsRectArray addObject:imageView];
//
//        }
//        self.imageArray = imageArray;
//        self.imageBgView_constraint_height.constant = ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
//    }
    
}

-(void)selectImage:(UITapGestureRecognizer *)sender{
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"menues = %ld",[singleTap view].tag);
    
    if (self.viewController) {
        if ([self.viewController isKindOfClass:[UIViewController class]]) {
            UITableView* tableView = self.tableView;
            UIWindow* window = [UIApplication sharedApplication].keyWindow;
            
            CGRect rectInbg = [self.contentView convertRect:[singleTap view].frame toView:self];
            
            // convert rect to self(cell)
            CGRect rectInCell = [self.contentView convertRect:rectInbg toView:self];
            
            // convert rect to tableview
            CGRect rectInTableView = [self convertRect:rectInCell toView:tableView];//self.superview
            
            // convert rect to window
            self.imageRect  = [tableView convertRect:rectInTableView toView:window];
        }
    }
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self.scrollView];
    
    self.touchImage = [UIImageView new];
    self.touchImage.frame = self.imageRect;
    self.touchImage.contentMode = UIViewContentModeScaleAspectFit;
    NSString *imageStr = self.imageArray[[singleTap view].tag];
    NSURL *imageUrl = [NSURL URLWithString:imageStr];
    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:nil];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.touchImage];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.touchImage.contentMode = UIViewContentModeScaleAspectFit;
        self.touchImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.scrollView.alpha = 1;
    } completion:^(BOOL finished){
        self.touchImage.hidden = YES;
        
        self.scrollView.delegate                       = self;
        self.scrollView.bounces                        = YES;
        self.scrollView.pagingEnabled                  = YES;
        self.scrollView.showsHorizontalScrollIndicator = FALSE;
        self.scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * self.imageArray.count, 0);
        for (int i = 0; i < self.imageArray.count; ++i) {
            UIImageView *imageView= [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            //            activityIndicator.frame = CGRectMake(0, 0, 100, 100);
            activityIndicator.center = imageView.center;
            [imageView addSubview:activityIndicator];
            
            NSString *imageStr = self.imageArray[i];
            NSURL *imageUrl = [NSURL URLWithString:imageStr];
            [imageView sd_setImageWithURL:imageUrl];
            imageView.tag = i;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = YES;
            [self.scrollView addSubview:imageView];
            NSLog(@"%.f  %.f",imageView.frame.size.width,imageView.frame.size.height);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageScroll)];
            [imageView addGestureRecognizer:tap];
        }
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * [singleTap view].tag , 0)];
        
        if (self.imageArray.count > 1) {
            self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 0, 40)];
            self.pageControl.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 50);
            self.pageControl.numberOfPages = self.imageArray.count;
            self.pageControl.currentPage = [singleTap view].tag;
            self.pageControl.tintColor = [UIColor lightGrayColor];
            self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
            [[UIApplication sharedApplication].keyWindow addSubview:self.pageControl];
        }
    }];
    
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
            
            CGRect rectInbg = [self.contentView convertRect:self.imageViewsRectArray[index].frame toView:self];
            
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

@end
