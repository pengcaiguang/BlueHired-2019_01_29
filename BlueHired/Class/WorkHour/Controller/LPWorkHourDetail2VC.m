//
//  LPWorkHourDetail2VC.m
//  BlueHired
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourDetail2VC.h"
#import "LPWorkHourDetailPieChartCell.h"
#import "LPTypeWorkHourCell.h"
#import "LPWorkHourScrollView.h"

static NSString *LPWorkHourDetailPieChartCellID = @"LPWorkHourDetailPieChartCell";
static NSString *LPTypeWorkHourCellID = @"LPTypeWorkHourCell";

@interface LPWorkHourDetail2VC ()
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong)UILabel *TitleLabel;
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;

@property (nonatomic, strong) UIScrollView *ViewscrollView;
@property (nonatomic, strong) NSMutableArray <LPWorkHourScrollView *>*ViewArray;

@property (nonatomic, strong) NSString *currentDateString;

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation LPWorkHourDetail2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    self.ViewscrollView = [[UIScrollView alloc] init];
    self.ViewscrollView.frame = CGRectMake(0, 50, Screen_Width,  SCREEN_HEIGHT-kNavBarHeight-50);
   
    self.ViewscrollView.delegate = self;
    self.ViewscrollView.pagingEnabled = YES;
    self.ViewscrollView.showsHorizontalScrollIndicator = FALSE;
    [self.view addSubview:self.ViewscrollView];
 
    [self setupWHTypeView];
    [self setupTitleView];

//    [self requestQueryGetMonthWageDetail];
    
//    [self.view addSubview:self.tableview];
//    self.tableview.backgroundColor = [UIColor clearColor];
//    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(50);
//        make.left.mas_equalTo(10);
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(0);
//    }];
    
}

-(void)setupTitleView{
    UIView *navigationView = [[UIView alloc]init];
    navigationView.frame = CGRectMake(0, 0, SCREEN_WIDTH-120, 49);
    navigationView.center = CGPointMake(navigationView.superview.center.x, navigationView.superview.frame.size.height/2);
    self.navigationItem.titleView = navigationView;
    
    self.TitleLabel = [[UILabel alloc] init];
    [navigationView addSubview:self.TitleLabel];
    [self.TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.equalTo(navigationView);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(SCREEN_WIDTH==320?154:200);
    }];
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];

    self.TitleLabel.textAlignment = NSTextAlignmentCenter;
    self.TitleLabel.font = [UIFont boldSystemFontOfSize:SCREEN_WIDTH==320?12:16];

    
    UIButton *leftButton = [[UIButton alloc] init];
    [navigationView addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.equalTo(self.TitleLabel.mas_left).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [leftButton setImage:[UIImage imageNamed:@"WorkHourDateLeftBT_icon"] forState:UIControlStateNormal];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftButton addTarget:self action:@selector(TouchLeftButton) forControlEvents:UIControlEventTouchUpInside];

    UIButton *RightButton = [[UIButton alloc] init];
    [navigationView addSubview:RightButton];
    [RightButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(self.TitleLabel.mas_right).offset(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(49);
        make.width.mas_equalTo(49);
    }];
    [RightButton setImage:[UIImage imageNamed:@"WorkHourDateRightBT_icon"] forState:UIControlStateNormal];
    RightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [RightButton addTarget:self action:@selector(TouchRightButton) forControlEvents:UIControlEventTouchUpInside];

}

-(void)TouchLeftButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    for (LPWorkHourScrollView *view in self.ViewArray) {
        view.KQDateString = self.KQDateString;
        view.page = view.page;
    }
}

