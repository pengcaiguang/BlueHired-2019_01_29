//
//  LPRecruitRequirePvwVC.m
//  BlueHired
//
//  Created by iMac on 2018/10/26.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitRequirePvwVC.h"
#import "LPWorkDetailTextCell.h"
#import "LPRecruitmentVC.h"

static NSString *LPWorkDetailTextCellID = @"LPWorkDetailTextCell";

@interface LPRecruitRequirePvwVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *textArray;
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic,strong) UIButton *senderBt;
@end

@implementation LPRecruitRequirePvwVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textArray = @[@"入职要求",@"薪资福利",@"住宿餐饮",@"工作时间",@"面试材料",@"其他说明"];
    self.navigationItem.title = @"招聘要求预览";
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.edges.equalTo(self.view);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(-58);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-58);
        } else {
            make.bottom.mas_equalTo(-58);
        }
    }];
    
    UIButton *bt = [[UIButton alloc] init];
    bt.layer.cornerRadius = 10;
    bt.backgroundColor = [UIColor baseColor];
    [bt addTarget:self action:@selector(touchSenderbt:) forControlEvents:UIControlEventTouchUpInside];
    [bt setTitle:@"保存" forState:UIControlStateNormal];
    [bt setTintColor:[UIColor whiteColor]];
    [self.view addSubview:bt];
    self.senderBt = bt;
    [self.senderBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableview.mas_bottom).offset(0);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
//        make.bottom.mas_equalTo(-20);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.mas_equalTo(-10);
        }
        
    }];
    
}

-(void)touchSenderbt:(UIButton *)sender
{
    LPRecruitmentVC  *vc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    vc.dataList = _model;
    vc.isBack = YES;
    vc.ModelID = _model.id.integerValue;
    [self.navigationController popToViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPWorkDetailTextCell *cell = [tableView dequeueReusableCellWithIdentifier:LPWorkDetailTextCellID];
    cell.detailTitleLabel.text = self.textArray[indexPath.row];
    if (indexPath.row == 0) {
        NSString *string= [LPTools isNullToString:_model.workDemand];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }else if (indexPath.row == 1){
        NSString *string= [LPTools isNullToString:_model.workSalary];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }else if (indexPath.row == 2){
        NSString *string= [LPTools isNullToString:_model.eatSleep];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }else if (indexPath.row == 3){
        NSString *string= [LPTools isNullToString:_model.workTime];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }else if (indexPath.row == 4){
        NSString *string= [LPTools isNullToString:_model.workKnow];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }else if (indexPath.row == 5){
        NSString *string= [LPTools isNullToString:_model.remarks];
        string = [string stringByReplacingOccurrencesOfString:@"<br>"withString:@"\n"];
        cell.detailLabel.text = string;
    }
    
    return cell;
}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 100;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPWorkDetailTextCellID bundle:nil] forCellReuseIdentifier:LPWorkDetailTextCellID];
        
    }
    return _tableview;
}

- (void)setModel:(LPWork_ListDataModel *)model
{
    _model = model;
 
     NSString *Type = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.workDemand] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type = [NSString stringWithFormat:@"%@%@<br>",Type,string];
        }
    }
    _model.workDemand =Type;
    
    
    
    NSString *Type1 = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.workSalary] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type1 = [NSString stringWithFormat:@"%@%@<br>",Type1,string];
        }
    }
    _model.workSalary =Type1;
    
    
    
    NSString *Type2 = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.eatSleep] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type2 = [NSString stringWithFormat:@"%@%@<br>",Type2,string];
        }
    }
    _model.eatSleep =Type2;

    
    
    NSString *Type3 = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.workTime] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type3 = [NSString stringWithFormat:@"%@%@<br>",Type3,string];
        }
    }
    _model.workTime =Type3;
    
    
    
    NSString *Type4 = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.workKnow] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type4 = [NSString stringWithFormat:@"%@%@<br>",Type4,string];
        }
    }
    _model.workKnow =Type4;
    
    
    
    NSString *Type5 = @"";
    for (NSString *string in [[[LPTools isNullToString:_model.remarks] componentsSeparatedByString:@"<br>"] mutableCopy]) {
        if (![string isEqualToString:@""]) {
            Type5 = [NSString stringWithFormat:@"%@%@<br>",Type5,string];
        }
    }
    _model.remarks =Type5;
}



@end
