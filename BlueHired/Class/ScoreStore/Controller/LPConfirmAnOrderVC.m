//
//  LPConfirmAnOrderVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/23.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPConfirmAnOrderVC.h"
#import "LPStoreCartCell.h"
#import "NSTimer+block.h"
#import "LPShippingAddressVC.h"
#import "GJAlertWithDrawPassword.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "LPSalarycCard2VC.h"



static NSString *LPStoreCartCellID = @"LPStoreCartCell";

@interface LPConfirmAnOrderVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, strong) UILabel *NumLabel;
@property (nonatomic, strong) UIButton *convertBtn;

@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UILabel *OrderState;
@property (nonatomic, strong) UILabel *OrderTitle;
@property (nonatomic, strong) UIButton *OrderBtn;


@property (nonatomic, strong) UILabel *HeadViewName;
@property (nonatomic, strong) UILabel *HeadViewTel;
@property (nonatomic, strong) UILabel *HeadViewDefault;
@property (nonatomic, strong) UILabel *HeadViewAddress;
@property (nonatomic, strong) UILabel *HeadViewNorAddress;
@property (nonatomic, strong) UIView *OrderFooterView;

@property (nonatomic, strong) UIView *FooterView;
@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) NSMutableArray <UILabel *> *LabelArr;
@property (nonatomic, strong) UILabel *ScoreLabel;

@property (nonatomic, weak) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger seconds;//倒计时

@property(nonatomic,assign) NSInteger errorTimes;


@end

@implementation LPConfirmAnOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.Type ? @"订单详情" : @"确认订单";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self initFooterView];
     
    
    
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
    
    if (self.Type) {
        if (self.OrderModel) {
            LPOrderGenerateModel *GenerateModel =[[LPOrderGenerateModel alloc] init];
            LPOrderGenerateDataModel *GenerateDataModel =[[LPOrderGenerateDataModel alloc] init];
            GenerateDataModel.order = self.OrderModel;
            GenerateDataModel.orderItemList = self.OrderModel.orderItemList;
            GenerateDataModel.userTel = self.OrderModel.userTel;
            GenerateDataModel.serviceTel = self.OrderModel.serviceTel;

            GenerateModel.data = GenerateDataModel;
            
            [self setGenerateModel:GenerateModel];
        }else{
             [self setGenerateModel:self.GenerateModel];
        }

    }else{
         [self requestGetOrderAddressList];
         if (self.BuyType == 0) {
             self.NumLabel.text = [NSString stringWithFormat:@"合计：%ld 积分",self.BuyModel.price.intValue * self.BuyNumber];
         }else{
             NSInteger Numder = 0 ;
             for (LPCartItemListDataModel *m in self.CartArray) {
                 Numder += m.price.intValue * m.quantity.intValue;
             }
             self.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];
         }
         [self NumAttributedString:self.NumLabel];
        
    }
   
    
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    if (self.countDownTimer) {
//           [self.countDownTimer invalidate];
//           self.countDownTimer = nil;
//       }
}

-(void)dealloc{
    if (self.countDownTimer) {
           [self.countDownTimer invalidate];
           self.countDownTimer = nil;
       }
}

-(void)timeFireMethod{
    _seconds--;
    
    NSLog(@"倒计时 = %ld",(long)_seconds);
    
    if (_seconds >= 0) {
        self.OrderTitle.text = [NSString stringWithFormat:@"剩余时长：%ld分%ld秒",(long)_seconds/60,_seconds%60];
    }

    if(_seconds ==0){
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
        self.GenerateModel.data.order.status = @"4";
        [self setGenerateModel:self.GenerateModel];
        if (self.OrderModel) {
            self.OrderModel.setTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
            self.OrderModel.status = @"4";
            if (self.OrderBlock) {
                self.OrderBlock(self.OrderModel, 1);
            }
        }
    }
}



 -(void)initFooterView{
     UIView *FooterView = [[UIView alloc] init];
     [self.view addSubview:FooterView];
     self.OrderFooterView = FooterView;
     [FooterView  mas_makeConstraints:^(MASConstraintMaker *make){
         make.right.left.mas_offset(0);
         make.height.mas_offset(LENGTH_SIZE(49));
         if (@available(iOS 11.0, *)) {
             make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
         } else {
             make.bottom.mas_offset(0);
         }
     }];
     FooterView.backgroundColor = [UIColor whiteColor];
     FooterView.clipsToBounds = YES;
     
     [self.view addSubview:self.tableview];
     [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_offset(LENGTH_SIZE(0));
         make.left.right.mas_offset(0);
         make.bottom.equalTo(FooterView.mas_top).offset(0);
     }];
     
     
     UILabel *NumderLabel = [[UILabel alloc] init];
     self.NumLabel = NumderLabel;
     [FooterView addSubview:NumderLabel];
     [NumderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.bottom.mas_offset(0);
         make.left.mas_offset(LENGTH_SIZE(13));
     }];
     NumderLabel.textColor = [UIColor baseColor];
     NumderLabel.font = FONT_SIZE(16);
     NumderLabel.text = @"合计：0 积分";
     
     [self NumAttributedString:NumderLabel];
     
     
     
     UIButton *convertBtn = [[UIButton alloc] init];
     [FooterView addSubview:convertBtn];
     self.convertBtn = convertBtn;
     [convertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.top.bottom.mas_offset(0);
         make.width.mas_offset(LENGTH_SIZE(120));
     }];
