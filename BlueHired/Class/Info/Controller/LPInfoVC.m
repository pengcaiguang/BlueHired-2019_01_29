//
//  LPInfoVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/20.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInfoVC.h"

@interface LPInfoVC ()

@end

@implementation LPInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息中心";
    
    [self requestQueryInfolist];
}



#pragma mark - request
-(void)requestQueryInfolist{
    [NetApiManager requestQueryInfolistWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
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
