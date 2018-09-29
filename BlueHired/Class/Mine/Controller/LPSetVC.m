//
//  LPSetVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSetVC.h"
#import "LPFeedBackVC.h"

@interface LPSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) UIView *alertBgView;
@property(nonatomic,strong) UIView *alertView;
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
    if (indexPath.row == 0) {
        LPFeedBackVC *vc = [[LPFeedBackVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){
        [self showAlert];
    }
}

-(void)showAlert{
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertBgView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    self.alertView.hidden = NO;
    self.alertBgView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBgView.alpha = 0.5;
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];

}
-(void)hiddenAlert{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBgView.alpha = 0;
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {
        self.alertView.hidden = YES;
        self.alertBgView.hidden = YES;
    }];
}

#pragma mark - request
-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            kUserDefaultsRemove(LOGINID);
            kUserDefaultsRemove(kLoginStatus);
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
-(UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.frame = CGRectMake(13, SCREEN_HEIGHT/3, SCREEN_WIDTH-26, 300);
        _alertView.backgroundColor = [UIColor whiteColor];
        _alertView.alpha = 0;
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 4.0;
        
        UIImageView *imgView = [[UIImageView alloc]init];
        [_alertView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.centerX.equalTo(self.alertView);
        }];
        imgView.image = [UIImage imageNamed:@"logo_Information"];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [_alertView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.equalTo(imgView.mas_bottom).offset(15);
        }];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = @"广东蓝聘科技有限公司";
        
        UILabel *textLabel = [[UILabel alloc]init];
        [_alertView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.top.equalTo(titleLabel.mas_bottom).offset(15);
        }];
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.numberOfLines = 0;
        textLabel.textColor = [UIColor grayColor];
        textLabel.text = @"广东蓝聘科技有限公司是一家专为蓝领打造招聘信息相关的综合服务平台，为广大职工朋友提供海量真实、可靠、优质的岗位。并设计资讯查看、互动社区、工时记录、工资查看等功能方便职工朋友的使用。保障劳动者的利益，让劳动者工作无忧！";
        
        UILabel *bottomLabel = [[UILabel alloc]init];
        [_alertView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(13);
            make.right.mas_equalTo(-13);
            make.bottom.mas_equalTo(-20);
        }];
        bottomLabel.font = [UIFont systemFontOfSize:13];
        bottomLabel.numberOfLines = 0;
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.textColor = [UIColor grayColor];
        bottomLabel.text = @"广东蓝聘科技有限公司\nCopyright©2018-2020lanpin123.com\nAll Rights Reserved.";
        
    }
    return _alertView;
}
-(UIView *)alertBgView{
    if (!_alertBgView) {
        _alertBgView = [[UIView alloc]init];
        _alertBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _alertBgView.backgroundColor = [UIColor blackColor];
        _alertBgView.alpha = 0;
        _alertBgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlert)];
        [_alertBgView addGestureRecognizer:tap];
    }
    return _alertBgView;
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
