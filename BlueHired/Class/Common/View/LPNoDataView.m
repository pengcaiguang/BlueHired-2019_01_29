//
//  LPNoDataView.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/8/28.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPNoDataView.h"

@interface LPNoDataView ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

@end

@implementation LPNoDataView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init{
    self = [super init];
    if (self) {
        [self updateUI];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self updateUI];
    }
    return self;
}
-(void)image:(UIImage *)image text:(NSString *)text{
    if (image) {
        self.imageView.image = image;
    }
    if (text) {
        self.label.text = text;
    }
}

-(void)updateUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.top.equalTo(self.imageView.mas_bottom).offset(14);
    }];
    
}

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"search_empty"];
        
    }
    return _imageView;
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.numberOfLines = 0;
        _label.textColor = [UIColor colorWithHexString:@"#444444"];
        _label.font = [UIFont systemFontOfSize:13];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"搜不到您要的结果，换个关键词试试哦～";
    }
    return _label;
}
@end
