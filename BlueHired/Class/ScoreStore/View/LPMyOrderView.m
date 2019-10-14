//
//  LPMyOrderView.m
//  BlueHired
//
//  Created by iMac on 2019/9/24.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPMyOrderView.h"
#import "LPStoreCartCell.h"
#import "LPSalarycCardBindPhoneVC.h"
#import "LPConfirmAnOrderVC.h"

static NSString *LPStoreCartCellID = @"LPStoreCartCell";

@interface LPMyOrderView() <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) LPMyOrderModel *model;
@property(nonatomic,assign) NSInteger errorTimes;

@end

@implementation LPMyOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.tableview];
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}


- (void)GetOrderList{
    self.page = 1;
    [self requestGetOrderList];
}

#pragma mark - Touch
- (void)TouchUpdateOrderStatusBtn:(UIButton *) sender{
    
    LPOrderGenerateDataorderModel *OrderModel = self.listArray[sender.tag - 1000];
    
    if (OrderModel.status.integerValue == 0) {      //付款
       [self initAlertWithDrawPassWord:OrderModel];

    }else if (OrderModel.status.integerValue == 2){
        NSString *urlStr = [NSString stringWithFormat:@"order/update_order_status?orderId=%@&type=3",OrderModel.id];
        [self requestOrderUpdateStatus:urlStr type:@"3" Order:OrderModel];
    }else if (OrderModel.status.integerValue == 4 ||
              OrderModel.status.integerValue == 3 ||
              OrderModel.status.integerValue == 5){
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:@"是否删除该订单？" message:nil textAlignment:NSTextAlignmentCenter buttonTitles:@[@"否",@"是"] buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex) {
                NSString *urlStr = [NSString stringWithFormat:@"order/update_order_status?orderId=%@&type=2",OrderModel.id];
                [self requestOrderUpdateStatus:urlStr type:@"2" Order:OrderModel];
            }
        }];
        [alert show];
     
    }
}


-(void)TouchHeadViewORFooter:(UITapGestureRecognizer *)recognizer{
    LPOrderGenerateDataorderModel *Order = self.listArray[recognizer.view.tag-1000];
    
    [self ToConfirmAnOrderVC:Order];
    
}

