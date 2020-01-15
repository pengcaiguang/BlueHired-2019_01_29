//
//  LPScoreStoredetailsVC.m
//  BlueHired
//
//  Created by iMac on 2019/9/18.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPScoreStoredetailsVC.h"
#import "LPStoreCartVC.h"
#import "SDCycleScrollView.h"
#import "LPScoreStoreDetalisModel.h"
#import "LPConfirmAnOrderVC.h"

@interface LPScoreStoredetailsVC ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageBgView;

@property (weak, nonatomic) IBOutlet UILabel *CommodityNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *BuyGradeImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityUnitLabel;
@property (weak, nonatomic) IBOutlet UILabel *StockLabel;
@property (weak, nonatomic) IBOutlet UILabel *MailLabel;
@property (weak, nonatomic) IBOutlet UILabel *CommoditySizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *CartNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *CartBtn;
@property (weak, nonatomic) IBOutlet UIButton *AddCartBtn;
@property (weak, nonatomic) IBOutlet UIButton *BuyBtn;
@property (weak, nonatomic) IBOutlet UIButton *NorBtn;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *SelectSizeView;
@property (nonatomic, strong) UILabel *SizeViewUnit;
@property (nonatomic, strong) UIButton *SizeViewSaveBtn;
@property (nonatomic, strong) UIButton *SizeViewAddCartBtn;
@property (nonatomic, strong) UIButton *SizeViewBuyBtn;

@property (nonatomic, strong) UIScrollView *sizeScrollView;
@property (nonatomic, strong) UIButton *SizeViewleftBtn;
@property (nonatomic, strong) UIButton *SizeViewRightBtn;
@property (nonatomic, strong) UILabel *SizeViewNumber;

@property (nonatomic, strong) NSMutableArray *selectSizeStrArr;
@property (nonatomic, strong) NSMutableArray *selectBtnArr;
@property (nonatomic, strong) NSMutableArray *selectTypeLabelArr;
@property (nonatomic, assign) NSInteger selectStock;
@property (nonatomic, strong) ProductSkuListModel *selectProductSkuModel;

@property (nonatomic, strong) LPScoreStoreDetalisModel *model;

@property (nonatomic, strong) NSArray *gradeArr;


@end

@implementation LPScoreStoredetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.selectStock = -1;
    
    self.CartNumberLabel.layer.cornerRadius = LENGTH_SIZE(6);
    self.gradeArr = @[@"见习职工",
                      @"初级职工",
                      @"中级职工",
                      @"高级职工",
                      @"部门精英",
                      @"部门经理",
                      @"区域经理",
                      @"总经理",
                      @"董事长"];
    [self.ScrollView addSubview:self.cycleScrollView];
     
    self.cycleScrollView.delegate = self;
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.SelectSizeView];
    [self requestGetProductDetail];
}

#pragma mark Touch
- (IBAction)TouchSelectCommoditySize:(id)sender {
    self.SizeViewSaveBtn.hidden = YES;
    self.SizeViewAddCartBtn.hidden = NO;
    self.SizeViewBuyBtn.hidden = NO;
    [self SelectSizeViewHidden:NO];
}

