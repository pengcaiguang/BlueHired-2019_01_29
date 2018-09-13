//
//  LPSubsidyDeductionVC.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSubsidyDeductionVC.h"
#import "LPSubsidyDeductionCell.h"

static NSString *LPSubsidyDeductionCellID = @"LPSubsidyDeductionCell";

@interface LPSubsidyDeductionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,assign) NSInteger selectIndex;

@end

@implementation LPSubsidyDeductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type == 1) {
        self.navigationItem.title = @"添加补贴记录";
    }else{
        self.navigationItem.title = @"添加扣款记录";
    }
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
        make.top.mas_equalTo(0);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    if (self.type == 1) {
        [button setTitle:@"自定义补贴记录" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"自定义扣款记录" forState:UIControlStateNormal];
    }
    [button setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setImage:[UIImage imageNamed:@"addItem"] forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -button.imageView.frame.size.width - button.titleLabel.intrinsicContentSize.width + 80, 0, 0);
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -button.titleLabel.intrinsicContentSize.width -button.imageView.frame.size.width-80);
    [button addTarget:self action:@selector(touchBottomButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(touchSave)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)touchSave{
    NSLog(@"touchSave");
}
-(void)touchBottomButton{
    NSLog(@"touchBottomButton");
    GJAlertText *alert = [[GJAlertText alloc]initWithTitle:@"自定义补贴记录" message:@"请输入补贴类型" buttonTitles:@[@"取消",@"确定"] buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]] buttonClick:^(NSInteger buttonIndex, NSString *string) {
        NSLog(@"-%@",string);
    }];
    [alert show];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSubsidyDeductionCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSubsidyDeductionCellID];
    if (indexPath.row == self.selectIndex) {
        cell.selectButton.selected = YES;
    }else{
        cell.selectButton.selected = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndex = indexPath.row;
    [tableView reloadData];
    
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
        [_tableview registerNib:[UINib nibWithNibName:LPSubsidyDeductionCellID bundle:nil] forCellReuseIdentifier:LPSubsidyDeductionCellID];
        
    }
    return _tableview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