//     convertBtn.backgroundColor = ;
     [convertBtn setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forState:UIControlStateNormal];
     [convertBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#9ED7FF"]] forState:UIControlStateDisabled];
     [convertBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [convertBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
     convertBtn.titleLabel.font = FONT_SIZE(17);
     [convertBtn addTarget:self action:@selector(TouchConvertBtn:) forControlEvents:UIControlEventTouchUpInside];
     
 }

#pragma mark - Touch

- (void)TouchConvertBtn:(UIButton *)sender{
    
    if (self.Type == 0) {  //直接购买
        if (self.GenerateModel == nil) {
            LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
            if (user.data.isBank.integerValue == 0) {        //添加银行卡
                GJAlertMessage *alert = [[GJAlertMessage alloc]
                                         initWithTitle:@"您还未绑定工资卡，请先绑定再兑换"
                                         message:nil
                                         textAlignment:NSTextAlignmentCenter
                                         buttonTitles:@[@"取消",@"去绑定"]
                                         buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                         buttonsBackgroundColors:@[[UIColor whiteColor],[UIColor whiteColor]]
                                         buttonClick:^(NSInteger buttonIndex) {
                                             if (buttonIndex) {
                                                 LPSalarycCard2VC *vc = [[LPSalarycCard2VC alloc] init];
                                                 vc.hidesBottomBarWhenPushed = YES;
                                                 [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                                             }
                                         }];
                [alert show];
            }else{
                 if (self.BuyType == 0) {
                                NSString *urlStr = [NSString stringWithFormat:@"order/generate_order_buy_now?productSkuId=%@&quantity=%ld&addressId=%@",
                                                    self.BuyModel.id,
                                                    (long)self.BuyNumber,
                                                    self.AddressModel.data[0].id];
                                [self requestOrderGenerate:urlStr Dictionart:nil];
                            }else if (self.BuyType == 1){
                                NSString *urlStr = [NSString stringWithFormat:@"order/generate_order?addressId=%@",
                                                           self.AddressModel.data[0].id];
                                       NSMutableArray *idsArr = [[NSMutableArray alloc] init];
                                       
                                       for (LPCartItemListDataModel *m in self.CartArray) {
                                           [idsArr addObject:m.id];
                                       }
                                       [self requestOrderGenerate:urlStr Dictionart:[idsArr mj_JSONObject]];

                            }
            }
        }else{
            [self  initAlertWithDrawPassWord];
        }
    }else if (self.Type == 1){
        [self  initAlertWithDrawPassWord];
    }
    
}

- (void)TouchSelectAddress:(UIButton *)sender{
    if (self.Type == 0) {
        LPShippingAddressVC *vc = [[LPShippingAddressVC alloc] init];
        vc.Type = 1;
        vc.SupreVC = self;
        if (self.AddressModel.data.count>0) {
            vc.SelectModel = self.AddressModel.data[0];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)ToService:(UIButton *)sender{
    if (self.GenerateModel.data.serviceTel) {
        sender.enabled = NO;
        NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.GenerateModel.data.serviceTel];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.enabled = YES;
        });
    }
    
}

- (void)TouchOrderBtn:(UIButton *)sender{
    if (self.GenerateModel.data.order.status.integerValue == 0) {   //取消订单  4
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否取消该订单？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                NSString *urlStr = [NSString stringWithFormat:@"order/update_order_status?orderId=%@&type=1",self.GenerateModel.data.order.id];
                [self requestOrderUpdateStatus:urlStr type:@"4"];
            }
        }];
        [alert show];
    } else if (self.GenerateModel.data.order.status.integerValue == 2){     //确认收货  3
        NSString *urlStr = [NSString stringWithFormat:@"order/update_order_status?orderId=%@&type=3",self.GenerateModel.data.order.id];
        [self requestOrderUpdateStatus:urlStr type:@"3"];
    } else if (self.GenerateModel.data.order.status.integerValue == 3 ||
               self.GenerateModel.data.order.status.integerValue == 4 ||
               self.GenerateModel.data.order.status.integerValue == 5){     //删除订单
        
                GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否删除该订单？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                NSString *urlStr = [NSString stringWithFormat:@"order/update_order_status?orderId=%@&type=2",self.GenerateModel.data.order.id];
                [self requestOrderUpdateStatus:urlStr type:@"2"];
            }
        }];
        [alert show];
        
        
    }
    
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.Type == 0) {
        if (self.BuyType == 0) {
            return 1;
        }else if (self.BuyType == 1){
            return self.CartArray.count;
        }
    }else if (self.Type == 1){
        return self.GenerateModel.data.orderItemList.count;
    }
    return 0;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return LENGTH_SIZE(121);
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPStoreCartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPStoreCartCellID];
    cell.Type = 3;
    cell.LayoutConstraint_selectBtn_Width.constant = 0;
