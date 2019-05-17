//
//  LPInfoDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPInfoDetailVC.h"
#import "LPInfoDetailModel.h"
#import "LPBankcardwithDrawModel.h"
#import "LPSalarycCardBindVC.h"
#import "LPSalarycCard2VC.h"
#import "LPInfoVC.h"

@interface LPInfoDetailVC ()

@property(nonatomic,strong) LPInfoDetailModel *DetailModel;
@property(nonatomic,strong) LPBankcardwithDrawModel *BankcardModel;
@property(nonatomic,strong) UIButton *Agreedbutton;
@end


@implementation LPInfoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息详情";
    [self requestQueryInfodetail];
//    [self setupUI];
}


-(void)viewDidAppear:(BOOL)animated
{
    if (_model.type.integerValue == 4) {
        [self requestQueryBankcardwithDraw];
    }
}

-(void)setupUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(13);
        make.right.mas_equalTo(-13);
    }];
    titleLabel.text = self.DetailModel.informationTitle;
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-13);
    }];
    timeLabel.text = [NSString convertStringToTime:[self.DetailModel.time stringValue]];
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
    detailLabel.text = self.DetailModel.informationDetails;
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:14];
    
    
    UILabel *textView = [[UILabel alloc] init];
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
//        make.centerY.mas_equalTo(self.view.mas_centerY);
        make.right.mas_equalTo(-13);
//        make.height.mas_equalTo(166);
    }];
    textView.numberOfLines = 0;
    textView.font = [UIFont systemFontOfSize:11];;
    textView.layer.cornerRadius = 10;
    textView.text = @"店员须知:\n 1、成为加盟店店员前,您邀请的员工仍归属您自己，相应的奖励金额请在个人中心的邀请奖励中查看。\n 2、成为加盟店店员后,您邀请的员工都归属您加入的加盟店,您邀请员工将不再由本平台进行奖励，而是由您所在的加盟店店主进行发放，具体奖励额度请您与店主进行线下协商。本平台概不负责！\n 3、若要成为加盟店的店员必须进行工资卡绑定！";
    textView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
    
    _Agreedbutton = [[UIButton alloc] init];
    [self.view addSubview:_Agreedbutton];
    [_Agreedbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(48);
        make.left.mas_equalTo(13);
        make.bottom.mas_equalTo(-102);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(48);
    }];
    
    _Agreedbutton.backgroundColor = [UIColor baseColor];
    [_Agreedbutton setTitle:@"同意" forState:UIControlStateNormal];
    [_Agreedbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _Agreedbutton.layer.cornerRadius = 10;
    [_Agreedbutton addTarget:self action:@selector(TouchAgreedbutton) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelbutton2 = [[UIButton alloc] init];
    [self.view addSubview:cancelbutton2];
    [cancelbutton2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.bottom.mas_equalTo(-27);
        make.right.mas_equalTo(-13);
        make.height.mas_equalTo(48);
    }];
    
    cancelbutton2.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    cancelbutton2.layer.cornerRadius = 10;
    [cancelbutton2 setTitle:@"拒绝" forState:UIControlStateNormal];
    [cancelbutton2 addTarget:self action:@selector(touchcancelButton) forControlEvents:UIControlEventTouchUpInside];
    [cancelbutton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (_model.type.integerValue == 4) {
        textView.hidden = NO;
        _Agreedbutton.hidden = NO;
        cancelbutton2.hidden = NO;
    }else{
        textView.hidden = YES;
        _Agreedbutton.hidden = YES;
        cancelbutton2.hidden = YES;
    }
    

}

-(void)TouchAgreedbutton{
    if ([_Agreedbutton.currentTitle isEqualToString:@"工资卡绑定"]) {
//        LPSalarycCardBindVC *vc = [[LPSalarycCardBindVC alloc] init];
        LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self requestQueryAccept_invite:YES];
    }
}

-(void)touchcancelButton{
    [self requestQueryAccept_invite:NO];
}

-(void)setBankcardModel:(LPBankcardwithDrawModel *)BankcardModel
{
    _BankcardModel = BankcardModel;
    
    if (BankcardModel.data.type.integerValue == 1) {
        [_Agreedbutton setTitle:@"工资卡绑定" forState:UIControlStateNormal];
     }else{
        [_Agreedbutton setTitle:@"同意" forState:UIControlStateNormal];
     }
}


-(void)requestQueryInfodetail{
    NSDictionary *dic = @{
                          @"infoId":self.model.id
                          };
    [NetApiManager requestQueryInfodetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.DetailModel = [LPInfoDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
                [self setupUI];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryBankcardwithDraw{
    [NetApiManager requestQueryBankcardwithDrawWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.BankcardModel = [LPBankcardwithDrawModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryAccept_invite:(BOOL) status{
    
    NSString *ShopNum = [[self.DetailModel.informationDetails componentsSeparatedByString:@"("][1] componentsSeparatedByString:@")"][0];
    
    NSDictionary *dic = @{@"messageId":self.model.id,
                          @"shopNum":ShopNum,
                          @"status":status?@"true":@"fasle"
                          };
    [NetApiManager requestQueryAccept_invite:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0  ) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"操作成功" time:2.0];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        LPInfoVC  *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                        vc.isReloadData = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                        //                    [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:2.0];
                }
           
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
@end
