//
//  LPBusinessReviewDetailSalaryCell.m
//  BlueHired
//
//  Created by peng on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBusinessReviewDetailSalaryCell.h"
@interface LPBusinessReviewDetailSalaryCell ()<UIScrollViewDelegate>
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;

@end
@implementation LPBusinessReviewDetailSalaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = LENGTH_SIZE(32.0)/2;
    self.imageViewsRectArray = [NSMutableArray array];
    self.lineView.layer.borderColor = [UIColor blackColor].CGColor;
    self.lineView.layer.borderWidth = 1.0;
    
    self.BGView.layer.cornerRadius = 6;
    self.BGView.layer.borderWidth = 1;
    self.BGView.layer.borderColor = [UIColor colorWithHexString:@"#E0E0E0"].CGColor;
    
    self.commentUrlImg.layer.cornerRadius = 6;
//    for (UIView *view in self.contentView.subviews) {
//        if (view.tag == 100) {
//            view.layer.borderWidth= 0.5;
//            view.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        }
//    }
    
}
-(void)setModel:(LPMechanismcommentDetailDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.userNameLabel.text = model.userName;
    
    self.commentContentLabel.text = model.commentContent;
    self.workEnvironScoreLabel.text = [NSString stringWithFormat:@"%@",model.workEnvironScore];
    self.foodEnvironScoreLabel.text = [NSString stringWithFormat:@"%.2f",model.foodEnvironScore.floatValue];
    self.moneyEnvironScoreLabel.text = [NSString stringWithFormat:@"%.2f",model.moneyEnvironScore.floatValue];
    
    
    [self.commentUrlImg sd_setImageWithURL:[NSURL URLWithString:model.commentUrl] placeholderImage:[UIImage imageNamed:@"pic_no"]];
    
  
    
    NSArray *imageArray = [model.commentUrl componentsSeparatedByString:@";"];
    self.imageArray = imageArray;

    [self.imageViewsRectArray addObject:self.commentUrlImg];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
    [self.commentUrlImg addGestureRecognizer:tap];
    
    
    LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:self.imageArray originImageViews:self.imageViewsRectArray originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
        NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
    }];
    _imageBrowserManger = imageBrowserManger;
    
    
}

-(void)selectImage:(UITapGestureRecognizer *)sender{
    
    if (self.model.commentUrl.length == 0) {
        return;
    }
    
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSLog(@"menues = %ld",[singleTap view].tag);
    _imageBrowserManger.selectPage = singleTap.view.tag;
    [_imageBrowserManger showImageBrowser];
 
    
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
    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"NoImage"]];
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
