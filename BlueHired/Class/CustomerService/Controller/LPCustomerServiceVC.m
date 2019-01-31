//
//  LPCustomerServiceVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPCustomerServiceVC.h"
#import "LLPCustomerServiceCell.h"
#import "LPProblemDetailModel.h"

static NSString *LLPCustomerServiceCellID = @"LLPCustomerServiceCell";

@interface LPCustomerServiceVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIButton *button;

@property(nonatomic,strong) LPProblemDetailModel *detailModel;

@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UITextView *answerLabel;
@property(nonatomic,strong) UIView *answerview;

@property(nonatomic,strong) NSString *touchText;

@end

@implementation LPCustomerServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"常见问题";
    [self setupUI];
    [self requestQueryProblem];
}
- (void)setupUI{
  
    UIFont *font = [UIFont fontWithName:@"Arial-ItalicMT" size:19];
    NSDictionary *dic = @{NSFontAttributeName:font,
                              NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes =dic;
 
    
    self.navigationController.navigationBar.barTintColor = [UIColor baseColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor baseColor]] forBarMetrics:UIBarMetricsDefault];
    
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"Phone_Image"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ic_back_white"] forState:UIControlStateNormal];
    [btn setTitle:@" 返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)touchButton:(UIButton *)sender{
    sender.enabled = NO;
    NSMutableString * string = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.model.data.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
 });
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
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

    CGSize size = [self.titleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-60, MAXFLOAT)];//根据文字的长度返回一个最佳宽度和高度
    if (size.height<20) {
        size.height = 20;
    }

    self.titleLabel.frame = CGRectMake(30, 15, SCREEN_WIDTH-100, size.height);
    self.answerview.frame = CGRectMake(0, self.titleLabel.frame.size.height+self.titleLabel.frame.origin.y +15, SCREEN_WIDTH, 1);

    
    [self.alertView layoutSubviews];

    self.answerLabel.text =  [self removeHTML2: [detailModel.data.answer stringByDecodingHTMLEntities] ];
    
}


- (NSString *)removeHTML2:(NSString *)html{
    NSArray *components = [html componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    NSMutableArray *componentsToKeep = [NSMutableArray array];
    for (int i = 0; i < [components count]; i = i + 2) {
        [componentsToKeep addObject:[components objectAtIndex:i]];
    }
    NSString *plainText = [componentsToKeep componentsJoinedByString:@"\n"];
    return plainText;
}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.data.list.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLPCustomerServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:LLPCustomerServiceCellID];
    cell.block = ^{
        [tableView reloadData];
    };
    cell.touchBlock = ^(NSString * _Nonnull string) {
        self.touchText = string;
        [self requestQueryProblemDetail];
    };
    cell.model = self.model.data.list[indexPath.row];

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
        _tableview.backgroundColor = [UIColor colorWithHexString:@"#FFF2F2F2"];
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        titleLabel.numberOfLines = 0;

        self.titleLabel = titleLabel;
        
        UIView *view = [[UIView alloc]init];
        self.answerview = view;
        view.frame = CGRectMake(0, titleLabel.frame.size.height+titleLabel.frame.origin.y +15, SCREEN_WIDTH, 1);
        view.backgroundColor = [UIColor colorWithHexString:@"#EEEEEE"];
        [_alertView addSubview:view];
        
        UITextView *answerLabel = [[UITextView alloc]init];
        [_alertView addSubview:answerLabel];
        [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(view.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
        }];
        answerLabel.editable = NO;
        answerLabel.showsVerticalScrollIndicator = NO;
        answerLabel.font = [UIFont systemFontOfSize:14];
//        answerLabel.numberOfLines = 0;
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


-(NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim
{
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:
        [ NSString stringWithFormat:@"%@>", text] withString:@""];
        
    }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
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
