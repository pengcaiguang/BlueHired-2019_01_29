//
//  LPSetVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSetVC.h"

@interface LPSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@end

@implementation LPSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置中心";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-120);
        make.top.mas_equalTo(0);
    }];
    if (AlreadyLogin) {
        [self setLogoutButton];
    }
}
-(void)setLogoutButton{
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-60);
    }];
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor baseColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(touchLogoutButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchLogoutButton{
    NSLog(@"退出登陆");
    [self requestSignout];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:rid];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#343434"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#939393"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"意见反馈";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"关注微信公众号";
    }else if (indexPath.row == 2) {
        cell.textLabel.text = @"关于我们";
    }else if (indexPath.row == 3) {
        cell.textLabel.text = @"检查更新";
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本%@",app_build];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - request
-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            kUserDefaultsSave(@"0", kLoginStatus);
            [self.navigationController popViewControllerAnimated:YES];
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        
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
