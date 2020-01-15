//
//  LPSignInfoVC.m
//  BlueHired
//
//  Created by peng on 2018/9/29.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPSignInfoVC.h"
#import <WebKit/WebKit.h>

@interface LPSignInfoVC ()<FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance,WKNavigationDelegate, WKUIDelegate>{
    WKWebView *webview;
}
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *signNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayScoreLabel;

@property (weak, nonatomic) FSCalendar *calendar;
@property(nonatomic,strong) NSArray *selectDateArray;

@property(nonatomic,strong) NSString *currentDateString;
@property(nonatomic,strong) FSCalendar *Customcalendar;
@property(nonatomic,assign) BOOL IsSign;

@property (nonatomic,weak) CALayer *progressLayer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;


@end

@implementation LPSignInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [LPTools deleteWebCache];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"签到";
    self.selectDateArray = [NSMutableArray array];
    
    self.signButton.titleLabel.numberOfLines = 0;
    self.signButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.signButton.adjustsImageWhenHighlighted=NO;
    self.IsSign = NO;
 

    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.currentDateString = [dateFormatter stringFromDate:currentDate];
    
    
    [self WebKit];
    
 
    
    
    
}
 



- (void)WebKit {
    self.view.backgroundColor = [UIColor whiteColor];
 
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    
    webview = [[WKWebView alloc] init];
    [self.view addSubview:webview];
    
    [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resident/#/sign?sign=%ld",BaseRequestWeiXiURL,(long)[kUserDefaultsValue(LOGINID) integerValue]]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self setupProgress];
    
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        if (webview.canGoBack) {
            [webview goBack];
        }
    }
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (webview.canGoForward) {
            [webview goForward];
        }
    }
}

-(void)setupProgress{
    UIView *progress = [[UIView alloc]init];
    progress.frame = CGRectMake(0, 0, self.view.frame.size.width, 1);
    progress.backgroundColor = [UIColor  clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 1);
    layer.backgroundColor = [UIColor baseColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progressLayer = layer;
}

#pragma mark - KVO回馈
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.frame.size.width*[change[@"new"] floatValue], 1);
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                self.progressLayer.frame = CGRectMake(0, 0, 0, 1);
            });
        }
    }
    
}

- (void)dealloc {
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
