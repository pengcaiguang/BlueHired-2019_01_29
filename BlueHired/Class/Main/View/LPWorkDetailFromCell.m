//
//  LPWorkDetailFromCell.m
//  BlueHired
//
//  Created by iMac on 2019/11/7.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkDetailFromCell.h"

@implementation LPWorkDetailFromCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(LPWorkDetailModel *)model{
    _model = model;
     NSArray *TypeDataArr = @[[LPTools isNullToString:self.model.data.sexAge],
                             [LPTools isNullToString:self.model.data.tattooHair],
                             [LPTools isNullToString:self.model.data.medicalFee],
                             [LPTools isNullToString:self.model.data.vision],
                             [LPTools isNullToString:self.model.data.culturalSkills],
                             [LPTools isNullToString:self.model.data.nation],
                             [LPTools isNullToString:self.model.data.idCard],
                             [LPTools isNullToString:self.model.data.postOther],
                              [model.data.postType integerValue] == 0 ? [LPTools isNullToString:self.model.data.workingPrice] : [LPTools isNullToString:self.model.data.hoursPrice],
                             [LPTools isNullToString:self.model.data.overtimeDetails],
                             [LPTools isNullToString:self.model.data.subsidyDetails],
                             [LPTools isNullToString:self.model.data.payrollTime],
                             [LPTools isNullToString:self.model.data.salaryOther],
                             [LPTools isNullToString:self.model.data.accConditions],
                             [LPTools isNullToString:self.model.data.diet],
                             [LPTools isNullToString:self.model.data.accOther],
                             [LPTools isNullToString:self.model.data.workSystem],
                             [LPTools isNullToString:self.model.data.shiftTime],
                             [LPTools isNullToString:self.model.data.workOther],
                             [LPTools isNullToString:self.model.data.interviewData],
                             [LPTools isNullToString:self.model.data.interviewOther]];
    
    
    for (NSInteger i =0; i<TypeDataArr.count; i++) {
      
        
        NSString *str = TypeDataArr[i];
        if (str.length == 0) {
            str = @"无";
        }
        
        UILabel *DataLabel = [[self.fromView viewWithTag:i*10+1000+1] viewWithTag:1000];
        if (DataLabel && [DataLabel isKindOfClass:[UILabel class]]) {
            DataLabel.text = str;
        }
    }
    
    UILabel *workingPriceLabel = [[self.fromView viewWithTag:1080] viewWithTag:1000];
    
    
    if ([model.data.postType integerValue] == 0) {      //正式工
        workingPriceLabel.text = @"底薪说明";
        NSString *str = model.data.overtimeDetails;
        if (str.length == 0) {
            str = @"无";
        }
        CGFloat RowHeight = [LPTools calculateRowHeight:str fontSize:FontSize(13) Width:SCREEN_WIDTH - LENGTH_SIZE(145)];
        self.LayoutConstraint_postType_Top.constant = LENGTH_SIZE(14) + RowHeight + 2;
    }else{
        workingPriceLabel.text = @"工价";
        self.LayoutConstraint_postType_Top.constant = LENGTH_SIZE(1);
    }
    
}

@end
