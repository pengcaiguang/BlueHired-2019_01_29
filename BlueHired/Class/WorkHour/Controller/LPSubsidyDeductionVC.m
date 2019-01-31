//
//  LPSubsidyDeductionVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSubsidyDeductionVC.h"
#import "LPSubsidyDeductionCell.h"

static NSString *LPSubsidyDeductionCellID = @"LPSubsidyDeductionCell";

@interface LPSubsidyDeductionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSString *selectString;

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSMutableArray *selectTitleArray;

@end

@implementation LPSubsidyDeductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type == 1) {
        self.navigationItem.title = @"添加补贴记录";
        self.titleArray = @[@"全勤绩效",@"高温补贴",@"餐费补贴",@"外宿补贴",@"管理津贴",@"车费补贴",@"叉车补贴",@"夜班补贴",@"其他补贴"];
        
    }else{
        self.navigationItem.title = @"添加扣款记录";
        self.titleArray = @[@"请假扣款",@"水电费扣款",@"住宿费扣款",@"体检费扣款",@"社保扣款",@"其他扣款"];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titleArray];
    for (NSString *string in self.selectArray) {
        if (![self.titleArray containsObject:string]) {
            [arr addObject:string];
        }
        self.titleArray = [arr copy];
    }
    self.selectTitleArray = [NSMutableArray arrayWithArray:self.selectArray];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
        make.top.mas_equalTo(0);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    if (self.type == 1) {
        [button setTitle:@"自定义补贴记录" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"自定义扣款记录" forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setImage:[UIImage imageNamed:@"addItem"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width - button.titleLabel.intrinsicContentSize.width + 80, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.titleLabel.intrinsicContentSize.width -button.imageView.frame.size.width-80);
    [button addTarget:self action:@selector(touchBottomButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(touchSave)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)touchSave{
    if (self.block) {
        self.block(self.selectTitleArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchBottomButton{
        
    GJAlertText *alert = [[GJAlertText alloc]initWithTitle:self.type==1?@"自定义补贴记录":@"自定义扣款记录"
                                                   message:self.type==1?@"请输入补贴类型":@"请输入扣款类型"
                                              buttonTitles:@[@"取消",@"确定"]
                                              buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]]
                                                 MaxLength:8
                                               buttonClick:^(NSInteger buttonIndex, NSString *string) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.titleArray];
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
        
        if (string.length >8)
        {
            [self.view showLoadingMeg:@"字数不能大于8，请重新输入" time:MESSAGE_SHOW_TIME];
            return ;
        }

        if (string) {
            if (![array containsObject:string]) {
                [array addObject:string];
                self.titleArray = [array copy];
                [self.selectTitleArray addObject:string];
                [self.tableview reloadData];
            }else{
                [self.view showLoadingMeg:[NSString stringWithFormat:@"列表中已包含-%@",string] time:MESSAGE_SHOW_TIME];
            }
        }
    }];
    [alert show];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSubsidyDeductionCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSubsidyDeductionCellID];
    if ([self.selectTitleArray containsObject:self.titleArray[indexPath.row]]) {
        cell.selectButton.selected = YES;
    }else{
        cell.selectButton.selected = NO;
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPSubsidyDeductionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selectButton.selected) {
        [self.selectTitleArray removeObject:self.titleArray[indexPath.row]];
    }else{
        [self.selectTitleArray addObject:self.titleArray[indexPath.row]];
    }
    [tableView reloadData];
    
}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPSubsidyDeductionCellID bundle:nil] forCellReuseIdentifier:LPSubsidyDeductionCellID];
        
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
