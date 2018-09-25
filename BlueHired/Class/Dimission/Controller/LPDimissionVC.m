//
//  LPDimissionVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPDimissionVC.h"
#import "LPUserMaterialModel.h"

@interface LPDimissionVC ()

@end

@implementation LPDimissionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"离职通知";
    LPUserMaterialModel *userMaterialModel = [LPUserDefaults getObjectByFileName:USERINFO];
    if (userMaterialModel.data.workStatus) {
        if ([userMaterialModel.data.workStatus integerValue] != 1) { //0待业1在职2入职中
            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"你尚未入职，暂不支持离职通知" message:nil textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert show];
        }
    }
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