//    cell.LayoutConstraint_Content_height.constant = LENGTH_SIZE(120);
    cell.LayoutConstraint_Content_Top.constant = LENGTH_SIZE(1);
    cell.LayoutConstraint_Content_bottom.constant = LENGTH_SIZE(20);
    
    if (self.Type == 0) {
        if (self.BuyType == 0) {
            cell.BuyNumber = self.BuyNumber;
            cell.BuyModel = self.BuyModel;
        }else if (self.BuyType == 1){
            cell.CartModel = self.CartArray[indexPath.row];
        }
    }else{
        cell.GenerateModel = self.GenerateModel.data.orderItemList[indexPath.row];

    }

    
    return cell;
}
 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = LENGTH_SIZE(121);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPStoreCartCellID bundle:nil] forCellReuseIdentifier:LPStoreCartCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];

        _tableview.tableHeaderView = self.HeadView;
        if (self.Type) {
            _tableview.tableFooterView = self.FooterView;
        }

//        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//
//        }];
//
//        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
//        }];
    }
    return _tableview;
}

-(UIView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(self.Type ? 180 : 90))];
        _HeadView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];

        if (self.Type == 1) {
            UIView *BgView = [[UIView alloc] init];
            [_HeadView addSubview:BgView];
            [BgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_offset(0);
                make.height.mas_offset(LENGTH_SIZE(90));
            }];
            BgView.backgroundColor = [UIColor baseColor];
            
            CAGradientLayer *gl = [CAGradientLayer layer];
            gl.frame = CGRectMake(0,0,SCREEN_WIDTH,LENGTH_SIZE(90));
            gl.startPoint = CGPointMake(1, 0);
            gl.endPoint = CGPointMake(1, 1);
            gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#43CCFF"].CGColor,
                          (__bridge id)[UIColor colorWithHexString:@"#1FA3FF"].CGColor];
            gl.locations = @[@(0.0),@(1.0)];

            [BgView.layer addSublayer:gl];
            
            UILabel *OrderState = [[UILabel alloc] init];
            [_HeadView addSubview:OrderState];
            self.OrderState = OrderState;

            [OrderState mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(LENGTH_SIZE(22));
                make.left.mas_offset(LENGTH_SIZE(13));
            }];
            OrderState.font = [UIFont boldSystemFontOfSize:FontSize(17)];
            OrderState.textColor = [UIColor whiteColor];
            OrderState.text = @"待支付";
            
            UILabel *OrderTitle = [[UILabel alloc] init];
            [_HeadView addSubview:OrderTitle];
            self.OrderTitle = OrderTitle;
            [OrderTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(OrderState.mas_bottom).offset(LENGTH_SIZE(8));
                make.left.mas_offset(LENGTH_SIZE(13));
            }];
            OrderTitle.font = FONT_SIZE(14);
            OrderTitle.textColor = [UIColor whiteColor];
            OrderTitle.text = @"剩余时长：0分0秒";
            
            UIButton *OrderBtn = [[UIButton alloc] init];
            [_HeadView addSubview:OrderBtn];
            self.OrderBtn = OrderBtn;
            [OrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_offset(LENGTH_SIZE(-13));
                make.top.mas_offset(LENGTH_SIZE(32));
                make.height.mas_offset(LENGTH_SIZE(28));
            }];
            [OrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            OrderBtn.titleLabel.font = FONT_SIZE(14);
            OrderBtn.layer.cornerRadius = LENGTH_SIZE(14);
            OrderBtn.layer.borderWidth = 1;
            OrderBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [OrderBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];
            [OrderBtn addTarget:self action:@selector(TouchOrderBtn:) forControlEvents:UIControlEventTouchUpInside];

        }
        
        UIView *ContentView = [[UIView alloc] init];
        [_HeadView addSubview:ContentView];
        [ContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(self.Type ? 100 : 10));
            make.right.mas_offset(0);
            make.width.mas_offset(SCREEN_WIDTH);
//            make.height.mas_offset(LENGTH_SIZE(70));
            make.bottom.mas_offset(LENGTH_SIZE(-10));
        }];
        ContentView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView *locationImage = [[UIImageView alloc] init];
        [ContentView addSubview:locationImage];
        [locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_offset(0);
            make.width.mas_offset(LENGTH_SIZE(38));
        }];
        locationImage.image = [UIImage imageNamed:@"detail_location"];
        locationImage.contentMode = UIViewContentModeCenter;
        
        UILabel *norAddressLabel = [[UILabel alloc] init];
        [ContentView addSubview:norAddressLabel];
        self.HeadViewNorAddress = norAddressLabel;
        [norAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(ContentView);
            make.left.equalTo(locationImage.mas_right).offset(0);
        }];
        norAddressLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        norAddressLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        norAddressLabel.text = self.Type ? @"" : @"选择收货地址";
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [ContentView addSubview:nameLabel];
        self.HeadViewName = nameLabel;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(14));
            make.left.equalTo(locationImage.mas_right).offset(0);
        }];
        nameLabel.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UILabel *TelLabel = [[UILabel alloc] init];
        [ContentView addSubview:TelLabel];
        self.HeadViewTel = TelLabel;
        [TelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameLabel);
            make.left.equalTo(nameLabel.mas_right).offset(8);
        }];
        TelLabel.font = [UIFont systemFontOfSize:FontSize(14)];
        TelLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UILabel *defaultAddress = [[UILabel alloc] init];
        [ContentView addSubview:defaultAddress];
        self.HeadViewDefault = defaultAddress;
        [defaultAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(nameLabel);
            make.left.equalTo(TelLabel.mas_right).offset(10);
            make.width.mas_offset(LENGTH_SIZE(55));
            make.height.mas_offset(LENGTH_SIZE(18));
        }];
        defaultAddress.font = [UIFont systemFontOfSize:FontSize(11)];
        defaultAddress.textColor = [UIColor whiteColor];
        defaultAddress.backgroundColor = [UIColor baseColor];
        defaultAddress.clipsToBounds = YES;
        defaultAddress.layer.cornerRadius = LENGTH_SIZE(2);
        defaultAddress.textAlignment = NSTextAlignmentCenter;
        defaultAddress.text = @"默认地址";
        defaultAddress.hidden = YES;
        