- (IBAction)TouchCart:(id)sender {
    if ([LoginUtils validationLogin:self]) {
        if (self.SuperType == 1) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            LPStoreCartVC *vc = [[LPStoreCartVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (IBAction)TouchShare:(id)sender {
    if ([LoginUtils validationLogin:self]) {
        NSString  *url = [NSString stringWithFormat:@"%@resident/#/commoditylike?productId=%@&shareUserId=%@",BaseRequestWeiXiURL,self.model.data.id,kUserDefaultsValue(LOGINID)];
       NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
       [LPTools ClickShare:encodedUrl Title:self.model.data.name];
        WEAK_SELF()
        [LPTools shareInstance].ShareBlock = ^(BOOL isSuccess, NSInteger Type) {
            if (isSuccess) {
                [weakSelf requestQueryInsertProductShare];
             }
        };
    }
}

- (IBAction)TouchAddCart:(id)sender {
    self.SizeViewSaveBtn.tag = 1111;
    self.SizeViewSaveBtn.hidden = NO;
    self.SizeViewAddCartBtn.hidden = YES;
    self.SizeViewBuyBtn.hidden = YES;
    [self SelectSizeViewHidden:NO];
}

- (IBAction)TouchBuy:(id)sender {
    if (self.selectTypeLabelArr.count == self.selectBtnArr.count) {
        if ([LoginUtils validationLogin:self]) {
            LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

            if ([self.gradeArr indexOfObject:self.model.data.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                return;
            }
            
             LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
            vc.Type = 0;
            vc.BuyType = 0;
            vc.BuyModel = self.selectProductSkuModel;
            vc.BuyNumber = self.SizeViewNumber.text.intValue;

            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        self.SizeViewSaveBtn.tag = 2222;
        self.SizeViewSaveBtn.hidden = NO;
        self.SizeViewAddCartBtn.hidden = YES;
        self.SizeViewBuyBtn.hidden = YES;
        [self SelectSizeViewHidden:NO];
    }
}

- (void)TouchSizeViewAddCart:(UIButton *)sender {
    if (self.selectTypeLabelArr.count == self.selectBtnArr.count) {
        if ([LoginUtils validationLogin:self]) {
            LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
            
            if ([self.gradeArr indexOfObject:self.model.data.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                return;
            }
            [self requestInsertCartitem:self.selectProductSkuModel Numder:self.SizeViewNumber.text.intValue];
            [self hidden];
        }
    }else{
        [self SelectViewSizeMessage];
    }
    
    
    
}

- (void)TouchSizeViewBuy:(UIButton *)sender {
    
    if (self.selectTypeLabelArr.count == self.selectBtnArr.count) {
        if ([LoginUtils validationLogin:self]) {
            
            LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
            
            if ([self.gradeArr indexOfObject:self.model.data.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                return;
            }
            
            [self hidden];
            
            LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
            vc.Type = 0;
            vc.BuyType = 0;
            vc.BuyModel = self.selectProductSkuModel;
            vc.BuyNumber = self.SizeViewNumber.text.intValue;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self SelectViewSizeMessage];
    }
    
}

- (void)TouchSizeViewSave:(UIButton *)sender {
    if (self.selectTypeLabelArr.count == self.selectBtnArr.count) {
        if ([LoginUtils validationLogin:self]) {
            if (sender.tag == 1111) {   //加购物车
                LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

                if ([self.gradeArr indexOfObject:self.model.data.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                    [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                    return;
                }
                [self requestInsertCartitem:self.selectProductSkuModel Numder:self.SizeViewNumber.text.intValue];
            }else if (sender.tag == 2222){  //购买
                
                LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];

                if ([self.gradeArr indexOfObject:self.model.data.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                    [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                    return;
                }
                
                LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
                vc.Type = 0;
                vc.BuyType = 0;
                vc.BuyModel = self.selectProductSkuModel;
                vc.BuyNumber = self.SizeViewNumber.text.intValue;
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            [self hidden];
        }
          
       }else{
           [self SelectViewSizeMessage];
       }
}

-(void)SelectViewSizeMessage{
    NSMutableArray *MessType = [self.selectTypeLabelArr mutableCopy];
    NSMutableArray *SelectMessType = [[NSMutableArray alloc] init];
    for ( NSInteger i =0 ; i<self.selectBtnArr.count; i++) {
        UIButton *btn = [self.selectBtnArr objectAtIndex:i];
        [SelectMessType addObject:MessType[btn.tag - 1000]];
    }
    [MessType removeObjectsInArray:[SelectMessType copy]];
    NSString *messageStr = [NSString stringWithFormat:@"请选择 %@",[MessType componentsJoinedByString:@","]];
    [self.view  showLoadingMeg:messageStr time:MESSAGE_SHOW_TIME];
}


//选择商品规格
- (void)TouchSizeViewTagBtn:(UIButton *) sender{
    sender.selected = !sender.selected;

    for (UIView *v in sender.superview.subviews) {
        if (v.tag == sender.tag  && [v isKindOfClass:[UIButton class]] && sender != v) {
            UIButton *btn = (UIButton *)v;
            btn.selected = NO;
        }
    }
    
    self.selectSizeStrArr = [[NSMutableArray alloc] init];
    self.selectBtnArr = [[NSMutableArray alloc] init];

    for (UIView *v in sender.superview.subviews) {
        if (v.tag >= 1000 && v.tag <= 1002 && [v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            if (btn.selected == YES) {
                [self.selectSizeStrArr addObject:btn.currentTitle];
                [self.selectBtnArr addObject:btn];
            }
        }
    }
    
    for (UIView *v in sender.superview.subviews) {
        if (v.tag >= 1000 && v.tag <= 1002 && [v isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)v;
            if (btn.selected == NO  && (btn.tag != sender.tag || sender.selected == NO)) {
                
                if (self.selectBtnArr.count>0) {
                    BOOL isEnabled = NO;
                   for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
                       NSMutableArray *typeArr = [[NSMutableArray alloc] init];
                       
                       [typeArr addObject:[LPTools isNullToString:spModel.sp1]];
                       [typeArr addObject:[LPTools isNullToString:spModel.sp2]];
                       [typeArr addObject:[LPTools isNullToString:spModel.sp3]];
                       
                   
                       
                       if (self.selectBtnArr.count == 1) {
//                           for (NSInteger i = 0; i < selectBtnArr.count; i++) {
                               UIButton *selectBtn = [self.selectBtnArr objectAtIndex:0];
                                if ( spModel.stock.intValue > 0 &&
                                    [btn.currentTitle isEqualToString:typeArr[btn.tag - 1000]] &&
                                    ([self.selectSizeStrArr containsObject:typeArr[selectBtn.tag - 1000]] || btn.tag == selectBtn.tag)){
                                   isEnabled = YES;
                                    break;
                                    
                                }
//                           }
                       }else if (self.selectBtnArr.count == 2){
                           UIButton *selectBtn = [self.selectBtnArr objectAtIndex:0];
                           UIButton *selectBtn1 = [self.selectBtnArr objectAtIndex:1];

                           if ( spModel.stock.intValue > 0 &&
                               [btn.currentTitle isEqualToString:typeArr[btn.tag - 1000]] &&
                               (([self.selectSizeStrArr containsObject:typeArr[selectBtn.tag - 1000]] && btn.tag == selectBtn1.tag) ||
                               ([self.selectSizeStrArr containsObject:typeArr[selectBtn1.tag - 1000]] && btn.tag == selectBtn.tag)||
                                
                                ([self.selectSizeStrArr containsObject:typeArr[selectBtn.tag - 1000]] &&
                               [self.selectSizeStrArr containsObject:typeArr[selectBtn1.tag - 1000]] &&
                                 btn.tag != selectBtn.tag &&
                                 btn.tag != selectBtn1.tag))) {
                              isEnabled = YES;
                               break;
                               
                           }
                       }else if (self.selectBtnArr.count == 3){
                           UIButton *selectBtn = [self.selectBtnArr objectAtIndex:0];
                           UIButton *selectBtn1 = [self.selectBtnArr objectAtIndex:1];
                           UIButton *selectBtn2 = [self.selectBtnArr objectAtIndex:2];

                           if ( spModel.stock.intValue > 0 &&
                               [btn.currentTitle isEqualToString:typeArr[btn.tag - 1000]] &&
                              (([self.selectSizeStrArr containsObject:typeArr[selectBtn.tag - 1000]] &&
                               [self.selectSizeStrArr containsObject:typeArr[selectBtn1.tag - 1000]] &&
                                btn.tag != selectBtn.tag &&
                               btn.tag != selectBtn1.tag) ||
                               
                               ([self.selectSizeStrArr containsObject:typeArr[selectBtn.tag - 1000]] &&
                               [self.selectSizeStrArr containsObject:typeArr[selectBtn2.tag - 1000]] &&
                                btn.tag != selectBtn.tag &&
                               btn.tag != selectBtn2.tag) ||
                               
                               ([self.selectSizeStrArr containsObject:typeArr[selectBtn1.tag - 1000]] &&
                               [self.selectSizeStrArr containsObject:typeArr[selectBtn2.tag - 1000]]  &&
                                btn.tag != selectBtn1.tag &&
                               btn.tag != selectBtn2.tag))) {
                              isEnabled = YES;
                               break;
                               
                           }
                       }

                       

                   }
                    btn.enabled = isEnabled;
                }else{
                    btn.enabled = NO;
                    for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
                        if (([btn.currentTitle isEqualToString:spModel.sp1] ||
                            [btn.currentTitle isEqualToString:spModel.sp2]  ||
                            [btn.currentTitle isEqualToString:spModel.sp3]) &&
                            spModel.stock.intValue > 0) {
                            btn.enabled = YES;
                            break;
                        }
                    }
                }
                
               
            }
        }
    }

    
    self.CommoditySizeLabel.text = self.selectSizeStrArr.count == 0 ? @"选择商品类型" : [NSString stringWithFormat:@"已选 “%@”",[self.selectSizeStrArr componentsJoinedByString:@","]];
    
     //判断库存数量
    if (self.selectTypeLabelArr.count == self.selectSizeStrArr.count) {
        for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
            NSMutableArray *typeArr = [[NSMutableArray alloc] init];
                                  
            [typeArr addObject:[LPTools isNullToString:spModel.sp1]];
            [typeArr addObject:[LPTools isNullToString:spModel.sp2]];
            [typeArr addObject:[LPTools isNullToString:spModel.sp3]];
            
            [typeArr removeObject:@""];
            if ([typeArr isEqualToArray:self.selectSizeStrArr] ) {
                self.selectStock = spModel.stock.intValue;
                self.SizeViewUnit.text = spModel.price;
                self.selectProductSkuModel = spModel;
                if (spModel.stock.intValue <= self.SizeViewNumber.text.intValue) {
                    self.SizeViewNumber.text = [NSString stringWithFormat:@"%ld",(long)spModel.stock.integerValue];
                    self.SizeViewleftBtn.selected = self.SizeViewNumber.text.integerValue == 1 ? YES : NO;
                    self.SizeViewRightBtn.selected = self.SizeViewNumber.text.integerValue == spModel.stock.integerValue ? YES : NO;
                }
                break;
            }else{
                self.selectProductSkuModel = nil;
                self.selectStock = -1;
                self.SizeViewleftBtn.selected = self.SizeViewNumber.text.integerValue == 1 ? YES : NO;
                self.SizeViewRightBtn.selected = NO;
            }
            
        }
    }else{
        self.selectProductSkuModel = nil;
    }
}

//选择商品数量
- (void)TouchSizeViewAddandSubtract:(UIButton *) sender{
    if (sender.selected == NO) {
        
        if (sender == self.SizeViewleftBtn) {
            self.SizeViewNumber.text = [NSString stringWithFormat:@"%d",self.SizeViewNumber.text.integerValue-1];
        }else{
            self.SizeViewNumber.text = [NSString stringWithFormat:@"%d",self.SizeViewNumber.text.integerValue+1];
        }
        
        self.SizeViewleftBtn.selected = self.SizeViewNumber.text.integerValue == 1 ? YES : NO;
        if (self.selectStock > 0) {
            self.SizeViewRightBtn.selected = self.SizeViewNumber.text.integerValue == self.selectStock ? YES : NO;
        }
    }else if (sender.selected == YES && sender == self.SizeViewRightBtn){
        [self.view showLoadingMeg:@"库存不足，请勿继续添加" time:1.0];
    }else if (sender.selected == YES && sender == self.SizeViewleftBtn){
        [self.view showLoadingMeg:@"宝贝不能再减少了哦~" time:1.0];
    }
}

-(void)SelectSizeViewHidden:(BOOL)hidden{
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.SelectSizeView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, CGRectGetHeight(self.SelectSizeView.frame));
        } completion:^(BOOL finished) {
 
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.SelectSizeView.frame = CGRectMake(0, SCREEN_HEIGHT-CGRectGetHeight(self.SelectSizeView.frame)-kNavBarHeight, SCREEN_WIDTH, CGRectGetHeight(self.SelectSizeView.frame));
        }completion:^(BOOL finished){
 
        }];
    }
}



#pragma mark lazy
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, LENGTH_SIZE(375)) shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.delegate = self;

        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScroll = YES;
//        _cycleScrollView.infiniteLoop = NO;
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _cycleScrollView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -kNavBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
-(void)hidden{
    [self SelectSizeViewHidden:YES];
}

-(UIView *)SelectSizeView{
    if (!_SelectSizeView) {
        _SelectSizeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, LENGTH_SIZE(379)+kBottomBarHeight)];
        _SelectSizeView.backgroundColor = [UIColor whiteColor];
        
        UILabel *UnitTitle = [[UILabel alloc] init];
        [_SelectSizeView addSubview:UnitTitle];
        [UnitTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.mas_offset(LENGTH_SIZE(13));
            make.height.mas_offset(LENGTH_SIZE(45));
        }];
        UnitTitle.text = @"单价：";
        UnitTitle.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        UnitTitle.textColor = [UIColor colorWithHexString:@"#333333"];
        
        UILabel *SizeViewUnit = [[UILabel alloc] init];
        self.SizeViewUnit = SizeViewUnit;
        [_SelectSizeView addSubview:SizeViewUnit];
        [SizeViewUnit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.equalTo(UnitTitle.mas_right).offset(0);
            make.height.mas_offset(LENGTH_SIZE(45));
        }];
        SizeViewUnit.text = @"0";
        SizeViewUnit.font = [UIFont boldSystemFontOfSize:FontSize(16)];
        SizeViewUnit.textColor = [UIColor colorWithHexString:@"#FF7F00"];
        
        UILabel *Unit = [[UILabel alloc] init];
        [_SelectSizeView addSubview:Unit];
        [Unit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.left.equalTo(SizeViewUnit.mas_right).offset(0);
            make.height.mas_offset(LENGTH_SIZE(45));
       
        }];
        Unit.text = @" 积分";
        Unit.font = FONT_SIZE(13);
        Unit.textColor = [UIColor colorWithHexString:@"#808080"];
        
        UIButton *delBtn = [[UIButton alloc] init];
        [_SelectSizeView addSubview:delBtn];
        [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(0);
            make.right.mas_offset(LENGTH_SIZE(-13));
            make.width.mas_offset(LENGTH_SIZE(14));
            make.height.mas_offset(LENGTH_SIZE(45));
        }];
        [delBtn setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineV = [[UIView alloc] init];
        [_SelectSizeView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.equalTo(UnitTitle.mas_bottom).offset(0);
            make.height.mas_equalTo(LENGTH_SIZE(1));
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
        
        UIButton *AddCart = [[UIButton alloc] init];
        [_SelectSizeView addSubview:AddCart];
        self.SizeViewAddCartBtn = AddCart;
        [AddCart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-kBottomBarHeight);
            make.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(48));
            make.width.mas_offset(0);
        }];
        [AddCart setTitle:@"加入购物车" forState:UIControlStateNormal];
        [AddCart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        AddCart.titleLabel.font = FONT_SIZE(17);
        AddCart.backgroundColor = [UIColor baseColor];
        [AddCart addTarget:self action:@selector(TouchSizeViewAddCart:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *Buy = [[UIButton alloc] init];
        [_SelectSizeView addSubview:Buy];
        self.SizeViewBuyBtn = Buy;
        [Buy mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-kBottomBarHeight);
            make.right.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(48));
            make.width.mas_offset(SCREEN_WIDTH);
        }];
        [Buy setTitle:@"立即兑换" forState:UIControlStateNormal];
        [Buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        Buy.titleLabel.font = FONT_SIZE(17);
        Buy.backgroundColor = [UIColor colorWithHexString:@"#FF5353"];
        [Buy addTarget:self action:@selector(TouchSizeViewBuy:) forControlEvents:UIControlEventTouchUpInside];

        
        UIButton *saveBtn = [[UIButton alloc] init];
        [_SelectSizeView addSubview:saveBtn];
        self.SizeViewSaveBtn = saveBtn;
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(-kBottomBarHeight);
            make.bottom.right.left.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(48));
        }];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font = FONT_SIZE(17);
        saveBtn.backgroundColor = [UIColor baseColor];
        [saveBtn setTitle:@"确定" forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(TouchSizeViewSave:) forControlEvents:UIControlEventTouchUpInside];

        
        UIScrollView *sizeScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, LENGTH_SIZE(46), SCREEN_WIDTH, LENGTH_SIZE(379-46-48))];
        [_SelectSizeView addSubview:sizeScroll];
        self.sizeScrollView = sizeScroll;
        
        
     }
    return _SelectSizeView;
}


