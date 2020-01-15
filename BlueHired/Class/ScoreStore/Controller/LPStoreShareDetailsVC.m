//
//  LPStoreShareDetailsVC.m
//  BlueHired
//
//  Created by iMac on 2019/10/29.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPStoreShareDetailsVC.h"
#import "LPConfirmAnOrderVC.h"

@interface LPStoreShareDetailsVC ()

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UIView *commodityView;
@property (weak, nonatomic) IBOutlet UIImageView *commodityImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityName;
@property (weak, nonatomic) IBOutlet UILabel *postageLabel;
@property (weak, nonatomic) IBOutlet UILabel *commoditySize;
@property (weak, nonatomic) IBOutlet UIView *commoditySizeView;
@property (weak, nonatomic) IBOutlet UIImageView *commoditySizeViewImage;
@property (weak, nonatomic) IBOutlet UILabel *commodityUnit;
@property (weak, nonatomic) IBOutlet UILabel *commoditySaleUnit;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Commodity_Right;


@property (weak, nonatomic) IBOutlet UIImageView *BuyGradeImage;
@property (weak, nonatomic) IBOutlet UIButton *BuyBtn;
@property (weak, nonatomic) IBOutlet UILabel *shareNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sharePlanImage;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel1;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel3;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel4;

@property (weak, nonatomic) IBOutlet UILabel *PeopleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *PeopleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *PeopleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *PeopleLabel4;
@property (weak, nonatomic) IBOutlet UIButton *SharePlanBtn;


@property (weak, nonatomic) IBOutlet UIButton *ShareBtn;

@property (weak, nonatomic) IBOutlet UIView *shareNumView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_shareNumView_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_RuleView_Top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_IconLike_Left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_sharePlanImage_Width;


@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *SelectSizeView;
@property (nonatomic, strong) UILabel *SizeViewUnit;
@property (nonatomic, strong) UIButton *SizeViewSaveBtn;
@property (nonatomic, strong) UIScrollView *sizeScrollView;
@property (nonatomic, strong) NSMutableArray *selectSizeStrArr;
@property (nonatomic, strong) NSMutableArray *selectBtnArr;
@property (nonatomic, strong) NSMutableArray *selectTypeLabelArr;
@property (nonatomic, strong) ProductSkuListModel *selectProductSkuModel;
@property (nonatomic, strong) NSArray *gradeArr;

@end

@implementation LPStoreShareDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"分享详情";
    self.gradeArr = @[@"见习职工",
                      @"初级职工",
                      @"中级职工",
                      @"高级职工",
                      @"部门精英",
                      @"部门经理",
                      @"区域经理",
                      @"总经理",
                      @"董事长"];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.SelectSizeView];
    [self initView];
}

