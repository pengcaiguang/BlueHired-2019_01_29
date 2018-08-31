//
//  LPWorkDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkDetailVC.h"
#import "LPWorkDetailModel.h"
#import "LPWorkDetailHeadCell.h"
#import "LPWorkDetailTextCell.h"

static NSString *LPWorkDetailHeadCellID = @"LPWorkDetailHeadCell";
static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";

@interface LPWorkDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) LPWorkDetailModel *model;

@property(nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property(nonatomic,strong) UIView *lineView;


@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业详情";
    self.buttonArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self requestWorkDetail];
}

#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else{
        return 50;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 8;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [view addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        NSArray *textArray = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];
        
        CGFloat btnw = SCREEN_WIDTH/textArray.count;
        for (int i = 0; i <textArray.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(btnw*i, 0, btnw, 50);
            [button setTitle:textArray[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor baseColor] forState:UIControlStateSelected];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            [button addTarget:self action:@selector(touchTextButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            [scrollView addSubview:button];
        }
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 50);
        
        self.lineView = [[UIView alloc]init];
        self.lineView.frame = CGRectZero;
        self.lineView.backgroundColor = [UIColor baseColor];
        [scrollView addSubview:self.lineView];
        [self selectButtonAtIndex:0];
        
        return view;
    }
    return nil;
}

-(void)touchTextButton:(UIButton *)button{
    NSInteger index = button.tag;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)touchLabel:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    [self selectButtonAtIndex:index];
    [self scrollToItenIndex:index];
}
-(void)selectButtonAtIndex:(NSInteger)index{
    for (UIButton *button in self.buttonArray) {
        button.selected = NO;
    }
    self.buttonArray[index].selected = YES;;
    CGSize size = CGSizeMake(100, MAXFLOAT);//设置高度宽度的最大限度
    CGRect rect = [self.buttonArray[index].titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    CGFloat btnx = CGRectGetMinX(self.buttonArray[index].frame);
    CGFloat btnw = CGRectGetWidth(self.buttonArray[index].frame);
    CGFloat x = (btnw - rect.size.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = CGRectMake(btnx + x, 40, rect.size.width, 2);
    }];
    
}
-(void)scrollToItenIndex:(NSInteger)index{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:index inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        LPWorkDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailHeadCellID];
        return cell;
    }else{
        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - request
-(void)requestWorkDetail{
    NSDictionary *dic = @{
                          @"workId":self.workListModel.id
                          };
    [NetApiManager requestWorkDetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        self.model = [LPWorkDetailModel mj_objectWithKeyValues:responseObject];
    }];
}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailHeadCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailTextCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailTextCellID];

        
        
    }
    return _tableview;
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
