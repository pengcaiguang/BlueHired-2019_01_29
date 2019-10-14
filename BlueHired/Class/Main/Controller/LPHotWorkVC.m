//
//  LPHotWorkVC.m
//  BlueHired
//
//  Created by iMac on 2019/7/30.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPHotWorkVC.h"
#import "LPWorkDetailVC.h"
#import "LPMain2Cell.h"
#import "LPHotWorkModel.h"

static NSString *LPMainCellID = @"LPMain2Cell";

@interface LPHotWorkVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UIScrollView *ScrollView;

@property (nonatomic, strong)UITableView *headtableview;
@property (nonatomic, strong)UITableView *foottableview;

@property (nonatomic, strong)UIView *BGview;
@property (nonatomic, strong)UILabel *WorkTime;
@property (nonatomic, strong)UILabel *returnLabel;
@property (nonatomic, strong)UILabel *footreturnLabel;

@property (nonatomic, strong) LPHotWorkModel *model;

@end

@implementation LPHotWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"热招企业";
    self.ScrollView = [[UIScrollView alloc] init];
    self.ScrollView.bounces = NO;
    [self.view addSubview:self.ScrollView];
    [self.ScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.left.right.mas_offset(0);
        make.bottom.mas_offset(0);
    }];
//    self.ScrollView.backgroundColor = [UIColor lightGrayColor];
    [self setinitView];
    [self requestWorkHotList];

    if ( @available(iOS 11.0, *) ) {
        self.ScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)setinitView{
    
    CGFloat ViewHeigth = LENGTH_SIZE(460) + kBottomBarHeight +(self.model.data.hourWorkList.count + self.model.data.fullWorkList.count) * LENGTH_SIZE(130);

    self.ScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, ViewHeigth);

    
    UIView *BGview =[[UIView alloc] init];
    [self.ScrollView addSubview:BGview];
    self.BGview = BGview;
    [BGview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
        make.width.mas_offset(SCREEN_WIDTH);
        make.height.mas_offset(ViewHeigth);
    }];
    
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.ScrollView.contentSize.height>SCREEN_HEIGHT?self.ScrollView.contentSize.height:SCREEN_HEIGHT) ;
    gl.startPoint = CGPointMake(1, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)[UIColor colorWithHexString:@"#FFAB19"].CGColor,
                  (__bridge id)[UIColor colorWithHexString:@"#FF4F4F"].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [BGview.layer addSublayer:gl];
    
    
    UIImageView *imageview =[[UIImageView alloc] init];
    [BGview addSubview:imageview];
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(783));
    }];
    imageview.image = [UIImage imageNamed:@"bg"];
    
    UIImageView *Titleimage =[[UIImageView alloc] init];
    [BGview addSubview:Titleimage];
    [Titleimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(31);
        make.left.mas_offset(LENGTH_SIZE(26));
        make.right.mas_offset(LENGTH_SIZE(-26));
        make.height.mas_offset(LENGTH_SIZE(46));
    }];
    Titleimage.image = [UIImage imageNamed:@"word"];
 
    UILabel *WorktimeLabel = [[UILabel alloc] init];
    [BGview addSubview:WorktimeLabel];
    self.WorkTime = WorktimeLabel;
    [WorktimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Titleimage.mas_bottom).offset(LENGTH_SIZE(10));
        make.height.mas_offset(LENGTH_SIZE(24));
        make.left.mas_offset(LENGTH_SIZE(30));
        make.right.mas_offset(LENGTH_SIZE(-30));
    }];
    WorktimeLabel.textColor = [UIColor whiteColor];
    WorktimeLabel.layer.cornerRadius = LENGTH_SIZE(12);
    WorktimeLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    WorktimeLabel.layer.borderWidth = 1;
    WorktimeLabel.font = FONT_SIZE(15);
    WorktimeLabel.textAlignment = NSTextAlignmentCenter;
    WorktimeLabel.text = @"招聘时间：01月01日-01月01日";
    
    
    UIImageView *headImage = [[UIImageView alloc] init];
    [BGview addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(WorktimeLabel.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(110));
    }];
    headImage.image = [UIImage imageNamed:@"capsule"];
    
    UILabel *returnLabel = [[UILabel alloc] init];
    [BGview addSubview:returnLabel];
    self.returnLabel = returnLabel;
    [returnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headImage);
        make.left.mas_offset(LENGTH_SIZE(100));
    }];
    
    returnLabel.textColor = [UIColor colorWithHexString:@"#9045FE"];
    returnLabel.text = @"当前最高返费 0元";
    returnLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:returnLabel.text];
    [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(33)],
                            NSForegroundColorAttributeName: [UIColor colorWithRed:144/255.0 green:69/255.0 blue:254/255.0 alpha:1.0],
                            NSStrokeWidthAttributeName:@-2,
                            NSStrokeColorAttributeName: [UIColor colorWithHexString:@"#eedbec"]
                            }
                    range:[returnLabel.text rangeOfString:[NSString stringWithFormat:@"0元"]]];
                                                                                                                 
    returnLabel.attributedText = string;

    
    
    [BGview addSubview:self.headtableview];
    [self.headtableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImage.mas_bottom).offset(-10);
        make.left.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.height.mas_offset(self.model.data.fullWorkList.count * LENGTH_SIZE(130));
    }];
    
    
    
    
    UIImageView *FootImage = [[UIImageView alloc] init];
    [BGview addSubview:FootImage];
    [FootImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headtableview.mas_bottom);
        make.left.right.mas_offset(0);
        make.height.mas_offset(LENGTH_SIZE(110));
    }];
    FootImage.image = [UIImage imageNamed:@"capsule"];

    UILabel *FootreturnLabel = [[UILabel alloc] init];
    [BGview addSubview:FootreturnLabel];
    self.footreturnLabel = FootreturnLabel;

    [FootreturnLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(FootImage);
        make.left.mas_offset(LENGTH_SIZE(100));
    }];
    
    FootreturnLabel.textColor = [UIColor colorWithHexString:@"#9045FE"];
    FootreturnLabel.text = @"当前最高工价 0元";
    FootreturnLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
    NSMutableAttributedString *Footstring = [[NSMutableAttributedString alloc] initWithString:FootreturnLabel.text];
    [Footstring addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(33)],
                            NSForegroundColorAttributeName: [UIColor colorWithRed:144/255.0 green:69/255.0 blue:254/255.0 alpha:1.0],
                            NSStrokeWidthAttributeName:@-2,
                                NSStrokeColorAttributeName: [UIColor colorWithHexString:@"#eedbec"]
                            }
                    range:[FootreturnLabel.text rangeOfString:[NSString stringWithFormat:@"0元"]]];
    
    FootreturnLabel.attributedText = Footstring;
    
    
    [BGview addSubview:self.foottableview];
    [self.foottableview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FootImage.mas_bottom).offset(-10);
        make.left.mas_offset(LENGTH_SIZE(13));
        make.right.mas_offset(LENGTH_SIZE(-13));
        make.height.mas_offset(self.model.data.hourWorkList.count * LENGTH_SIZE(130));
    }];
    
    
    UIButton *Btn = [[UIButton alloc] init];
    [BGview addSubview:Btn];
    [Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.foottableview.mas_bottom).offset(LENGTH_SIZE(37));
        make.left.mas_offset(LENGTH_SIZE(28));
        make.right.mas_offset(LENGTH_SIZE(-28));
        make.height.mas_offset(LENGTH_SIZE(48));
    }];
    [Btn setImage:[UIImage imageNamed:@"btn_ask"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(TouchPhoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.foottableview reloadData];
    [self.headtableview reloadData];
    if (self.model.data) {
        FootreturnLabel.text =[NSString localizedStringWithFormat:@"当前最高工价 %@元/小时",reviseString(self.model.data.workMoney)];
        NSMutableAttributedString *Footstring = [[NSMutableAttributedString alloc] initWithString:FootreturnLabel.text];
        [Footstring addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(33)],
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:144/255.0 green:69/255.0 blue:254/255.0 alpha:1.0],
                                    NSStrokeWidthAttributeName:@-2,
                                    NSStrokeColorAttributeName: [UIColor colorWithHexString:@"#eedbec"]
                                    }
                            range:[FootreturnLabel.text rangeOfString:[NSString localizedStringWithFormat:@" %@",reviseString(self.model.data.workMoney)]]];
        [Footstring addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(16)],
                                    NSForegroundColorAttributeName: [UIColor colorWithRed:144/255.0 green:69/255.0 blue:254/255.0 alpha:1.0],
                                    NSStrokeWidthAttributeName:@-2,
                                    NSStrokeColorAttributeName: [UIColor colorWithHexString:@"#eedbec"]
                                    }
                            range:[FootreturnLabel.text rangeOfString:@"元/小时"]];
        
        FootreturnLabel.attributedText = Footstring;
        
        returnLabel.text = [NSString localizedStringWithFormat:@"当前最高返费 %@元",reviseString(self.model.data.workRange)];
        returnLabel.font = [UIFont boldSystemFontOfSize:FontSize(18)];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:returnLabel.text];
        [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(33)],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:144/255.0 green:69/255.0 blue:254/255.0 alpha:1.0],
                                NSStrokeWidthAttributeName:@-2,
                                NSStrokeColorAttributeName: [UIColor colorWithHexString:@"#eedbec"]
                                }
                        range:[returnLabel.text rangeOfString:[NSString localizedStringWithFormat:@" %@元",reviseString(self.model.data.workRange)]]];
        
        returnLabel.attributedText = string;
        
        WorktimeLabel.text = [NSString stringWithFormat:@"招聘时间：%@",self.model.data.activityTime];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [DSBaActivityView hideActiviTy];
    });
    
}


