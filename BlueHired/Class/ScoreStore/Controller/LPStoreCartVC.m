//
//  LPStoreCartVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPStoreCartVC.h"
#import "LPStoreCartCell.h"
#import "LPCartItemListModel.h"
#import "LPScoreStoredetailsVC.h"
#import "LPConfirmAnOrderVC.h"

static NSString *LPStoreCartCellID = @"LPStoreCartCell";

@interface LPStoreCartVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property (nonatomic, strong) UIButton *AllBtn;
@property (nonatomic, strong) UIButton *DeleteBtn;
@property (nonatomic, strong) UILabel *NumLabel;

@property (nonatomic,strong) LPCartItemListModel *model;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray <LPCartItemListDataModel *>*listArray;
@property (nonatomic, strong) NSMutableArray <LPCartItemListDataModel *>*selectArray;

@end

@implementation LPStoreCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    self.selectArray = [[NSMutableArray alloc] init];
    
    [self initDeleteView];
    [self setNavigationButton];
    
    self.page = 1;
    [self requestGetCartItemList];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)getCartList{
    [self.selectArray removeAllObjects];
    self.AllBtn.selected = NO;
    [self touchManagerButton];

    self.NumLabel.text = @"合计：0 积分";

    [self NumAttributedString:self.NumLabel];
    self.NumLabel.hidden = NO;
    [self.navigationItem.rightBarButtonItem setTitle:@"管理"];
    
    [self.DeleteBtn setTitle:@"兑换"
                    forState:UIControlStateNormal];
    
    self.page = 1;
    [self requestGetCartItemList];
}


