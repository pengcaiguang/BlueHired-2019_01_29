//
//  LPStoreCartCell.m
//  BlueHired
//
//  Created by iMac on 2019/9/19.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPStoreCartCell.h"

@implementation LPStoreCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.commodityImage.layer.borderColor = [UIColor colorWithHexString:@"#EBEBEB"].CGColor;
    self.commodityImage.layer.borderWidth = LENGTH_SIZE(1);
    self.commodityUnits.hidden = NO;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

     
}

- (void)setType:(NSInteger)Type{
    _Type = Type;
    if (Type == 1) {
        self.BuyCount.hidden = YES;
        self.NorStock.hidden = YES;
        self.Sub_Btn.hidden = NO;
        self.Add_Btn.hidden = NO;
        self.commodityCount.hidden = NO;
    }else if (Type == 2){
        self.BuyCount.hidden = YES;
        self.NorStock.hidden = NO;
        self.Sub_Btn.hidden = NO;
        self.Add_Btn.hidden = NO;
        self.commodityCount.hidden = NO;
        self.NorStock.font = FONT_SIZE(12);
        self.NorStock.textColor = [UIColor colorWithHexString:@"FF5353"];
        self.NorStock.text = [NSString stringWithFormat:@"库存:%@",self.model.stock];
    }else if (Type == 3){
        self.BuyCount.hidden = NO;

        self.NorStock.hidden = YES;
        self.Sub_Btn.hidden = YES;
        self.Add_Btn.hidden = YES;
        self.commodityCount.hidden = YES;
         
        
    }
}

- (void)setModel:(LPCartItemListDataModel *)model{
    _model = model;
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:model.productPic]
                                placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
    self.commodityName.text = model.productName;
    NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:model.sp1],
                                                                      [LPTools isNullToString:model.sp2],
                                                                      [LPTools isNullToString:model.sp3]]];
    [SizeArr removeObject:@""];
    
    self.commoditySize.text = [NSString stringWithFormat:@"%@  规格:%@",
                               model.postage.integerValue == 0 ? @"包邮" : @"到付",
                               [SizeArr componentsJoinedByString:@","]];
    self.commodityUnit.text = model.price;
    self.commodityCount.text = model.quantity;
    
    self.Sub_Btn.selected = self.commodityCount.text.integerValue == 1 ? YES : NO;
    self.Add_Btn.selected = self.commodityCount.text.integerValue >= model.stock.intValue ? YES : NO;
    
    if (model.stock.intValue < model.quantity.intValue || model.stock.intValue == 0) {
        self.contentView.alpha = model.stock.intValue == 0 ? 0.5 : 1 ;
        [self setType:2];
 
        self.selectButton.enabled = self.selectStatus == NO ? NO : YES;
    }else{
        self.selectButton.enabled = YES;
        self.contentView.alpha = 1 ;
        [self setType:1];
    }
}


- (void)setCartModel:(LPCartItemListDataModel *)CartModel{
    _CartModel = CartModel;
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:CartModel.productPic]
                                   placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
       self.commodityName.text = CartModel.productName;
       NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:CartModel.sp1],
                                                                         [LPTools isNullToString:CartModel.sp2],
                                                                         [LPTools isNullToString:CartModel.sp3]]];
       [SizeArr removeObject:@""];
       
       self.commoditySize.text = [NSString stringWithFormat:@"%@  规格:%@",
                                  CartModel.postage.integerValue == 0 ? @"包邮" : @"到付",
                                  [SizeArr componentsJoinedByString:@","]];
       self.commodityUnit.text = CartModel.price;
    self.BuyCount.text = [NSString stringWithFormat:@"x%@",CartModel.quantity];

}