#pragma mark - 客服
-(void)TouchPhoneBtn:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return LENGTH_SIZE(10);
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return LENGTH_SIZE(120) ;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 3;
    if (tableView == self.headtableview) {
        return self.model.data.fullWorkList.count;
    }else {
        return self.model.data.hourWorkList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPMain2Cell *cell = [tableView dequeueReusableCellWithIdentifier:LPMainCellID];
    if(cell == nil){
        cell = [[LPMain2Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMainCellID];
    }
    cell.iscornerRadius = YES;
    cell.CellType = 1;
    if (tableView == self.headtableview) {
        cell.model = self.model.data.fullWorkList[indexPath.section];
    }else if (tableView == self.foottableview){
        cell.model = self.model.data.hourWorkList[indexPath.section];
    }
 
 
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LPWorkDetailVC *vc = [[LPWorkDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    if (tableView == self.headtableview) {
        vc.workListModel = self.model.data.fullWorkList[indexPath.section];
    }else if (tableView == self.foottableview){
        vc.workListModel = self.model.data.hourWorkList[indexPath.section];
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)setModel:(LPHotWorkModel *)model{
    _model = model;
    
    [self.BGview removeFromSuperview];
    NSLog(@"开始初始化时间 %@",[NSDate date]);
    [self setinitView];
    NSLog(@"完成时间 %@",[NSDate date]);
}


#pragma mark - request
-(void)requestWorkHotList{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [DSBaActivityView showActiviTy];
    });
    
    NSDictionary *dic = @{};
    [NetApiManager requestWorkHotList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPHotWorkModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}



#pragma mark lazy
- (UITableView *)headtableview{
    if (!_headtableview) {
        _headtableview = [[UITableView alloc]init];
        _headtableview.delegate = self;
        _headtableview.dataSource = self;
        _headtableview.tableFooterView = [[UIView alloc]init];
        _headtableview.rowHeight = UITableViewAutomaticDimension;
        _headtableview.estimatedRowHeight = 0;
        _headtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _headtableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_headtableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _headtableview.backgroundColor = [UIColor clearColor];
        _headtableview.scrollEnabled = NO;
        
        
    }
    return _headtableview;
}

- (UITableView *)foottableview{
    if (!_foottableview) {
        _foottableview = [[UITableView alloc]init];
        _foottableview.delegate = self;
        _foottableview.dataSource = self;
        _foottableview.tableFooterView = [[UIView alloc]init];
        _foottableview.rowHeight = UITableViewAutomaticDimension;
        _foottableview.estimatedRowHeight = 0;
        _foottableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _foottableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_foottableview registerNib:[UINib nibWithNibName:LPMainCellID bundle:nil] forCellReuseIdentifier:LPMainCellID];
        _foottableview.backgroundColor = [UIColor clearColor];
        _foottableview.scrollEnabled = NO;
    }
    return _foottableview;
}




@end
