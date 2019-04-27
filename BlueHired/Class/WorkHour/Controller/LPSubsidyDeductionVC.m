//
//  LPSubsidyDeductionVC.m
//  BlueHired
//
//  Created by peng on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSubsidyDeductionVC.h"
#import "LPSubsidyDeductionCell.h"

static NSString *LPSubsidyDeductionCellID = @"LPSubsidyDeductionCell";

@interface LPSubsidyDeductionVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;

@property(nonatomic,strong) NSString *selectString;

@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,strong) NSMutableArray *selectTitleArray;

@end

@implementation LPSubsidyDeductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type == 1) {
        self.navigationItem.title = @"选择补贴类型";
        self.titleArray = @[@"早班补贴",@"中班补贴",@"晚班补贴",@"白班补贴",
                            @"夜班补贴",@"全勤补贴",@"绩效补贴",@"高温补贴",
                            @"餐费补贴",@"外宿补贴",@"管理津贴",@"车费补贴",
                            @"叉车补贴",@"岗位补贴",@"其他补贴"];
        
    }else{
        self.navigationItem.title = @"选择扣款类型";
        self.titleArray = @[@"水电费扣款",@"住宿费扣款",@"体检费扣款",@"其他扣款"];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.titleArray];
    for (NSString *string in self.selectArray) {
        if (![self.titleArray containsObject:string]) {
            [arr addObject:string];
        }
        self.titleArray = [arr copy];
    }
    self.selectTitleArray = [NSMutableArray arrayWithArray:self.selectArray];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-48);
        } else {
            make.bottom.mas_equalTo(-48);
        }
        make.top.mas_equalTo(0);
    }];
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.mas_equalTo(0);
        }
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
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(touchSave)];
//    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithHexString:@"#1B1B1B"]];
}
-(void)touchSave{
    if (self.block) {
//        self.block(self.selectTitleArray);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchBottomButton{
        
    GJAlertText *alert = [[GJAlertText alloc]initWithTitle:self.type==1?@"自定义补贴记录":@"自定义扣款记录"
                                                   message:self.type==1?@"请输入补贴类型":@"请输入扣款类型"
                                              buttonTitles:@[@"取消",@"确定"]
                                              buttonsColor:@[[UIColor colorWithHexString:@"#666666"],[UIColor baseColor]]
                                                 MaxLength:8
                                                  NilTitel:self.type==1?@"请输入补贴类型":@"请输入扣款类型"
                                               buttonClick:^(NSInteger buttonIndex, NSString *string) {
                                                   
                                                   if (buttonIndex) {
                                                       NSMutableArray *array = [NSMutableArray arrayWithArray:self.titleArray];
                                                       string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
                                                       string = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
                                                       string = [string stringByReplacingOccurrencesOfString:@":" withString:@""];
                                                       
                                                       if (string.length >8)
                                                       {
                                                           [self.view showLoadingMeg:@"字数不能大于8，请重新输入" time:MESSAGE_SHOW_TIME];
                                                           return ;
                                                       }
                                                       
                                                       if (string) {
                                                           if (![array containsObject:string]) {
                                                               [array addObject:string];
                                                               self.titleArray = [array copy];
                                                               [self.selectTitleArray addObject:string];
                                                               [self.tableview reloadData];
                                                               
                                                               BOOL IsBaoHan = NO;
                                                               for (NSString *str in self.TypeArray) {
                                                                   NSString  *TypeName = [str componentsSeparatedByString:@"-"][0];
                                                                   if ([TypeName isEqualToString:string]) {
                                                                       IsBaoHan = YES;
                                                                       [self.view showLoadingMeg:@"该类型已经存在,请重新选择" time:2.0];
                                                                       break;
                                                                   }
                                                               }
                                                               if (IsBaoHan == NO) {
                                                                   if (self.block) {
                                                                       self.block(string);
                                                                   }
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                               }
                                                               
                                                               
                                                           }else{
                                                               [self.view showLoadingMeg:[NSString stringWithFormat:@"列表中已包含-%@",string] time:MESSAGE_SHOW_TIME];
                                                           }
                                                       }
                                                   }
    }];
    [alert show];
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPSubsidyDeductionCell *cell = [tableView dequeueReusableCellWithIdentifier:LPSubsidyDeductionCellID];
    if ([self.TypeName isEqualToString:self.titleArray[indexPath.row]]) {
        cell.selectButton.selected = YES;
        cell.titleLabel.textColor = [UIColor baseColor];
    }else{
        cell.selectButton.selected = NO;
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    cell.titleLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LPSubsidyDeductionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.selectButton.selected) {
//        [self.selectTitleArray removeObject:self.titleArray[indexPath.row]];
//    }else{
//        [self.selectTitleArray addObject:self.titleArray[indexPath.row]];
//    }
//    [tableView reloadData];
    BOOL IsBaoHan = NO;
    for (NSString *str in self.TypeArray) {
        NSString  *TypeName = [str componentsSeparatedByString:@"-"][0];
        if ([TypeName isEqualToString:self.titleArray[indexPath.row]]) {
            IsBaoHan = YES;
            [self.view showLoadingMeg:@"该类型已经存在,请重新选择" time:2.0];
            break;
        }
    }
    if (IsBaoHan == NO) {
        if (self.block) {
            self.block(self.titleArray[indexPath.row]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
