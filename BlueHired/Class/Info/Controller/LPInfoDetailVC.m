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
#import "LPWorkDetailVC.h"
#import "LPWorklistModel.h"

@interface LPInfoDetailVC ()

@property(nonatomic,strong) LPInfoDetailModel *DetailModel;
@property(nonatomic,strong) LPBankcardwithDrawModel *BankcardModel;
@property(nonatomic,strong) UIButton *Agreedbutton;
@property(nonatomic,strong) UILabel *TLabel;

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //加在这里是OK的
    [self setViewShapeLayer:self.TLabel CornerRadii:LENGTH_SIZE(12) byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight ];
    
}


-(void)setupUI{
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.mas_equalTo(LENGTH_SIZE(13));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    titleLabel.text = self.DetailModel.informationTitle;
    titleLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(titleLabel.mas_bottom).offset(LENGTH_SIZE(10));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    timeLabel.text = [NSString convertStringToTime:[self.DetailModel.time stringValue]];
    timeLabel.font = [UIFont systemFontOfSize:FontSize(11)];
    timeLabel.textColor = [UIColor grayColor];
    
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(timeLabel.mas_bottom).offset(LENGTH_SIZE(5));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
        make.height.mas_equalTo(LENGTH_SIZE(0.5));
    }];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    [self.view addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(LENGTH_SIZE(13));
        make.top.equalTo(timeLabel.mas_bottom).offset(LENGTH_SIZE(10));
        make.right.mas_equalTo(LENGTH_SIZE(-13));
    }];
    detailLabel.text = self.DetailModel.informationDetails;
    detailLabel.numberOfLines = 0;
    detailLabel.font = [UIFont systemFontOfSize:FontSize(14)];
    
    
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
        make.top.equalTo(detailLabel.mas_bottom).offset(LENGTH_SIZE(60));
        make.left.mas_equalTo(LENGTH_SIZE(18));
        make.right.mas_equalTo(LENGTH_SIZE(-18));
        make.height.mas_equalTo(LENGTH_SIZE(48));
    }];
    
    _Agreedbutton.backgroundColor = [UIColor baseColor];
    [_Agreedbutton setTitle:@"前往报名" forState:UIControlStateNormal];
    [_Agreedbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _Agreedbutton.layer.cornerRadius = 10;
    [_Agreedbutton addTarget:self action:@selector(TouchAgreedbutton:) forControlEvents:UIControlEventTouchUpInside];

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
    textView.hidden = YES;
    _Agreedbutton.hidden = YES;
    cancelbutton2.hidden = YES;
    
    
    UIView *viewDetail = [[UIView alloc] init];
    [self.view addSubview:viewDetail];
    [viewDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailLabel.mas_bottom).offset(LENGTH_SIZE(24));
        make.left.right.mas_offset(LENGTH_SIZE(0));
    }];
    viewDetail.backgroundColor = [UIColor colorWithHexString:@"#F5F8FA"];
    
    UILabel *Vtitle = [[UILabel alloc] init];
    [viewDetail addSubview:Vtitle];
    self.TLabel = Vtitle;
    [Vtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(10));
        make.left.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(87));
        make.height.mas_offset(LENGTH_SIZE(24));
    }];
    Vtitle.backgroundColor = [UIColor baseColor];
    Vtitle.textAlignment = NSTextAlignmentCenter;
    Vtitle.font = FONT_SIZE(15);
    Vtitle.textColor = [UIColor whiteColor];
    [LPTools setViewShapeLayer:Vtitle CornerRadii:12 byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight];
    
    UILabel *VDetails = [[UILabel alloc] init];
    [viewDetail addSubview:VDetails];
    [VDetails mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Vtitle.mas_bottom).offset(LENGTH_SIZE(18));
        make.bottom.mas_offset(LENGTH_SIZE(-45));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    VDetails.textColor = [UIColor colorWithHexString:@"#666666"];
    VDetails.font = FONT_SIZE(15);
    VDetails.numberOfLines = 0;
    
