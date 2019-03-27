//
//  LPEntryScreenView.m
//  BlueHired
//
//  Created by iMac on 2018/10/27.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPEntryScreenView.h"

@interface LPEntryScreenView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *tableBgView;
@property(nonatomic,strong) NSArray *titleArray;
@property(nonatomic,copy) NSString *selectTitle;
@end

@implementation LPEntryScreenView
-(instancetype)init{
    self = [super init];
    if (self) {
        self.titleArray = @[@"全部",@"面试未处理",@"面试已处理",@"一人多号"];
        self.selectTitle = @"全部";
        self.userInteractionEnabled = YES;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.tableBgView];
    }
    return self;
}


-(void)setHidden:(BOOL)hidden{
    self.bgView.hidden = hidden;
    //    self.tableview.hidden = hidden;
    self.touchButton.selected = !hidden;
    
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.tableBgView.frame = CGRectMake(0, kNavBarHeight+48+40, SCREEN_WIDTH,0);
            self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
        }];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.tableBgView.frame = CGRectMake(0, kNavBarHeight+48+40, SCREEN_WIDTH, 44 *4);
            self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44
                                          *4);

        }];
    }
}


-(void)hiddens{
    self.hidden = YES;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    self.selectTitle = self.titleArray[indexPath.row];
    
    [self.tableview reloadData];
    if ([self.delegate respondsToSelector:@selector(touchTableView:)]) {
        [self.delegate touchTableView:indexPath.row];
        [self hiddens];
    }
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44
                                      *4);
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 44;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableview;
}
-(UIView *)tableBgView{
    if (!_tableBgView) {
        _tableBgView = [[UIView alloc]init];
        _tableBgView.frame = CGRectMake(0, 20+44+48+40, SCREEN_WIDTH, 0);
        _tableBgView.backgroundColor = [UIColor whiteColor];
        [_tableBgView addSubview:self.tableview];
        
    }
    return _tableBgView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20+44+48+40+44*4, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.1;
        _bgView.hidden = YES;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddens)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}


@end