//        WorkHourBackImage_icon
        UIImageView *rightImage = [[UIImageView alloc] init];
        [ContentView addSubview:rightImage];
        [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.centerY.equalTo(ContentView);
        }];
        rightImage.image = self.Type == 0 ? [UIImage imageNamed:@"WorkHourBackImage_icon"] : [UIImage new];
        
        rightImage.hidden = self.Type;
        
        UILabel *Address = [[UILabel alloc] init];
        [ContentView addSubview:Address];
        self.HeadViewAddress = Address;
        [Address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(LENGTH_SIZE(8));
            make.left.equalTo(locationImage.mas_right).offset(0);
            make.right.mas_offset(LENGTH_SIZE(self.Type ? -13 : -20));
        }];
        Address.numberOfLines = 0;
        Address.textColor = [UIColor colorWithHexString:@"#808080"];
        Address.font = FONT_SIZE(13);
        Address.lineBreakMode = NSLineBreakByCharWrapping;

        UIImageView *lineImage = [[UIImageView alloc] init];
        [ContentView addSubview:lineImage];
        [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(2));
        }];
        lineImage.image = [UIImage imageNamed:@"add_line"];
        
        UIButton *selectAddress = [[UIButton alloc]init];
        [ContentView addSubview:selectAddress];
        [selectAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(ContentView);
        }];
        
        [selectAddress addTarget:self action:@selector(TouchSelectAddress:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _HeadView;
}

-(UIView *)FooterView{
    if (!_FooterView) {
        _FooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(307))];
        _FooterView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        
        UIView *View = [[UIView alloc] init];
        [_FooterView addSubview:View];
        [View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(1));
            make.left.right.mas_offset(0);
            make.height.mas_offset(40);
        }];
        View.backgroundColor = [UIColor whiteColor];
        
        UILabel *ScoreLabel = [[UILabel alloc] init];
        [View addSubview:ScoreLabel];
        self.ScoreLabel = ScoreLabel;
        [ScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.centerY.equalTo(View);
        }];
        ScoreLabel.font = FONT_SIZE(16);
        ScoreLabel.text = @"合计：0 积分";
        
        [self NumAttributedString:ScoreLabel];
        
        UIView *View2 = [[UIView alloc] init];
        [_FooterView addSubview:View2];
        [View2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(View.mas_bottom).offset(LENGTH_SIZE(10));
            make.left.right.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(40));
        }];
        View2.backgroundColor = [UIColor whiteColor];
        
        UILabel *DetailsTitle = [[UILabel alloc] init];
        [View2 addSubview:DetailsTitle];
        [DetailsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
            make.centerY.equalTo(View2);
        }];
        DetailsTitle.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        DetailsTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        DetailsTitle.text = @"订单详情";
        
        UIView *View3 = [[UIView alloc] init];
        [_FooterView addSubview:View3];
        self.labelView = View3;
        [View3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(View2.mas_bottom).offset(LENGTH_SIZE(1));
            make.left.right.mas_offset(0);
        }];
        View3.backgroundColor = [UIColor whiteColor];

        self.LabelArr = [[NSMutableArray alloc] init];
        for (NSInteger i =0; i <4; i++) {
            UILabel *label = [[UILabel alloc] init];
            label.font = FONT_SIZE(13);
            label.textColor = [UIColor colorWithHexString:@"#808080"];
            label.text = @"订单编号：2019091613201445";
            [View3 addSubview:label];
            [self.LabelArr addObject:label];
        }
        
        [self.LabelArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:LENGTH_SIZE(10) leadSpacing:LENGTH_SIZE(16) tailSpacing:LENGTH_SIZE(16)];
        [self.LabelArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(-13));
        }];
        
        
        UIButton *ServiceBtn = [[UIButton alloc] init];
        [_FooterView addSubview:ServiceBtn];
        [ServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(View3.mas_bottom).offset(LENGTH_SIZE(24));
            make.left.mas_offset(LENGTH_SIZE(18));
            make.right.mas_offset(LENGTH_SIZE(-18));
            make.height.mas_offset(LENGTH_SIZE(48));
//            make.bottom.mas_offset(LENGTH_SIZE(-30));
        }];
        ServiceBtn.clipsToBounds = YES;
        ServiceBtn.layer.cornerRadius = LENGTH_SIZE(6);
        [ServiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ServiceBtn.titleLabel.font = FONT_SIZE(17);
        [ServiceBtn setTitle:@"  联系客服" forState:UIControlStateNormal];
        [ServiceBtn setImage:[UIImage imageNamed:@"c_service"] forState:UIControlStateNormal];
        ServiceBtn.backgroundColor = [UIColor baseColor];
        [ServiceBtn addTarget:self action:@selector(ToService:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _FooterView;
}



- (void)initLabelView:(NSArray *) strArr{
    
    [self.labelView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.LabelArr removeAllObjects];
    for (NSInteger i =0; i <strArr.count; i++) {
       UILabel *label = [[UILabel alloc] init];
       label.font = FONT_SIZE(13);
       label.textColor = [UIColor colorWithHexString:@"#808080"];
       label.text = strArr[i];
       [self.labelView addSubview:label];
       [self.LabelArr addObject:label];
   }
   
    if (self.LabelArr.count > 1) {
        [self.LabelArr mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:LENGTH_SIZE(10) leadSpacing:LENGTH_SIZE(16) tailSpacing:LENGTH_SIZE(16)];
        [self.LabelArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(LENGTH_SIZE(13));
        }];
    }

    if (strArr.count == 4) {
        self.FooterView.lx_height = LENGTH_SIZE(307);
    }else if (strArr.count == 3){
        self.FooterView.lx_height = LENGTH_SIZE(284);
    }else if (strArr.count == 2){
        self.FooterView.lx_height = LENGTH_SIZE(254);
    }
  
}


-(void)NumAttributedString:(UILabel *)NumLabel{
    if (!NumLabel) {
        return;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NumLabel.text];
    
    [string addAttributes:@{NSFontAttributeName: FONT_SIZE(13),
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]}
                    range:NSMakeRange(0, 3)];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(16)],
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF7F00"]}
                    range:NSMakeRange(3, NumLabel.text.length - 6)];
    
    [string addAttributes:@{NSFontAttributeName: FONT_SIZE(13),
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#808080"]} range:NSMakeRange(NumLabel.text.length - 3, 3)];
    
    NumLabel.attributedText = string;
}


- (void)setAddressModel:(LPOrderAddressModel *)AddressModel{
    _AddressModel = AddressModel;
    if (_AddressModel.data.count > 0) {
        
        self.HeadViewName.hidden = NO;
        self.HeadViewTel.hidden = NO;
        self.HeadViewDefault.hidden = NO;
        self.HeadViewAddress.hidden = NO;
        self.HeadViewNorAddress.hidden = YES;
        self.convertBtn.enabled = YES;

        LPOrderAddressDataModel *AddM = AddressModel.data[0];
        self.HeadViewName.text = AddM.name;
        self.HeadViewTel.text = AddM.phone;
        self.HeadViewDefault.hidden = !AddM.sendStatus.integerValue;

        NSString *strCity = [AddM.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
        if ([AddM.province isEqualToString:strCity]) {
            if ([AddM.region isEqualToString:@"全市"]) {
                self.HeadViewAddress.text = [NSString stringWithFormat:@"%@ %@",AddM.city,AddM.detailAddress];
            }else{
                self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@ %@",AddM.city,AddM.region,AddM.detailAddress];
            }
        }else{
            if ([AddM.region isEqualToString:@"全市"]) {
                self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@ %@",AddM.province,AddM.city,AddM.detailAddress];
            }else{
                self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@%@ %@",AddM.province,AddM.city,AddM.region,AddM.detailAddress];
            }
        }
        self.HeadView.lx_height = LENGTH_SIZE(self.Type ? 180 : 90);

        CGFloat AddressTopH = [LPTools calculateRowHeight:@" " fontSize:FontSize(13) Width:40];

        CGFloat AddressH = [LPTools calculateRowHeight:self.HeadViewAddress.text fontSize:FontSize(13) Width:SCREEN_WIDTH-LENGTH_SIZE(38)-LENGTH_SIZE(self.Type ? 13 : 20)];
        
        self.HeadView.lx_height = self.HeadView.lx_height+AddressH-AddressTopH;
                
        self.tableview.tableHeaderView = self.HeadView;
        
    }else{
        self.HeadViewName.hidden = YES;
        self.HeadViewTel.hidden = YES;
        self.HeadViewDefault.hidden = YES;
        self.HeadViewAddress.hidden = YES;
        self.HeadViewNorAddress.hidden = NO;
        self.convertBtn.enabled = NO;
        
        
    }
}


- (void)setGenerateModel:(LPOrderGenerateModel *)GenerateModel{
    _GenerateModel = GenerateModel;
    if (self.Type == 0) {
        [self initAlertWithDrawPassWord];
        if (self.CartBlock) {
            self.CartBlock();
        }
    }else if (self.Type == 1){
        [self initOrderDetailsVC:GenerateModel.data.order];
    }
    
}


- (void)initOrderDetailsVC:(LPOrderGenerateDataorderModel *) order{
    
        self.HeadViewName.hidden = NO;
       self.HeadViewTel.hidden = NO;
       self.HeadViewDefault.hidden = YES;
       self.HeadViewAddress.hidden = NO;
       self.HeadViewNorAddress.hidden = YES;
       self.convertBtn.enabled = YES;

       self.HeadViewName.text = order.receiverName;
       self.HeadViewTel.text = order.receiverPhone;

       NSString *strCity = [order.receiverCity stringByReplacingOccurrencesOfString:@"市" withString:@""];
       if ([order.receiverProvince isEqualToString:strCity]) {
           if ([order.receiverRegion isEqualToString:@"全市"]) {
               self.HeadViewAddress.text = [NSString stringWithFormat:@"%@ %@",order.receiverCity,order.receiverDetailAddress];
           }else{
               self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@ %@",order.receiverCity,order.receiverRegion,order.receiverDetailAddress];
           }
       }else{
           if ([order.receiverRegion isEqualToString:@"全市"]) {
               self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@ %@",order.receiverProvince,order.receiverCity,order.receiverDetailAddress];
           }else{
               self.HeadViewAddress.text = [NSString stringWithFormat:@"%@%@%@ %@",order.receiverProvince,order.receiverCity,order.receiverRegion,order.receiverDetailAddress];
           }
       }
    
    self.HeadView.lx_height = LENGTH_SIZE(self.Type ? 180 : 90);

    
    CGFloat AddressTopH = [LPTools calculateRowHeight:@" " fontSize:FontSize(13) Width:40];

    CGFloat AddressH = [LPTools calculateRowHeight:self.HeadViewAddress.text fontSize:FontSize(13) Width:SCREEN_WIDTH-LENGTH_SIZE(38)-LENGTH_SIZE(self.Type ? 13 : 20)];
    
    self.HeadView.lx_height = self.HeadView.lx_height+AddressH-AddressTopH;
            
    self.tableview.tableHeaderView = self.HeadView;
    
    
    [self.OrderFooterView  mas_remakeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(0));
        make.bottom.mas_offset(0);
    }];
    
    self.OrderBtn.hidden = NO;
    
    self.ScoreLabel.text = [NSString stringWithFormat:@"合计：%@ 积分",order.totalAmount];
    [self NumAttributedString:self.ScoreLabel];

    if (self.GenerateModel.data.order.status.intValue == 0) {       //待付款

        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        
        [self initLabelView: @[OrderSn,timeStr]];
        
        self.OrderState.text = @"待支付";
        self.OrderTitle.text = @"剩余时长：0分0秒";
        [self.OrderBtn setTitle:@"  取消订单  " forState:UIControlStateNormal];

        [self.OrderFooterView  mas_remakeConstraints:^(MASConstraintMaker *make){
            make.right.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(49));
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
            } else {
                make.bottom.mas_offset(0);
            }
        }];
        
        self.NumLabel.text = [NSString stringWithFormat:@"合计：%@ 积分",order.totalAmount];
        [self NumAttributedString:self.NumLabel];

        
        _seconds = 30*60 - ([NSString getNowTimestamp] - order.time.integerValue)/1000 ;
               if (_seconds > 0) {
                   if (self.countDownTimer) {
                       [self.countDownTimer invalidate];
                       self.countDownTimer = nil;
                   }
                   
                   WEAK_SELF()
                   self.countDownTimer = [NSTimer repeatWithInterval:1 block:^(NSTimer *timer) {
                              //收到timer回调
                       [weakSelf timeFireMethod];

                   }];
               }else{
                   self.GenerateModel.data.order.status = @"4";
                   [self setGenerateModel:self.GenerateModel];
                   if (self.OrderModel) {
                       self.OrderModel.setTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                       self.OrderModel.status = @"4";
                       if (self.OrderBlock) {
                           self.OrderBlock(self.OrderModel, 1);
                       }
                   }
               }
        
        
        
    }else if (self.GenerateModel.data.order.status.intValue == 1) {     //待发货
        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        NSString *paymentTimeStr = [NSString stringWithFormat:@"兑换时间：%@",[NSString convertStringToTime:order.paymentTime]];
    
        [self initLabelView: @[OrderSn,timeStr,paymentTimeStr]];
        self.OrderState.text = @"下单成功，商品等待发货";
        self.OrderTitle.text = @"客服人员正在马不停蹄的处理订单，请耐心等候";
        self.OrderBtn.hidden = YES;

    }else if (self.GenerateModel.data.order.status.intValue == 2){      //已发货
        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        NSString *paymentTimeStr = [NSString stringWithFormat:@"兑换时间：%@",[NSString convertStringToTime:order.paymentTime]];
        NSString *deliveryTimeStr = [NSString stringWithFormat:@"发货时间：%@",[NSString convertStringToTime:order.deliveryTime]];
        
        [self initLabelView: @[OrderSn,timeStr,paymentTimeStr,deliveryTimeStr]];
        self.OrderState.text = @"待收货";
        self.OrderTitle.text = @"客服人员处理完成，请等待收货";
        [self.OrderBtn setTitle:@"  确认收货  " forState:UIControlStateNormal];

        
    }else if (self.GenerateModel.data.order.status.intValue == 3){      //已完成
        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        NSString *paymentTimeStr = [NSString stringWithFormat:@"兑换时间：%@",[NSString convertStringToTime:order.paymentTime]];
        NSString *deliveryTimeStr = [NSString stringWithFormat:@"发货时间：%@",[NSString convertStringToTime:order.deliveryTime]];
        
        [self initLabelView: @[OrderSn,timeStr,paymentTimeStr,deliveryTimeStr]];
        
        self.OrderState.text = @"订单完成";
        self.OrderTitle.text = @"感谢您的使用，祝您生活愉快~";
        [self.OrderBtn setTitle:@"  删除订单  " forState:UIControlStateNormal];
        
    }else if (self.GenerateModel.data.order.status.intValue == 4){      //已关闭
        self.OrderState.text = @"交易关闭";

        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        NSString *setTimeStr = [NSString stringWithFormat:@"取消时间：%@",[NSString convertStringToTime:order.setTime]];
        
        [self initLabelView: @[OrderSn,timeStr,setTimeStr]];
        self.OrderTitle.text = @"订单已取消";
        [self.OrderBtn setTitle:@"  删除订单  " forState:UIControlStateNormal];
    }else if (self.GenerateModel.data.order.status.intValue == 5){      //已关闭
        self.OrderState.text = @"积分已退还";

        NSString *OrderSn = [NSString stringWithFormat:@"订单编号：%@",order.orderSn];
        NSString *timeStr = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToTime:order.time]];
        NSString *paymentTimeStr = [NSString stringWithFormat:@"兑换时间：%@",[NSString convertStringToTime:order.paymentTime]];
        NSString *backTimeStr = [NSString stringWithFormat:@"积分退还时间：%@",[NSString convertStringToTime:order.backTime]];

        [self initLabelView: @[OrderSn,timeStr,paymentTimeStr,backTimeStr]];
        self.OrderTitle.text = @"相应积分系统会自动返还给您";
        [self.OrderBtn setTitle:@"  删除订单  " forState:UIControlStateNormal];
    }
}


