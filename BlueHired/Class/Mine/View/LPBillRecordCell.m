//
//  LPBillRecordCell.m
//  BlueHired
//
//  Created by iMac on 2018/10/12.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPBillRecordCell.h"

@implementation LPBillRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)loadCell
{
    return [[[NSBundle mainBundle]loadNibNamed:@"LPBillRecordCell" owner:self options:nil] lastObject];
}

- (void)setModel:(LPBillrecordDataModel *)model
{
    _model =model;
    
    long long time=[[model.time stringValue] longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString*timeStr=[formatter stringFromDate:d];
    
    _dateLabel.text = timeStr;
    if ([_model.billType integerValue] == 2)
    {
        _titleLabel.text = [NSString stringWithFormat:@"账户提现: %.2f",_model.money.floatValue];
        _stateLabel.text =  [_model.type integerValue] == 1?@"处理中": @"处理完成";
     }
    else{
        if ([_model.type integerValue] == 0) {
            _titleLabel.text = [NSString stringWithFormat:@"其他到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 1)
        {
            _titleLabel.text = [NSString stringWithFormat:@"借支到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 2)
        {
            _titleLabel.text = [NSString stringWithFormat:@"管理费到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 3)
        {
            _titleLabel.text = [NSString stringWithFormat:@"工资到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 4)
        {
            _titleLabel.text = [NSString stringWithFormat:@"返费到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 5)
        {
            _titleLabel.text = [NSString stringWithFormat:@"注册返利到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 7)
        {
            _titleLabel.text = [NSString stringWithFormat:@"代扣借支到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 8)
        {
            _titleLabel.text = [NSString stringWithFormat:@"邀请奖励到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 9)
        {
            _titleLabel.text = [NSString stringWithFormat:@"蓝聘红包: %.2f",_model.money.floatValue];
        }
        _stateLabel.text = @"已到账";
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
