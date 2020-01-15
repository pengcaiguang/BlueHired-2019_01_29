//
//  LPCollectionVC.m
//  BlueHired
//
//  Created by peng on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCollectionVC.h"
 #import "AppDelegate.h"
#import "LPCollectionView.h"
 
@interface LPCollectionVC ()<UISearchBarDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) NSMutableArray <LPCollectionView *> *ViewArr;

@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) BOOL selectAll;
@property(nonatomic,assign) NSInteger selectType;
@property(nonatomic,strong) UIButton *allButton;
@property(nonatomic,strong) UIButton *deleteBt;

@end

@implementation LPCollectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ViewArr = [[NSMutableArray alloc] init];
    [self setNavigationButton];
    [self setupTitleView];

     
    [self setBottomView];

   
}

- (void)viewDidDisappear:(BOOL)animated{
     [super viewDidDisappear:animated];
     [self.ViewArr[2].PlayerView closeClick];
}

// 这个方法返回支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAll;
}

// 这个返回是否自动旋转
- (BOOL)shouldAutorotate{
  return kAppDelegate.allowRotation ;
}


-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc] init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 44);
    self.navigationItem.titleView = navigationView;


    self.buttonArray = [NSMutableArray array];
    NSArray *titleArray = @[@"资讯",@"招聘",@"视频"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-120-40)/titleArray.count*i+10, 0, (SCREEN_WIDTH-120-40)/titleArray.count, 44)];
        [navigationView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(touchTitleButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
    }
    self.buttonArray[0].selected = YES;


    self.lineView = [[UIView alloc]initWithFrame:CGRectMake(self.buttonArray[0].lx_x, 42, self.buttonArray[0].lx_width, 2)];
    [navigationView addSubview:self.lineView];
 
    self.lineView.backgroundColor = [UIColor baseColor];

    self.scrollview = [[UIScrollView alloc] init];
        [self.view addSubview:self.scrollview];
    
        self.scrollview.frame = CGRectMake(0,
                                               LENGTH_SIZE(0),
                                               Screen_Width,
                                               SCREEN_HEIGHT - kNavBarHeight );

        self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*titleArray.count,SCREEN_HEIGHT  - kNavBarHeight );
        self.scrollview.pagingEnabled = YES;
        self.scrollview.showsHorizontalScrollIndicator = NO;
        self.scrollview.delegate = self;
     
        for (NSInteger i =0 ; i < titleArray.count ; i++) {
            LPCollectionView *view = [[LPCollectionView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH,
                                                                                      0,
                                                                                      SCREEN_WIDTH,
                                                                                      SCREEN_HEIGHT - kNavBarHeight)];
            view.index = i;
            [view GetList];
     
            [self.ViewArr addObject:view];
            [self.scrollview addSubview:view];
        }
    

}
-(void)setBottomView{
    UIButton *selectButton = [[UIButton alloc]init];
    [self.view addSubview:selectButton];
    self.allButton = selectButton;
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        //        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.width.mas_equalTo(SCREEN_WIDTH - LENGTH_SIZE(180) );
        make.height.mas_equalTo(LENGTH_SIZE(49));
    }];
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    selectButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    selectButton.titleEdgeInsets = UIEdgeInsetsMake(0, LENGTH_SIZE(30), 0, 0);
    selectButton.imageEdgeInsets = UIEdgeInsetsMake(0, LENGTH_SIZE(20), 0, 0);
    selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [selectButton addTarget:self action:@selector(touchSelectButton:) forControlEvents:UIControlEventTouchUpInside];
    selectButton.backgroundColor = [UIColor whiteColor];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    [self.view addSubview:deleteButton];
    self.deleteBt = deleteButton;
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
        make.height.mas_equalTo(LENGTH_SIZE(49));
        make.width.mas_equalTo(LENGTH_SIZE(180));
    }];
    deleteButton.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    [deleteButton addTarget:self action:@selector(touchDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    self.allButton.hidden = YES;
    self.deleteBt.hidden = YES;
    self.allButton.selected = NO;
    
    for (LPCollectionView *view  in self.ViewArr) {
        view.AllButton = self.allButton;
    }
}
-(void)touchSelectButton:(UIButton *)button{
    button.selected = !button.isSelected;
    self.ViewArr[self.selectType].AllButton = button;
}

-(void)touchDeleteButton:(UIButton *)button{
    
    [self.ViewArr[self.selectType] deleteInfo];

}

-(void)touchManagerButton{
    if (self.isSelect) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = NO;
 
        self.allButton.hidden = YES;
        self.deleteBt.hidden = YES;
        self.allButton.selected = NO;
     }else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
        self.isSelect = YES;
 
        self.allButton.hidden = NO;
        self.deleteBt.hidden = NO;
     }
    if (self.selectType == 2) {
        [self.ViewArr[self.selectType].PlayerView closeClick];
    }
    self.ViewArr[self.selectType].selectStatus = self.isSelect;
    //    [self.collectionView reloadData];
}

-(void)touchTitleButton:(UIButton *)button{
    NSInteger index = [self.buttonArray indexOfObject:button];
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)selectButtonAtIndex:(NSInteger)index{
    for (UIButton *btn in self.buttonArray) {
        btn.selected = NO;
    }
    self.buttonArray[index].selected = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(2);
            make.width.mas_equalTo(self.buttonArray[index].mas_width);
            make.centerX.equalTo(self.buttonArray[index]);
        }];
        [self.lineView.superview layoutIfNeeded];
    }];
 
}
 
-(void)scrollToItenIndex:(NSInteger)index{
    self.selectType =index;
     if (self.isSelect) {
        self.isSelect = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
         self.allButton.hidden = YES;
        self.deleteBt.hidden = YES;
        self.allButton.selected = NO;
         for (LPCollectionView *view in self.ViewArr) {
             view.selectStatus = NO;
         }
    }
    [self.ViewArr[2].PlayerView closeClick];
 
    [self.scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*index,0 )animated:YES];

}
#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [self selectButtonAtIndex:page];
    [self scrollToItenIndex:page];

}

 

@end
