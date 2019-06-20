//
//  LPSalaryDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/12.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSalaryDetailVC.h"

@interface LPSalaryDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSArray *itemArray;
@end

@implementation LPSalaryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.navigationItem.title = @"工资明细";
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.right.top.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(60));
    }];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *month = [[UILabel alloc] init];
    [view addSubview:month];
    [month mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(13);
        make.centerY.equalTo(view);
    }];
    month.textColor = [UIColor colorWithHexString:@"#333333"];
    month.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    month.text = [DataTimeTool getDataTime:self.currentDateString DateFormat:@"yyyy年MM月"];
    
    UILabel *money = [[UILabel alloc] init];
    [view addSubview:money];
    [money mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.mas_offset(-13);
        make.centerY.equalTo(view);
    }];
    money.textColor = [UIColor baseColor];
    money.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    money.text = [NSString stringWithFormat:@"总计：%.2f元",self.model.actualPay.floatValue];
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.right.bottom.mas_offset(0);
        make.top.mas_offset(LENGTH_SIZE(70));
    }];
    NSMutableArray *mu = [NSMutableArray arrayWithArray:[self.model.salaryDetails componentsSeparatedByString:@";"]];
    [mu removeObject:@""];
    
    self.itemArray = [mu copy];
    
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rid];
    }
    NSArray *array = [self.itemArray[indexPath.row] componentsSeparatedByString:@":"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",array[0]];
    cell.detailTextLabel.text = array[1];
    cell.textLabel.font = FONT_SIZE(15);
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    cell.detailTextLabel.font = FONT_SIZE(15);
    cell.detailTextLabel.textColor = [UIColor baseColor];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request
-(void)requestQuerySalarydetail{
    NSDictionary *dic = @{
                          @"id":@""
                          };
    [NetApiManager requestQuerySalarydetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];
//        [_tableview registerNib:[UINib nibWithNibName:LPSalaryBreakdownCellID bundle:nil] forCellReuseIdentifier:LPSalaryBreakdownCellID];
        
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