#pragma mark - 付款
- (void)initAlertWithDrawPassWord:(LPOrderGenerateDataorderModel *)OrderModel{
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
       
    
       
    NSString *str1 = [NSString stringWithFormat:@"将消耗%@积分兑换商品，请输入提现密码验证身份",OrderModel.totalAmount];
       NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
       //设置：在3~length-3个单位长度内的内容显示色
       [str addAttribute:NSForegroundColorAttributeName value:[UIColor baseColor]
                   range:[str1 rangeOfString:[NSString stringWithFormat:@"%@积分",OrderModel.totalAmount]]];
       
       
       GJAlertWithDrawPassword *alert = [[GJAlertWithDrawPassword alloc] initWithTitle:str
                                                              message:@""
                                                         buttonTitles:@[]
                                                         buttonsColor:@[[UIColor baseColor]]
                                                          buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                              if (string.length==6) {
                                                                  [self requestOrderPayOrder:OrderModel DrawPwd:string];
                                                              }else{
                                                                  
                                                                  LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                  vc.type = 1;
                                                                  vc.Phone = OrderModel.userTel;
                                                               
                                                                  vc.hidesBottomBarWhenPushed = YES;
                                                                  [[UIWindow visibleViewController].navigationController  pushViewController:vc animated:YES];
                                                                 
                                                                  
                                                              }
                                                            
       }];
       [alert show];
    
    
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.listArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray[section].orderItemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LENGTH_SIZE(40);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    LPOrderGenerateDataorderModel *OrderModel = self.listArray[section];
    
    UIView *View = [[UIView alloc] init];
    View.backgroundColor = [UIColor whiteColor];
    UILabel *TimeLabel = [[UILabel alloc] init];
    [View addSubview:TimeLabel];
    [TimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(View);
        make.left.mas_offset(LENGTH_SIZE(13));
    }];
    TimeLabel.font = FONT_SIZE(13);
    TimeLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    TimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",[NSString convertStringToYYYMMDD:OrderModel.time]];
    
    UILabel *StateLabel = [[UILabel alloc] init];
    [View addSubview:StateLabel];
    [StateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(View);
        make.right.mas_offset(LENGTH_SIZE(-13));
    }];
    StateLabel.font = FONT_SIZE(13);
    StateLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    //0->待付款；1->已付款；2->已发货；3->已完成；4->已关闭
    if (OrderModel.status.integerValue == 0) {
        StateLabel.text = @"待支付";
        StateLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
    } else if (OrderModel.status.integerValue == 1) {
        StateLabel.text = @"待发货";
        StateLabel.textColor = [UIColor colorWithHexString:@"#FFAA00"];
    } else if (OrderModel.status.integerValue == 2) {
         StateLabel.text = @"已完成";
    } else if (OrderModel.status.integerValue == 3) {
        StateLabel.text = @"已完成";
    } else if (OrderModel.status.integerValue == 4) {
        StateLabel.text = @"交易关闭";
    } else if (OrderModel.status.integerValue == 5) {
        StateLabel.text = @"积分已退还";
        StateLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
    }
      
    View.tag = section + 1000;
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchHeadViewORFooter:)];
    [View addGestureRecognizer:TapGestureRecognizerimageBg];
    
    return View;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return LENGTH_SIZE(50);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    LPOrderGenerateDataorderModel *OrderModel = self.listArray[section];
    
    UIView *View = [[UIView alloc] init];
    View.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
    
    UIView *SubView = [[UIView alloc] init];
    [View addSubview:SubView];
    [SubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(1));
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(40));
    }];
    SubView.backgroundColor = [UIColor whiteColor];
    
    UILabel *NumderLabel = [[UILabel alloc] init];

    [SubView addSubview:NumderLabel];
    [NumderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(SubView);
        make.left.mas_offset(LENGTH_SIZE(13));
    }];
    NumderLabel.textColor = [UIColor baseColor];
    NumderLabel.font = FONT_SIZE(16);
    NumderLabel.text = [NSString stringWithFormat:@"合计：%@ 积分",OrderModel.totalAmount];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NumderLabel.text];
    
    [string addAttributes:@{NSFontAttributeName: FONT_SIZE(13),
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#333333"]}
                    range:NSMakeRange(0, 3)];
    
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(16)],
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF7F00"]}
                    range:NSMakeRange(3, NumderLabel.text.length - 6)];
    
    [string addAttributes:@{NSFontAttributeName: FONT_SIZE(13),
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]} range:NSMakeRange(NumderLabel.text.length - 3, 3)];
    
    NumderLabel.attributedText = string;
    
    UILabel *CountLabel = [[UILabel alloc] init];
    [SubView addSubview:CountLabel];
    [CountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(SubView);
        make.left.equalTo(NumderLabel.mas_right).offset(LENGTH_SIZE(10));
    }];
    CountLabel.font = FONT_SIZE(13);
    CountLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    CountLabel.text = [NSString stringWithFormat:@"共%@件商品",OrderModel.totalQuantity];
    
    UIButton *Btn = [[UIButton alloc] init];
    [SubView addSubview:Btn];
    [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(SubView);
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.width.mas_offset(LENGTH_SIZE(72));
        make.height.mas_offset(LENGTH_SIZE(24));
    }];
    Btn.layer.cornerRadius = LENGTH_SIZE(12);
    Btn.layer.borderWidth = LENGTH_SIZE(1);
    Btn.titleLabel.font = FONT_SIZE(13);
    Btn.tag = section+1000;
    [Btn addTarget:self action:@selector(TouchUpdateOrderStatusBtn:) forControlEvents:UIControlEventTouchUpInside];
    Btn.hidden = NO;
    
    if (OrderModel.status.integerValue == 0) {
        [Btn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
         Btn.layer.borderColor = [UIColor baseColor].CGColor;
        [Btn setTitle:@"立即兑换" forState:UIControlStateNormal];
    }else if (OrderModel.status.integerValue == 2){
        [Btn setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
         Btn.layer.borderColor = [UIColor baseColor].CGColor;
        [Btn setTitle:@"确认收货" forState:UIControlStateNormal];
    }else if (OrderModel.status.integerValue == 4 ||
              OrderModel.status.integerValue == 3 ||
              OrderModel.status.integerValue == 5){
        [Btn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
        Btn.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
        [Btn setTitle:@"删除订单" forState:UIControlStateNormal];
    }else if (OrderModel.status.integerValue == 1){
        Btn.hidden = YES;
    }
   
    View.tag = section + 1000;
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchHeadViewORFooter:)];
    [View addGestureRecognizer:TapGestureRecognizerimageBg];
    
    return View;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return LENGTH_SIZE(121);
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPStoreCartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPStoreCartCellID];
    cell.Type = 3;
    cell.LayoutConstraint_selectBtn_Width.constant = 0;