- (void)initAlertWithDrawPassWord{
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
       dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
       NSString *string = [dateFormatter stringFromDate:[NSDate date]];
       if (kUserDefaultsValue(ERRORTIMES)) {
           NSString *errorString = kUserDefaultsValue(ERRORTIMES);
           if(errorString.length<17){
               kUserDefaultsRemove(ERRORTIMES);
           }else{
               NSString *d = [errorString substringToIndex:16];
               NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
               NSString *t = [errorString substringFromIndex:17];
               self.errorTimes = [t integerValue];
               if ([t integerValue] >= 3 && [str integerValue] < 10) {
                   GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                       if (self.Type == 0) {
                           [self ToOrderVC];
                       }
                   }];
                   [alert show];
                   return;
               }
               else
               {
                   kUserDefaultsRemove(ERRORTIMES);
               }
           }
       }
       
    
       
    NSString *str1 = [NSString stringWithFormat:@"将消耗%@积分兑换商品，请输入提现密码验证身份",self.GenerateModel.data.order.totalAmount];
       NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
       //设置：在3~length-3个单位长度内的内容显示色
       [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor]
                   range:[str1 rangeOfString:[NSString stringWithFormat:@"%@积分",self.GenerateModel.data.order.totalAmount]]];
       
       
       GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                              message:@""
                                                         buttonTitles:@[]
                                                         buttonsColor:@[[UIColor baseColor]]
                                                          buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                              if (string.length==6) {
                                                                  [self requestOrderPayOrder:self.GenerateModel.data.order.id DrawPwd:string];
                                                              }else{
                                                                  if (self.Type == 0) {
                                                                      LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                      vc.type = 1;
                                                                      vc.Phone = self.GenerateModel.data.userTel;

                                                                      NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                                                                      for (UIViewController *vc in naviVCsArr) {
                                                                          if ([vc isKindOfClass:[self class]]) {
                                                                              [naviVCsArr removeObject:vc];
                                                                              break;
                                                                          }
                                                                      }
                                                                      [naviVCsArr addObject:vc];
                                                                      vc.hidesBottomBarWhenPushed = YES;
                                                                      [self.navigationController  setViewControllers:naviVCsArr animated:YES];
                                                                  }else{
                                                                      LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                      vc.type = 1;
                                                                      vc.Phone = self.GenerateModel.data.userTel;
                                                                   
                                                                      vc.hidesBottomBarWhenPushed = YES;
                                                                      [self.navigationController  pushViewController:vc animated:YES];
                                                                  }
                                                                  
                                                                  
                                                              }
                                                            
       }];
       [alert show];
    WEAK_SELF()
    alert.DismissBlock = ^{
        if (weakSelf.Type == 0 ) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf ToOrderVC];
            });
        }
    };
    
}

