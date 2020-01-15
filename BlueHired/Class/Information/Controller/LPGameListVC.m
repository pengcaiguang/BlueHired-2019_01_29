//
//  LPGameListVC.m
//  BlueHired
//
//  Created by iMac on 2019/11/15.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPGameListVC.h"
#import "LPGameListView.h"

@interface LPGameListVC ()<UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <UIButton *>*TypeArr;
@property (nonatomic,strong) UIButton *selectTypeBtn;
@property (nonatomic,strong) UIView *LineV;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LPGameListView *>*ViewArr;
@end

@implementation LPGameListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"休闲游戏";
    self.TypeArr = [[NSMutableArray alloc] init];
    self.ViewArr = [[NSMutableArray alloc] init];
    [self initView];
}


 -(void)initView{
     
     UIImageView *imageView = [[UIImageView alloc] init];
     [self.view addSubview:imageView];
     [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.mas_offset(0);
         make.height.mas_offset(LENGTH_SIZE(120));
     }];
     imageView.image  = [UIImage imageNamed:@"Game_banner"];
     
     UIView *SelectView = [[UIView alloc] init];
     [self.view addSubview:SelectView];
     [SelectView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_offset(LENGTH_SIZE(120));
         make.left.right.mas_offset(0);
         make.height.mas_offset(LENGTH_SIZE(50));
     }];
     SelectView.backgroundColor =[UIColor whiteColor];
     NSArray *arr = @[@"热门游戏",@"棋牌类",@"休闲类"];

     for (NSInteger i =0 ; i < arr.count ; i++) {
         UIButton *btn = [[UIButton alloc] init];
         [SelectView addSubview:btn];
         [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
         [btn setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
         [btn setTitle:arr[i] forState:UIControlStateNormal];
         [btn addTarget:self action:@selector(TouchTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
         btn.titleLabel.font = FONT_SIZE(16);
         btn.tag = i;
         [self.TypeArr addObject:btn];
     }
     
     [self.TypeArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
 
     [self.TypeArr mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.bottom.mas_offset(0);
     }];
     self.TypeArr[0].selected = YES;
     self.selectTypeBtn = self.TypeArr[0];
     
     self.LineV = [[UIView alloc] init];
     [SelectView addSubview:self.LineV];
     [self.LineV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_offset(LENGTH_SIZE(30));
         make.height.mas_offset(LENGTH_SIZE(2));
         make.bottom.mas_offset(LENGTH_SIZE(-1));
         make.centerX.equalTo(self.TypeArr[0]);
     }];
     self.LineV.backgroundColor = [UIColor baseColor];

     UIView *LineV1 = [[UIView alloc] init];
     [SelectView addSubview:LineV1];
     [LineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.mas_offset(LENGTH_SIZE(1));
         make.bottom.left.right.mas_offset(LENGTH_SIZE(0));
     }];
     LineV1.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
     
     UIView *LineV2 = [[UIView alloc] init];
     [SelectView addSubview:LineV2];
     [LineV2 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_offset(LENGTH_SIZE(1));
         make.height.mas_offset(LENGTH_SIZE(27));
         make.centerY.equalTo(SelectView);
         make.left.equalTo(self.TypeArr[1].mas_left);
     }];
     LineV2.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
     
     UIView *LineV3 = [[UIView alloc] init];
     [SelectView addSubview:LineV3];
     [LineV3 mas_makeConstraints:^(MASConstraintMaker *make) {
         make.width.mas_offset(LENGTH_SIZE(1));
         make.height.mas_offset(LENGTH_SIZE(27));
         make.centerY.equalTo(SelectView);
         make.left.equalTo(self.TypeArr[1].mas_right);
     }];
     LineV3.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
     
     
      
     self.scrollview = [[UIScrollView alloc] init];
     [self.view addSubview:self.scrollview];
 
     self.scrollview.frame = CGRectMake(0,
                                            LENGTH_SIZE(170),
                                            Screen_Width,
                                            SCREEN_HEIGHT - LENGTH_SIZE(170) - kNavBarHeight );

     self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*arr.count,SCREEN_HEIGHT - LENGTH_SIZE(170) - kNavBarHeight );
     self.scrollview.pagingEnabled = YES;
     self.scrollview.showsHorizontalScrollIndicator = NO;
     self.scrollview.delegate = self;
  
     for (NSInteger i =0 ; i < arr.count ; i++) {
         LPGameListView *view = [[LPGameListView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                   0,
                                                                                   SCREEN_WIDTH,
                                                                                   SCREEN_HEIGHT - LENGTH_SIZE(170)- kNavBarHeight)];
         view.GameStatus = i;
         [view GetList];
         [self.ViewArr addObject:view];
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
            make.bottom.mas_offset(LENGTH_SIZE(-1));
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
