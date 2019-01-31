//
//  LPScreenAlertView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/31.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPScreenAlertView.h"

@interface LPScreenAlertView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableview;
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIView *tableBgView;

@property(nonatomic,strong) NSArray *titleArray;

@property(nonatomic,strong) NSMutableArray *buttonArray;
@property(nonatomic,strong) NSMutableArray *buttonHangyeArray;
@property(nonatomic,strong) NSMutableArray *buttonGongzhongArray;



@end

@implementation LPScreenAlertView

-(instancetype)init{
    self = [super init];
    if (self) {
        self.titleArray = @[@"综合工资最高",@"报名人数最多",@"企业评分最高",@"工价最高",@"可借支"];
        self.userInteractionEnabled = YES;
        self.buttonHangyeArray = [NSMutableArray array];
        self.buttonGongzhongArray = [NSMutableArray array];
        [[UIApplication sharedApplication].keyWindow addSubview:self.bgView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.tableBgView];
    }
    return self;
}
-(void)setTouchButton:(UIButton *)touchButton{
    _touchButton = touchButton;
}

-(void)setMechanismlistModel:(LPMechanismlistModel *)mechanismlistModel{
    _mechanismlistModel = mechanismlistModel;
    
    CGFloat hangyex = 34;
    UILabel *hangyeLabel = [[UILabel alloc]init];
    [self.tableBgView addSubview:hangyeLabel];
    [hangyeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(hangyex);
        
    }];
    hangyeLabel.text = @"行业筛选";
    hangyeLabel.font = [UIFont systemFontOfSize:14];
    
    CGFloat w = (SCREEN_WIDTH/3*2-10*6)/3;
    for (int i = 0; i < mechanismlistModel.data.mechanismTypeList.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(i%3 * w + (10*(2*(i%3)+1)), floor(i/3)*40 + hangyex + 35, w, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [btn setTitle:mechanismlistModel.data.mechanismTypeList[i].mechanismTypeName forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.tag = mechanismlistModel.data.mechanismTypeList[i].id.integerValue;
        [btn addTarget:self action:@selector(touchHangyeButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableBgView addSubview:btn];
        [self.buttonHangyeArray addObject:btn];
    }
    
    CGFloat gongzhongx = floor(mechanismlistModel.data.mechanismTypeList.count/3)*40 + hangyex + 35 + 30;
    
    UILabel *gongzhongLabel = [[UILabel alloc]init];
    [self.tableBgView addSubview:gongzhongLabel];
    [gongzhongLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.top.mas_equalTo(gongzhongx);
        
    }];
    gongzhongLabel.text = @"工种筛选";
    gongzhongLabel.font = [UIFont systemFontOfSize:14];
    
//    CGFloat w = (SCREEN_WIDTH/3*2-10*6)/3;
    NSArray *gongzhong = @[@"小时工",@"正式工"];
    for (int i = 0; i < gongzhong.count; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(i%3 * w + (10*(2*(i%3)+1)), floor(i/3)*40 + gongzhongx + 35, w, 30);
        btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor colorWithHexString:@"#434343"] forState:UIControlStateNormal];
        [btn setTitle:gongzhong[i] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 15;
        btn.tag = i;
        [btn addTarget:self action:@selector(touchGongzhongButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.tableBgView addSubview:btn];
        [self.buttonGongzhongArray addObject:btn];
    }
    
}

-(void)touchHangyeButton:(UIButton *)button{
    for (UIButton *btn in self.buttonHangyeArray) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
    }
    button.backgroundColor = [UIColor colorWithHexString:@"#E8F6FF"];
    button.layer.borderColor = [UIColor baseColor].CGColor;
    button.layer.borderWidth = 0.5;
    
    self.typeId = [NSString stringWithFormat:@"%ld",(long)button.tag];
    self.SuperView.mechanismTypeId = self.typeId;
}
-(void)touchGongzhongButton:(UIButton *)button{
    for (UIButton *btn in self.buttonGongzhongArray) {
        btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
        btn.layer.borderColor = [UIColor whiteColor].CGColor;
        btn.layer.borderWidth = 0.5;
    }
    button.backgroundColor = [UIColor colorWithHexString:@"#E8F6FF"];
    button.layer.borderColor = [UIColor baseColor].CGColor;
    button.layer.borderWidth = 0.5;
    switch (button.tag) {
        case 0:
            self.workType = @"1";
            break;
        case 1:
            self.workType = @"0";
            break;
        default:
            break;
    }
    self.SuperView.workType = self.workType;
}