//    cell.LayoutConstraint_Content_height.constant = LENGTH_SIZE(120);
    cell.GenerateModel = self.listArray[indexPath.section].orderItemList[indexPath.row];
     cell.LayoutConstraint_Content_Top.constant = LENGTH_SIZE(1);
     cell.LayoutConstraint_Content_bottom.constant = LENGTH_SIZE(20);
    
//    cell.model = self.listArray[indexPath.row];
//    cell.selectStatus = !self.Deleteview.hidden;
//    if ([self.selectArray containsObject:cell.model]) {
//        cell.selectButton.selected = YES;
//    }else{
//        cell.selectButton.selected = NO;
//    }
    
//    WEAK_SELF()
//    cell.selectBlock = ^(LPInfoListDataModel * _Nonnull model) {
//        if ([weakSelf.selectArray containsObject:model]) {
//            [weakSelf.selectArray removeObject:model];
//        }else{
//            [weakSelf.selectArray addObject:model];
//        }
//
//        weakSelf.NumLabel.text = [NSString stringWithFormat:@"已选%lu条",(unsigned long)self.selectArray.count];
//
//        if (weakSelf.selectArray.count == weakSelf.listArray.count){
//            self.AllBtn.selected = YES;
//        }else{
//            self.AllBtn.selected = NO;
//        }
//    };
 
    
    return cell;
}
 

 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPOrderGenerateDataorderModel *Order = self.listArray[indexPath.section];
    
    [self ToConfirmAnOrderVC:Order];
    
}

- (void)ToConfirmAnOrderVC:(LPOrderGenerateDataorderModel *) Order{
    LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
      
       vc.Type = 1;

       vc.OrderModel = Order;
       [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
       
       WEAK_SELF()
       vc.OrderBlock = ^(LPOrderGenerateDataorderModel * _Nonnull OrderModel, NSInteger Type) {
           if (Type == 0) {
                   for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[1].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           [weakSelf.superViewArr[1].listArray removeObject:m];
                           [weakSelf.superViewArr[1] setNodataViewHidden];
                           [weakSelf.superViewArr[1].tableview reloadData];
                           break;
                       }
                   }
               
                   [weakSelf.superViewArr[2].listArray addObject:OrderModel];
                   [weakSelf.superViewArr[2] setNodataViewHidden];
                   [weakSelf.superViewArr[2].tableview reloadData];
                   
                   for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[0].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           m.status = @"1";
                           m.paymentTime = OrderModel.paymentTime;
                           [weakSelf.superViewArr[0].tableview reloadData];
                           [weakSelf setNodataViewHidden];
                           break;
                       }
                   }
               
           }else if (Type == 1){
               for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[1].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           [weakSelf.superViewArr[1].listArray removeObject:m];
                           [weakSelf.superViewArr[1] setNodataViewHidden];
                           [weakSelf.superViewArr[1].tableview reloadData];
                           break;
                       }
                   }
               
                   for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[0].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           m.status = @"4";
                           m.setTime = OrderModel.setTime;
                           [weakSelf.superViewArr[0].tableview reloadData];
                           [weakSelf setNodataViewHidden];
                           break;
                       }
                   }
               
           }else if (Type == 2){
               for (LPMyOrderView *View in weakSelf.superViewArr) {
                  for (LPOrderGenerateDataorderModel *m in View.listArray) {
                      if (m.id.integerValue == OrderModel.id.integerValue) {
                          [View.listArray removeObject:m];
                          [View setNodataViewHidden];
                          [View.tableview reloadData];
                          break;
                      }
                  }
              }
           }else if (Type == 3){

                   for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[3].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           m.status = @"3";
                           m.receiveTime = OrderModel.receiveTime;
                           [weakSelf.superViewArr[3].tableview reloadData];
                           break;
                       }
                   }
        
                   for (LPOrderGenerateDataorderModel *m in weakSelf.superViewArr[0].listArray) {
                       if (m.id.integerValue == OrderModel.id.integerValue) {
                           m.status = @"3";
                           m.receiveTime = OrderModel.receiveTime;
                           [weakSelf.superViewArr[0].tableview reloadData];
                           break;
                       }
                   }
              
           }
       } ;
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = LENGTH_SIZE(121);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [_tableview registerNib:[UINib nibWithNibName:LPStoreCartCellID bundle:nil] forCellReuseIdentifier:LPStoreCartCellID];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestGetOrderList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestGetOrderList];
        }];
        
    }
    return _tableview;
}


