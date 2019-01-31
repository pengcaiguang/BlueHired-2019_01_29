//
//  LPWStoreManageVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPWStoreManageVC.h"
#import "UIBarButtonItem+Badge.h"
#import "LPInfoVC.h"
#import "LPWStoreManageModel.h"
#import "LPWStoreBalanceVC.h"
#import "LPStoreAssistantManageVC.h"
#import "LPAffiliationMenageVC.h"
#import "LPBonusDetailVC.h"

@interface LPWStoreManageVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *textArr;
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *codeBackView;
@property (nonatomic,strong) UIBarButtonItem *navLeftButton;

@property (nonatomic,strong) LPWStoreManageModel *model;

@end

@implementation LPWStoreManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"门店管理";
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"message_base"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0,100,button.currentImage.size.width, button.currentImage.size.height);
    [button addTarget:self action:@selector(touchMessageButton) forControlEvents:UIControlEventTouchDown];
    
    // 添加角标
    _navLeftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = _navLeftButton;
    self.navigationItem.rightBarButtonItem.badgeValue = @"";
    self.navigationItem.rightBarButtonItem.badgeBGColor = [UIColor redColor];

    
    
     [self.view addSubview:self.tableview];
    if (kUserDefaultsValue(USERDATA).integerValue == 1||
        kUserDefaultsValue(USERDATA).integerValue == 2) {
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo(self.view);
            make.top.mas_equalTo(240);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self requestQueryshopkeeperinfo];

    }else if (kUserDefaultsValue(USERDATA).integerValue == 6){
        [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            //        make.edges.equalTo(self.view);
            make.top.mas_equalTo(240-63);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [self requestQueryassistantshopkeeperinfo];
    }

    
    [self setCodeUI];
    
    if (AlreadyLogin) {
        [self requestQueryInfounreadNum];
    }

 }


-(void)setCodeUI
{
    
    LPUserMaterialModel *user = [LPUserDefaults getObjectByFileName:USERINFO];
    
    if (user.data.user_url.length) {
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:user.data.user_url]];
    }else{
        self.headImageView.image = [UIImage imageNamed:@"logo_Information"];
    }
    
    
    NSString *str = kUserDefaultsValue(COOKIES);
    NSString *s = [self URLDecodedString:str];
    
    NSDictionary *dic = [self dictionaryWithJsonString:[s substringFromIndex:5]];
    
    NSString *st = dic[@"identity"];
    