-(void)setHidden:(BOOL)hidden{
    self.bgView.hidden = hidden;
//    self.tableview.hidden = hidden;
    self.touchButton.selected = !hidden;
    
    
    if (hidden) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0;
            self.tableBgView.frame = CGRectMake(SCREEN_WIDTH, 20, SCREEN_WIDTH/3*2, SCREEN_HEIGHT-69);
        }];
    }else{
        if (self.typeId) {
            for (UIButton *btn in self.buttonHangyeArray) {
                btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.layer.borderWidth = 0.5;
                if (btn.tag == [self.typeId integerValue]) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"#E8F6FF"];
                    btn.layer.borderColor = [UIColor baseColor].CGColor;
                }
            }
        }

        if (self.workType) {
                        NSInteger *bttag = 0;
            switch (self.workType.integerValue) {
                case 0:
                    bttag = 1;
                    break;
                case 1:
                    bttag = 0;
                    break;
                default:
                    break;
            }

            for (UIButton *btn in self.buttonGongzhongArray) {
                btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
                btn.layer.borderColor = [UIColor whiteColor].CGColor;
                btn.layer.borderWidth = 0.5;
                if (btn.tag == bttag) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"#E8F6FF"];
                    btn.layer.borderColor = [UIColor baseColor].CGColor;
                }
            }
            

        }

        
        [UIView animateWithDuration:0.3 animations:^{
            self.bgView.alpha = 0.5;
            self.tableBgView.frame = CGRectMake(SCREEN_WIDTH/3, 20, SCREEN_WIDTH/3*2, SCREEN_HEIGHT-69);
        }];
    }
}
-(void)hidden{
    self.hidden = YES;
//    self.bgView.hidden = YES;
//    self.tableview.hidden = YES;
//    self.touchButton.selected = NO;
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
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([self.delegate respondsToSelector:@selector(touchTableView:)]) {
//        [self.delegate touchTableView:indexPath.row];
//        [self hidden];
//    }
}

-(void)touchBottomButton:(UIButton *)button{
    if (button.tag == 0) {
        self.typeId = nil;
        self.workType = nil;
        self.SuperView.mechanismTypeId = nil;
        self.SuperView.workType = nil;
        for (UIButton *btn in self.buttonHangyeArray) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.borderWidth = 0.5;
        }
        for (UIButton *btn in self.buttonGongzhongArray) {
            btn.backgroundColor = [UIColor colorWithHexString:@"#EBEBEB"];
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.layer.borderWidth = 0.5;
        }
    }else{
        [self hidden];
        if ([self.delegate respondsToSelector:@selector(selectMechanismTypeId:workType:)]) {
            [self.delegate selectMechanismTypeId:self.typeId workType:self.workType];
        }
    }
}
#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]init];
        _tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH/3*2, SCREEN_HEIGHT-49);
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
        _tableBgView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH/3*2, SCREEN_HEIGHT);
        _tableBgView.backgroundColor = [UIColor whiteColor];
//        [_tableBgView addSubview:self.tableview];
        
        self.buttonArray = [NSMutableArray array];
        NSArray *titleArray = @[@"重置",@"确定"];
        for (int i =0; i<titleArray.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            [_tableBgView addSubview:button];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(touchBottomButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.buttonArray addObject:button];
            if (i == 0) {
                button.backgroundColor = [UIColor whiteColor];
                [button setTitleColor:[UIColor colorWithHexString:@"#939393"] forState:UIControlStateNormal];
            }else{
                button.backgroundColor = [UIColor baseColor];
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        [self.buttonArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
        [self.buttonArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(49);
        }];
    }
    return _tableBgView;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 69)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.1;
        _bgView.hidden = YES;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidden)];
        [_bgView addGestureRecognizer:tap];
        
    }
    return _bgView;
}

@end