- (void)setModel:(LPMyOrderModel *)model
{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
        }else{
            if (self.page == 1) {
                [self.tableview reloadData];
            }else{
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        if (self.listArray.count == 0) {
            [self addNodataViewHidden:NO];
        }else{
            [self addNodataViewHidden:YES];
        }
    }else{
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }

}

-(void)setNodataViewHidden{
    if (self.listArray.count == 0) {
       [self addNodataViewHidden:NO];
    }else{
       [self addNodataViewHidden:YES];
    }
}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.tableview.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.tableview.lx_height)];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.tableview addSubview:noDataView];
       
        noDataView.hidden = hidden;
    }
}



#pragma mark - request
-(void)requestGetOrderList{
    
    NSString *type = @"-1";
    if (self.MyOrderStatus == 0) {
        type = @"-1";
    } else if (self.MyOrderStatus == 1) {
        type = @"0";
    } else if (self.MyOrderStatus == 2) {
        type = @"1";
    } else if (self.MyOrderStatus == 3) {
        type = @"3";
    } else if (self.MyOrderStatus == 4) {
        type = @"5";
    }
    
    NSDictionary *dic = @{@"page":@(self.page),
                          @"type":type
    };
    [NetApiManager requestGetOrderList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPMyOrderModel mj_objectWithKeyValues:responseObject];
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestOrderUpdateStatus:(NSString *) urlStr type:(NSString *)type Order:(LPOrderGenerateDataorderModel *)OrderModel{
    
    [NetApiManager requestOrderUpdateStatus:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"操作成功" time:MESSAGE_SHOW_TIME];
                    if (type.integerValue == 2) {
//                        删除订单
                        for (LPMyOrderView *View in self.superViewArr) {
                            for (LPOrderGenerateDataorderModel *m in View.listArray) {
                                if (m.id.integerValue == OrderModel.id.integerValue) {
                                    [View.listArray removeObject:m];
                                    [View setNodataViewHidden];
                                    [View.tableview reloadData];
                                    break;
                                }
                            }
                        }
                    }else if (type.integerValue == 3) {
                        OrderModel.status = @"3";

                        if (self.MyOrderStatus == 0) {
                            for (LPOrderGenerateDataorderModel *m in self.superViewArr[3].listArray) {
                                if (m.id.integerValue == OrderModel.id.integerValue) {
                                    m.status = @"3";
                                    [self.superViewArr[3].tableview reloadData];
                                    break;
                                }
                            }
                            
                        }else{
                            for (LPOrderGenerateDataorderModel *m in self.superViewArr[0].listArray) {
                                if (m.id.integerValue == OrderModel.id.integerValue) {
                                    m.status = @"3";
                                    [self.superViewArr[0].tableview reloadData];
                                    break;
                                }
                            }
                        }
                        [self.tableview reloadData];

                    }
                    
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"操作失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestOrderPayOrder:(LPOrderGenerateDataorderModel *)OrderModel DrawPwd:(NSString *) drawPwd{
 
    NSString *passwordmd5 = [drawPwd md5];
    NSString *newPasswordmd5 = [[NSString stringWithFormat:@"%@lanpin123.com",passwordmd5] md5];
    
    NSString *urlStr = [NSString stringWithFormat:@"order/pay_order?orderId=%@&drawPwd=%@",
    OrderModel.id,
    newPasswordmd5];
    
    
    [NetApiManager requestOrderPayOrder:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                 if ([responseObject[@"data"] integerValue] ==1) {
                     OrderModel.status = @"1";
                     OrderModel.paymentTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];

                     if (self.MyOrderStatus == 0) {
                         for (LPOrderGenerateDataorderModel *m in self.superViewArr[1].listArray) {
                             if (m.id.integerValue == OrderModel.id.integerValue) {
                                 [self.superViewArr[1].listArray removeObject:m];
                                 [self.superViewArr[1] setNodataViewHidden];
                                 [self.superViewArr[1].tableview reloadData];
                                 break;
                             }
                         }
                         [self.superViewArr[2].listArray addObject:OrderModel];
                         [self.superViewArr[2].tableview reloadData];
                     }else{
                         
                         for (LPOrderGenerateDataorderModel *m in self.superViewArr[0].listArray) {
                             if (m.id.integerValue == OrderModel.id.integerValue) {
                                 m.status = @"1";
                                 m.paymentTime = [NSString stringWithFormat:@"%ld",(long)[NSString getNowTimestamp]];
                                 [self.superViewArr[0].tableview reloadData];
                                 break;
                             }
                         }
                         
                         [self.listArray removeObject:OrderModel];
                         [self setNodataViewHidden];
                         
                         [self.superViewArr[2].listArray addObject:OrderModel];
                         [self.superViewArr[2].tableview reloadData];
                     }
                     [self.tableview reloadData];
                     [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"支付成功" time:MESSAGE_SHOW_TIME];
                 }else{
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
                                
                            }];
                            [alert show];
                        }else{
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:[NSString stringWithFormat:@"密码错误，剩余%ld次机会",2-self.errorTimes]
                                                                                 message:nil
                                                                           textAlignment:NSTextAlignmentCenter
                                                                            buttonTitles:@[@"忘记密码",@"重新输入"]
                                                                            buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                                 buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                             buttonClick:^(NSInteger buttonIndex) {
                                                                                 if (buttonIndex == 0) {
                                                                                     LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                     vc.type = 1;
                                                                                     vc.Phone = OrderModel.userTel;
                                                                                     vc.hidesBottomBarWhenPushed = YES;
                                                                                     [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                                                                                    
                                                                                     
                                                                                 }else if (buttonIndex == 1){
                                                                                     [self initAlertWithDrawPassWord:OrderModel];
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
                                                                        buttonsColor:@[[UIColor colorWithHexString:@"#999999"],[UIColor baseColor]]
                                                             buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                         buttonClick:^(NSInteger buttonIndex) {
                                                                             if (buttonIndex == 0) {
                                                                                 LPSalarycCardBindPhoneVC *vc = [[LPSalarycCardBindPhoneVC alloc]init];
                                                                                 vc.type = 1;
                                                                                 vc.Phone = OrderModel.userTel;
                                                                                 vc.hidesBottomBarWhenPushed = YES;
                                                                                 
                                                                                 [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
                                                                                 
                                                                             }else if (buttonIndex == 1){
                                                                                 [self initAlertWithDrawPassWord:OrderModel];
                                                                             }
                                                                         }];
                        
                        [alert show];
                        self.errorTimes += 1;
                        NSString *str = [NSString stringWithFormat:@"%@-%ld",string,self.errorTimes];
                        kUserDefaultsSave(str, ERRORTIMES);
                    }
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