//    if (_model.type.integerValue == 4) {
//        textView.hidden = NO;
//        _Agreedbutton.hidden = NO;
//        cancelbutton2.hidden = NO;
//    }else{
//
//    }
    
    if ([self.DetailModel.informationTitle isEqualToString:@"企业推荐"] &&
        self.DetailModel.workId.integerValue > 0 &&
        self.DetailModel.upIdentity.length >0) {
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = YES;
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(detailLabel.mas_bottom).offset(LENGTH_SIZE(60));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage new] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@"前往报名" forState:UIControlStateNormal];
    }else if ([self.DetailModel.informationTitle isEqualToString:@"日日薪资格申请"]){
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = NO;
        
        Vtitle.text = @"申请详情";
        detailLabel.text = self.DetailModel.infoContent;
        VDetails.text = [self removeHTML2:self.DetailModel.informationDetails];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:VDetails.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VDetails.text length])];
        VDetails.attributedText = string;
        
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewDetail.mas_bottom).offset(LENGTH_SIZE(36));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage imageNamed:@"phone_info"] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@" 联系员工" forState:UIControlStateNormal];
    }else if ([self.DetailModel.informationTitle isEqualToString:@"借支申请"]){
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = NO;
        
        Vtitle.text = @"借支详情";
        detailLabel.text = self.DetailModel.infoContent;
        VDetails.text = [self removeHTML2:self.DetailModel.informationDetails];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:VDetails.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VDetails.text length])];
        VDetails.attributedText = string;
        
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewDetail.mas_bottom).offset(LENGTH_SIZE(36));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage imageNamed:@"phone_info"] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@" 联系员工" forState:UIControlStateNormal];
    }else if ([self.DetailModel.informationTitle isEqualToString:@"离职申请"]){
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = NO;
        
        Vtitle.text = @"离职详情";
        detailLabel.text = self.DetailModel.infoContent;
        VDetails.text = [self removeHTML2:self.DetailModel.informationDetails];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:VDetails.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VDetails.text length])];
        VDetails.attributedText = string;
        
        
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewDetail.mas_bottom).offset(LENGTH_SIZE(36));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage imageNamed:@"phone_info"] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@" 联系员工" forState:UIControlStateNormal];
    }else if ([self.DetailModel.informationTitle isEqualToString:@"取消离职申请"]){
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = NO;
        
        Vtitle.text = @"离职详情";
        detailLabel.text = self.DetailModel.infoContent;
        VDetails.text = [self removeHTML2:self.DetailModel.informationDetails];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:VDetails.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VDetails.text length])];
        VDetails.attributedText = string;
        
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewDetail.mas_bottom).offset(LENGTH_SIZE(36));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage imageNamed:@"phone_info"] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@" 联系员工" forState:UIControlStateNormal];
    }else if ([self.DetailModel.informationTitle isEqualToString:@"员工报名"]){
        _Agreedbutton.hidden = NO;
        viewDetail.hidden = NO;
        
        Vtitle.text = @"报名详情";
        detailLabel.text = self.DetailModel.infoContent;
        VDetails.text = [self removeHTML2:self.DetailModel.informationDetails];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:VDetails.text];
        NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:LENGTH_SIZE(5)];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [VDetails.text length])];
        VDetails.attributedText = string;
        
        [_Agreedbutton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(viewDetail.mas_bottom).offset(LENGTH_SIZE(36));
            make.left.mas_equalTo(LENGTH_SIZE(18));
            make.right.mas_equalTo(LENGTH_SIZE(-18));
            make.height.mas_equalTo(LENGTH_SIZE(48));
        }];
        [_Agreedbutton setImage:[UIImage imageNamed:@"phone_info"] forState:UIControlStateNormal];
        [_Agreedbutton setTitle:@" 联系员工" forState:UIControlStateNormal];
    }else{
        _Agreedbutton.hidden = YES;
        viewDetail.hidden = YES;
    }
    
    

}

-(void)TouchAgreedbutton:(UIButton *)sender{
 
    if ([self.DetailModel.informationTitle isEqualToString:@"企业推荐"]) {
        LPWorklistDataWorkListModel *workListModel = [[LPWorklistDataWorkListModel alloc] init];
        workListModel.id = self.DetailModel.workId;
        LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.workListModel = workListModel;
        vc.upIdentity = self.DetailModel.upIdentity;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        sender.enabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.DetailModel.userTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
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
                    [self.view showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        LPInfoVC  *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                        vc.isReloadData = YES;
                        [self.navigationController popToViewController:vc animated:YES];
                        //                    [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [self.view showLoadingMeg:@"操作失败" time:MESSAGE_SHOW_TIME];
                }
           
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


- (NSString *)removeHTML2:(NSString *)html{

    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSString *string = [attrStr.string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    return string;
    
    
}


-(void)setViewShapeLayer:(UIView *) View CornerRadii:(CGFloat) Radius byRoundingCorners:(UIRectCorner)corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(View.bounds.origin.x,
                                                                                View.bounds.origin.y,
                                                                                View.bounds.size.width,
                                                                                View.bounds.size.height)
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(Radius, Radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(View.bounds.origin.x,
                                 (View.bounds.origin.y),
                                 (View.bounds.size.width),
                                 (View.bounds.size.height)) ;
    maskLayer.path = maskPath.CGPath;
    View.layer.mask = maskLayer;
    
    
}

@end