- (void)setModel:(LPScoreStoreDetalisModel *)model{
    _model = model;
    
    NSArray *imageArr = [model.data.pic componentsSeparatedByString:@","];
    self.cycleScrollView.imageURLStringsGroup = imageArr;

    self.CommodityNameLabel.text = model.data.name;
    self.commodityUnitLabel.text = model.data.price;
    self.StockLabel.text = [NSString stringWithFormat:@"库存: %@件",model.data.stock];
    self.MailLabel.text = model.data.postage.integerValue == 0 ? @"邮费: 包邮" : @"邮费: 到付" ;
    self.BuyGradeImage.image = [UIImage imageNamed:model.data.grade];
    self.remarkLabel.text = model.data.remark;
    
    self.CartNumberLabel.hidden = !model.data.cartItemNum.integerValue;
    self.CartNumberLabel.text = model.data.cartItemNum;

    
    for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
        spModel.name = model.data.name;
        spModel.postage = model.data.postage;
    }
    
    
    NSMutableArray *spNameArr = [[NSMutableArray alloc] init];
    [spNameArr addObject:[LPTools isNullToString:model.data.mProductSkuList[0].spName1]];
    [spNameArr addObject:[LPTools isNullToString:model.data.mProductSkuList[0].spName2]];
    [spNameArr addObject:[LPTools isNullToString:model.data.mProductSkuList[0].spName3]];
    self.selectTypeLabelArr = [[NSMutableArray alloc] init];;
    
    self.SizeViewUnit.text = model.data.price;

    [self.sizeScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat tagBtnX = LENGTH_SIZE(13);
    CGFloat tagBtnY = 0;
    
    for (NSInteger j = 0; j <spNameArr.count; j++) {
        if (![spNameArr[j] isEqualToString:@""]) {
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LENGTH_SIZE(13),
                                                                       tagBtnY+LENGTH_SIZE(16),
                                                                       SCREEN_WIDTH - LENGTH_SIZE(26),
                                                                       LENGTH_SIZE(18))];
            title.text = spNameArr[j];
            title.font = FONT_SIZE(14);
            title.textColor = [UIColor colorWithHexString:@"#333333"];
            title.tag = 2000+j;
            [self.selectTypeLabelArr addObject:spNameArr[j]];
            [self.sizeScrollView addSubview:title];
            
            tagBtnY += LENGTH_SIZE(43);
            tagBtnX = LENGTH_SIZE(13);
            
            NSMutableArray *sp1Arr = [[NSMutableArray alloc] init];
            for (ProductSkuListModel *spModel in model.data.mProductSkuList) {
                if (! [sp1Arr containsObject:spModel.sp1] && j == 0) {
                    [sp1Arr addObject:spModel.sp1];
                }
                if (! [sp1Arr containsObject:spModel.sp2] && j == 1) {
                    [sp1Arr addObject:spModel.sp2];
                }
                if (! [sp1Arr containsObject:spModel.sp3] && j == 2) {
                    [sp1Arr addObject:spModel.sp3];
                }
            }
            
            for (int i= 0; i<sp1Arr.count; i++) {
                
                CGSize tagTextSize = [sp1Arr[i] sizeWithFont:[UIFont systemFontOfSize:FontSize(13)]
                                                      maxSize:CGSizeMake(SCREEN_WIDTH-LENGTH_SIZE(26), LENGTH_SIZE(24))];
                if (tagBtnX+tagTextSize.width+LENGTH_SIZE(13) > SCREEN_WIDTH-LENGTH_SIZE(26)) {
                    tagBtnX = LENGTH_SIZE(13);
                    tagBtnY += LENGTH_SIZE(24+12);
                }
                UIButton * tagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                tagBtn.tag = 1000+j;
                
                CGFloat tagBtnWidth = tagTextSize.width+LENGTH_SIZE(24) > SCREEN_WIDTH-LENGTH_SIZE(26) ?
                SCREEN_WIDTH-LENGTH_SIZE(26) :
                tagTextSize.width+LENGTH_SIZE(24);
                
                tagBtn.frame = CGRectMake(tagBtnX,
                                          tagBtnY,
                                          tagBtnWidth,
                                          LENGTH_SIZE(24));
                [tagBtn setTitle:sp1Arr[i] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
                [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [tagBtn setTitleColor:[UIColor colorWithHexString:@"#CCCCCC"] forState:UIControlStateDisabled];

                [tagBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]] forState:UIControlStateNormal];
                [tagBtn setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forState:UIControlStateSelected];
                
                tagBtn.titleLabel.font = [UIFont systemFontOfSize:FontSize(13)];
                tagBtn.layer.cornerRadius = LENGTH_SIZE(12);
                tagBtn.layer.masksToBounds = YES;
                [self.sizeScrollView addSubview:tagBtn];
                [tagBtn addTarget:self action:@selector(TouchSizeViewTagBtn:) forControlEvents:UIControlEventTouchUpInside];
                tagBtnX = CGRectGetMaxX(tagBtn.frame)+LENGTH_SIZE(12);
                
                tagBtn.enabled = NO;
                for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
                    if (([tagBtn.currentTitle isEqualToString:spModel.sp1] ||
                        [tagBtn.currentTitle isEqualToString:spModel.sp2]  ||
                        [tagBtn.currentTitle isEqualToString:spModel.sp3]) &&
                        spModel.stock.intValue > 0) {
                        tagBtn.enabled = YES;
                        break;
                    }
                }
                
            }
            tagBtnY += LENGTH_SIZE(24);
        }
    }
    
    
    UILabel *numberTitle = [[UILabel alloc] init];
    [self.sizeScrollView addSubview:numberTitle];
    [numberTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(tagBtnY+LENGTH_SIZE(39));
        make.left.mas_offset(LENGTH_SIZE(13));
    }];
    numberTitle.text = @"购买数量";
    numberTitle.font = FONT_SIZE(14);
    numberTitle.textColor = [UIColor colorWithHexString:@"#333333"];
    
    UIButton *leftBtn = [[UIButton alloc] init];
    [self.sizeScrollView addSubview:leftBtn];
    self.SizeViewleftBtn = leftBtn;
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberTitle);
        make.left.mas_offset(LENGTH_SIZE(255));
        make.width.height.mas_offset(LENGTH_SIZE(30));
    }];
    [leftBtn setImage:[UIImage imageNamed:@"sub_nor"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"sub_dis"] forState:UIControlStateSelected];
    [leftBtn addTarget:self action:@selector(TouchSizeViewAddandSubtract:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.selected = YES;
    
    UIButton *rightBtn = [[UIButton alloc] init];
    [self.sizeScrollView addSubview:rightBtn];
    self.SizeViewRightBtn = rightBtn;
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberTitle);
        make.left.mas_offset(LENGTH_SIZE(333));
        make.width.height.mas_offset(LENGTH_SIZE(30));
    }];
    [rightBtn setImage:[UIImage imageNamed:@"add_nor"] forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"add_dis"] forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(TouchSizeViewAddandSubtract:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *number = [[UILabel alloc] init];
    [self.sizeScrollView addSubview:number];
    self.SizeViewNumber = number;
    [number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numberTitle);
        make.left.equalTo(leftBtn.mas_right).offset(0);
        make.right.equalTo(rightBtn.mas_left).offset(0);
    }];
    number.textAlignment = NSTextAlignmentCenter;
    number.textColor = [UIColor colorWithHexString:@"#333333"];
    number.font = FONT_SIZE(16);
    number.text = @"1";
    self.sizeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tagBtnY + LENGTH_SIZE(115));
        
     if (model.data.stock.integerValue > 0) {
         self.NorBtn.hidden = YES;
         self.AddCartBtn.hidden = NO;
         self.BuyBtn.hidden = NO;
     }else{
         self.NorBtn.hidden = NO;
         self.AddCartBtn.hidden = YES;
         self.BuyBtn.hidden = YES;
         leftBtn.selected = YES;
         rightBtn.selected = YES;
         number.text = @"0";

     }
    
}

