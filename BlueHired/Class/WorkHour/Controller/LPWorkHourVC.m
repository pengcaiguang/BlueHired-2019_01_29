//
//  LPWorkHourVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/10.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPWorkHourVC.h"
#import "LPFullTimeVC.h"
#import "LPHourlyWorkVC.h"

@interface LPWorkHourVC ()

@end

@implementation LPWorkHourVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工时记录";
    [self setupUI];
}
-(void)setupUI{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_WIDTH/(360/173));
    }];
    imageView.image = [UIImage imageNamed:@"workhour_head"];
    
    UIImageView *bottomImageView = [[UIImageView alloc]init];
    [self.view addSubview:bottomImageView];
    [bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(imageView.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
    }];
    bottomImageView.image = [UIImage imageNamed:@"workhour_bottom"];
    
    
    UIButton *fullTimeButton = [[UIButton alloc]init];
    [self.view addSubview:fullTimeButton];
    [fullTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(imageView.mas_bottom).offset(73);
        make.height.mas_equalTo(48);
    }];
    fullTimeButton.layer.masksToBounds = YES;
    fullTimeButton.layer.cornerRadius = 24;
    fullTimeButton.backgroundColor = [UIColor baseColor];
    [fullTimeButton setTitle:@"正式工" forState:UIControlStateNormal];
    [fullTimeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fullTimeButton addTarget:self action:@selector(touchFullTimeButton) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hourlyButton = [[UIButton alloc]init];
    [self.view addSubview:hourlyButton];
    [hourlyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(fullTimeButton.mas_bottom).offset(49);
        make.height.mas_equalTo(48);
    }];
    hourlyButton.layer.masksToBounds = YES;
    hourlyButton.layer.cornerRadius = 24;
    hourlyButton.backgroundColor = [UIColor whiteColor];
    [hourlyButton setTitle:@"小时工" forState:UIControlStateNormal];
    [hourlyButton setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    [hourlyButton addTarget:self action:@selector(touchHourlyButtonButton) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)touchFullTimeButton{
    LPFullTimeVC *vc = [[LPFullTimeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)touchHourlyButtonButton{
    LPHourlyWorkVC *vc = [[LPHourlyWorkVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