- (void)initView{
    self.commodityView.layer.shadowColor = [UIColor colorWithRed:230/255.0 green:129/255.0 blue:157/255.0 alpha:0.25].CGColor;
    self.commodityView.layer.shadowOffset = CGSizeMake(0,5);
    self.commodityView.layer.shadowOpacity = 1;
    self.commodityView.layer.shadowRadius = 7;
    self.commodityView.layer.cornerRadius = 6;
    
    UITapGestureRecognizer *TapGestureRecognizerimageBg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchSelectSize)];
    [self.commoditySizeView addGestureRecognizer:TapGestureRecognizerimageBg];
    
    
    NSArray *imageArr = [self.model.productPic componentsSeparatedByString:@","];

    self.commodityImage.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
    self.commodityImage.layer.borderWidth = LENGTH_SIZE(1);
    
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:imageArr[0]]
                                   placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
       self.commodityName.text = self.model.productName;
       self.postageLabel.text = self.model.postage.integerValue == 0 ? @"包邮" : @"到付";
       self.BuyGradeImage.image = [UIImage imageNamed:self.model.grade];

    [self UpdateSize];
    [self UpdateStatus];
       if (self.model.discountNum.integerValue == 0) {
           self.commodityUnit.text = [NSString stringWithFormat:@"%@ 积分",self.model.price];
           [self NumAttributedString:self.commodityUnit isLine:NO];
           self.commoditySaleUnit.hidden = YES;
           
           NSString *ShareNumStr = [NSString stringWithFormat:@"%ld人",(long)self.model.shareNum.integerValue];
           self.shareNumLabel.text = [NSString stringWithFormat:@"已有%@点赞，无优惠",ShareNumStr];
           NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.shareNumLabel.text];

           [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#E6313F"]} range:[self.shareNumLabel.text rangeOfString:ShareNumStr]];
           self.shareNumLabel.attributedText = string;
           
//           self.SharePlanBtn.hidden = YES;
           self.LayoutConstraint_IconLike_Left.constant = LENGTH_SIZE(92);
       }else{
           self.commodityUnit.text = [NSString stringWithFormat:@"%@积分",self.model.price];
           [self NumAttributedString:self.commodityUnit isLine:YES];
           self.commoditySaleUnit.hidden = NO;
           self.commoditySaleUnit.text = [NSString stringWithFormat:@"折后%.0f积分",floor(self.model.discountNum.integerValue/100.0*self.model.price.integerValue)];
           
           NSString *ShareNumStr = [NSString stringWithFormat:@"%ld人",(long)self.model.shareNum.integerValue];
           NSString *discountNumStr = [NSString stringWithFormat:@"%.1f折",self.model.discountNum.floatValue/10];

           self.shareNumLabel.text = [NSString stringWithFormat:@"已有%@点赞，可享受%@优惠",ShareNumStr,discountNumStr];
           NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.shareNumLabel.text];

           [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#E6313F"]} range:[self.shareNumLabel.text rangeOfString:ShareNumStr]];
           [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#E6313F"]} range:[self.shareNumLabel.text rangeOfString:discountNumStr]];

           self.shareNumLabel.attributedText = string;
           
//           self.SharePlanBtn.hidden = NO;
           [self.SharePlanBtn setTitle:discountNumStr forState:UIControlStateNormal];
           
           self.LayoutConstraint_IconLike_Left.constant = LENGTH_SIZE(54);

       }
       

    
    if (self.model.shareNum.integerValue > 5 && self.model.shareNum.integerValue <= 10 ) {
        self.DiscountLabel1.hidden = YES;
        self.PeopleLabel1.hidden = YES;

    }else if (self.model.shareNum.integerValue > 10 && self.model.shareNum.integerValue <= 15 ){
        self.DiscountLabel1.hidden = YES;
        self.PeopleLabel1.hidden = YES;
        self.DiscountLabel2.hidden = YES;
        self.PeopleLabel2.hidden = YES;
    }else if (self.model.shareNum.integerValue > 15  ){
        self.DiscountLabel1.hidden = YES;
        self.PeopleLabel1.hidden = YES;
        self.DiscountLabel2.hidden = YES;
        self.PeopleLabel2.hidden = YES;
        self.DiscountLabel3.hidden = YES;
        self.PeopleLabel3.hidden = YES;
    }
    
    //点赞人数列表
    
    self.LayoutConstraint_sharePlanImage_Width.constant = (SCREEN_WIDTH - LENGTH_SIZE(32)) / 20 * (self.model.shareNum.integerValue>20?20:self.model.shareNum.integerValue);
    
    for (NSInteger j = 0 ; j < ceil(self.model.shareNum.integerValue/5.0); j++) {
        NSInteger irow = self.model.shareNum.integerValue > (j+1)*5?5:self.model.shareNum.integerValue-j*5;
        for (NSInteger i = 0; i< irow; i++) {
            
            LPStoreShareDataUserModel *m = self.model.shareUserList[j*5+i];
            
            UIImageView *UserImage = [[UIImageView alloc] init];
            [self.shareNumView addSubview:UserImage];
            [UserImage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_offset(j * LENGTH_SIZE(80) + LENGTH_SIZE(60));
                make.left.mas_offset(LENGTH_SIZE(15) + i*LENGTH_SIZE(69));
                make.width.mas_offset(LENGTH_SIZE(45));
                make.height.mas_offset(LENGTH_SIZE(45));
            }];
            UserImage.clipsToBounds = YES;
            UserImage.layer.cornerRadius = LENGTH_SIZE(22.5);
            UserImage.layer.borderColor = [UIColor whiteColor].CGColor;
            UserImage.layer.borderWidth = LENGTH_SIZE(1);
            [UserImage yy_setImageWithURL:[NSURL URLWithString:m.userImage]
                                           placeholder:[UIImage imageNamed:@"avatar"]];
            
            UILabel *userName = [[UILabel alloc] init];
            [self.shareNumView addSubview:userName];
            [userName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(UserImage.mas_bottom).offset(LENGTH_SIZE(4));
                make.centerX.equalTo(UserImage);
                make.width.mas_offset(LENGTH_SIZE(65));
            }];
            userName.textAlignment = NSTextAlignmentCenter;
            userName.textColor = [UIColor colorWithHexString:@"#333333"];
            userName.font = FONT_SIZE(11);
            userName.text = m.userName;
            
        }
    }
    
    self.LayoutConstraint_shareNumView_Height.constant = self.model.shareNum.integerValue == 0 ? 0 : ceil(self.model.shareNum.integerValue/5.0) * LENGTH_SIZE(80) + LENGTH_SIZE(60) ;
    self.LayoutConstraint_RuleView_Top.constant = self.model.shareNum.integerValue == 0 ? LENGTH_SIZE(30) : self.LayoutConstraint_shareNumView_Height.constant + LENGTH_SIZE(20) + LENGTH_SIZE(30);
     
}

