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

@property(nonatomic,strong) NSArray *textArray;
@property(nonatomic,strong) NSMutableArray <UIButton *> *bottomButtonArray;


@end

@implementation LPWorkDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"企业详情";
    self.buttonArray = [NSMutableArray array];
    self.bottomButtonArray = [NSMutableArray array];
    self.textArray = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];

    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];
    [self setBottomView];
    [self requestWorkDetail];
}

-(void)setBottomView{
    
    UIView *bottomBgView = [[UIView alloc]init];
    [self.view addSubview:bottomBgView];
    [bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-136);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    UIButton *signUpButton = [[UIButton alloc]init];
    [self.view addSubview:signUpButton];
    [signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(136);
    }];
    [signUpButton setTitle:@"入职报名" forState:UIControlStateNormal];
    [signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signUpButton.backgroundColor = [UIColor baseColor];
    signUpButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    NSArray *imgArray = @[@"collection_normal",@"share_btn",@"customersService"];
    NSArray *titleArray = @[@"收藏",@"分享",@"咨询"];
    for (int i =0; i<titleArray.count; i++) {
        UIButton *button = [[UIButton alloc]init];
        [bottomBgView addSubview:button];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"#424242"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imgArray[i]] forState:UIControlStateNormal];
        if (i == 0) {
            [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        button.tag = i;
        [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomButtonArray addObject:button];
    }
    [self.bottomButtonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [self.bottomButtonArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    for (UIButton *button in self.bottomButtonArray) {
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width, -button.imageView.frame.size.height, 0);
        button.imageEdgeInsets = UIEdgeInsetsMake(-button.titleLabel.intrinsicContentSize.height, 0, 0, -button.titleLabel.intrinsicContentSize.width);
    }
}

-(void)touchBottomButton:(UIButton *)button{
    if ([LoginUtils validationLogin:self]) {
        NSInteger index = button.tag;
        NSLog(@"%ld",index);
    }
}

#pragma mark - setdata
-(void)setModel:(LPWorkDetailModel *)model{
    _model = model;
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }else if (section == 1) {
        return 50;
    }else{
        return 20;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 6;
    }else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [view addSubview:scrollView];
        scrollView.showsHorizontalScrollIndicator = NO;
        
        CGFloat btnw = SCREEN_WIDTH/self.textArray.count;
        for (int i = 0; i <self.textArray.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            button.frame = CGRectMake(btnw*i, 0, btnw, 50);
            [button setTitle:self.textArray[i] forState:UIControlStateNormal];
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
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
        cell.detailTitleLabel.text = self.textArray[indexPath.row];
        if (indexPath.row == 0) {
            NSString *string=[self.model.data.workDemand stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 1){
            NSString *string=[self.model.data.workSalary stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 2){
            NSString *string=[self.model.data.eatSleep stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 3){
            NSString *string=[self.model.data.workTime stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 4){
            NSString *string=[self.model.data.workKnow stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }else if (indexPath.row == 5){
            NSString *string=[self.model.data.remarks stringByReplacingOccurrencesOfString:@"<p>"withString:@" "];
            string = [string stringByReplacingOccurrencesOfString:@"</p>"withString:@"\n"];
            cell.detailLabel.text = string;
        }
        
        return cell;
    }else{
        if (indexPath.row == 0) {
            LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
            cell.detailTitleLabel.text = @"企业简介";
            cell.detailLabel.text = self.model.data.mechanismDetails;
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.imageView.image = [UIImage imageNamed:@"detail_location"];
            cell.textLabel.textColor = [UIColor colorWithHexString:@"#444444"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = [NSString stringWithFormat:@"地址：%@",self.model.data.mechanismAddress];
            return cell;
        }
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
