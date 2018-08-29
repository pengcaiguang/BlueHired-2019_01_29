//
//  LPCircleCollectionViewCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/29.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPCircleCollectionViewCell.h"
#import "LPMoodTypeModel.h"

@interface LPCircleCollectionViewCell ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *tableHeaderView;
@property(nonatomic,assign) NSInteger page;

@property(nonatomic,strong) LPMoodTypeModel *moodTypeModel;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@end

@implementation LPCircleCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.page = 1;
    self.labelArray = [NSMutableArray array];
    
    [self.contentView addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}
#pragma mark - setdata
-(void)setIndex:(NSInteger)index{
    if (index == 0) {
        [self requestMoodType];
    }
}


-(void)setMoodTypeModel:(LPMoodTypeModel *)moodTypeModel{
    _moodTypeModel = moodTypeModel;
    if (moodTypeModel.data.count > 0 ) {
        self.tableview.tableHeaderView = self.tableHeaderView;
        self.tableHeaderView.clipsToBounds = YES;
        
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
            self.labelArray[0].textColor = [UIColor baseColor];
        }
    }
}
-(void)touchMoodType:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    for (UILabel *label in self.labelArray) {
        label.textColor = [UIColor blackColor];
    }
    self.labelArray[index].textColor = [UIColor baseColor];
}

-(void)touchExpandButton:(UIButton *)button{
    button.selected = !button.isSelected;
    if (button.selected) {
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
    }else{
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
    }
    [self.tableview reloadData];
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.backgroundColor = randomColor;
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
//        [_tableview registerNib:[UINib nibWithNibName:LPInformationSingleCellID bundle:nil] forCellReuseIdentifier:LPInformationSingleCellID];
        
        _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 1;
            [self.tableview.mj_header endRefreshing];
//            [self requestMoodType];
        }];
        _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//            [self requestMoodType];
            [self.tableview.mj_footer endRefreshing];

        }];
    }
    return _tableview;
}
-(UIView *)tableHeaderView{
    if (!_tableHeaderView){
        _tableHeaderView = [[UIView alloc]init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 110);
        
        UIButton *expandbutton = [[UIButton alloc]init];
        [_tableHeaderView addSubview:expandbutton];
        [expandbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        [expandbutton setTitle:@"点击展开" forState:UIControlStateNormal];
        [expandbutton setTitle:@"点击收起" forState:UIControlStateSelected];
        [expandbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [expandbutton setImage:[UIImage imageNamed:@"expand_img"] forState:UIControlStateNormal];
        [expandbutton setImage:[UIImage imageNamed:@"shrinkage_img"] forState:UIControlStateSelected];
        expandbutton.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
        expandbutton.titleLabel.font = [UIFont systemFontOfSize:10];
        [expandbutton addTarget:self action:@selector(touchExpandButton:) forControlEvents:UIControlEventTouchUpInside];
        expandbutton.titleEdgeInsets = UIEdgeInsetsMake(0, -expandbutton.imageView.frame.size.width - expandbutton.titleLabel.intrinsicContentSize.width-5, 0, 0);
        expandbutton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -expandbutton.titleLabel.intrinsicContentSize.width -expandbutton.imageView.frame.size.width-5);
        
    }
    return _tableHeaderView;
}
@end
