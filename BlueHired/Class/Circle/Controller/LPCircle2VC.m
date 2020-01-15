//
//  LPCircle2VC.m
//  BlueHired
//
//  Created by iMac on 2019/12/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPCircle2VC.h"
#import "LPCircleView.h"
#import "LPAddMoodeVC.h"
#import "LPInformationSearchVC.h"


@interface LPCircle2VC ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <UIButton *>*BtnArr;
@property (nonatomic,strong) UIView *LineV;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LPCircleView *>*CircleViewArr;
@property (nonatomic,assign) NSInteger selectType;

@property (nonatomic,assign) BOOL isGetData;

@end

@implementation LPCircle2VC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setNavArrView];
 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.isGetData == YES) {
        [self.CircleViewArr[self.selectType] GetCircleList];
    }
    self.isGetData = YES;
}

 

- (void)setNavArrView{
        
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    self.scrollview = [[UIScrollView alloc] init];
    [self.view addSubview:self.scrollview];
    self.scrollview.frame = CGRectMake(0,
                                                LENGTH_SIZE(0),
                                                Screen_Width,
                                                SCREEN_HEIGHT - kBottomBarHeight - kNavBarHeight - kTabbarHeight );
    
//    UIView *leftBarButtonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -LENGTH_SIZE(26) , 44)];
    UIView *leftBarButtonView = [[UIView alloc]init];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              self.navigationItem.titleView = leftBarButtonView;
              [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                  if ([DeviceUtils systemVersion]<10.0){
                      make.height.mas_offset(64);
                      make.width.mas_offset(SCREEN_WIDTH);
                  }else{
                      make.height.mas_offset(44);
                      make.width.mas_offset(SCREEN_WIDTH-LENGTH_SIZE(26));
                  }

              }];
       });
    
//    if (@available(iOS 11.0, *)) {
//        if (@available(iOS 13.0, *)) {
//            self.navigationItem.titleView = leftBarButtonView;
//
//                   [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//                          make.width.mas_offset(SCREEN_WIDTH-LENGTH_SIZE(26));
//                          make.height.mas_offset(44);
//                      }];
//        }else{
//            leftBarButtonView.frame = CGRectMake(0, 0, SCREEN_WIDTH -LENGTH_SIZE(26) , 44);
//            self.navigationItem.titleView = leftBarButtonView;
//
//        }
//
//    }else{
//        self.navigationItem.titleView = leftBarButtonView;
//
//        [self.navigationItem.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//               make.width.mas_offset(SCREEN_WIDTH-LENGTH_SIZE(26));
//               make.height.mas_offset(44);
//           }];
//    }
    
   
    leftBarButtonView.userInteractionEnabled = YES;

    self.BtnArr = [[NSMutableArray alloc] init];
    self.CircleViewArr = [[NSMutableArray alloc] init];
    NSArray *TitleStrArr = @[@"广场",@"关注",@"我的"];

    self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*TitleStrArr.count,SCREEN_HEIGHT - kBottomBarHeight - kNavBarHeight - kTabbarHeight );
    self.scrollview.pagingEnabled = YES;
    self.scrollview.showsHorizontalScrollIndicator = NO;
    self.scrollview.delegate = self;
       
    for(NSInteger i = 0 ;i < TitleStrArr.count ; i++){

        UIButton *Btn = [[UIButton alloc] init];
        [leftBarButtonView addSubview:Btn];
        [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.width.mas_offset(45);
            make.height.mas_offset(44);
            if ([DeviceUtils systemVersion]<10.0){
                make.left.mas_offset(13+i*55);
             }else{
                make.left.mas_offset(i*55);
             }
        }];
        
        
        [Btn setTitle:TitleStrArr[i] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        Btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [Btn addTarget:self action:@selector(touchBtnArr:) forControlEvents:UIControlEventTouchUpInside];
        Btn.tag = i;
        [self.BtnArr addObject:Btn];
        
        LPCircleView *view = [[LPCircleView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                           0,
                                                                                           SCREEN_WIDTH,
                                                                                           SCREEN_HEIGHT - kBottomBarHeight- kNavBarHeight - kTabbarHeight)];
        view.CircleStatue = i;
//        view.superViewArr = self.MyOrderViewArr;
        [view GetCircleList];
        [self.CircleViewArr addObject:view];
        [self.scrollview addSubview:view];
    }
    
    UIView *lineV = [[UIView alloc] init];
    self.LineV = lineV;
    [leftBarButtonView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(24);
        make.height.mas_offset(2);
        make.bottom.mas_offset(-5);
        make.centerX.equalTo(self.BtnArr[0]);
    }];
    lineV.backgroundColor = [UIColor colorWithHexString:@"333333"];
    
    UIButton *SearchCircle = [[UIButton alloc] init];
    [leftBarButtonView addSubview:SearchCircle];
    [SearchCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.width.mas_offset(24);
        make.height.mas_offset(44);
        if ([DeviceUtils systemVersion]<10.0){
            make.right.mas_offset(-13);
        }else{
            make.right.mas_offset(0);
        }
    }];
    [SearchCircle setImage:[UIImage imageNamed:@"Circle_search"] forState:UIControlStateNormal];
    [SearchCircle addTarget:self action:@selector(touchSearchCircle:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addCircle = [[UIButton alloc] init];
    [leftBarButtonView addSubview:addCircle];
    [addCircle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(0);
        make.width.mas_offset(24);
        make.height.mas_offset(44);
        make.right.equalTo(SearchCircle.mas_left).offset(-13);
    }];
    [addCircle setImage:[UIImage imageNamed:@"Circle_add"] forState:UIControlStateNormal];
    [addCircle addTarget:self action:@selector(touchAddCircle:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self touchBtnArr:self.BtnArr[0]];
    });
    
}
 
 
#pragma mark - Touch
- (void)touchAddCircle:(UIButton *)sender{
    if ([LoginUtils validationLogin:self]) {
        LPAddMoodeVC *vc = [[LPAddMoodeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        WEAK_SELF()
        vc.Senderblock = ^{
            [weakSelf touchBtnArr:self.BtnArr[0]];
            [weakSelf.CircleViewArr[0] GetDirectCircleList];
            [weakSelf.CircleViewArr[0].tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
    }
}

- (void)touchSearchCircle:(UIButton *)sender{
    LPInformationSearchVC *vc = [[LPInformationSearchVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.Type = 3;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchBtnArr:(UIButton *)sender{
    if (!sender.selected) {
        for (UIButton *btn in self.BtnArr) {
            btn.selected = NO;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        }
        sender.selected = YES;
        sender.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
        self.selectType = sender.tag;
         [UIView animateWithDuration:0.25 animations:^{
             self.scrollview.contentOffset = CGPointMake(SCREEN_WIDTH*sender.tag,0 );
        }];
        
 
        [self.CircleViewArr[sender.tag] GetCircleList];
        
        [self.LineV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(LENGTH_SIZE(22));
            make.height.mas_offset(LENGTH_SIZE(2));
            make.bottom.mas_offset(LENGTH_SIZE(-4));
            make.centerX.equalTo(sender);
            
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.LineV.superview layoutIfNeeded];
        }];

    }
    
}


#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self touchBtnArr:self.BtnArr[page]];
}


@end
