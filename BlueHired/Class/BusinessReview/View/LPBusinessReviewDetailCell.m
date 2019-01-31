//
//  LPBusinessReviewDetailCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBusinessReviewDetailCell.h"
@interface LPBusinessReviewDetailCell ()<UIScrollViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)LZImageBrowserManger *imageBrowserManger;

@end
@implementation LPBusinessReviewDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userUrlImgView.layer.masksToBounds = YES;
    self.userUrlImgView.layer.cornerRadius = 20;
    self.imageViewsRectArray = [NSMutableArray array];
    self.commentContentLabel.delegate = self;
    self.commentContentLabel.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
    self.commentContentLabel.scrollEnabled = NO;
}

-(void)setModel:(LPMechanismcommentDetailDataModel *)model{
    _model = model;
    [self.userUrlImgView sd_setImageWithURL:[NSURL URLWithString:model.userUrl] placeholderImage:[UIImage imageNamed:@"Head_image"]];
    self.userNameLabel.text = model.userName;
    self.commentContentLabel.text = model.commentContent;
    
    NSArray *array = [self getSeparatedLinesFromLabel:self.commentContentLabel];
    if (array.count>4) {
        if (model.IsAllShow == NO) {
            //组合需要显示的文本
            NSString *str = @"...[查看全部]";
            NSString *line4String =  [array[3] stringByReplacingOccurrencesOfString:@"\n" withString:@""];;
            NSString *line4Content = [NSString stringWithFormat:@"%@%@",line4String,str];
            NSString *showText;
            CGSize size =[line4Content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            while (size.width>SCREEN_WIDTH-28) {
                line4String = [line4String substringToIndex:line4String.length-1];
                line4Content =[NSString stringWithFormat:@"%@%@",line4String,str];
                size =[line4Content sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
            }
            showText = [NSString stringWithFormat:@"%@%@%@%@", array[0], array[1], array[2], line4Content];
            //设置label的attributedText
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:showText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
            [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor baseColor]} range:NSMakeRange(showText.length-6, 6)];
            [attStr addAttribute:NSLinkAttributeName
                           value:@"All://"
                           range:NSMakeRange(showText.length-6, 6)];
            self.commentContentLabel.attributedText = attStr;
         }else{
            //组合需要显示的文本
            NSString *str = @"[收起]";
             NSString *line4Content = [NSString stringWithFormat:@"%@%@",model.commentContent,str];
 
            //设置label的attributedText
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:line4Content attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
            [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor baseColor]} range:NSMakeRange(line4Content.length-4, 4)];
            [attStr addAttribute:NSLinkAttributeName
                           value:@"NoAll://"
                           range:NSMakeRange(line4Content.length-4, 4)];
            self.commentContentLabel.attributedText = attStr;
        }
    }else{
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:model.commentContent attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.commentContentLabel.attributedText = attStr;
    }
    
    self.workEnvironScoreLabel.text = [NSString stringWithFormat:@"工作环境：%@分",model.workEnvironScore];
    self.sleepEnvironScoreLabel.text = [NSString stringWithFormat:@"住宿环境：%@分",model.sleepEnvironScore];
    self.foodEnvironScoreLabel.text = [NSString stringWithFormat:@"餐饮环境：%@分",model.foodEnvironScore];
    self.manageEnvironScoreLabel.text = [NSString stringWithFormat:@"餐饮环境：%@分",model.manageEnvironScore];
    self.moneyEnvironScoreLabel.text = [NSString stringWithFormat:@"薪资福利：%@分",model.moneyEnvironScore];

    for (UIView *view in self.imageBgView.subviews) {
        [view removeFromSuperview];
    }
    if (kStringIsEmpty(model.commentUrl)) {
        self.imageBgView.hidden = YES;
        self.imageBgView_constraint_height.constant = 0;
    }else{
        self.imageBgView.hidden = NO;
        NSArray *imageArray = [model.commentUrl componentsSeparatedByString:@";"];
        CGFloat imgw = (SCREEN_WIDTH-28 - 10)/3;
        self.imageViewsRectArray = [NSMutableArray array];
        for (int i = 0; i < imageArray.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            imageView.frame = CGRectMake((imgw + 5)* (i%3), floor(i/3)*(imgw + 5), imgw, imgw);
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"NoImage"];
    
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageArray[i]] placeholderImage:[UIImage imageNamed:@"NoImage"]];
             [self.imageBgView addSubview:imageView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectImage:)];
            [imageView addGestureRecognizer:tap];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            [self.imageViewsRectArray addObject:imageView];
            
        }
        self.imageArray = imageArray;
        self.imageBgView_constraint_height.constant = ceil(imageArray.count/3.0)*imgw + floor(imageArray.count/3)*5;
        
        LZImageBrowserManger *imageBrowserManger = [LZImageBrowserManger imageBrowserMangerWithUrlStr:self.imageArray originImageViews:self.imageViewsRectArray originController:[UIWindow visibleViewController] forceTouch:NO forceTouchActionTitles:@[] forceTouchActionComplete:^(NSInteger selectIndex, NSString *title) {
            NSLog(@"当前选中%ld--标题%@",(long)selectIndex, title);
        }];
        _imageBrowserManger = imageBrowserManger;
        
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
//    [self.touchImage sd_setImageWithURL:imageUrl placeholderImage:nil];
//
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
//            [imageView sd_setImageWithURL:imageUrl];
//            imageView.tag = i;
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.userInteractionEnabled = YES;
//            [self.scrollView addSubview:imageView];
//            NSLog(@"%.f  %.f",imageView.frame.size.width,imageView.frame.size.height);
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeImageScroll)];
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

- (NSArray *)getSeparatedLinesFromLabel:(UITextView *)label
{
    NSString *text = [label text];
    UIFont   *font = [label font];
    CGRect    rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    //    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    CGPathAddRect(path, NULL, CGRectMake(0,0,SCREEN_WIDTH-28,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines)
    {
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
    
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
        if ([[URL scheme] isEqualToString:@"All"]) {
            NSLog(@"点击了全部");
            self.model.IsAllShow = YES;
            if (self.Block) {
                self.Block();
            }
                return NO;
        }else if ([[URL scheme] isEqualToString:@"NoAll"]){
            NSLog(@"收起");
            self.model.IsAllShow = NO;
            if (self.Block) {
                self.Block();
            }
            return NO;
        }
          return YES;
}
@end
