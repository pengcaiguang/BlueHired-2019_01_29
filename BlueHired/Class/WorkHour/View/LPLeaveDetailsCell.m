//
//  LPLeaveDetailsCell.m
//  BlueHired
//
//  Created by iMac on 2019/3/6.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPLeaveDetailsCell.h"

@implementation LPLeaveDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPLeaveDetailsDataModel *)Model{
    _Model = Model;
    if (self.Type == 1) {
        if (self.WorkHourType == 2) {
            _Name.text = [NSString stringWithFormat:@"%@(%@)",Model.time,[NSString weekdayStringFromDate:Model.time]];
            _Date.text = [NSString stringWithFormat:@"%.2f小时",Model.hours.floatValue];
        }else{
            _Name.text = [NSString stringWithFormat:@"%@(%@)",Model.time,[NSString weekdayStringFromDate:Model.time]];
            _Date.text = [NSString stringWithFormat:@"%.2f倍/%.2f小时",Model.mulAmount.floatValue,Model.hours.floatValue];
        }

        _remark.text = Model.remark;
    }else if (self.Type == 2){
        if (self.WorkHourType == 3) {
            _Name.text = [NSString stringWithFormat:@"%@(%@)",Model.time,[NSString weekdayStringFromDate:Model.time]];
        }else{
            _Name.text = [NSString stringWithFormat:@"%@(%@)",Model.time,[NSString weekdayStringFromDate:Model.time]];
        }
        _Date.text = [NSString stringWithFormat:@"%.2f小时",Model.hours.floatValue];
        _remark.text = Model.remark;
    }else if (self.Type == 3){
        _Name.text = [NSString stringWithFormat:@"%@(%@)",Model.time,[NSString weekdayStringFromDate:Model.time]];
        _Date.text = [NSString stringWithFormat:@"消费%.2f元",Model.hours.floatValue];
        _remark.text = Model.remark;
    }
}

@end
