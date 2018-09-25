//
//  LPInfoDetailVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInfoDetailVC.h"

@interface LPInfoDetailVC ()

@end

@implementation LPInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息详情";
//    [self requestQueryInfodetail];
    [self setupUI];
}
-(void)setupUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(13);
        make.right.mas_equalTo(-13);
    }];
    titleLabel.text = self.model.informationTitle;
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-13);
    }];
    timeLabel.text = [NSString convertStringToTime:[self.model.time stringValue]];
    timeLabel.font = [UIFont systemFontOfSize:11];
    timeLabel.textColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(timeLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(0.5);
    }];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(timeLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-13);
    }];
    detailLabel.text = self.model.informationDetails;
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:14];
    
    

}

-(void)requestQueryInfodetail{
    NSDictionary *dic = @{
                          @"infoId":self.model.id
                          };
    [NetApiManager requestQueryInfodetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
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
