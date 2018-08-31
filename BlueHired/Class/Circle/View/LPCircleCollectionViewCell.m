//
//  LPCircleCollectionViewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleCollectionViewCell.h"
#import "LPMoodTypeModel.h"
#import "LPMoodListModel.h"
#import "LPCircleListCell.h"

static NSString *LPCircleListCellID = @"LPCircleListCell";

@interface LPCircleCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,strong) UIButton *expandbutton;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPMoodTypeModel *moodTypeModel;
@property(nonatomic,strong) LPMoodTypeDataModel *selectMoodTypeDataModel;

@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;

@property(nonatomic,strong) LPMoodListModel *moodListModel;
@property(nonatomic,strong) NSMutableArray <LPMoodListDataModel *>*moodListArray;

@end

@implementation LPCircleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.labelArray = [NSMutableArray array];
    self.moodListArray = [NSMutableArray array];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
#pragma mark - setdata
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 0) {
        [self requestMoodType];
    }
    [self requestMoodList];
}


-(void)setMoodTypeModel:(LPMoodTypeModel *)moodTypeModel{
    if (_moodTypeModel) {
        if ([_moodTypeModel.mj_keyValues isEqual:moodTypeModel.mj_keyValues]) {
            return;
        }
    }
    _moodTypeModel = moodTypeModel;
    if (moodTypeModel.data.count > 0 ) {
        self.tableview.tableHeaderView = self.tableHeaderView;
        self.tableHeaderView.clipsToBounds = YES;
        if (moodTypeModel.data.count > 4) {
            [self.tableHeaderView addSubview:self.expandbutton];
            [self.expandbutton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
        }
        
        CGFloat space = (SCREEN_WIDTH-37*4)/8;
        for (int i = 0; i<moodTypeModel.data.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.frame = CGRectMake(i%4 * 37 + (space*(2*(i%4)+1)), floor(i/4)*80 + 20, 37, 37);
            [imgView sd_setImageWithURL:[NSURL URLWithString:moodTypeModel.data[i].labelUrl]];
            [self.tableHeaderView addSubview:imgView];
            [self.tableHeaderView insertSubview:imgView atIndex:0];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMoodType:)];
            imgView.tag = i;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:tap];
            
            UILabel *label = [[UILabel alloc]init];
            label.frame = CGRectMake(i%4 * SCREEN_WIDTH/4, CGRectGetMaxY(imgView.frame)+5, SCREEN_WIDTH/4, 15);
            label.text = moodTypeModel.data[i].labelName;
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:12];
            [self.tableHeaderView addSubview:label];
            [self.tableHeaderView insertSubview:label atIndex:0];
            [self.labelArray addObject:label];
        }
        self.labelArray[0].textColor = [UIColor baseColor];
        self.selectMoodTypeDataModel = moodTypeModel.data[0];

    }
}

-(void)setMoodListModel:(LPMoodListModel *)moodListModel{
    _moodListModel = moodListModel;
    if ([moodListModel.code integerValue] == 0) {
        if (self.page == 1) {
            self.moodListArray = [NSMutableArray array];
        }
        if (moodListModel.data.count > 0) {
            self.page += 1;
            [self.moodListArray addObjectsFromArray:moodListModel.data];
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
        }
        [self.tableview reloadData];
    }else{
        [self.contentView showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}

-(void)touchMoodType:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor blackColor];
    }
    self.labelArray[index].textColor = [UIColor baseColor];
    self.selectMoodTypeDataModel = self.moodTypeModel.data[index];
    self.page = 1;
    [self requestMoodList];
}

-(void)touchExpandButton:(UIButton *)button{
    button.selected = !button.isSelected;
    if (button.selected) {
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110 + floor(self.moodTypeModel.data.count/4)*80);
    }else{
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
    }
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.moodListArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LPCircleListCell *cell = [tableView dequeueReusableCellWithIdentifier:LPCircleListCellID];
    if(cell == nil){
        cell = [[LPCircleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPCircleListCellID];
    }
    cell.model = self.moodListArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - request
-(void)requestMoodType{
    [NetApiManager requestMoodTypeWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        self.moodTypeModel = [LPMoodTypeModel mj_objectWithKeyValues:responseObject];
    }];
}

-(void)requestMoodList{
    NSInteger type = 0;
    switch (self.index) {
        case 0:
            type = 0;
            break;
        case 1:
            type = 2;
            break;
            
        case 2:
            type = 1;
            break;
            
        default:
            break;
    }
    NSDictionary *dic = @{
                          @"moodTypeId":self.selectMoodTypeDataModel.id ? self.selectMoodTypeDataModel.id : @"",
                          @"page":@(self.page),
                          @"type":@(type)
                          };
    [NetApiManager requestMoodListWithParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.tableview.mj_header endRefreshing];
        [self.tableview.mj_footer endRefreshing];

        self.moodListModel = [LPMoodListModel mj_objectWithKeyValues:responseObject];
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
        [_tableview registerNib:[UINib nibWithNibName:LPCircleListCellID bundle:nil] forCellReuseIdentifier:LPCircleListCellID];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self requestMoodList];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self requestMoodList];

        }];
    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView){
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        
        
        
    }
    return _tableHeaderView;
}
-(UIButton *)expandbutton{
    if (!_expandbutton) {
        _expandbutton = [[UIButton alloc]init];
        [_expandbutton setTitle:@"点击展开" forState:UIControlStateNormal];
        [_expandbutton setTitle:@"点击收起" forState:UIControlStateSelected];
        [_expandbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_expandbutton setImage:[UIImage imageNamed:@"expand_img"] forState:UIControlStateNormal];
        [_expandbutton setImage:[UIImage imageNamed:@"shrinkage_img"] forState:UIControlStateSelected];
        _expandbutton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        _expandbutton.titleLabel.font = [UIFont systemFontOfSize:10];
        [_expandbutton addTarget:self action:@selector(touchExpandButton:) forControlEvents:UIControlEventTouchUpInside];
        _expandbutton.titleEdgeInsets = UIEdgeInsetsMake(0, -_expandbutton.imageView.frame.size.width - _expandbutton.titleLabel.intrinsicContentSize.width + 10, 0, 0);
        _expandbutton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -_expandbutton.titleLabel.intrinsicContentSize.width -_expandbutton.imageView.frame.size.width-30);
    }
    return _expandbutton;
    
}
@end