-(void)initDeleteView{
    UIView *Deleteview = [[UIView alloc] init];
    [self.view addSubview:Deleteview];
    [Deleteview  mas_makeConstraints:^(MASConstraintMaker *make){
        make.right.left.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(49));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.bottom.mas_offset(0);
        }
    }];
    Deleteview.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(LENGTH_SIZE(0));
        make.left.right.mas_offset(0);
        make.bottom.equalTo(Deleteview.mas_top).offset(0);
    }];
    
    UIButton *AllBtn = [[UIButton alloc] init];
    self.AllBtn = AllBtn;
    [Deleteview addSubview:AllBtn];
    [AllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(108));
    }];
    [AllBtn setTitle:@"  全选" forState:UIControlStateNormal];
    [AllBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"add_ record_normal2"] forState:UIControlStateNormal];
    [AllBtn setImage:[UIImage imageNamed:@"add_ record_selected2"] forState:UIControlStateSelected];
    AllBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(16)];
    [AllBtn addTarget:self action:@selector(TouchAllSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *NumderLabel = [[UILabel alloc] init];
    self.NumLabel = NumderLabel;
    [Deleteview addSubview:NumderLabel];
    [NumderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.equalTo(AllBtn.mas_right).offset(0);
    }];
    NumderLabel.textColor = [UIColor baseColor];
    NumderLabel.font = FONT_SIZE(16);
    NumderLabel.text = @"合计：0 积分";
    [self NumAttributedString:NumderLabel];
    
    
    
    UIButton *DeleteBtn = [[UIButton alloc] init];
    [Deleteview addSubview:DeleteBtn];
    self.DeleteBtn = DeleteBtn;
    [DeleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_offset(0);
        make.width.mas_offset(LENGTH_SIZE(120));
    }];
    DeleteBtn.backgroundColor = [UIColor baseColor];
    [DeleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [DeleteBtn setTitle:@"兑换" forState:UIControlStateNormal];
    DeleteBtn.titleLabel.font = FONT_SIZE(17);
    [DeleteBtn addTarget:self action:@selector(TouchDelete:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setNavigationButton{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(touchManagerButton)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#333333"]];
}


-(void)touchManagerButton{
    [self.selectArray removeAllObjects];
    self.AllBtn.selected = NO;

    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
        [self.navigationItem.rightBarButtonItem setTitle:@"取消"];
        self.NumLabel.hidden = YES;
        [self.DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        if (self.AllBtn.selected) {
            [self.selectArray removeAllObjects];
            [self.selectArray addObjectsFromArray:self.listArray];
        }
    }else{
        NSInteger Numder = 0 ;
        for (NSInteger i =0 ;i < self.selectArray.count ;i++) {
            LPCartItemListDataModel *m = self.selectArray[i];
            if (m.stock.integerValue == 0 || m.quantity.integerValue > m.stock.integerValue) {
                [self.selectArray removeObject:m];
                i--;
            }else{
                Numder += m.price.integerValue * m.quantity.integerValue;
            }
        }
        
        self.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];

        [self NumAttributedString:self.NumLabel];

        
        self.NumLabel.hidden = NO;
        [self.navigationItem.rightBarButtonItem setTitle:@"管理"];
        
        if (self.selectArray.count == self.listArray.count){
            self.AllBtn.selected = YES;
        }else{
            self.AllBtn.selected = NO;
        }
        
        if (self.selectArray.count>0) {
            [self.DeleteBtn setTitle:[NSString stringWithFormat:@"兑换(%lu)",(unsigned long)self.selectArray.count]
                            forState:UIControlStateNormal];

        }else{
            [self.DeleteBtn setTitle:@"兑换"
                            forState:UIControlStateNormal];
        }
    }
    [self.tableview reloadData];
    
}

-(void)TouchDelete:(UIButton *)sender{
    if (self.selectArray.count == 0) {
        [self.view showLoadingMeg:@"请选择购物车商品" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) { //兑换
        LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
        vc.Type = 0;
        vc.BuyType = 1;
        vc.CartArray = self.selectArray;
        
        [self.navigationController pushViewController:vc animated:YES];
        WEAK_SELF()
        vc.CartBlock = ^(LPOrderGenerateModel * _Nonnull GenModel) {

            [weakSelf.listArray removeObjectsInArray:weakSelf.selectArray];
            [weakSelf.selectArray removeObjectsInArray:weakSelf.selectArray];
            if (weakSelf.listArray.count == 0 ) {
                [weakSelf addNodataViewHidden:NO];
            }else{
                [weakSelf addNodataViewHidden:YES];
            }
            [weakSelf.tableview reloadData];
            weakSelf.AllBtn.selected = NO;
            [weakSelf.DeleteBtn setTitle:@"兑换"
                            forState:UIControlStateNormal];
             self.NumLabel.text = @"合计：0 积分";
            [self NumAttributedString:self.NumLabel];
        };
        
    }else{  //删除
        if (self.AllBtn.selected) {
            [self requestDelCartItem:nil Type:@"1"];
        }else{
            [self requestDelCartItem:self.selectArray Type:@"0"];
        }
    }
    
}

-(void)TouchAllSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.selectArray removeAllObjects];

        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
            NSInteger Numder = 0 ;
            for (LPCartItemListDataModel *m in self.listArray) {
                if (m.stock.integerValue>0 && m.quantity.integerValue <= m.stock.integerValue) {
                    Numder += m.price.integerValue * m.quantity.integerValue;
                    [self.selectArray addObject:m];
                }
            }
            self.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];
            [self NumAttributedString:self.NumLabel];
            
            if (self.selectArray.count>0) {
                [self.DeleteBtn setTitle:[NSString stringWithFormat:@"兑换(%lu)",(unsigned long)self.selectArray.count]
                                forState:UIControlStateNormal];

            }else{
                [self.DeleteBtn setTitle:@"兑换"
                                forState:UIControlStateNormal];
            }
        }else{
            [self.selectArray addObjectsFromArray:self.listArray];

        }
    }else{
        [self.selectArray removeAllObjects];
        self.NumLabel.text = @"合计：0 积分";
        [self NumAttributedString:self.NumLabel];
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
            [self.DeleteBtn setTitle:@"兑换"
                            forState:UIControlStateNormal];
        }
    }
    
    [self.tableview reloadData];
    
}


