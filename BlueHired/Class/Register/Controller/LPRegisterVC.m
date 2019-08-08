//
//  LPRegisterVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisterVC.h"
#import "LPRegisterModel.h"
#import "LPRegisterDetailVC.h"
#import "LPInviteVC.h"
#import "LPRegisterEntryVC.h"


@interface LPRegisterVC ()

@property (nonatomic,strong) UILabel *BUserNumLabel;
@property (nonatomic,strong) UILabel *CUserNumLabel;
@property (nonatomic,strong) UILabel *sumNumLabel;
@property (nonatomic,strong) UILabel *fullMonthNumLabel;

@property (nonatomic,strong) UILabel *sumAmountLabel;
@property (nonatomic,strong) UILabel *unAmountLabel;
@property (nonatomic,strong) UILabel *remarkLabel;

@property (nonatomic,strong) UIScrollView *ScrollView;

@property(nonatomic,strong) LPRegisterModel *model;
@end

@implementation LPRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"邀请奖励";
    self.ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavBarHeight)];
    self.ScrollView.backgroundColor = [UIColor colorWithHexString:@"#548af7"];
    self.ScrollView.bounces = NO;
    self.ScrollView.alwaysBounceVertical = YES;
    self.ScrollView.showsHorizontalScrollIndicator = NO;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.ScrollView];
    [self.ScrollView layoutIfNeeded];
    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, LENGTH_SIZE(798));
    
    
    [self ScrollViewSub];


    
//    [self.ScrollView mas_makeConstraints:^(MASConstraintMaker *make){
//        make.top.left.bottom.right.mas_offset(0);
//    }];
    
    [self requestGetRegister];

}


-(void)setModel:(LPRegisterModel *)model{
    _model = model;
    self.CUserNumLabel.text = [NSString stringWithFormat:@"报名人数：%ld人",(long)model.data.inviteNum.integerValue];
    self.BUserNumLabel.text = [NSString stringWithFormat:@"预计奖励：%.2f元",model.data.totalMoney.floatValue];
    
    self.fullMonthNumLabel.text = [NSString stringWithFormat:@"注册人数：%ld人",model.data.sumNum.integerValue];
    self.sumNumLabel.text = [NSString stringWithFormat:@"预计奖励：%.2f元",model.data.regMoney.floatValue];

 
    self.remarkLabel.text = model.data.remark;
    
    CGFloat RemarkLabelH = [LPTools calculateRowHeight:self.remarkLabel.text fontSize:FontSize(14) Width:SCREEN_WIDTH - LENGTH_SIZE(2*13)];
    
    [self.ScrollView layoutIfNeeded];
    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, LENGTH_SIZE(798)+RemarkLabelH);

}


