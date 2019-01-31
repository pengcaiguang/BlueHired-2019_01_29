//
//  LPtestViewController.m
//  BlueHired
//
//  Created by iMac on 2018/12/28.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPtestViewController.h"

@interface LPtestViewController ()
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation LPtestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI{
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.alwaysBounceVertical = YES;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    UIView *view2 = [[UIView alloc] init];
    [scrollView addSubview:view2];
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(113);
        make.right.mas_equalTo(-50);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo(160);
    }];
    view2.backgroundColor = [UIColor redColor];
    
    NSLog(@"%f",scrollView.frame.size.width);
     
}
 

@end
