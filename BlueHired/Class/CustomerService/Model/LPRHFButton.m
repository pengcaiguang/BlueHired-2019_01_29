//
//  LPRHFButton.m
//  BlueHired
//
//  Created by iMac on 2019/1/2.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPRHFButton.h"
@interface LPRHFButton()
@property (nonatomic,strong) UILabel *label;
@end

@implementation LPRHFButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        UILabel *label = [[UILabel alloc] init];
        self.label = label;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        [self addSubview:label];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        NSLayoutConstraint  *labelTop = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:10];
        [self addConstraint:labelTop];
        NSLayoutConstraint *labelLeft = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
        [self addConstraint:labelLeft];
        NSLayoutConstraint *labelBottom = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
        [self addConstraint:labelBottom];
        NSLayoutConstraint *labelRight = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-17];
        [self addConstraint:labelRight];
    }
    return self;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    self.label.text= title;
}

- (UILabel *)titleLabel{
    return self.label;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    self.label.textColor = color;
}
@end
