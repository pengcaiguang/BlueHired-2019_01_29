//
//  LPMyOrderVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/24.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMyOrderVC.h"
#import "LPMyOrderView.h"


@interface LPMyOrderVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <UIButton *>*TypeArr;
@property (nonatomic,strong) UIButton *selectTypeBtn;
@property (nonatomic,strong) UIView *LineV;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LPMyOrderView *>*MyOrderViewArr;
@end

@implementation LPMyOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的订单";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    self.TypeArr = [[NSMutableArray alloc] init];
    self.MyOrderViewArr = [[NSMutableArray alloc] init];
    [self initView];
}


 -(void)initView{
     UIView *SelectView = [[UIView alloc] init];
     [self.view addSubview:SelectView];
     [SelectView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.mas_offset(0);
         make.height.mas_offset(LENGTH_SIZE(40));
     }];
     SelectView.backgroundColor =[UIColor whiteColor];
     NSArray *arr = @[@"全部",@"待支付",@"待发货",@"已完成",@"已退还"];

     for (NSInteger i =0 ; i < arr.count ; i++) {
         UIButton *btn = [[UIButton alloc] init];
         [SelectView addSubview:btn];
         [btn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
         [btn setTitle:arr[i] forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(TouchTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
         btn.titleLabel.font = FONT_SIZE(14);
         btn.tag = i;
         [self.TypeArr addObject:btn];
     }
     
     [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
 //    [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:SCREEN_WIDTH/3 leadSpacing:0 tailSpacing:0];
     [self.TypeArr mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.bottom.mas_offset(0);
     }];
     self.TypeArr[0].selected = YES;
     self.selectTypeBtn = self.TypeArr[0];
     
     self.LineV = [[UIView alloc] init];
     [SelectView addSubview:self.LineV];
     [self.LineV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_offset(LENGTH_SIZE(22));
         make.height.mas_offset(LENGTH_SIZE(2));
         make.bottom.mas_offset(LENGTH_SIZE(-4));
         make.centerX.equalTo(self.TypeArr[0]);
     }];
     self.LineV.backgroundColor = [UIColor baseColor];

     
      
     self.scrollview = [[UIScrollView alloc] init];
     [self.view addSubview:self.scrollview];
 //    [self.scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
 //        make.left.mas_equalTo(0);
 //        make.right.mas_equalTo(0);
 //        make.bottom.equalTo(addBtn.mas_top);
 //        make.top.equalTo(SelectView.mas_bottom).offset(10);
 //    }];
     self.scrollview.frame = CGRectMake(0,
                                            LENGTH_SIZE(50),
                                            Screen_Width,
                                            SCREEN_HEIGHT - LENGTH_SIZE(50) - kNavBarHeight );

     self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*arr.count,SCREEN_HEIGHT - LENGTH_SIZE(50) - kNavBarHeight );
     self.scrollview.pagingEnabled = YES;
     self.scrollview.showsHorizontalScrollIndicator = NO;
     self.scrollview.delegate = self;
  
     for (NSInteger i =0 ; i < arr.count ; i++) {
         LPMyOrderView *view = [[LPMyOrderView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                   0,
                                                                                   SCREEN_WIDTH,
                                                                                   SCREEN_HEIGHT - LENGTH_SIZE(50)- kNavBarHeight)];
         view.MyOrderStatus = i;
//         view.ArrBtn = self.TypeArr;
         view.superViewArr = self.MyOrderViewArr;
         [view GetOrderList];
         [self.MyOrderViewArr addObject:view];
         [self.scrollview addSubview:view];
     }
     
 
     
 }
#pragma mark - Touch -

-(void)TouchTypeBtn:(UIButton *)sender{
    if (!sender.selected) {
        for (UIButton *btn in self.TypeArr) {
            btn.selected = NO;
        }
        sender.selected = YES;
        self.selectTypeBtn = sender;
        [self.LineV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(LENGTH_SIZE(22));
            make.height.mas_offset(LENGTH_SIZE(2));
            make.bottom.mas_offset(LENGTH_SIZE(-4));
            make.centerX.equalTo(sender);
            
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.LineV.superview layoutIfNeeded];
        }];
        [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*sender.tag,0 )animated:YES];
    }
}



#pragma mark - ScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self TouchTypeBtn:self.TypeArr[page]];
}



@end
