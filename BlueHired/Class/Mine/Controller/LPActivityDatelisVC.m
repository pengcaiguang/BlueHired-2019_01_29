//
//  LPActivityDatelisVC.m
//  BlueHired
//
//  Created by iMac on 2019/1/8.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPActivityDatelisVC.h"
#import <WebKit/WebKit.h>

@interface LPActivityDatelisVC ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *webview;
}
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,weak) CALayer *progressLayer;
@property (nonatomic,assign) BOOL isfirst;

@end

@implementation LPActivityDatelisVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"活动详情";
    [self WebKit];
}
-(void)viewDidAppear:(BOOL)animated{
    if (_isfirst) {
        NSURL *url;
        if ([kUserDefaultsValue(LOGINID) integerValue]) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@bluehired/activity.html?sign=%ld&id=%@",BaseRequestWeiXiURL,[kUserDefaultsValue(LOGINID) integerValue],self.Model.id]];
        }else{
            url =  [NSURL URLWithString:[NSString stringWithFormat:@"%@bluehired/activity.html?id=%@",BaseRequestWeiXiURL,self.Model.id]];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webview loadRequest:request];
    }
    _isfirst = YES;

}

- (void)WebKit {
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    config.userContentController = userController;
    [userController addScriptMessageHandler:self name:@"JSToViewController"];
    
    
    webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:webview];
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
      [webview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    NSURL *url;
    if ([kUserDefaultsValue(LOGINID) integerValue]) {
          url = [NSURL URLWithString:[NSString stringWithFormat:@"%@bluehired/activity.html?sign=%ld&id=%@",BaseRequestWeiXiURL,[kUserDefaultsValue(LOGINID) integerValue],self.Model.id]];
    }else{
         url =  [NSURL URLWithString:[NSString stringWithFormat:@"%@bluehired/activity.html?id=%@",BaseRequestWeiXiURL,self.Model.id]];
    }

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
//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"JSToViewController"]) {
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        [self JSToViewController];
    }
}

- (void)JSToViewController{
    [LoginUtils validationLogin:self];
}

@end
