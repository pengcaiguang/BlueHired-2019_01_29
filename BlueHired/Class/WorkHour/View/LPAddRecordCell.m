//
//  LPAddRecordCell.m
//  BlueHired
//
//  Created by peng on 2018/9/13.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPAddRecordCell.h"
#import "LPSubsidyDeductionVC.h"

@interface LPAddRecordCell ()<UITextFieldDelegate>

@property(nonatomic,strong) UIView *textView;
@property(nonatomic,strong) NSMutableArray <UILabel *>*labelArray;
@property(nonatomic,strong) NSMutableArray <UITextField *>*textFieldArray;

@property(nonatomic,strong) NSMutableArray *viewArray;
@property(nonatomic,strong) NSMutableDictionary *muDic;

@end

@implementation LPAddRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.labelArray = [NSMutableArray array];
    self.textFieldArray = [NSMutableArray array];
    
    self.muDic = [NSMutableDictionary dictionary];
    
    self.viewArray = [NSMutableArray array];
//    [self addTextView:48 bottom:48*2];
//    [self addTextView:96 bottom:48];
    
    [self addBottomButton];
}


-(void)addTextView:(CGFloat)top tag:(NSInteger)tag{
    UIView *view = [[UIView alloc]init];
    [self.contentView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(top);
        make.height.mas_equalTo(48);
//        make.bottom.mas_equalTo(-bottom);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(90);
        make.centerY.equalTo(view);
    }];
    label.textColor = [UIColor colorWithHexString:@"#666666"];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.numberOfLines = 2;
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
    textField.keyboardType = UIKeyboardTypeDecimalPad;
    textField.textAlignment = NSTextAlignmentLeft;
    [self.textFieldArray addObject:textField];
    textField.tag = tag;
    textField.delegate =self;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [self.viewArray addObject:view];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    //匹配以0开头的数字
    NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
    //匹配两位小数、整数
    NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
    return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7 ? YES : NO;
}


-(void)textFieldChanged:(UITextField *)textField{
    NSLog(@"-%ld - %@",textField.tag ,textField.text);
//    _valueArray[textField.tag-1] = textField.text;
    [self.muDic setObject:textField.text forKey:self.textArray[textField.tag-1]];
    NSLog(@"-%@",self.muDic);
    if (self.dicBlock) {
        self.dicBlock([self.muDic copy]);
    }
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

-(void)setTextArray:(NSArray *)textArray{
    if ([self.textArray isEqualToArray:textArray]) {
        return;
    }
    _textArray = textArray;
    self.view_constraint_height.constant = 48*(textArray.count+1);
    
    for (UIView *view in self.viewArray) {
        [view removeFromSuperview];
    }
    self.labelArray = [NSMutableArray array];
    self.textFieldArray = [NSMutableArray array];
    self.viewArray = [NSMutableArray array];
    
    
    for (int i = 1; i<=self.textArray.count; i++) {
        [self addTextView:48*i tag:i];
    }
    for (int i = 0; i<self.textArray.count; i++) {
        self.labelArray[i].text = [NSString stringWithFormat:@"%@:", self.textArray[i]];
    }
    
    self.view_constraint_height.constant = 48*(self.textArray.count+1);

}

-(void)setValueArray:(NSMutableArray *)valueArray
{
    _valueArray = valueArray;
//    if (valueArray.count && valueArray.count == _labelArray.count)
//    {
//        for (int i = 0; i<self.labelArray.count; i++) {
//            NSString *s = [_valueArray objectAtIndex:i];
//            self.textFieldArray[i].text = s;
//        }
//    }
}

-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    if (dic) {
        [self.muDic setDictionary:dic];
        
        for (int i = 0; i<self.labelArray.count; i++) {
            NSString *str = [self.labelArray[i].text stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            NSLog(@"%@",[dic objectForKey:str]);
            NSString *s = [dic objectForKey:str];
            self.textFieldArray[i].text = s;
        }
    }
}

-(void)addItem{
    if (self.block) {
        self.block();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
