//
//  LPCustomerServiceVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCustomerServiceVC.h"
#import "LPCustomerServiceModel.h"
#import "LLPCustomerServiceCell.h"
#import "LPProblemDetailModel.h"

static NSString *LLPCustomerServiceCellID = @"LLPCustomerServiceCell";

@interface LPCustomerServiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIButton *button;
@property(nonatomic,strong) LPCustomerServiceModel *model;

@property(nonatomic,strong) LPProblemDetailModel *detailModel;

@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *answerLabel;

@property(nonatomic,strong) NSString *touchText;

@end

@implementation LPCustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的客服";
    [self setupUI];
    [self requestQueryProblem];
}
- (void)setupUI{
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    label.text = @"常见问题";
    label.font = [UIFont systemFontOfSize:16];
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(48);
    }];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor baseColor];
    [button addTarget:self action:@selector(touchButton) forControlEvents:UIControlEventTouchUpInside];
    self.button = button;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-90);
    }];
}
-(void)touchButton{
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

-(void)setModel:(LPCustomerServiceModel *)model{
    _model = model;
    [self.button setTitle:[NSString stringWithFormat:@"客服热线：%@",model.data.telephone] forState:UIControlStateNormal];
    [self.tableview reloadData];
}
-(void)setDetailModel:(LPProblemDetailModel *)detailModel{
    _detailModel = detailModel;
    [self showAlert];
    self.titleLabel.text = detailModel.data.problemTitle;
    self.answerLabel.text = detailModel.data.answer;
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.list.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLPCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LLPCustomerServiceCellID];
    cell.model = self.model.data.list[indexPath.row];
    cell.block = ^{
        [tableView reloadData];
    };
    cell.touchBlock = ^(NSString * _Nonnull string) {
        self.touchText = string;
        [self requestQueryProblemDetail];
    };
    return cell;
}
-(void)showAlert{
    self.bgView.hidden = NO;
    self.alertView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    }];
}
-(void)hiddenAlert{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
        self.alertView.hidden = YES;
    }];

}
#pragma mark - request
-(void)requestQueryProblem{
    [NetApiManager requestQueryProblemWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.model = [LPCustomerServiceModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryProblemDetail{
    NSDictionary *dic = @{
                          @"title":self.touchText
                          };
    [NetApiManager requestQueryProblemDetailWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            self.detailModel = [LPProblemDetailModel mj_objectWithKeyValues:responseObject];
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        [_tableview registerNib:[UINib nibWithNibName:LLPCustomerServiceCellID bundle:nil] forCellReuseIdentifier:LLPCustomerServiceCellID];
        
    }
    return _tableview;
}
-(UIView *)alertView{
    if (!_alertView) {
        _alertView = [[UIView alloc]init];
        _alertView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT/2);
        _alertView.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:_alertView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        [_alertView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(30, 15, SCREEN_WIDTH-60, 20);
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
        
        UIView *view = [[UIView alloc]init];
        view.frame = CGRectMake(0, 50, SCREEN_WIDTH, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [_alertView addSubview:view];
        
        UILabel *answerLabel = [[UILabel alloc]init];
        [_alertView addSubview:answerLabel];
        [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(60);
        }];
        answerLabel.font = [UIFont systemFontOfSize:14];
        answerLabel.numberOfLines = 0;
        answerLabel.textColor = [UIColor blackColor];
        self.answerLabel = answerLabel;
        
        UIButton *close = [[UIButton alloc]init];
        close.frame = CGRectMake(SCREEN_WIDTH-28, 18, 14, 14);
        [_alertView addSubview:close];
        [close setImage:[UIImage imageNamed:@"closeButton"] forState:UIControlStateNormal];
        [close addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.3;
        [[UIApplication sharedApplication].keyWindow addSubview:_bgView];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenAlert)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
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