- (void)setBuyModel:(ProductSkuListModel *)BuyModel{
    _BuyModel = BuyModel;
    
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:BuyModel.pic]
                                   placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
    self.commodityName.text = BuyModel.name;
   NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:BuyModel.sp1],
                                                                     [LPTools isNullToString:BuyModel.sp2],
                                                                     [LPTools isNullToString:BuyModel.sp3]]];
    [SizeArr removeObject:@""];
       
    self.commoditySize.text = [NSString stringWithFormat:@"%@  规格:%@",
                               BuyModel.postage.integerValue == 0 ? @"包邮" : @"到付",
                               [SizeArr componentsJoinedByString:@","]];
    self.commodityUnit.text = BuyModel.price;
    self.BuyCount.text = [NSString stringWithFormat:@"x%ld",(long)self.BuyNumber];
 
}

- (void)setShareModel:(LPStoreShareDataModel *)ShareModel{
    _ShareModel = ShareModel;
    NSArray *imageArr = [ShareModel.productPic componentsSeparatedByString:@","];

    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:imageArr[0]]
                                placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
    self.commodityName.text = ShareModel.productName;
   NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:ShareModel.sp1],
                                                                     [LPTools isNullToString:ShareModel.sp2],
                                                                     [LPTools isNullToString:ShareModel.sp3]]];
    [SizeArr removeObject:@""];
       
    self.commoditySize.text = [NSString stringWithFormat:@"%@  规格:%@",
                               ShareModel.postage.integerValue == 0 ? @"包邮" : @"到付",
                               [SizeArr componentsJoinedByString:@","]];
    self.commodityUnits.hidden = YES;
    self.BuyCount.text = @"x1";
 
    if (ShareModel.discountNum.integerValue == 0) {
        self.commodityUnit.text = [NSString stringWithFormat:@"%@ 积分",ShareModel.price];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.commodityUnit.text];
        [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(14)],
                         NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF7F00"]}
                 range:NSMakeRange(0, self.commodityUnit.text.length - 2)];
 
        [string addAttributes:@{NSFontAttributeName: FONT_SIZE(12),
                         NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#808080"]} range:NSMakeRange(self.commodityUnit.text.length - 2, 2)];
        self.commodityUnit.attributedText = string;

     }else{
 
         NSString *discountNumStr = [NSString stringWithFormat:@"折后%.0f积分",floor(ShareModel.discountNum.integerValue/100.0*ShareModel.price.integerValue)];
         self.commodityUnit.text = [NSString stringWithFormat:@"%@积分  %@",ShareModel.price,discountNumStr];

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.commodityUnit.text];
        [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2)];
        [string addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2)]; // 删除线颜色
        
        [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
                                NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]}
                        range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2 )];
         
         [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF5353"]}
                         range:NSMakeRange(self.commodityUnit.text.length - discountNumStr.length, discountNumStr.length )];
         
        self.commodityUnit.attributedText = string;
    }

}


- (void)setGenerateModel:(LPOrderGenerateDataItemModel *)GenerateModel{
    _GenerateModel = GenerateModel;
    [self.commodityImage yy_setImageWithURL:[NSURL URLWithString:GenerateModel.productPic]
                                   placeholder:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F5F5F5"]]];
       self.commodityName.text = GenerateModel.productName;
       NSMutableArray *SizeArr = [[NSMutableArray alloc] initWithArray:@[[LPTools isNullToString:GenerateModel.sp1],
                                                                         [LPTools isNullToString:GenerateModel.sp2],
                                                                         [LPTools isNullToString:GenerateModel.sp3]]];
       [SizeArr removeObject:@""];
       
       self.commoditySize.text = [NSString stringWithFormat:@"%@  规格:%@",
                                  GenerateModel.postage.integerValue == 0 ? @"包邮" : @"到付",
                                  [SizeArr componentsJoinedByString:@","]];
        
    self.BuyCount.text = [NSString stringWithFormat:@"x%@",GenerateModel.productQuantity];
    
    self.commodityUnits.hidden = YES;
 
       if (GenerateModel.discountNum.integerValue == 0) {
           self.commodityUnit.text = [NSString stringWithFormat:@"%@ 积分",GenerateModel.productPrice];
           NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.commodityUnit.text];
           [string addAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:FontSize(14)],
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF7F00"]}
                    range:NSMakeRange(0, self.commodityUnit.text.length - 2)];
    
           [string addAttributes:@{NSFontAttributeName: FONT_SIZE(12),
                            NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#808080"]} range:NSMakeRange(self.commodityUnit.text.length - 2, 2)];
           self.commodityUnit.attributedText = string;

        }else{
    
            NSString *discountNumStr = [NSString stringWithFormat:@"折后%.0f积分",floor(GenerateModel.discountNum.integerValue/100.0*GenerateModel.productPrice.integerValue)];
            self.commodityUnit.text = [NSString stringWithFormat:@"%@积分  %@",GenerateModel.productPrice,discountNumStr];

           NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.commodityUnit.text];
           [string addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2)];
           [string addAttribute:NSStrikethroughColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2)]; // 删除线颜色
           
           [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
                                   NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#999999"]}
                           range:NSMakeRange(0, self.commodityUnit.text.length - discountNumStr.length - 2 )];
            
            [string addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:FontSize(14)],
                                    NSForegroundColorAttributeName: [UIColor colorWithHexString:@"#FF5353"]}
                            range:NSMakeRange(self.commodityUnit.text.length - discountNumStr.length, discountNumStr.length )];
            
           self.commodityUnit.attributedText = string;
       }
    
}

