//
//  LPWithDrawalVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/30.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPWithDrawalVC.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCardBindVC.h"

@interface LPWithDrawalVC ()
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

@property(nonatomic,strong) LPBankcardwithDrawModel *model;

@end

@implementation LPWithDrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提现";
    [self requestQueryBankcardwithDraw];
}
-(void)setModel:(LPBankcardwithDrawModel *)model{
    _model = model;
    if (model.data.type.integerValue == 1) {
        self.addCardButton.hidden = NO;
        self.navigationItem.title = @"添加银行卡";
    }else{
        self.addCardButton.hidden = YES;
    }
}
- (IBAction)touchAddCardButton:(UIButton *)sender {
    LPSalarycCardBindVC *vc = [[LPSalarycCardBindVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - request
-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
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
