//
//  LPSetVC.m
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSetVC.h"
#import "LPFeedBackVC.h"
#import "LPBlackUserVC.h"
#import "AppDelegate.h"

static NSString *WXAPPID = @"wx566f19a70d573321";

@interface LPSetVC ()<UITableViewDelegate,UITableViewDataSource,LPWxLoginHBDelegate>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) UIView *alertBgView;
@property(nonatomic,strong) UIView *alertView;
@end

@implementation LPSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
     AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    appDelegate.WXdelegate = self;
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

}

-(void)viewWillAppear:(BOOL)animated{
    if (AlreadyLogin) {
        [self setLogoutButton];
        LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
        self.userMaterialModel.data.openid = [LPTools isNullToString:user.data.openid];
        [self.tableview reloadData];
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
    [button setTitle:@"退出登录" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor baseColor];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0;
    [button addTarget:self action:@selector(touchLogoutButton) forControlEvents:UIControlEventTouchUpInside];
}
-(void)touchLogoutButton{
    NSLog(@"退出登录");
    [self requestSignout];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return AlreadyLogin?4:3;
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
    cell.detailTextLabel.text = @"";
    if (AlreadyLogin) {
        if (indexPath.row == 0) {
//            cell.textLabel.text = @"微信绑定";
//            if ([[LPTools isNullToString:self.userMaterialModel.data.openid] isEqualToString:@""]) {
//                cell.detailTextLabel.text = @"未绑定";
//            }else{
//                cell.detailTextLabel.text = @"已绑定";
//            }
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"关注微信公众号";
        }else if (indexPath.row == 2) {
            cell.textLabel.text = AlreadyLogin?@"黑名单":@"关于我们";
        }else if (indexPath.row == 3) {
            cell.textLabel.text = @"关于我们";
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"意见反馈";
        }else if (indexPath.row == 1) {
            cell.textLabel.text = @"关注微信公众号";
        }else if (indexPath.row == 2) {
            cell.textLabel.text =  @"关于我们";
        }
    }
    
//    else if (indexPath.row == 3) {
//        cell.textLabel.text = @"检查更新";
//
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *app_build = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"当前版本%@",app_build];
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (AlreadyLogin) {
//        if (indexPath.row == 0) {
//            if ([WXApi isWXAppInstalled]==NO) {
//                [self.view showLoadingMeg:@"请安装微信" time:MESSAGE_SHOW_TIME];
//                return;
//            }
//
//            if ([[LPTools isNullToString:self.userMaterialModel.data.openid] isEqualToString:@""]) {
//                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否前去绑定微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                    if (buttonIndex) {
//                        [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                            State:@"123x"
//                                                           OpenID:WXAPPID
//                                                 InViewController:self];
//                    }
//                }];
//                [alert show];
//            }else{
//                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否换绑微信号？" message:nil textAlignment:0 buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor blackColor],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
//                    if (buttonIndex) {
//                        [WXApiRequestHandler sendAuthRequestScope: @"snsapi_userinfo"
//                                                            State:@"123x"
//                                                           OpenID:WXAPPID
//                                                 InViewController:self];
//                    }
//                }];
//                [alert show];
//            }
//        }else
        if (indexPath.row == 0) {
            LPFeedBackVC *vc = [[LPFeedBackVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 1)
        {
            NSString *urlsting =[[NSString stringWithFormat:@"weixin://"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlsting]]) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"蓝聘网络科技";
                 [self.view showLoadingMeg:@"蓝聘：点击搜索按钮，粘贴文本进行搜索" time:MESSAGE_SHOW_TIME];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
                });
             }
        }else if (indexPath.row == 2){
            if ([kUserDefaultsValue(LOGINID) integerValue]) {
                if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
                    LPBlackUserVC *vc = [[LPBlackUserVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }else{
                [self showAlert];
            }
         }else if (indexPath.row == 3){
            [self showAlert];
        }
    
    }else{
        if (indexPath.row == 0) {
            if ([LoginUtils validationLogin:[UIWindow visibleViewController]]){
            LPFeedBackVC *vc = [[LPFeedBackVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            }
        }
        else if (indexPath.row == 1)
        {
            NSString *urlsting =[[NSString stringWithFormat:@"weixin://"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlsting]]) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = @"蓝聘网络科技";
                [self.view showLoadingMeg:@"蓝聘：点击搜索按钮，粘贴文本进行搜索" time:MESSAGE_SHOW_TIME];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
                });
            }
        }else if (indexPath.row == 2){
                 [self showAlert];
         }
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

#pragma mark - LPWxLoginHBBack
- (void)LPWxLoginHBBack:(LPWXUserInfoModel *)wxUserInfo{
    if (![self.userMaterialModel.data.openid isEqualToString:wxUserInfo.unionid]) {
        NSDictionary *dic = @{
                              @"sgin":[LPTools isNullToString:wxUserInfo.unionid],
                              @"phone":self.userMaterialModel.data.userTel,
                              @"userUrl":[LPTools isNullToString:wxUserInfo.headimgurl],
                              @"userName":@"0fc23ce3bc0e1ee5e5e"
                              };
        [NetApiManager requestQueryWXSetPhone:dic withHandle:^(BOOL isSuccess, id responseObject) {
            NSLog(@"%@",responseObject);
            if (isSuccess) {
                if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] > 0) {
                        if ([[LPTools isNullToString:self.userMaterialModel.data.openid] isEqualToString:@""]) {
                            [self.view showLoadingMeg:@"绑定成功" time:MESSAGE_SHOW_TIME];
                        }else{
                            [self.view showLoadingMeg:@"换绑成功，请之后用新微信号进行登录！" time:MESSAGE_SHOW_TIME];
                        }
                        self.userMaterialModel.data.openid = wxUserInfo.unionid;
                        [self.tableview reloadData];
                    }else{
                        [self.view showLoadingMeg:responseObject[@"msg"] ? responseObject[@"msg"] : @"注册失败" time:MESSAGE_SHOW_TIME];
                    }
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }

            }else{
                [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
            }
        }];
        
    }else{
        [self.view showLoadingMeg:@"此次微信号与之前绑定的一致，请更换微信号重试！" time:MESSAGE_SHOW_TIME];
    }

}


#pragma mark - request
-(void)requestSignout{
    [NetApiManager requestSignoutWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                kUserDefaultsSave(kUserDefaultsValue(LOGINID), OLDLOGINID);
                kUserDefaultsRemove(LOGINID);
                kUserDefaultsRemove(kLoginStatus);
                [self.navigationController popViewControllerAnimated:YES];
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
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
    }
    return _tableview;
}
-(UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.frame = CGRectMake(13, (SCREEN_HEIGHT-300)/2.0, SCREEN_WIDTH-26, 300);
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