//    NSString *strutl = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestURL,st];
    NSString *strutl = [NSString stringWithFormat:@"%@bluehired/login.html?identity=%@",BaseRequestWeiXiURL,st];

    //1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    // 3. 将字符串转换成NSData
    NSString *urlStr = strutl;
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    self.imageView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:240];//重绘二维码,使其显示清晰
    
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (NSString *)URLDecodedString:(NSString *)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByRemovingPercentEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)touchMessageButton{
    if ([LoginUtils validationLogin:self]) {
        LPInfoVC *vc = [[LPInfoVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - TableViewDelegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (kUserDefaultsValue(USERDATA).integerValue == 6) {
        return 3;
    }
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#3A3A3A"];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    if (kUserDefaultsValue(USERDATA).integerValue == 6) {
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@"Results"];
            cell.textLabel.text = @"门店业绩";
        }else if (indexPath.section == 1) {
            cell.imageView.image = [UIImage imageNamed:@"StoreCode_img"];
            cell.textLabel.text = @"门店二维码";
        }else if (indexPath.section == 2) {
            cell.imageView.image = [UIImage imageNamed:@"Workersset_img"];
            cell.textLabel.text = @"劳务工管理";
        }
    }else{
        if (indexPath.section == 0) {
            cell.imageView.image = [UIImage imageNamed:@"Paymentdetails_img"];
            cell.textLabel.text = @"门店收支明细";
        }else if (indexPath.section == 1) {
            cell.imageView.image = [UIImage imageNamed:@"StoreCode_img"];
            cell.textLabel.text = @"门店二维码";
        }else if (indexPath.section == 2) {
            cell.imageView.image = [UIImage imageNamed:@"assistant_img"];
            cell.textLabel.text = @"店员管理";
        }else if (indexPath.section == 3) {
            cell.imageView.image = [UIImage imageNamed:@"Workersset_img"];
            cell.textLabel.text = @"劳务工管理";
        }
    }
    

    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (kUserDefaultsValue(USERDATA).integerValue == 6) {
        if (indexPath.section == 0) {
            LPBonusDetailVC *vc = [[LPBonusDetailVC alloc] init];
            LPAssistantDataModel *Assistantmodel = [[LPAssistantDataModel alloc] init];
            Assistantmodel.userName = [LPTools isNullToString: _model.data.userName];
            Assistantmodel.role = [LPTools isNullToString:_model.data.role];
            Assistantmodel.certNo = [LPTools isNullToString:_model.data.userCardNumber];
            vc.Assistantmodel = Assistantmodel;
            [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 1) {
            [self chooseMonth];
        }else if (indexPath.section == 2) {
            LPAffiliationMenageVC *vc = [[LPAffiliationMenageVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        if (indexPath.section == 0) {
            LPWStoreBalanceVC *vc = [[LPWStoreBalanceVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 1) {
            [self chooseMonth];
        }else if (indexPath.section == 2) {
            LPStoreAssistantManageVC *vc = [[LPStoreAssistantManageVC alloc] init];
            vc.Storemodel = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.section == 3) {
            LPAffiliationMenageVC *vc = [[LPAffiliationMenageVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#FFF9F9F9"];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//        [_tableview registerNib:[UINib nibWithNibName:LPMineCellID bundle:nil] forCellReuseIdentifier:LPMineCellID];
//        [_tableview registerNib:[UINib nibWithNibName:LPMineCardCellID bundle:nil] forCellReuseIdentifier:LPMineCardCellID];
//
        _tableview.sectionHeaderHeight = CGFLOAT_MIN;
        _tableview.sectionFooterHeight = 10;
        _tableview.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        
//        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self requestUserMaterial];
//            [self requestSelectCurIsSign];
//        }];
    }
    return _tableview;
}

- (UIView *)codeBackView
{
    if (!_codeBackView) {
        _codeBackView = [[UIView alloc] init];
        [self.view addSubview:_codeBackView];
        [_codeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        _codeBackView.backgroundColor = [UIColor blackColor];
        _codeBackView.alpha = 0.5;
        _codeBackView.userInteractionEnabled = YES;
        _codeBackView.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthViewHidden)];
        [_codeBackView addGestureRecognizer:tap];
        
        [self.view bringSubviewToFront:self.CodeView];
    }
    return _codeBackView;
}

-(void)chooseMonth{
    self.CodeView.hidden = NO;
    self.codeBackView.hidden = NO;
}

-(void)monthViewHidden{
    self.CodeView.hidden = YES;
    self.codeBackView.hidden = YES;
}

-(void)setModel:(LPWStoreManageModel *)model
{
    _model = model;
    if (model.data.userUrl.length >1) {
        [_suerimage sd_setImageWithURL:[NSURL URLWithString:model.data.userUrl] placeholderImage:[UIImage imageNamed:@"userurl"]];
    }
    _ShopNum.text = [NSString stringWithFormat:@"加盟编号:%@",[LPTools isNullToString:_model.data.shopNum]];
    
    if (kUserDefaultsValue(USERDATA).integerValue == 6) {
        _Time.text =[NSString stringWithFormat:@"入店时间:%@",[NSString convertStringToYYYMMDD:_model.data.time]];
    }else if (kUserDefaultsValue(USERDATA).integerValue == 1 ||
              kUserDefaultsValue(USERDATA).integerValue == 2){
        _Time.text =[NSString stringWithFormat:@"注册时间:%@",[NSString convertStringToYYYMMDD:_model.data.time]];
    }
    
    _UserNum.text = [LPTools isNullToString:_model.data.shopUserNum];
    _LabourNum.text = [LPTools isNullToString:_model.data.shopLabourNum];
    
    
    
}




-(void)requestQueryInfounreadNum{
    NSDictionary *dic = @{
                          };
    WEAK_SELF()
    [NetApiManager requestQueryUnreadNumWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            NSInteger num = [responseObject[@"data"] integerValue];
            if (num == 0) {
                weakSelf.navLeftButton.badgeValue = @"";
            }
            else if (num>9)
            {
                weakSelf.navLeftButton.badgeValue = @"9+";
            }
            else
            {
                weakSelf.navLeftButton.badgeValue = [NSString stringWithFormat:@"%ld",(long)num];

            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryshopkeeperinfo{
    NSDictionary *dic = @{
                          };
    [NetApiManager requestQueryshopkeeperinfo:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWStoreManageModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryassistantshopkeeperinfo{
    NSDictionary *dic = @{
                          };
    [NetApiManager requestQueryassistantshopkeeperinfo:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPWStoreManageModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
