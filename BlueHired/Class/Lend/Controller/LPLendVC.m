//
//  LPLendVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendVC.h"

@interface LPLendVC ()

@end

@implementation LPLendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"借支";
    [self requestQueryIsLend];
}

#pragma mark - request
-(void)requestQueryIsLend{
    [NetApiManager requestQueryIsLendWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                if (responseObject[@"data"][@"res_code"]) {
                    if ([responseObject[@"data"][@"res_code"] integerValue] == 20012) {
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"data"][@"res_msg"] message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert show];
                    }
                }
            }
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