#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return LENGTH_SIZE(150);
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPStoreCartCell *cell = [tableView dequeueReusableCellWithIdentifier:LPStoreCartCellID];
    cell.selectStatus = ![self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"];
    cell.model = self.listArray[indexPath.row];
//    cell.LayoutConstraint_Content_height.constant = LENGTH_SIZE(140);
    cell.LayoutConstraint_Content_Top.constant = LENGTH_SIZE(10);
    cell.LayoutConstraint_Content_bottom.constant = LENGTH_SIZE(40);

    if ([self.selectArray containsObject:cell.model]) {
        cell.selectButton.selected = YES;
    }else{
        cell.selectButton.selected = NO;
    }
    
    WEAK_SELF()
    cell.selectBlock = ^(LPCartItemListDataModel * _Nonnull model) {
        if ([weakSelf.selectArray containsObject:model]) {
            [weakSelf.selectArray removeObject:model];
        }else{
            [weakSelf.selectArray addObject:model];
        }
        NSInteger Numder = 0 ;
        for (LPCartItemListDataModel *m in weakSelf.selectArray) {
            Numder += m.price.integerValue * m.quantity.integerValue;
        }

        weakSelf.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];

        [weakSelf NumAttributedString:weakSelf.NumLabel];
        
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
            if (weakSelf.selectArray.count>0) {
                [weakSelf.DeleteBtn setTitle:[NSString stringWithFormat:@"兑换(%lu)",(unsigned long)weakSelf.selectArray.count]
                                forState:UIControlStateNormal];

            }else{
                [weakSelf.DeleteBtn setTitle:@"兑换"
                                forState:UIControlStateNormal];
            }
        }
        
        
        
        if (weakSelf.selectArray.count == weakSelf.listArray.count){
            self.AllBtn.selected = YES;
        }else{
            self.AllBtn.selected = NO;
        }
    };
    
    cell.AddroSubBlock = ^{
        NSInteger Numder = 0 ;
        for (LPCartItemListDataModel *m in weakSelf.selectArray) {
            Numder += m.price.integerValue * m.quantity.integerValue;
        }

        weakSelf.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];

        [weakSelf NumAttributedString:weakSelf.NumLabel];
        
        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
            if (weakSelf.selectArray.count>0) {
                [weakSelf.DeleteBtn setTitle:[NSString stringWithFormat:@"兑换(%lu)",(unsigned long)weakSelf.selectArray.count]
                                forState:UIControlStateNormal];

            }else{
                [weakSelf.DeleteBtn setTitle:@"兑换"
                                forState:UIControlStateNormal];
            }
        }
    };
 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self requestDelCartItem:@[self.listArray[indexPath.row]] Type:@"0"];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPScoreStoredetailsVC *vc = [[LPScoreStoredetailsVC alloc] init];
    vc.SuperType = 1;
    vc.SuperVC = self;
    vc.CartModel = self.listArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = LENGTH_SIZE(150);
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPStoreCartCellID bundle:nil] forCellReuseIdentifier:LPStoreCartCellID];
        _tableview.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        _tableview.mj_header = [HZNormalHeader headerWithRefreshingBlock:^{
//            if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
                self.page = 1;
                [self requestGetCartItemList];
//            }else{
//                [self.tableview.mj_header endRefreshing];
//            }
        }];
        
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
                [self requestGetCartItemList];
//            }else{
//                [self.tableview.mj_footer endRefreshing];
//            }
        }];
    }
    return _tableview;
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


