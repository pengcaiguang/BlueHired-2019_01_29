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
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString*timeStr=[formatter stringFromDate:d];
    
    _stateLabel.textColor = [UIColor colorWithHexString:@"#181818"];
    if ([_model.billType integerValue] == 2)
    {
        _titleLabel.text = [NSString stringWithFormat:@"账户提现: %.2f",_model.money.floatValue];


        long long time1=[[model.set_time stringValue] longLongValue];
        NSDate *d2 = [[NSDate alloc]initWithTimeIntervalSince1970:time1/1000.0];
        NSString*SettimeStr=[formatter stringFromDate:d2];
        
        if (model.status.integerValue == 1) {
            _stateLabel.text =  @"待处理";
            _dateLabel.text = timeStr;
 

        }else if (model.status.integerValue == 2){
            _stateLabel.text =  @"处理中";
            _dateLabel.text = SettimeStr;

        }else if (model.status.integerValue == 3){
            _stateLabel.text =  @"到账成功";
            _dateLabel.text = SettimeStr;

        }else if (model.status.integerValue == 4){
            _stateLabel.text =  @"到账失败";
            _stateLabel.textColor = [UIColor colorWithHexString:@"#FF5353"];
            _dateLabel.text = SettimeStr;

        }
        

        
//        long long timeSet=[[self.model.set_time stringValue] longLongValue];

//        if (timeSet/1000.0+60*60*2<[NSString getNowTimestamp]/1000.0 && timeSet >0) {
//            _stateLabel.text = @"已完成";
//        }
     }else{
         _dateLabel.text = timeStr;

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
            _titleLabel.text = [NSString stringWithFormat:@"邀请注册奖励: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 7)
        {
            _titleLabel.text = [NSString stringWithFormat:@"代扣借支到账: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 8)
        {
            _titleLabel.text = [NSString stringWithFormat:@"邀请入职奖励: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 9)
        {
            _titleLabel.text = [NSString stringWithFormat:@"蓝聘红包: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 10)
        {
            _titleLabel.text = [NSString stringWithFormat:@"完善资料奖励: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 11)
        {
            _titleLabel.text = [NSString stringWithFormat:@"积分兑换奖励: %.2f",_model.money.floatValue];
        }
        else if ([_model.type integerValue] == 12)
        {
            _titleLabel.text = [NSString stringWithFormat:@"分享点赞奖励: %.2f",_model.money.floatValue];
        }
        _stateLabel.text = @"已到蓝聘账户";
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
