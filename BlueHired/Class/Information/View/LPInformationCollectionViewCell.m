//
//  LPInformationCollectionViewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPInformationCollectionViewCell.h"
#import "LPEssaylistModel.h"
#import "SDCycleScrollView.h"
#import "LPInformationSingleCell.h"
#import "LPInformationMoreCell.h"
#import "LPEssayDetailVC.h"

static NSString *LPInformationSingleCellID = @"LPInformationSingleCell";
static NSString *LPInformationMoreCellID = @"LPInformationMoreCell";

@interface LPInformationCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic, strong)UITableView *tableview;
@property (nonatomic, assign) NSNumber *labelListModelId;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPEssaylistModel *model;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*listArray;
@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong) NSMutableArray <LPEssaylistDataModel *>*choiceListArray;

@property(nonatomic,assign) NSInteger selectRow;

@end

@implementation LPInformationCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.listArray = [NSMutableArray array];
    self.choiceListArray = [NSMutableArray array];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}


-(void)setLabelListDataModel:(LPLabelListDataModel *)labelListDataModel{
    _labelListDataModel = labelListDataModel;
    self.labelListModelId = labelListDataModel.id;
    self.page = 1;
    [self requestEssaylist];

}
-(void)setModel:(LPEssaylistModel *)model{
    _model = model;
    if ([model.code integerValue] == 0) {
        if (self.page == 1) {
            self.listArray = [NSMutableArray array];
            self.choiceListArray = [NSMutableArray array];
        }
        for (LPEssaylistDataModel *model in self.model.data) {
            if ([model.choiceStatus integerValue] == 1) {
                [self.choiceListArray addObject:model];
            }else{
                [self.listArray addObject:model];
            }
        }
        if (self.choiceListArray.count > 0) {
            self.tableview.tableHeaderView = self.cycleScrollView;
            NSMutableArray *imgArray = [NSMutableArray array];
            NSMutableArray *titleArray = [NSMutableArray array];

            for (LPEssaylistDataModel *model in self.choiceListArray) {
                [imgArray addObject:model.essayUrl];
                [titleArray addObject:model.essayName];
            }
            self.cycleScrollView.imageURLStringsGroup = imgArray;
            self.cycleScrollView.titlesGroup = titleArray;
        }else{
            self.tableview.tableHeaderView = [[UIView alloc]init];
        }
        
        if (self.model.data.count > 0) {
            self.page += 1;
//            [self.listArray addObjectsFromArray:self.model.data];
//            [self.tableview reloadData];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableview reloadData];

    }else{
        [self.contentView showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[];
    if (self.listArray.count > indexPath.row) {
        array = [self.listArray[indexPath.row].essayUrl componentsSeparatedByString:@";"];
    }
    if (array.count ==0) {
        return nil;
    }else if (array.count == 1) {
        LPInformationSingleCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationSingleCellID];
        if(cell == nil){
            cell = [[LPInformationSingleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationSingleCellID];
        }
        cell.model = self.listArray[indexPath.row];
        return cell;
    }else{
        LPInformationMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:LPInformationMoreCellID];
        if(cell == nil){
            cell = [[LPInformationMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPInformationMoreCellID];
        }
        cell.model = self.listArray[indexPath.row];
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.essaylistDataModel = self.listArray[indexPath.row];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[LPInformationSingleCell class]]) {
            LPInformationSingleCell *c = (LPInformationSingleCell *)cell;
            c.viewLabel.text = [NSString stringWithFormat:@"%ld",[c.viewLabel.text integerValue] + 1];
        }else if ([cell isKindOfClass:[LPInformationMoreCell class]]) {
            LPInformationMoreCell *c = (LPInformationMoreCell *)cell;
            c.viewLabel.text = [NSString stringWithFormat:@"%ld",[c.viewLabel.text integerValue] + 1];
        }
    });
    
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    NSLog(@"---点击了第%ld张图片", (long)index);
    LPEssayDetailVC *vc = [[LPEssayDetailVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.essaylistDataModel = self.choiceListArray[index];
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}
#pragma mark - request
-(void)requestEssaylist{
    NSDictionary *dic = @{
                          @"labelId":self.labelListModelId,
                          @"page":@(self.page)
                          };
    [NetApiManager requestEssaylistWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];
        if (isSuccess) {
            self.model = [LPEssaylistModel mj_objectWithKeyValues:responseObject];
        }else{
            [[UIWindow visibleViewController].view showLoadingMeg:@"网络错误" time:MESSAGE_SHOW_TIME];
        }
    }];
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
        [_tableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        [_tableview registerNib:[UINib nibWithNibName:LPInformationMoreCellID bundle:nil] forCellReuseIdentifier:LPInformationMoreCellID];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestEssaylist];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestEssaylist];
        }];
    }
    return _tableview;
}
-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) delegate:self placeholderImage:nil];
        _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    }
    return _cycleScrollView;
}
@end