- (void)setModel:(LPCartItemListModel *)model
{
    _model = model;
    if ([self.model.code integerValue] == 0) {
        
        if (self.page == 1) {
            self.selectArray = [NSMutableArray array];
            self.listArray = [NSMutableArray array];
            
            self.AllBtn.selected = NO;
            if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
                [self.DeleteBtn setTitle:@"兑换"
                forState:UIControlStateNormal];
                self.NumLabel.text = [NSString stringWithFormat:@"合计：0 积分"];
                [self NumAttributedString:self.NumLabel];
                self.NumLabel.hidden = NO;

            }else{
                self.NumLabel.hidden = YES;
                [self.DeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            }
            

        }
        if (self.model.data.count > 0) {
            self.page += 1;
            [self.listArray addObjectsFromArray:self.model.data];
            [self.tableview reloadData];
            if (self.model.data.count<20) {
                [self.tableview.mj_footer endRefreshingWithNoMoreData];
                self.tableview.mj_footer.hidden = self.listArray.count<20?YES:NO;
            }
            if (self.selectArray.count == self.listArray.count){
                self.AllBtn.selected = YES;
            }else{
                self.AllBtn.selected = NO;
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
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }

}

-(void)addNodataViewHidden:(BOOL)hidden{
    BOOL has = NO;
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[LPNoDataView class]]) {
            view.hidden = hidden;
            has = YES;
        }
    }
    if (!has) {
        LPNoDataView *noDataView = [[LPNoDataView alloc]init];
        [noDataView image:nil text:@"抱歉！没有相关记录！"];
        [self.view addSubview:noDataView];
        [noDataView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
        
        noDataView.hidden = hidden;
    }
}


#pragma mark - request
-(void)requestGetCartItemList{
    NSDictionary *dic = @{@"page":@(self.page)};
    [NetApiManager requestGetCartItemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPCartItemListModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestDelCartItem:(NSArray *) ids Type:(NSString *)type{
 
    
    NSString *idStr = @"";
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (LPCartItemListDataModel *m in ids) {
        [arr addObject:m.id];
    }
    
    idStr = [arr componentsJoinedByString:@","];
    
//    NSDictionary *dic = @{@"ids":idStr,
//                          @"type":type,
//    };
    
    NSString *urlStr = [NSString stringWithFormat:@"cart/del_cart_item?ids=%@&type=%@",idStr,type];
    
    [NetApiManager requestDelCartItem:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
 
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    if (type.integerValue == 1) {
                        [self.listArray removeAllObjects];
                        [self.selectArray removeAllObjects];
                        [self addNodataViewHidden:NO];
                        self.AllBtn.selected = NO;
//                        self.NumLabel.text = @"合计：0 积分";
//                        [self NumAttributedString:self.NumLabel];
                        
                        [self touchManagerButton];
                    }else{
                        [self.listArray removeObjectsInArray:ids];
                        [self.selectArray removeObjectsInArray:ids];
   
                        if (self.selectArray.count == self.listArray.count){
                            self.AllBtn.selected = YES;
                        }else{
                            self.AllBtn.selected = NO;
                        }
                        if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"管理"]) {
                                NSInteger Numder = 0 ;
                               for (LPCartItemListDataModel *m in self.selectArray) {
                                   Numder += m.price.integerValue * m.quantity.integerValue;
                               }

                               self.NumLabel.text = [NSString stringWithFormat:@"合计：%lu 积分",(unsigned long)Numder];

                               [self NumAttributedString:self.NumLabel];
                            if (self.selectArray.count>0) {
                                [self.DeleteBtn setTitle:[NSString stringWithFormat:@"兑换(%lu)",(unsigned long)self.selectArray.count]
                                                forState:UIControlStateNormal];

                            }else{
                                [self.DeleteBtn setTitle:@"兑换"
                                                forState:UIControlStateNormal];
                            }
                            
                        }else{
                            
                        }
                    }
                    
                    if (self.listArray.count == 0 ) {
                        [self addNodataViewHidden:NO];
                    }else{
                        [self addNodataViewHidden:YES];
                    }
                    [self.tableview reloadData];
                    [self.view showLoadingMeg:@"删除成功" time:MESSAGE_SHOW_TIME];
                }else{
                    [self.view showLoadingMeg:@"删除失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
