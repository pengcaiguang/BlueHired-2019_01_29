//
//  LPSortAlertView.m
//  BlueHired
//
//  Created by peng on 2018/8/30.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPSortAlertView.h"


static NSInteger rowHeight = 30;

@interface LPSortAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;

@property(nonatomic,copy) NSString *selectTitle;

@end

@implementation LPSortAlertView

-(instancetype)init{
    self = [super init];
    if (self) {

        self.titleArray = @[@"综合工资最高",@"报名人数最多",@"企业评分最高",@"工价最高",@"可借支"];
        self.selectTitle = @"";

        self.userInteractionEnabled = YES;
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.tableview];
    }
    return self;
}
-(void)setTouchButton:(UIButton *)touchButton{
    _touchButton = touchButton;
}

-(void)setHidden:(BOOL)hidden{
    self.bgView.hidden = hidden;
    self.tableview.hidden = hidden;
    
    UIWindow *window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[self.touchButton convertRect: self.touchButton.bounds toView:window];
    self.tableview.frame = CGRectMake(rect.origin.x, CGRectGetMaxY(rect), rect.size.width, rowHeight*self.titleArray.count);
    self.bgView.frame = CGRectMake(0,0 , SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.tableview reloadData];
}

-(void)hidden{
    self.hidden = YES;
    self.bgView.hidden = YES;
    self.tableview.hidden = YES;
    self.touchButton.selected = NO;
}
#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return rowHeight;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
        UIImageView *imageViews = [[UIImageView alloc] initWithFrame:CGRectMake( SCREEN_WIDTH - 40, 15, 16, 13)];
        imageViews.image = [UIImage imageNamed:@"select_slices"];
        imageViews.contentMode = UIViewContentModeScaleAspectFit;
        imageViews.tag = 100;
        [cell.contentView addSubview:imageViews];
    }
    UIImageView *imageViews = [cell.contentView viewWithTag:100];

    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    cell.contentView.backgroundColor = indexPath.row%2 ? [UIColor colorWithHexString:@"#FFFFFF"] :[UIColor colorWithHexString:@"#F2F2F2"];
    
    if ([cell.textLabel.text isEqualToString:_selectTitle]) {
        cell.textLabel.textColor = [UIColor baseColor];
        imageViews.hidden = NO;
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        imageViews.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.selectTitle = self.titleArray[indexPath.row];
    [self.tableview reloadData];

    if ([self.delegate respondsToSelector:@selector(touchTableView:)]) {
        [self.delegate touchTableView:indexPath.row];
        [self hidden];
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
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.layer.borderWidth = 0.5;
        _tableview.layer.borderColor = [UIColor colorWithHexString:@"#929292"].CGColor;
        
    }
    return _tableview;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}
@end
