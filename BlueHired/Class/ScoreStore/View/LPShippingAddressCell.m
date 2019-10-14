//
//  LPShippingAddressCell.m
//  BlueHired
//
//  Created by iMac on 2019/9/20.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPShippingAddressCell.h"

@implementation LPShippingAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.defaultAddress.layer.cornerRadius = LENGTH_SIZE(2);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(LPOrderAddressDataModel *)model{
    _model = model;
    self.userName.text = model.name;
    self.userTel.text = model.phone;
    self.defaultAddress.hidden = !model.sendStatus.integerValue;
    
    NSString *strCity = [model.city stringByReplacingOccurrencesOfString:@"市" withString:@""];
    if ([model.province isEqualToString:strCity]) {
        if ([model.region isEqualToString:@"全市"]) {
            self.Address.text = [NSString stringWithFormat:@"%@ %@",model.city,model.detailAddress];
        }else{
            self.Address.text = [NSString stringWithFormat:@"%@%@ %@",model.city,model.region,model.detailAddress];
        }
    }else{
        if ([model.region isEqualToString:@"全市"]) {
            self.Address.text = [NSString stringWithFormat:@"%@%@ %@",model.province,model.city,model.detailAddress];
        }else{
            self.Address.text = [NSString stringWithFormat:@"%@%@%@ %@",model.province,model.city,model.region,model.detailAddress];
        }
    }
    
}

- (IBAction)TouchEdit:(UIButton *)sender {
    if (self.Block) {
        self.Block();
    }
}

@end
