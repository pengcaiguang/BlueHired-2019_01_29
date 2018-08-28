//
//  LPInformationVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/27.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationVC.h"
#import "LPSearchBar.h"
#import "LPLabelListModel.h"

@interface LPInformationVC ()<UISearchBarDelegate>
@property(nonatomic,strong) LPLabelListModel *labelListModel;
@property(nonatomic,strong) UIView *labelListView;
@property(nonatomic,strong) UIView *lineView;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@end

@implementation LPInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    
    self.labelArray = [NSMutableArray array];
    
    [self setNavigationButton];
    [self setSearchView];
    
    [self.view addSubview:self.labelListView];
    [self.labelListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    [self requestLabellist];
    
    
    
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)setNavigationButton{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logo_Information" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.leftBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"message" WithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:nil];
}

-(void)setSearchView{
    LPSearchBar *searchBar = [self addSearchBarWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 2 * 44 - 2 * 15, 44)];
    UIView *wrapView = [[UIView alloc] initWithFrame:searchBar.frame];
    [wrapView addSubview:searchBar];
    self.navigationItem.titleView = wrapView;
}
- (LPSearchBar *)addSearchBarWithFrame:(CGRect)frame {
    
    self.definesPresentationContext = YES;
    
    LPSearchBar *searchBar = [[LPSearchBar alloc]initWithFrame:frame];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索关键字";
    [searchBar setShowsCancelButton:NO];
    [searchBar setTintColor:[UIColor lightGrayColor]];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
    }
    if (YES) {
        CGFloat height = searchBar.bounds.size.height;
        CGFloat top = (height - 28.0) / 2.0;
        CGFloat bottom = top;
        searchBar.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    }
    return searchBar;
}


-(void)setLabelListModel:(LPLabelListModel *)labelListModel{
    _labelListModel = labelListModel;
    if ([labelListModel.code integerValue] == 0) {
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [self.labelListView addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
//        NSArray *t = @[@"首页",@"军事",@"生活生活",@"社会回",@"招聘",@"信息新",@"圈子",@"我的我的",@"我",@"搜索"];
        
        CGFloat w = 0;
        for (int i = 0; i <labelListModel.data.count; i++) {
            UILabel *label = [[UILabel alloc]init];
            label.text = labelListModel.data[i].labelName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:label];
            label.textColor = [UIColor grayColor];
            CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
            CGRect rect = [label.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            CGFloat lw = rect.size.width + 30;
            w += lw;
            label.frame = CGRectMake(w - lw, 0, lw, 50);
            label.tag = i;
            label.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchLabel:)];
            [label addGestureRecognizer:tap];
            [self.labelArray addObject:label];
        }
        scrollView.contentSize = CGSizeMake(w, 50);

        self.lineView = [[UIView alloc]init];
        CGFloat s = CGRectGetWidth(self.labelArray[0].frame);
        self.lineView.frame = CGRectMake(0, 48, s, 2);
        self.lineView.backgroundColor = [UIColor baseColor];
        [scrollView addSubview:self.lineView];
        self.labelArray[0].textColor = [UIColor blackColor];
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)touchLabel:(UITapGestureRecognizer *)tap{
    CGFloat x = CGRectGetMinX(self.labelArray[[tap view].tag].frame);
    CGFloat w = CGRectGetWidth(self.labelArray[[tap view].tag].frame);
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor grayColor];
    }
    self.labelArray[[tap view].tag].textColor = [UIColor blackColor];
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(x, 48, w, 2);
    }];
}
#pragma mark - request
-(void)requestLabellist{
    NSDictionary *dic = @{
                          @"type":@(1)
                          };
    [NetApiManager requestLabellistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        self.labelListModel = [LPLabelListModel mj_objectWithKeyValues:responseObject];
    }];
}

#pragma mark - lazy
-(UIView *)labelListView{
    if (!_labelListView) {
        _labelListView = [[UIView alloc]init];
    }
    return _labelListView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
