//
//  LPInvitationDrawVC.m
//  BlueHired
//
//  Created by iMac on 2019/8/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPInvitationDrawVC.h"
#import "LPAddMoodeVC.h"

@interface LPInvitationDrawVC ()
@property (weak, nonatomic) IBOutlet UIImageView *LogoImage;
@property (weak, nonatomic) IBOutlet UILabel *LogoTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *TobackBtn;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *CoinsLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *Bgimage;
@property (weak, nonatomic) IBOutlet UILabel *TypeLabel;

@end

@implementation LPInvitationDrawVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.LogoImage.hidden = YES;
    self.LogoTitleLabel.hidden = YES;
    self.TimeLabel.hidden = YES;
    self.CoinsLabel.hidden = YES;
    
    self.userImage.layer.cornerRadius = LENGTH_SIZE(22.5);
    
    self.MoneyLabel.text = [NSString stringWithFormat:@"%.2f元",self.model.relationMoney.floatValue];
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:user.data.user_url] placeholderImage:[UIImage imageNamed:@"UserImage"]];
    self.userName.text = user.data.user_name;

    self.Bgimage.image = [UIImage imageNamed:IS_iPhoneX ? @"Drawbg_X" : @"Drawbg"];
    if (self.model.type.integerValue == 1) {        //蓝聘返费
        self.TypeLabel.text = @"恭喜您，获得返费奖励";
    } else if (self.model.type.integerValue == 2){      //邀请注册奖励
        self.TypeLabel.text = @"恭喜您，获得邀请注册奖励";
    } else if (self.model.type.integerValue == 3){      //邀请入职奖励
        self.TypeLabel.text = @"恭喜您，获得邀请入职奖励";
    } else if (self.model.type.integerValue == 4){
        self.TypeLabel.text = @"恭喜您，获得分享点赞奖励";
    }

}

- (IBAction)ToBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)TouchSave:(id)sender {
    self.LogoImage.hidden = NO;
    self.LogoTitleLabel.hidden = NO;
    self.TimeLabel.hidden = NO;
    self.CoinsLabel.hidden = NO;
    self.TobackBtn.hidden = YES;
    self.saveBtn.hidden = YES;
    
    self.TimeLabel.text = [DataTimeTool stringFromDate:[NSDate date] DateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *ShareString = @"";
    if (self.model.type.integerValue == 1) {
//        str = @"蓝聘返费";
//        ShareString = [NSString stringWithFormat:@"我通过蓝聘入职%@，拿到了%@份的返费%.2f元，这奖励，你也值得拥有，快来蓝聘入职吧！",
//                       self.model.mechanismName,
//                       self.model.relationMoneyTime,
//                       self.model.relationMoney.floatValue];
        ShareString = self.model.title;

    }else if (self.model.type.integerValue == 2){
//        str = @"邀请注册奖励";
//        ShareString = [NSString stringWithFormat:@"我在蓝聘平台领到了%@份的邀请注册奖励%.2f元，邀请好友注册拿奖励，你来你也行，赶快行动吧~",
//                       [DataTimeTool getDataTime:self.model.relationMoneyTime DateFormat:@"yyyy年MM月"],
//                       self.model.relationMoney.floatValue];
        ShareString = self.model.title;
    }else if (self.model.type.integerValue == 3){
//        str = @"邀请入职奖励";
//        ShareString = [NSString stringWithFormat:@"邀请好友上蓝聘，找好工作，领高额奖励！我又拿到了%@份的邀请入职奖励%.2f元！",
//                       [DataTimeTool getDataTime:self.model.relationMoneyTime DateFormat:@"yyyy年MM月"],
//                       self.model.relationMoney.floatValue];
        ShareString = self.model.title;
    }else if (self.model.type.integerValue == 4){
//        ShareString = [NSString stringWithFormat:@"邀请好友上蓝聘，找好工作，领高额奖励！我又拿到了%@份的邀请入职奖励%.2f元！",
//                       [DataTimeTool getDataTime:self.model.relationMoneyTime DateFormat:@"yyyy年MM月"],
//                       self.model.relationMoney.floatValue];
        ShareString = self.model.title;
    }
    
    
    LPAddMoodeVC *vc = [[LPAddMoodeVC alloc] init];
    vc.Type = 2;
    vc.ShareImage = [self getNormalImage:[UIApplication sharedApplication].keyWindow];
    vc.ShareString = ShareString;
    vc.Sharemodel = self.model;
    [self.navigationController pushViewController:vc animated:YES];
    vc.block = ^(NSString * _Nonnull moodDetails, NSString * _Nonnull moodUrl, NSString * _Nonnull address) {
        [self requestQueryUpdatePrizeMoney:self.model
                               moodDetails:moodDetails
                                   moodUrl:moodUrl
                                   address:address];
    };
    
    self.LogoImage.hidden = YES;
    self.LogoTitleLabel.hidden = YES;
    self.TimeLabel.hidden = YES;
    self.CoinsLabel.hidden = YES;
    self.TobackBtn.hidden = NO;
    self.saveBtn.hidden = NO;
    
    
}


-(void)requestQueryUpdatePrizeMoney:(LPPrizeDataMoney *) m
                        moodDetails:(NSString *) moodDetails
                            moodUrl:(NSString *) moodUrl
                            address:(NSString *) address{
    NSDictionary *dic = @{
                          @"moodDetails":moodDetails,
                          @"moodUrl":moodUrl,
                          @"address":address,
                          };
    NSString *UrlStr = [NSString stringWithFormat:@"billrecord/update_prize_money?id=%@&type=%@",m.id,m.type];
    [NetApiManager requestQueryUpdatePrizeMoney:dic URLString:UrlStr  withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    m.status = @"1";
                    if (m.type.integerValue == 1) {
                        self.ReMoneyModel.delStatus = @"3";
                    }
                    if (self.block) {
                        self.block();
                    }
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取成功" time:MESSAGE_SHOW_TIME];
                    if ([responseObject[@"data"] integerValue] == 2) {
                        [LPTools AlertCircleView:@""];
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"领取失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}




- (UIImage *)getNormalImage:(UIView *)view
{
    UIImage* viewImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    {
        [view.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
    }
 
    
    return viewImage;
    
}

@end
