//
//  LPEssayDetailVC.m
//  BlueHired
//
//  Created by peng on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailVC.h"
#import "LPEssayDetailHeadCell.h"
#import "LPEssayDetailCommentCell.h"
#import "LPEssayDetailModel.h"
#import "LPCommentListModel.h"
#import "LPEssaylistModel.h"
 
static NSString *LPEssayDetailHeadCellID = @"LPEssayDetailHeadCell";
 

@interface LPEssayDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *HeadView;
@property (nonatomic, strong) UILabel *EssayTitle;
@property (nonatomic, strong) UILabel *EssayTime;
@property (nonatomic, strong) UIButton *CommonBtn;
@property (nonatomic, strong) UIButton *shaerBtn;

@property (nonatomic, strong) LPEssayDetailModel *model;

@end

@implementation LPEssayDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"新闻详情";
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
 
    [self requestEssay];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)touchBottomButton:(UIButton *)button{
    
    if (button == self.shaerBtn) {
        NSString *url = [NSString stringWithFormat:@"%@resident/#/newsdetail?id=%@",BaseRequestWeiXiURL,self.model.data.id];
        NSString *encodedUrl = [NSString stringWithString:[url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [LPTools ClickShare:encodedUrl Title:_model.data.essayName];
        return;
    }else if (button == self.CommonBtn){
        if ([LoginUtils validationLogin:self]) {
            [self requestSetCollection];
        }
    }
}
 

-(void)setModel:(LPEssayDetailModel *)model{
    _model = model;
    if (model) {
        self.EssayTitle.text = model.data.essayName;
        self.EssayTime.text = [NSString stringWithFormat:@"发布时间：%@",[NSString convertStringToTime:model.data.time.stringValue]];
        if (model.data.collectionStatus.integerValue  && AlreadyLogin) {
            self.CommonBtn.selected = YES;
        }else{
            self.CommonBtn.selected = NO;
        }
     }
    [self.tableview reloadData];
}
 

#pragma mark - TableViewDelegate & Datasource
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
 
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPEssayDetailHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:LPEssayDetailHeadCellID];
    cell.model = self.model;
    WEAK_SELF()
    cell.Block = ^(CGFloat height) {
        [weakSelf.tableview reloadData];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - request
-(void)requestEssay{
    NSDictionary *dic = @{
                          @"id":self.essaylistDataModel.id
                          };
    [DSBaActivityView showActiviTy];
    [NetApiManager requestEssayWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPEssayDetailModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
        [DSBaActivityView hideActiviTy];
    }];
}
 
-(void)requestSetCollection{
    NSDictionary *dic = @{
                          @"type":@(2),
                          @"id":self.essaylistDataModel.id,
                          };

    [NetApiManager requestSetCollectionWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                    if ([responseObject[@"data"] integerValue] == 0) {
                        [LPTools AlertCollectView:@""];
                        self.CommonBtn.selected = YES;
                        self.essaylistDataModel.collectionStatus = @"1";
                    } else if ([responseObject[@"data"] integerValue] == 1) {
                        self.CommonBtn.selected = NO;
                        self.essaylistDataModel.collectionStatus = @"0";
                        if (self.CollectionBlock) {
                            self.CollectionBlock();
                        }
                    }
              
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    } IsShowActivity:YES];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPEssayDetailHeadCellID bundle:nil] forCellReuseIdentifier:LPEssayDetailHeadCellID];
        _tableview.tableHeaderView = self.HeadView;
        [self.HeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(_tableview);
        }];
    }
    return _tableview;
}

- (UIView *)HeadView{
    if (!_HeadView) {
        _HeadView = [[UIView alloc] init];
        UILabel *Title = [[UILabel alloc] init];
        [_HeadView addSubview:Title];
        self.EssayTitle = Title;
        [Title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(LENGTH_SIZE(15));
            make.left.mas_offset(LENGTH_SIZE(13));
            make.right.mas_offset(LENGTH_SIZE(-13));
        }];
        Title.font = FONT_SIZE(17);
        Title.numberOfLines = 0;
        Title.textColor = [UIColor colorWithHexString:@"#1D1D1D"];
        
        UIButton *Shaer = [[UIButton alloc] init];
        [_HeadView addSubview:Shaer];
        self.shaerBtn = Shaer;
        [Shaer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(Title.mas_bottom).offset(LENGTH_SIZE(6));
            make.right.mas_offset(LENGTH_SIZE(-16));
            make.width.mas_offset(LENGTH_SIZE(20));
            make.height.mas_offset(LENGTH_SIZE(20));
        }];
        [Shaer setImage:[UIImage imageNamed:@"share_btn"] forState:UIControlStateNormal];
        [Shaer addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *common = [[UIButton alloc] init];
        [_HeadView addSubview:common];
        self.CommonBtn = common;
        [common mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(Shaer);
            make.right.mas_offset(LENGTH_SIZE(-55));
            make.width.mas_offset(LENGTH_SIZE(20));
            make.height.mas_offset(LENGTH_SIZE(20));
        }];
        [common setImage:[UIImage imageNamed:@"collection_normal"] forState:UIControlStateNormal];
        [common setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
        [common addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *Time = [[UILabel alloc] init];
        [_HeadView addSubview:Time];
        self.EssayTime = Time;
        [Time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(common);
            make.left.mas_offset(LENGTH_SIZE(13));
            make.right.equalTo(common.mas_left).offset(LENGTH_SIZE(-4));
        }];
        Time.textColor = [UIColor colorWithHexString:@"#999999"];
        Time.font = FONT_SIZE(12);
        
        UIView *lineV = [[UIView alloc] init];
        [_HeadView addSubview:lineV];
        [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(common.mas_bottom).offset(LENGTH_SIZE(8));
            make.left.mas_offset(LENGTH_SIZE(13));
            make.right.bottom.mas_offset(0);
            make.height.mas_offset(LENGTH_SIZE(0.5));
        }];
        lineV.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        
    }
    return _HeadView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 
@end