-(void)CheckStock:(UIButton *) tagBtn{
    for (ProductSkuListModel *spModel in self.model.data.mProductSkuList) {
       if (([tagBtn.currentTitle isEqualToString:spModel.sp1] ||
           [tagBtn.currentTitle isEqualToString:spModel.sp2]  ||
           [tagBtn.currentTitle isEqualToString:spModel.sp3]) && spModel.stock.intValue > 0) {
           tagBtn.enabled = YES;
           break;
       }
   }
}


#pragma mark - request
-(void)requestGetProductDetail{
    
    NSDictionary *dic = @{@"productId":self.SuperType == 0 ? self.ListModel.id : self.CartModel.productId};
    [NetApiManager requestGetProductDetail:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPScoreStoreDetalisModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestInsertCartitem:(ProductSkuListModel *) model Numder:(NSInteger) numder{
    NSDictionary *dic = @{@"productSkuId":model.id,
                          @"quantity":@(numder)
                        };
    [NetApiManager requestInsertCartitem:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] > 0) {
                    self.model.data.cartItemNum = [NSString stringWithFormat:@"%ld",[responseObject[@"data"] integerValue]];
                    self.CartNumberLabel.hidden = !self.model.data.cartItemNum.integerValue;
                    self.CartNumberLabel.text = self.model.data.cartItemNum;
                    [self.view showLoadingMeg:@"添加购物车成功,请前往购物车查看" time:MESSAGE_SHOW_TIME];
                    [self.SuperVC getCartList];
                }else{
                    [self.view showLoadingMeg:@"添加购物车失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryInsertProductShare{

    NSString *urlStr = [NSString stringWithFormat:@"product/insert_product_share?productId=%@",self.model.data.id];
    
    [NetApiManager requestQueryInsertProductShare:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {

                }else{
//                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"分享失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
