//
//  LPLendRepulsedetailsVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendRepulsedetailsVC.h"
#import "LPLendDetailsCell.h"
#import "RSAEncryptor.h"
#import "XWScanImage.h"

static  NSString *RSAPublickKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDvh1MAVToAiuEVOFq9mo3IOJxN5aekgto1kyOh07qQ+1Wc+Uxk1wX2t6+HCA31ojcgaR/dZz/kQ5aZvzlB8odYHJXRtIcOAVQe/FKx828XFTzC8gp1zGh7vTzBCW3Ieuq+WRiq9cSzEZlNw9RcU38st9q9iBT8PhK0AkXE2hLbKQIDAQAB";
static NSString *RSAPrivateKey = @"MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBAO+HUwBVOgCK4RU4Wr2ajcg4nE3lp6SC2jWTI6HTupD7VZz5TGTXBfa3r4cIDfWiNyBpH91nP+RDlpm/OUHyh1gcldG0hw4BVB78UrHzbxcVPMLyCnXMaHu9PMEJbch66r5ZGKr1xLMRmU3D1FxTfyy32r2IFPw+ErQCRcTaEtspAgMBAAECgYBSczN39t5LV4LZChf6Ehxh4lKzYa0OLNit/mMSjk43H7y9lvbb80QjQ+FQys37UoZFSspkLOlKSpWpgLBV6gT5/f5TXnmmIiouXXvgx4YEzlXgm52RvocSCvxL81WCAp4qTrp+whPfIjQ4RhfAT6N3t8ptP9rLgr0CNNHJ5EfGgQJBAP2Qkq7RjTxSssjTLaQCjj7FqEYq1f5l+huq6HYGepKU+BqYYLksycrSngp0y/9ufz0koKPgv1/phX73BmFWyhECQQDx1D3Gui7ODsX02rH4WlcEE5gSoLq7g74U1swbx2JVI0ybHVRozFNJ8C5DKSJT3QddNHMtt02iVu0a2V/uM6eZAkEAhvmce16k9gV3khuH4hRSL+v7hU5sFz2lg3DYyWrteHXAFDgk1K2YxVSUODCwHsptBNkogdOzS5T9MPbB+LLAYQJBAKOAknwIaZjcGC9ipa16txaEgO8nSNl7S0sfp0So2+0gPq0peWaZrz5wa3bxGsqEyHPWAIHKS20VRJ5AlkGhHxECQQDr18OZQkk0LDBZugahV6ejb+JIZdqA2cEQPZFzhA3csXgqkwOdNmdp4sPR1RBuvlVjjOE7tCiFLup/8TvRJDdr";
static NSString *LPTLendAuditCellID = @"LPLendDetailsCell";

@interface LPLendRepulsedetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,copy)NSArray *tittleArr;
@property (nonatomic,copy)NSMutableArray *contentArr;
@property (nonatomic,strong) LPLandAuditDataModel *Detailmodel;
@property (nonatomic,strong) UIButton *ImageButton;

@end

@implementation LPLendRepulsedetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _tittleArr = @[@"姓名",@"工号",@"联系电话",@"身份证号",@"审核日期",@"借支金额",@"企业姓名",@"入职日期"];
    self.navigationItem.title = @"借支详情";
    _contentArr = [[NSMutableArray alloc] init];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(self.tittleArr.count*44+10);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_equalTo(13);
        make.top.equalTo(self.tableview.mas_bottom).offset(17);
    }];
    label.text = @"上传图片";
    
    UIButton *ImageButton = [[UIButton alloc] init];
    self.ImageButton = ImageButton;
    [self.view addSubview:ImageButton];
    [ImageButton mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.mas_equalTo(117*SCREEN_WIDTH/360);
        make.height.mas_equalTo(83*SCREEN_WIDTH/360);
        make.right.mas_equalTo(-13);
        make.top.equalTo(self.tableview.mas_bottom).offset(17);
    }];
    ImageButton.layer.cornerRadius = 4;
    ImageButton.clipsToBounds = YES;
    [ImageButton setImage:[UIImage imageNamed:@"LendNormalImage"] forState:UIControlStateNormal];
    
    [self requestQueryMoneyList];
    [ImageButton addTarget:self action:@selector(scanBigImageClick1:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)scanBigImageClick1:(UIButton *)sender{
    NSLog(@"点击图片");
    UIImageView *clickedImageView = sender.imageView;
    [XWScanImage scanBigImageWithImageView:clickedImageView];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.scrollEnabled = NO;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LPTLendAuditCellID bundle:nil] forCellReuseIdentifier:LPTLendAuditCellID];
        //        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //            self.page = 1;
        //            [self requestGetOnWork];
        //        }];
        //        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //            [self requestGetOnWork];
        //        }];
    }
    return _tableview;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tittleArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPLendDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPLendDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    cell.titleLabel.text = _tittleArr[indexPath.row];
    
    if (_contentArr.count == _tittleArr.count) {
        cell.content.text = [_contentArr objectAtIndex:indexPath.row];
    }
    return cell;
    
}

#pragma mark - request
-(void)requestQueryMoneyList{
    NSDictionary *dic = @{@"id":self.model.id,@"versionType":@"2.1"};
    
    WEAK_SELF()
    [NetApiManager requestQueryUpdateLandMoneyDetail:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weakSelf.Detailmodel = [LPLandAuditDataModel mj_objectWithKeyValues:responseObject[@"data"]];
                [weakSelf.contentArr removeAllObjects];
                [weakSelf.contentArr addObject:[LPTools isNullToString:weakSelf.Detailmodel.userName]];
                [weakSelf.contentArr addObject:[LPTools isNullToString:weakSelf.Detailmodel.workNum]];
                [weakSelf.contentArr addObject:[LPTools isNullToString:weakSelf.Detailmodel.userTel]];
                [weakSelf.contentArr addObject:[RSAEncryptor decryptString:weakSelf.Detailmodel.certNo privateKey:RSAPrivateKey]];
                if (weakSelf.Detailmodel.status.integerValue == 0) {
                    [weakSelf.contentArr addObject:@"审核中"];
                }else if (weakSelf.Detailmodel.status.integerValue == 1){
                    long long time=[weakSelf.Detailmodel.set_time longLongValue];
                    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy年MM月dd日"];
                    NSString*timeStr=[formatter stringFromDate:d];
                    
                    [weakSelf.contentArr addObject:timeStr];
                }else if (weakSelf.Detailmodel.status.integerValue == 2){
                    [weakSelf.contentArr addObject:@"已拒绝"];
                }
                [weakSelf.contentArr addObject:[NSString stringWithFormat:@"%@元",[LPTools isNullToString:weakSelf.Detailmodel.lendMoney]]];
                [weakSelf.contentArr addObject:[LPTools isNullToString:weakSelf.Detailmodel.mechanismName]];
                long long time=[weakSelf.Detailmodel.workBeginTime longLongValue];
                if (time>0) {
                    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
                    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
                    [formatter setDateFormat:@"yyyy年MM月dd日"];
                    NSString*timeStr=[formatter stringFromDate:d];
                    [weakSelf.contentArr addObject:timeStr];
                }else{
                    [weakSelf.contentArr addObject:@""];
                }
                [self.ImageButton yy_setImageWithURL:[NSURL URLWithString:weakSelf.Detailmodel.userWorkImage] forState:UIControlStateNormal placeholder:[UIImage imageNamed:@"LendNormalImage"]];
                [weakSelf.tableview reloadData];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
            
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

@end
