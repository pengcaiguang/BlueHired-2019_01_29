//
//  LPAddRecordCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPAddRecordCell.h"
#import "LPSubsidyDeductionVC.h"

@interface LPAddRecordCell ()

@property(nonatomic,strong) UIView *textView;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@property(nonatomic,strong) NSMutableArray <UITextField *>*textFieldArray;
@property(nonatomic,strong) UIButton *addButton;

@end

@implementation LPAddRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelArray = [NSMutableArray array];
    self.textFieldArray = [NSMutableArray array];

    [self addTextView:48 bottom:48*2];
    [self addTextView:96 bottom:48];
    
    [self addBottomButton];
}


-(void)addTextView:(CGFloat)top bottom:(CGFloat)bottom{
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(top);
        make.height.mas_equalTo(48);
        make.bottom.mas_equalTo(-bottom);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.centerY.equalTo(view);
    }];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"社保扣款";
    [self.labelArray addObject:label];
//    label.backgroundColor = [UIColor greenColor];
    
    UITextField *textField = [[UITextField alloc]init];
    [view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(14);
        make.centerY.equalTo(view);
        make.right.mas_equalTo(-14);
        make.height.mas_equalTo(34);
    }];
    textField.layer.borderColor = [UIColor colorWithHexString:@"#AAAAAA"].CGColor;
    textField.layer.borderWidth = 0.5;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 2.0;
    [self.textFieldArray addObject:textField];
//    textField.backgroundColor = [UIColor redColor];
    
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

-(void)addBottomButton{
    UIButton *button = [[UIButton alloc]init];
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.mas_equalTo(-14);
        make.height.mas_equalTo(30);
    }];
    [button setImage:[UIImage imageNamed:@"addItem"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(addItem) forControlEvents:UIControlEventTouchUpInside];
    self.addButton = button;
}
-(void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 3) {
        self.imgView.image = [UIImage imageNamed:@"add_subsidies_record"];
        self.addTextLabel.text = @"添加补贴记录";
        [self.addButton setTitle:@"添加补贴记录" forState:UIControlStateNormal];
        
        self.textArray = @[@"全勤绩效：",@"车费补贴："];
        for (int i = 0; i<self.textArray.count; i++) {
            self.labelArray[i].text = self.textArray[i];
        }
    }else if (index == 4) {
        self.imgView.image = [UIImage imageNamed:@"add_deductions_record"];
        self.addTextLabel.text = @"添加扣款记录";
        [self.addButton setTitle:@"添加扣款记录" forState:UIControlStateNormal];

        self.textArray = @[@"社保扣款：",@"请假扣款："];
        for (int i = 0; i<self.textArray.count; i++) {
            self.labelArray[i].text = self.textArray[i];
        }
    }
}

-(void)addItem{
    NSLog(@"addItem");
    LPSubsidyDeductionVC *vc = [[LPSubsidyDeductionVC alloc]init];
    if (self.index == 3) {
        vc.type = 1;
    }else{
        vc.type = 2;
    }
    [[UIWindow visibleViewController].navigationController pushViewController:vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