-(void)UpdateSize{
    NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:self.model.sp1],
                                                                      [LPTools isNullToString:self.model.sp2],
                                                                      [LPTools isNullToString:self.model.sp3]]];
    [SizeArr removeObject:@""];
    self.commoditySize.text = [NSString stringWithFormat:@"规格:%@",
                               [SizeArr componentsJoinedByString:@","]];
    if (self.model.discountNum.integerValue == 0) {
        self.commodityUnit.text = [NSString stringWithFormat:@"%@ 积分",self.model.price];
        [self NumAttributedString:self.commodityUnit isLine:NO];
        self.commoditySaleUnit.hidden = YES;
    }else{
        self.commodityUnit.text = [NSString stringWithFormat:@"%@积分",self.model.price];
        [self NumAttributedString:self.commodityUnit isLine:YES];
        self.commoditySaleUnit.hidden = NO;
        self.commoditySaleUnit.text = [NSString stringWithFormat:@"折后%.0f积分",floor(self.model.discountNum.integerValue/100.0*self.model.price.integerValue)];
     
    }
}

-(void)UpdateStatus{
    //    未兑换
           if (self.model.status.integerValue == 0) {
               self.LayoutConstraint_Commodity_Right.constant = LENGTH_SIZE(22);
               self.commoditySizeViewImage.hidden = NO;
               self.commoditySizeView.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];

               
               CAGradientLayer *gl = [CAGradientLayer layer];
               gl.frame = CGRectMake(0, 0, LENGTH_SIZE(90), LENGTH_SIZE(30));
               gl.startPoint = CGPointMake(0, 0);
               gl.endPoint = CGPointMake(1, 1);
               gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#3CCFFF"].CGColor,
                             (__bridge id)[UIColor baseColor].CGColor];
               gl.locations = @[@(0.0),@(1.0)];
               [self.BuyBtn.layer insertSublayer:gl atIndex:0];
               self.BuyBtn.layer.cornerRadius = LENGTH_SIZE(15);
               
               [self.BuyBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
               [self.BuyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               self.BuyBtn.layer.borderColor = [UIColor clearColor].CGColor;
               self.BuyBtn.layer.borderWidth = LENGTH_SIZE(0);
               self.BuyBtn.layer.cornerRadius = LENGTH_SIZE(15);
               
               CAGradientLayer *Sharegl = [CAGradientLayer layer];
               Sharegl.frame = CGRectMake(0, 0,SCREEN_WIDTH - LENGTH_SIZE(28*2), LENGTH_SIZE(45));
               Sharegl.startPoint = CGPointMake(0, 0);
               Sharegl.endPoint = CGPointMake(1, 1);
               Sharegl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:77/255.0 blue:119/255.0 alpha:1.0].CGColor,
                             (__bridge id)[UIColor colorWithRed:235/255.0 green:33/255.0 blue:50/255.0 alpha:1.0].CGColor];
               Sharegl.locations = @[@(0.0),@(1.0)];
               self.ShareBtn.layer.cornerRadius = LENGTH_SIZE(15);
               [self.ShareBtn.layer insertSublayer:Sharegl atIndex:0];
               self.ShareBtn.layer.cornerRadius = LENGTH_SIZE(23);
               [self.ShareBtn setTitle:@"邀请更多好友点赞" forState:UIControlStateNormal];
               [self.ShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

           }else{
    //           已兑换
               NSArray<CALayer *> *subLayers = self.ShareBtn.layer.sublayers;
               NSArray<CALayer *> *removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                   return [evaluatedObject isKindOfClass:[CAGradientLayer class]];
               }]];
               [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   [obj removeFromSuperlayer];
               }];


                subLayers = self.BuyBtn.layer.sublayers;
                removedLayers = [subLayers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return [evaluatedObject isKindOfClass:[CAGradientLayer class]];
                }]];
                [removedLayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperlayer];
                }];
               
               self.LayoutConstraint_Commodity_Right.constant = LENGTH_SIZE(6);
               self.commoditySizeViewImage.hidden = YES;
               self.commoditySizeView.backgroundColor = [UIColor whiteColor];
               [self.BuyBtn setTitle:@"查看订单" forState:UIControlStateNormal];
               [self.BuyBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
               self.BuyBtn.layer.borderColor = [UIColor colorWithHexString:@"#808080"].CGColor;
               self.BuyBtn.layer.borderWidth = LENGTH_SIZE(1);
               self.BuyBtn.layer.cornerRadius = LENGTH_SIZE(15);
               
               [self.ShareBtn setTitle:@"商品已兑换" forState:UIControlStateNormal];
               [self.ShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
               self.ShareBtn.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];
               self.ShareBtn.layer.cornerRadius = LENGTH_SIZE(23);

           }
}