-(void)ToOrderVC{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
       

        NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
        for (UIViewController *vc in naviVCsArr) {
            if ([vc isKindOfClass:[self class]]) {
                [naviVCsArr removeObject:vc];
                break;
            }
        }
        [naviVCsArr addObject:vc];
        vc.Type = 1;
        vc.GenerateModel = self.GenerateModel;
        [self.navigationController  setViewControllers:naviVCsArr animated:YES];
    });
    

}

#pragma mark - request
-(void)requestGetOrderAddressList{
    NSDictionary *dic = @{@"type":@"1"};
    [NetApiManager requestGetOrderAddressList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.AddressModel = [LPOrderAddressModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestOrderPayOrder:(NSString *) orderId DrawPwd:(NSString *) drawPwd{
 
    NSString *passwordmd5 = [drawPwd md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSString *urlStr = [NSString stringWithFormat:@"order/pay_order?orderId=%@&drawPwd=%@",
    orderId,
    newPasswordmd5];
    
    
    [NetApiManager requestOrderPayOrder:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 if ([responseObject[@"data"] integerValue] ==1) {
                     
                     if (self.Type == 0) {
                         self.GenerateModel.data.order.status = @"1";
                         self.GenerateModel.data.order.paymentTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];

                         [self ToOrderVC];
                     }else{
                         if (self.countDownTimer) {
                                [self.countDownTimer invalidate];
                                self.countDownTimer = nil;
                            }
                         self.GenerateModel.data.order.paymentTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                         self.GenerateModel.data.order.status = @"1";

                         [self setGenerateModel:self.GenerateModel];
                     }
                     
                     if (self.OrderModel) {
                         self.OrderModel.paymentTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                         self.OrderModel.status = @"1";
                         if (self.OrderBlock) {
                             self.OrderBlock(self.OrderModel, 0);
                         }
                     }
                     
                     [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"支付成功" time:MESSAGE_SHOW_TIME];

                     
                 }else{
                     if (self.Type == 0) {
                         [self ToOrderVC];
                     }
                     [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"支付失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                 }
            }else{
                if ([responseObject[@"code"] integerValue] == 20027) {
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
                    NSString *string = [dateFormatter stringFromDate:[NSDate date]];
                    
                    if (kUserDefaultsValue(ERRORTIMES)) {
                        NSString *errorString = kUserDefaultsValue(ERRORTIMES);
                        NSString *d = [errorString substringToIndex:16];
                        NSString *t = [errorString substringFromIndex:17];
                        NSString *str = [LPTools dateTimeDifferenceWithStartTime:d endTime:string];
                        
                        self.errorTimes = [t integerValue];
                        if ([t integerValue] >= 3&& [str integerValue] < 10) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"提现密码错误次数过多，请10分钟后再试" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                if (self.Type == 0) {
                                    [self ToOrderVC];
                                }
                            }];
                            [alert show];
                        }else{
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                            buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                                                                                 if (buttonIndex == 0) {
                                                                                     LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                     vc.type = 1;
                                                                                     vc.Phone = self.GenerateModel.data.userTel;
                                                                                     vc.hidesBottomBarWhenPushed = YES;

                                                                                     if (self.Type == 0 ) {
                                                                                         NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                                                                                         for (UIViewController *vc in naviVCsArr) {
                                                                                             if ([vc isKindOfClass:[self class]]) {
                                                                                                 [naviVCsArr removeObject:vc];
                                                                                                 break;
                                                                                             }
                                                                                         }
                                                                                         [naviVCsArr addObject:vc];
                                                                                         [self.navigationController  setViewControllers:naviVCsArr animated:YES];
                                                                                     }else{
                                                                                         [self.navigationController pushViewController:vc animated:YES];
                                                                                     }
                                                                                     
                                                                                 }else if (buttonIndex == 1){
                                                                                     [self initAlertWithDrawPassWord];
                                                                                 }
                                                                                 
                                                                             }];
                            
                            [alert show];
                            
                            self.errorTimes += 1;
                            NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                            kUserDefaultsSave(str, ERRORTIMES);
                        }
                    }else{
                        if (self.errorTimes >2) {
                            self.errorTimes = 0;
                        }
                        
                        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                             message:nil
                                                                       textAlignment:NSTextAlignmentCenter
                                                                        buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                        buttonsColor:@[[UIColor colorWithHexString:@"#808080"],[UIColor baseColor]]
                                                             buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                         buttonClick:^(NSInteger buttonIndex) {
                                                                             if (buttonIndex == 0) {
                                                                                 LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                 vc.type = 1;
                                                                                 vc.Phone = self.GenerateModel.data.userTel;
                                                                                 vc.hidesBottomBarWhenPushed = YES;

                                                                                 if (self.Type == 0 ) {
                                                                                     NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
                                                                                     for (UIViewController *vc in naviVCsArr) {
                                                                                         if ([vc isKindOfClass:[self class]]) {
                                                                                             [naviVCsArr removeObject:vc];
                                                                                             break;
                                                                                         }
                                                                                     }
                                                                                     [naviVCsArr addObject:vc];
                                                                                     [self.navigationController  setViewControllers:naviVCsArr animated:YES];
                                                                                 }else{
                                                                                     [self.navigationController pushViewController:vc animated:YES];
                                                                                 }
                                                                                 
                                                                             }else if (buttonIndex == 1){
                                                                                 [self initAlertWithDrawPassWord];
                                                                             }
                                                                         }];
                        
                        [alert show];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestOrderGenerate:(NSString *) urlStr Dictionart:(NSDictionary *) dic{
    
    [NetApiManager requestOrderGenerate:dic URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.GenerateModel = [LPOrderGenerateModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestOrderUpdateStatus:(NSString *) urlStr type:(NSString *)type{
    
    [NetApiManager requestOrderUpdateStatus:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self.view showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                    if (type.integerValue == 2) {
//                        删除订单
                        if (self.OrderModel) {
                            if (self.OrderBlock) {
                                self.OrderBlock(self.OrderModel, 2);
                            }
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if (type.integerValue == 4) {
                        self.GenerateModel.data.order.status = @"4";
                        self.GenerateModel.data.order.setTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                        [self setGenerateModel:self.GenerateModel];
                        
                        if (self.OrderModel) {
                            self.OrderModel.setTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                            self.OrderModel.status = @"4";
                            if (self.OrderBlock) {
                                self.OrderBlock(self.OrderModel, 1);
                            }
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }else if (type.integerValue== 3){
                        self.GenerateModel.data.order.status = @"3";
                        self.GenerateModel.data.order.receiveTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                        [self setGenerateModel:self.GenerateModel];
                        
                        if (self.OrderModel) {
                            self.OrderModel.receiveTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                            self.OrderModel.status = @"3";
                            if (self.OrderBlock) {
                                self.OrderBlock(self.OrderModel, 3);
                            }
                        }
                        
                    }
                    
                }else{
                    [self.view showLoadingMeg:@"操作失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