-(void)TouchRightButton{
    NSArray *dateArr = [self.KQDateString componentsSeparatedByString:@"#"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateArr[0]];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *StartDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSDateComponents *comps2 = [[NSDateComponents alloc] init];
    [comps2 setMonth:1];
    [comps2 setDay:-1];
    NSDate *endDate = [calender dateByAddingComponents:comps2 toDate:StartDate options:0];
 
    NSString *KQ = [NSString stringWithFormat:@"%@#%@",[dateFormatter stringFromDate:StartDate],[dateFormatter stringFromDate:endDate]];
    self.KQDateString = KQ;
    self.TitleLabel.text = [self.KQDateString stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.TitleLabel.text = [self.TitleLabel.text stringByReplacingOccurrencesOfString:@"#" withString:@"—"];
    for (LPWorkHourScrollView *view in self.ViewArray) {
        view.KQDateString = self.KQDateString;
        view.page = view.page;
    }
}
-(void)setupWHTypeView{
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
     }];
    self.buttonArray = [NSMutableArray array];
    self.ViewArray = [[NSMutableArray alloc] init];
    NSArray *titleArray = @[@"工资",@"工时",@"消费"];
    if (self.WorkHourType == 4) {
        titleArray = @[@"工资",@"计件",@"消费"];
    }
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [view addSubview:button];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        button.layer.cornerRadius = 15;
        [button addTarget:self action:@selector(touchTypeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        
        LPWorkHourScrollView *view = [[LPWorkHourScrollView alloc] init];
        view.frame = CGRectMake(i*self.ViewscrollView.bounds.size.width, 0, self.ViewscrollView.bounds.size.width, self.ViewscrollView.bounds.size.height);
        view.WorkHourType = self.WorkHourType;
        view.KQDateString = self.KQDateString;
        view.page = i;
        [self.ViewscrollView addSubview:view];
        [self.ViewArray addObject:view];

    }
    self.ViewscrollView.contentSize = CGSizeMake(Screen_Width*titleArray.count, self.ViewscrollView.frame.size.height);

    
    self.buttonArray[0].backgroundColor = [UIColor baseColor];
    [self.buttonArray[0] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:13 leadSpacing:13 tailSpacing:13];
    [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(30);
    }];
    
}

-(void)touchTypeButton:(UIButton *)button{
//    NSInteger index = [self.buttonArray indexOfObject:button];
    for (UIButton *bt in self.buttonArray) {
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        bt.backgroundColor = [UIColor whiteColor];
    }
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor baseColor];
    
    NSInteger index =[self.buttonArray indexOfObject:button];
    self.currentPage = index;
    self.ViewArray[index].page = index;
    [self.ViewscrollView setContentOffset:CGPointMake(Screen_Width*index,0 ) animated:YES];
    self.ViewscrollView.bouncesZoom = NO;
    
}
#pragma mark -- UICollectionViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.ViewscrollView) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (scrollView == self.ViewscrollView) {
            if (self.currentPage != page) {
                self.currentPage = page;
                self.ViewArray[page].page = page;
                
                for (UIButton *bt in self.buttonArray) {
                    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    bt.backgroundColor = [UIColor whiteColor];
                }
                [self.buttonArray[page] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.buttonArray[page].backgroundColor = [UIColor baseColor];
            }

        }
    }
    
}
//#pragma mark - TableViewDelegate & Datasource
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 4;
//}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return CGFLOAT_MIN;
//    //    return 10;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 10;
//}
//
//- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    WEAK_SELF()
//    if (indexPath.section == 0) {
//        LPWorkHourDetailPieChartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkHourDetailPieChartCellID];
//        cell.index = indexPath.row;
//        NSLog(@"index = %ld",(long)indexPath.row);
//        cell.model = nil;
//        return cell;
//
//    }else if (indexPath.section == 1){
//        LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
//        cell.count = indexPath.section;
//        cell.Rowblock = ^(BOOL IsSelect){
//            [weakSelf.tableview reloadData];
//        };
//        return cell;
//        cell.block = ^(NSInteger row){
//
//        };
//    }else if (indexPath.section == 2){
//        LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
//        cell.count = indexPath.section;
//        cell.Rowblock = ^(BOOL IsSelect){
//            [weakSelf.tableview reloadData];
//        };
//        cell.block = ^(NSInteger row){
//
//        };
//        return cell;
//    }else{
//        LPTypeWorkHourCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTypeWorkHourCellID];
//        cell.count = indexPath.section;
//        cell.Rowblock = ^(BOOL IsSelect){
//            [weakSelf.tableview reloadData];
//        };
//        cell.block = ^(NSInteger row){
//
//        };
//        return cell;
//    }
//}
//

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 10;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
                _tableview.separatorColor = [UIColor whiteColor];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourDetailPieChartCellID bundle:nil] forCellReuseIdentifier:LPWorkHourDetailPieChartCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPTypeWorkHourCellID bundle:nil] forCellReuseIdentifier:LPTypeWorkHourCellID];
//        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourCalendarCellID bundle:nil] forCellReuseIdentifier:LPWorkHourCalendarCellID];
//        [_tableview registerNib:[UINib nibWithNibName:LPWorkHourTallyBookCellID bundle:nil] forCellReuseIdentifier:LPWorkHourTallyBookCellID];
        _tableview.showsVerticalScrollIndicator = NO;
        
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        //        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
        //            [self requestUserMaterial];
        //            [self requestSelectCurIsSign];
        //        }];
    }
    return _tableview;
}


#pragma mark - request
-(void)requestQueryGetMonthWageDetail{
    
    NSDictionary *dic = @{
                          @"type":@(self.WorkHourType),
                          @"time":self.currentDateString
                          };
    [NetApiManager requestQueryGetMonthWageDetail:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                
             }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
