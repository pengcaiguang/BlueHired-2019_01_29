//
//  LPInviteRewardsVC.m
//  BlueHired
//
//  Created by iMac on 2020/1/4.
//  Copyright © 2020 lanpin. All rights reserved.
//

#import "LPInviteRewardsVC.h"
#import "LPRegisterModel.h"
#import "LPRegisterDetailVC.h"
#import "LPAwardInvitationVC.h"
#import "LPInviteVC.h"
#import "LPRegisterRankingVC.h"
#import "LPEmployeeManageVC.h"

@interface LPInviteRewardsVC ()
@property (weak, nonatomic) IBOutlet UILabel *registeredTitle;
@property (weak, nonatomic) IBOutlet UILabel *registeredNumber;
@property (weak, nonatomic) IBOutlet UILabel *registeredRewards;

@property (weak, nonatomic) IBOutlet UILabel *inductionTitle;
@property (weak, nonatomic) IBOutlet UILabel *inductionNumber;
@property (weak, nonatomic) IBOutlet UILabel *inductionRewards;

@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) LPRegisterModel *model;
@property(nonatomic,strong) UITextView *answerLabel;

@end

@implementation LPInviteRewardsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请奖励";
    self.registeredTitle.layer.cornerRadius = LENGTH_SIZE(15);
    self.inductionTitle.layer.cornerRadius = LENGTH_SIZE(15);
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"奖励规则" style:UIBarButtonItemStylePlain target:self action:@selector(showAlert)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(15),NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT_SIZE(15),NSFontAttributeName, nil] forState:UIControlStateSelected];
    self.bgView.hidden = YES;
    self.alertView.hidden = YES;
    
    [self requestGetRegister];


}

- (IBAction)TouchBtn:(UIButton *)sender {
    if (sender.tag == 1000) {       //注册奖励
        LPRegisterDetailVC *vc = [[LPRegisterDetailVC alloc]init];
        vc.Type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1001){      //入职奖励
        LPRegisterDetailVC *vc = [[LPRegisterDetailVC alloc]init];
        vc.Type = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1002){      //奖励领取
        LPAwardInvitationVC *vc = [[LPAwardInvitationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1003){      //邀请二维码
        LPInviteVC *vc = [[LPInviteVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1004){      //员工归宿
        LPEmployeeManageVC *vc = [[LPEmployeeManageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 1005){      //月排名
        LPRegisterRankingVC *vc = [[LPRegisterRankingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)showAlert{
    self.bgView.hidden = NO;
    self.alertView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    }];
}

-(void)hiddenAlert{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
        self.alertView.hidden = YES;
    }];

}

#pragma mark lazy
-(void)setModel:(LPRegisterModel *)model{
    _model = model;
    self.inductionNumber.text = [NSString stringWithFormat:@"邀请入职人数  %ld人",(long)model.data.inviteNum.integerValue];
    self.inductionRewards.text = [NSString stringWithFormat:@"预计奖励：%.2f元",model.data.totalMoney.floatValue];
    
    self.registeredNumber.text = [NSString stringWithFormat:@"邀请注册人数  %ld人",model.data.sumNum.integerValue];
    self.registeredRewards.text = [NSString stringWithFormat:@"预计奖励：%.2f元",model.data.regMoney.floatValue];
    self.answerLabel.text =  model.data.remark;

}

-(UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _alertView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [_alertView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(30, 15, SCREEN_WIDTH-60, 20);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;
        titleLabel.text = @"奖励规则";
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y +15, SCREEN_WIDTH, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [_alertView addSubview:view];
        
        UITextView *answerLabel = [[UITextView alloc]init];
        [_alertView addSubview:answerLabel];
        [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(view.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
        }];
        answerLabel.editable = NO;
        answerLabel.showsVerticalScrollIndicator = NO;
        answerLabel.font = [UIFont systemFontOfSize:14];
        answerLabel.text =  self.model.data.remark;
        answerLabel.textColor = [UIColor blackColor];
        self.answerLabel = answerLabel;
        
        UIButton *close = [[UIButton alloc]init];
        close.frame = CGRectMake(SCREEN_WIDTH-28, 18, 14, 14);
        [_alertView addSubview:close];
        [close setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlert)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}




 
#pragma mark - request
-(void)requestGetRegister{
    NSDictionary *dic = @{@"versionType":@"2.4"};
    
    [NetApiManager requestGetRegisterWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPRegisterModel mj_objectWithKeyValues:responseObject];

            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
