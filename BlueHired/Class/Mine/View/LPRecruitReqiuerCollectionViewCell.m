//
//  LPRecruitReqiuerCollectionViewCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/24.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRecruitReqiuerCollectionViewCell.h"
#import "LPRecruitRequireCell.h"
#import "LPRecruitRequirePvwVC.h"


static NSString *LPInformationMoreCellID = @"LPRecruitRequireCell";


@interface LPRecruitReqiuerCollectionViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
//@property (nonatomic, strong)NSMutableArray *TypeArr;
@property (nonatomic,strong) NSMutableArray *ListArr;

@property (nonatomic,strong) NSArray *HintList;
@property (nonatomic,strong) UIButton *senderBt;

@end
@implementation LPRecruitReqiuerCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    self.ListArr = [[NSMutableArray alloc] init];
//    self.TypeArr = [[NSMutableArray alloc] init];
 
    self.HintList = @[@"请输入入职要求",@"请输入薪资福利",@"请输入住宿餐饮",@"请输入工作时间",@"请输入面试材料",@"请输入其他说明"];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);

    }];
    
 
}



#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _ListArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPRecruitRequireCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationMoreCellID];
    if(cell == nil){
        cell = [[LPRecruitRequireCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationMoreCellID];
    }
    
    cell.Type = self.type;
    cell.row = indexPath.row;
    
    if (indexPath.row+1 == _ListArr.count) {
        cell.textView.hidden = YES;
        cell.addRow.hidden = NO;
    }
    else
    {
        cell.textView.hidden = NO;
        cell.addRow.hidden = YES;
        NSString *str = [[_ListArr objectAtIndex:indexPath.row] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if ([str isEqualToString:@""]) {
            cell.textView.textColor = [UIColor lightGrayColor];
            cell.textView.text = [NSString stringWithFormat:@"%ld、%@",(long)indexPath.row+1,self.HintList[
                                  _type]];
        }else {
            cell.textView.text =str;
            cell.textView.textColor = [UIColor blackColor];
        }
        
        WEAK_SELF()
        cell.Block = ^(NSString *dic) {
//            weakSelf.
            NSMutableArray *arr = [weakSelf.ListArr mutableCopy];
            [arr removeObjectAtIndex:indexPath.row];
            [arr insertObject:dic atIndex:indexPath.row];
            weakSelf.ListArr =[arr mutableCopy];
//            [weakSelf.TypeArr removeObjectAtIndex:weakSelf.type];
//            [weakSelf.TypeArr insertObject:[arr componentsJoinedByString:@"<br>"] atIndex:weakSelf.type];
            if (self.BlockSuper) {
                self.BlockSuper([arr componentsJoinedByString:@"<br>"],self.type);
                weakSelf.content = [arr componentsJoinedByString:@"<br>"];
            }
        };
    }
     return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row+1 == _ListArr.count) {
        
         self.content = [NSString stringWithFormat:@"%@<br>",self.content];
         if (self.BlockSuper) {
            self.BlockSuper(self.content,self.type);
        }
        
        [self setType:_type];
        [self.tableview reloadData];
    }
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
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];

    }
    return _tableview;
}
//-(void)setModel:(LPWork_ListDataModel *)model
//{
//    _model = model;
//    [_TypeArr removeAllObjects];
//    [_TypeArr addObject:[LPTools isNullToString:_model.workDemand]];
//    [_TypeArr addObject:[LPTools isNullToString:_model.workSalary]];
//    [_TypeArr addObject:[LPTools isNullToString:_model.eatSleep]];
//    [_TypeArr addObject:[LPTools isNullToString:_model.workTime]];
//    [_TypeArr addObject:[LPTools isNullToString:_model.workKnow]];
//    [_TypeArr addObject:[LPTools isNullToString:_model.remarks]];
//
//
//}

-(void)setType:(NSInteger)type
{
    _type = type;
    _ListArr = [[self.content componentsSeparatedByString:@"<br>"] copy];
    
    if (_ListArr.count == 0 ||!_ListArr) {
        _ListArr = [[NSMutableArray alloc] init];
        [_ListArr addObject:@""];
    }
    [self.tableview reloadData];
}

@end