-(void)NumAttributedString:(UILabel *)NumLabel  isLine:(BOOL) isLine{
    if (!NumLabel) {
        return;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:NumLabel.text];
     
    if (isLine) {
        [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, NumLabel.text.length)];
        [string addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, NumLabel.text.length)]; // 删除线颜色
        
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]}
                        range:NSMakeRange(0, NumLabel.text.length )];
        
    }else{
        [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(14)],
                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF7F00"]}
                        range:NSMakeRange(0, NumLabel.text.length - 2)];
        
        [string addAttributes:@{NSFontAttributeName: FONT_SIZE(12),
                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#808080"]} range:NSMakeRange(NumLabel.text.length - 2, 2)];
    }


    
    NumLabel.attributedText = string;
}


#pragma mark Touch

- (IBAction)TouchBuyBtn:(id)sender {
    if (self.model.status.integerValue == 0) {
        if (self.model.productSkuId.integerValue>0) {
            
            LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
                       
            if ([self.gradeArr indexOfObject:self.model.grade] > [self.gradeArr indexOfObject:user.data.grading]) {
                [self.view showLoadingMeg:@"用户积分等级不足" time:MESSAGE_SHOW_TIME];
                return;
            }
            
            LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
            vc.Type = 0;
            vc.BuyType = 2;
            vc.ShareModel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            WEAK_SELF()
            vc.CartBlock = ^(LPOrderGenerateModel * _Nonnull GenModel) {
                weakSelf.model.orderId = GenModel.data.order.id;
                weakSelf.model.status = @"1";
                [weakSelf.SupreTableView reloadData];
                [weakSelf UpdateStatus];
                
            };
        }else{
            [self.view showLoadingMeg:@"请选择商品规格" time:MESSAGE_SHOW_TIME];
        }
    }else{
        LPConfirmAnOrderVC *vc = [[LPConfirmAnOrderVC alloc] init];
        vc.Type = 1;
        vc.ShareOrderID = self.model.orderId;
        [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    }
}

- (IBAction)TouchShareBtn:(id)sender {
    if (self.model.status.integerValue == 0) {
         NSString  *url = [NSString stringWithFormat:@"%@resident/#/commoditylike?productId=%@&shareUserId=%@",BaseRequestWeiXiURL,self.model.productId,kUserDefaultsValue(LOGINID)];
        NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [LPTools ClickShare:encodedUrl Title:self.model.productName];
    }

    
}

-(void)TouchSelectSize{
    if (self.model.status.integerValue == 0) {
       [self initSizeScrollView:self.model];
       [self SelectSizeViewHidden:NO];
    }
}



- (void)initSizeScrollView:(LPStoreShareDataModel *)model{

    NSMutableArray *spNameArr = [[NSMutableArray alloc] init];
    [spNameArr addObject:[LPTools isNullToString:model.mProductSkuList[0].spName1]];
    [spNameArr addObject:[LPTools isNullToString:model.mProductSkuList[0].spName2]];
    [spNameArr addObject:[LPTools isNullToString:model.mProductSkuList[0].spName3]];
 
    self.selectTypeLabelArr = [[NSMutableArray alloc] init];;

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
            for (ProductSkuListModel *spModel in model.mProductSkuList) {
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
                for (ProductSkuListModel *spModel in model.mProductSkuList) {
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
  
    self.sizeScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, tagBtnY + LENGTH_SIZE(40));
 
}

#pragma mark Touch


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
                   for (ProductSkuListModel *spModel in self.model.mProductSkuList) {
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
                    for (ProductSkuListModel *spModel in self.model.mProductSkuList) {
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

    //判断库存数量
      if (self.selectTypeLabelArr.count == self.selectSizeStrArr.count) {
          for (ProductSkuListModel *spModel in self.model.mProductSkuList) {
              NSMutableArray *typeArr = [[NSMutableArray alloc] init];
                                    
              [typeArr addObject:[LPTools isNullToString:spModel.sp1]];
              [typeArr addObject:[LPTools isNullToString:spModel.sp2]];
              [typeArr addObject:[LPTools isNullToString:spModel.sp3]];
              
              [typeArr removeObject:@""];
              if ([typeArr isEqualToArray:self.selectSizeStrArr] ) {
                  self.SizeViewUnit.text = spModel.price;
                   self.selectProductSkuModel = spModel;
                  break;
              }else{
                  self.selectProductSkuModel = nil;
              }
          }
      }else{
          self.selectProductSkuModel = nil;
      }
    
     
}

- (void)TouchSizeViewSave:(UIButton *)sender {
    if (self.selectTypeLabelArr.count == self.selectBtnArr.count) {
        [self requestQueryUpdateProductShareSKU:self.selectProductSkuModel];
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


#pragma mark - request
-(void)requestQueryUpdateProductShareSKU:(ProductSkuListModel *) SkuModel{
    
     NSString *urlStr = [NSString stringWithFormat:@"product/update_product_share_sku?id=%@&productSkuId=%@",self.model.id,SkuModel.id];

    [NetApiManager requestQueryUpdateProductShareSKU:nil URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    [self SelectSizeViewHidden:YES];
                    self.model.price = SkuModel.price;
                    self.model.productSkuId = SkuModel.id;
                    self.model.sp1 = SkuModel.sp1;
                    self.model.sp2 = SkuModel.sp2;
                    self.model.sp3 = SkuModel.sp3;
                    self.model.spName1 = SkuModel.spName1;
                    self.model.spName2 = SkuModel.spName2;
                    self.model.spName3 = SkuModel.spName3;
                    [self.SupreTableView reloadData];
                    
                    [self UpdateSize];

                    
                    
                }else{
                    [self.view showLoadingMeg:@"商品规格修改失败,请稍后再试" time:MESSAGE_SHOW_TIME];
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