- (IBAction)touchDetailButton:(UIButton *)sender {
    if (sender.tag == 1000) {
        LPRegisterEntryVC *vc = [[LPRegisterEntryVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender.tag == 2000){
        LPRegisterDetailVC *vc = [[LPRegisterDetailVC alloc]init];
        vc.Type = 2;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)TouchRegister:(UIButton *)sender{
    LPInviteVC *vc = [[LPInviteVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark lazy
-(void)ScrollViewSub{

    NSLog(@"%f   %f",self.ScrollView.contentSize.width,_ScrollView.contentSize.width);
    
    UIImageView *headImage = [[UIImageView alloc] init];
    [_ScrollView addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(362));
        make.width.mas_offset(SCREEN_WIDTH);
    }];
    headImage.image = [UIImage imageNamed:@"bg_Register"];

    UIButton *button = [[UIButton alloc] init];
    [_ScrollView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(headImage.mas_bottom).offset(0);
        make.left.mas_offset(LENGTH_SIZE(27));
        make.width.mas_offset(LENGTH_SIZE(320));
        make.height.mas_offset(LENGTH_SIZE(48));
    }];
    [button setImage:[UIImage imageNamed:@"btn_Register"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(TouchRegister:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *lineV = [[UIImageView alloc] init];
    [_ScrollView addSubview:lineV];
    [lineV mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(button.mas_bottom).offset(LENGTH_SIZE(28));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.width.mas_offset(LENGTH_SIZE(351));
        make.height.mas_offset(LENGTH_SIZE(18));
    }];
    lineV.image = [UIImage imageNamed:@"divide"];

    UILabel *lineLabel = [[UILabel alloc] init];
    [_ScrollView addSubview:lineLabel];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(lineV);
    }];
    lineLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lineLabel.font = FONT_SIZE(16);
    lineLabel.text = @"个人业绩";

    UIView *view = [[UIView alloc] init];
    [_ScrollView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineV.mas_bottom).offset(LENGTH_SIZE(19));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.width.mas_offset(LENGTH_SIZE(351));
        make.height.mas_offset(LENGTH_SIZE(92));
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#FCFEFF"];
    view.layer.cornerRadius = LENGTH_SIZE(6);
    
    UIButton *ViewBt = [[UIButton alloc] init];
    [view addSubview:ViewBt];
    [ViewBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.right.mas_offset(0);
    }];
    ViewBt.tag = 1000;
    [ViewBt addTarget:self action:@selector(touchDetailButton:) forControlEvents:UIControlEventTouchUpInside];

    UIImageView *ArrowImage = [[UIImageView alloc] init];
    [view addSubview:ArrowImage];
    [ArrowImage mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(view);
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.height.with.mas_offset(LENGTH_SIZE(18));
    }];
    ArrowImage.image = [UIImage imageNamed:@"in_Register"];

    UILabel *label1 = [[UILabel alloc] init];
    [view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(view);
        make.left.mas_offset(LENGTH_SIZE(21));
    }];
    label1.textColor = [UIColor colorWithHexString:@"#999999"];
    label1.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label1.text = @"邀请入职";

    UILabel *label2 = [[UILabel alloc] init];
    self.sumAmountLabel = label2;
    [view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label1.mas_bottom).offset(LENGTH_SIZE(6));
        make.left.mas_offset(LENGTH_SIZE(21));
    }];
    label2.textColor = [UIColor baseColor];
    label2.font = [UIFont boldSystemFontOfSize:FontSize(21)];
    label2.text = @"0.00元";
    label2.hidden = YES;

    UIView *ViewLine =[[UIView alloc] init];
    [view addSubview:ViewLine];
    [ViewLine mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(16));
        make.bottom.mas_offset(LENGTH_SIZE(-16));
        make.left.mas_offset(LENGTH_SIZE(102));
        make.width.mas_offset(1);
    }];
    ViewLine.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];

    UILabel *label3 = [[UILabel alloc] init];
    [view addSubview:label3];
    self.BUserNumLabel = label3;
    [label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(label1).offset(LENGTH_SIZE(17));
        make.left.equalTo(ViewLine.mas_right).offset(LENGTH_SIZE(18));
    }];
    label3.textColor = [UIColor baseColor];
    label3.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label3.text = @"报名人数：0人";

    UILabel *label4 = [[UILabel alloc] init];
    self.CUserNumLabel = label4;
    [view addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(label1).offset(LENGTH_SIZE(-17));
        make.left.equalTo(ViewLine.mas_right).offset(LENGTH_SIZE(18));
    }];
    label4.textColor = [UIColor baseColor];
    label4.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label4.text = @"预计奖励：0元";



    UIView *view2= [[UIView alloc] init];
    [_ScrollView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view.mas_bottom).offset(LENGTH_SIZE(13));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.width.mas_offset(LENGTH_SIZE(351));
        make.height.mas_offset(LENGTH_SIZE(92));
    }];
    view2.backgroundColor = [UIColor colorWithHexString:@"#FCFEFF"];
    view2.layer.cornerRadius = LENGTH_SIZE(6);

    UIButton *View2Bt = [[UIButton alloc] init];
    [view2 addSubview:View2Bt];
    [View2Bt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.left.bottom.right.mas_offset(0);
    }];
    View2Bt.tag = 2000;
    [View2Bt addTarget:self action:@selector(touchDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    

    UIImageView *ArrowImageView2 = [[UIImageView alloc] init];
    [view2 addSubview:ArrowImageView2];
    [ArrowImageView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(view2);
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.height.with.mas_offset(LENGTH_SIZE(18));
    }];
    ArrowImageView2.image = [UIImage imageNamed:@"in_Register"];

    UILabel *label1View2 = [[UILabel alloc] init];
    [view2 addSubview:label1View2];
    [label1View2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(view2);
        make.left.mas_offset(LENGTH_SIZE(21));
    }];
    label1View2.textColor = [UIColor colorWithHexString:@"#999999"];
    label1View2.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label1View2.text = @"邀请注册";

    UILabel *label2View = [[UILabel alloc] init];
    self.unAmountLabel = label2View;
    [view2 addSubview:label2View];
    [label2View mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(label1View2.mas_bottom).offset(LENGTH_SIZE(6));
        make.left.mas_offset(LENGTH_SIZE(21));
    }];
    label2View.textColor = [UIColor baseColor];
    label2View.font = [UIFont boldSystemFontOfSize:FontSize(21)];
    label2View.text = @"0.00元";
    label2View.hidden = YES;

    UIView *ViewLineView2 =[[UIView alloc] init];
    [view2 addSubview:ViewLineView2];
    [ViewLineView2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_offset(LENGTH_SIZE(16));
        make.bottom.mas_offset(LENGTH_SIZE(-16));
        make.left.mas_offset(LENGTH_SIZE(102));
        make.width.mas_offset(1);
    }];
    ViewLineView2.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];

    UILabel *label3View2 = [[UILabel alloc] init];
    self.sumNumLabel = label3View2;
    [view2 addSubview:label3View2];
    [label3View2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(label1View2).offset(LENGTH_SIZE(17));
        make.left.equalTo(ViewLineView2.mas_right).offset(LENGTH_SIZE(18));
    }];
    label3View2.textColor = [UIColor baseColor];
    label3View2.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label3View2.text = @"注册人数：0人";

    UILabel *label4View2 = [[UILabel alloc] init];
    self.fullMonthNumLabel = label4View2;
    [view2 addSubview:label4View2];
    [label4View2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.equalTo(label1View2).offset(LENGTH_SIZE(-17));
        make.left.equalTo(ViewLineView2.mas_right).offset(LENGTH_SIZE(18));
    }];
    label4View2.textColor = [UIColor baseColor];
    label4View2.font = [UIFont boldSystemFontOfSize:FontSize(16)];
    label4View2.text = @"预计奖励：0元";

    UIImageView *lineV2 = [[UIImageView alloc] init];
    [_ScrollView addSubview:lineV2];
    [lineV2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(view2.mas_bottom).offset(LENGTH_SIZE(28));
        make.left.mas_offset(LENGTH_SIZE(13));
        make.width.mas_offset(LENGTH_SIZE(351));
        make.height.mas_offset(LENGTH_SIZE(18));
    }];
    lineV2.image = [UIImage imageNamed:@"divide"];

    UILabel *lineLabel2 = [[UILabel alloc] init];
    [_ScrollView addSubview:lineLabel2];
    [lineLabel2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.center.equalTo(lineV2);
    }];
    lineLabel2.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    lineLabel2.font = FONT_SIZE(16);
    lineLabel2.text = @"奖励规则";

    UILabel *DetailsLabel = [[UILabel alloc] init];
    self.remarkLabel = DetailsLabel;
    [_ScrollView addSubview:DetailsLabel];
    [DetailsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(lineV2.mas_bottom).offset(LENGTH_SIZE(20));
        make.left.mas_offset(LENGTH_SIZE(13));
//        make.right.mas_offset(LENGTH_SIZE(-13));
        make.width.mas_offset(SCREEN_WIDTH - LENGTH_SIZE(2*13));
//        make.bottom.mas_offset(LENGTH_SIZE(-61));
    }];
    DetailsLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    DetailsLabel.font = FONT_SIZE(14);
    DetailsLabel.numberOfLines = 0;
//    DetailsLabel.lineBreakMode = NSLineBreakByCharWrapping;


}

#pragma mark - request
-(void)requestGetRegister{
    NSDictionary *dic = @{@"versionType":@"2.3.1"};
    
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
