//
//  LPWorkHourVC.m
//  BlueHired
//
//  Created by peng on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkHourVC.h"
#import "LPFullTimeVC.h"
#import "LPHourlyWorkVC.h"
#import "LPAdvertModel.h"
#import "ADAlertView.h"
#import "ADModel.h"
#import "LPActivityDatelisVC.h"
#import "LPActivityModel.h"
#define BOOLFORKEYVC @"BOOLFORKEYVC"

@interface LPWorkHourVC ()<UIAlertViewDelegate>
@property (nonatomic,strong)LPAdvertModel *AdvertModel;

@end

@implementation LPWorkHourVC{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工时记录";
//    [[AipOcrService shardService] authWithAK:@"wfvGZ6FbR5QI3GWMbO6elDo0" andSK:@"EFMMurZrs4WvV0WKGcvjXEGoq0ENTAjI"];

//    if ([[NSUserDefaults standardUserDefaults] boolForKey:BOOLFORKEYVC]) {
//    }
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:BOOLFORKEYVC];
    if (!self.isPush) {
        [self requestQueryDownload];
        [self requestQueryActivityadvert];
    }
    [self setupUI];
    [self configCallback];
    NSLog(@"屏幕宽度 = %f,屏幕高度 = %f",Screen_Width,Screen_Height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isPush) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@      %@", result,result[@"result"][@"bank_name"]);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alertView show];
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

-(void)setupUI{
//    if (!self.isPush) {
//        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//        [self.view addSubview:backView];
////        backView.backgroundColor = [UIColor baseColor];
//        backView.backgroundColor = [UIColor colorWithHexString:@"#FF3CAFFF"];
//    }

    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.isPush?0:0);
        make.height.mas_equalTo(SCREEN_WIDTH/320*252);
//        make.height.mas_equalTo(275);
    }];
    imageView.image = [UIImage imageNamed:@"workhour_head3"];
    
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
    }];
    bottomImageView.image = [UIImage imageNamed:@""];
    
    
    UIButton *fullTimeButton = [[UIButton alloc]init];
    [self.view addSubview:fullTimeButton];
    [fullTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(65);
        make.right.mas_equalTo(-65);
        make.top.equalTo(imageView.mas_bottom).offset(31);
        make.height.mas_equalTo(43);
    }];
    fullTimeButton.layer.masksToBounds = YES;
    fullTimeButton.layer.cornerRadius = 5;
    fullTimeButton.backgroundColor = [UIColor whiteColor];
    fullTimeButton.layer.borderColor = [UIColor baseColor].CGColor;
    fullTimeButton.layer.borderWidth = 0.5;
    [fullTimeButton setTitle:@"正式工" forState:UIControlStateNormal];
    [fullTimeButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [fullTimeButton addTarget:self action:@selector(touchFullTimeButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hourlyButton = [[UIButton alloc]init];
    [self.view addSubview:hourlyButton];
    [hourlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(65);
        make.right.mas_equalTo(-65);
        make.top.equalTo(fullTimeButton.mas_bottom).offset(21);
        make.height.mas_equalTo(43);
    }];
    hourlyButton.layer.masksToBounds = YES;
    hourlyButton.layer.cornerRadius = 5;
    hourlyButton.backgroundColor = [UIColor baseColor];
    [hourlyButton setTitle:@"小时工" forState:UIControlStateNormal];
    [hourlyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [hourlyButton addTarget:self action:@selector(touchHourlyButtonButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *TitleLabel1 = [[UILabel alloc] init];
    [self.view addSubview:TitleLabel1];
    [TitleLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.equalTo(hourlyButton.mas_bottom).offset(19);
     }];
    TitleLabel1.text = @"1.工时记录是为了帮助用户记录自己的工作情况，与实际工作考勤无关。";
    TitleLabel1.font = [UIFont systemFontOfSize:12.0];
    TitleLabel1.textColor = [UIColor colorWithHexString:@"#FF666666"];
    TitleLabel1.numberOfLines = 0;
    
    UILabel *TitleLabel2 = [[UILabel alloc] init];
    [self.view addSubview:TitleLabel2];
    [TitleLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.right.mas_equalTo(-14);
        make.top.equalTo(TitleLabel1.mas_bottom).offset(10);
    }];
    TitleLabel2.text = @"2.因正式工与小时工的薪资计算方式不同，所以用户要根据自己实际的工作性质选择对应的模块进行工时记录。";
    TitleLabel2.font = [UIFont systemFontOfSize:12.0];
    TitleLabel2.textColor = [UIColor colorWithHexString:@"#FF666666"];
    TitleLabel2.numberOfLines = 0;
}

-(void)touchFullTimeButton{
    if ([LoginUtils validationLogin:self]) {
        LPFullTimeVC *vc = [[LPFullTimeVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

-(void)touchHourlyButtonButton{
     if ([LoginUtils validationLogin:self]) {
    LPHourlyWorkVC *vc = [[LPHourlyWorkVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
//         [self bankCardOCROnline];
     }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestQueryActivityadvert{
    [NetApiManager requestQueryActivityadvert:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                LPAdvertModel *model = [LPAdvertModel mj_objectWithKeyValues:responseObject];
                if (model.data.count) {
                    self.AdvertModel = model;
                    [ADAlertView  showInView:[UIWindow visibleViewController].view theDelegate:self theADInfo:model.data placeHolderImage:@"1"];
                }
            }else{
                [[UIWindow visibleViewController].view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)clickAlertViewAtIndex:(NSInteger)index{
    LPActivityDatelisVC *vc = [[LPActivityDatelisVC alloc] init];
    LPActivityDataModel *M = [[LPActivityDataModel alloc] init];
    M.id = self.AdvertModel.data[index].id;
    vc.Model = M;
    vc.hidesBottomBarWhenPushed = YES;
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}


-(void)requestQueryDownload{
    NSDictionary *dic = @{
                          @"type":@"2"
                          };
    [NetApiManager requestQueryDownload:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"] != nil &&
                [responseObject[@"data"][@"version"] length]>0) {
                NSLog(@"%.2f",self.version.floatValue);
                if (self.version.floatValue <  [responseObject[@"data"][@"version"] floatValue]  ) {
                    NSString *updateStr = [NSString stringWithFormat:@"发现新版本V%@\n为保证软件的正常运行\n请及时更新到最新版本",responseObject[@"data"][@"version"]];
                    [self creatAlterView:updateStr];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

//版本
-(NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}
//3. 弹框提示
-(void)creatAlterView:(NSString *)msg{
    UIAlertController *alertText = [UIAlertController alertControllerWithTitle:@"更新提醒" message:msg preferredStyle:UIAlertControllerStyleAlert];
    //增加按钮
    [alertText addAction:[UIAlertAction actionWithTitle:@"我再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];
    [alertText addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *str = @"itms-apps://itunes.apple.com/cn/app/id1441365926?mt=8"; //更换id即可
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }]];
    [self presentViewController:alertText animated:YES completion:nil];
}


  
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