//选择商品数量
- (IBAction)TouchSizeViewAddandSubtract:(UIButton *) sender{
    
    if (self.model.stock.intValue == 0) {
        return;
    }
    
    if (sender.selected == NO) {
        if (sender == self.Sub_Btn) {
            if (self.commodityCount.text.integerValue>self.model.stock.integerValue) {
                [self requestUpdateQuantityNumder:self.model.stock.integerValue];
            }else{
                [self requestUpdateQuantityNumder:self.commodityCount.text.integerValue-1];
            }
        }else{
            [self requestUpdateQuantityNumder:self.commodityCount.text.integerValue+1];
        }
    }else if (sender.selected == YES && sender == self.Add_Btn){
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"库存不足，请勿继续添加" time:1.0];
    }else if (sender.selected == YES && sender == self.Sub_Btn){
        [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"宝贝不能再减少了哦~" time:1.0];
    }
}



- (IBAction)TouchSelectBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.selectBlock) {
        self.selectBlock(self.model);
    }
}

-(void)setSelectAll:(BOOL)selectAll{
    self.selectButton.selected = selectAll;
}



-(void)requestUpdateQuantityNumder:(NSInteger) numder{
    
//    cart/update_quantity
    NSString *urlStr = [NSString stringWithFormat:@"cart/update_quantity?cartItemId=%@&quantity=%ld",self.model.id,(long)numder];
    
    [NetApiManager requestUpdateQuantity:nil  URLString:urlStr withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue] == 1) {
                    self.model.quantity = [NSString stringWithFormat:@"%ld",numder];
                    self.commodityCount.text = [NSString stringWithFormat:@"%ld",numder];
                    self.Sub_Btn.selected = self.commodityCount.text.integerValue == 1 ? YES : NO;
                    self.Add_Btn.selected = self.commodityCount.text.integerValue >= self.model.stock.intValue ? YES : NO;
                    
                    if (self.model.stock.intValue < self.model.quantity.intValue) {
                           self.contentView.alpha = self.model.stock.intValue == 0 ? 0.5 : 1 ;
                           [self setType:2];
                    
                           self.selectButton.enabled = self.selectStatus == NO ? NO : YES;
                       }else{
                           self.selectButton.enabled = YES;
                           self.contentView.alpha = 1 ;
                           [self setType:1];
                       }
                    if (self.AddroSubBlock) {
                        self.AddroSubBlock();
                    }
                    
                }else{
                    [[UIApplication sharedApplication].keyWindow showLoadingMeg:@"修改失败,请稍后再试" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [[UIApplication sharedApplication].keyWindow showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [[UIApplication sharedApplication].keyWindow showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


@end
