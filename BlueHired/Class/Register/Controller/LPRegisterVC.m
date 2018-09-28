//
//  LPRegisterVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterVC.h"
#import "LPRegisterModel.h"
#import "LPRegisterDetailVC.h"

@interface LPRegisterVC ()

@property (weak, nonatomic) IBOutlet UILabel *BUserNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *CUserNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullMonthNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *sumAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *unAmountLabel;

@property(nonatomic,strong) LPRegisterModel *model;
@end

@implementation LPRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"邀请奖励";
    [self requestGetRegister];
}
-(void)setModel:(LPRegisterModel *)model{
    _model = model;
    self.BUserNumLabel.text = [NSString stringWithFormat:@"%@人",model.data.BUserNum];
    self.CUserNumLabel.text = [NSString stringWithFormat:@"%@人",model.data.CUserNum];
    self.sumNumLabel.text = [NSString stringWithFormat:@"%@人",model.data.sumNum];
    self.fullMonthNumLabel.text = [NSString stringWithFormat:@"%ld元",model.data.fullMonthNum.integerValue*20];

    self.sumAmountLabel.text = [NSString stringWithFormat:@"%ld元",model.data.sumNum.integerValue*20];
    self.unAmountLabel.text = [NSString stringWithFormat:@"%ld元",(model.data.sumNum.integerValue-model.data.fullMonthNum.integerValue) * 20];

}
- (IBAction)touchDetailButton:(UIButton *)sender {
    LPRegisterDetailVC *vc = [[LPRegisterDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - request
-(void)requestGetRegister{
    [NetApiManager requestGetRegisterWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPRegisterModel mj_objectWithKeyValues:responseObject];
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
