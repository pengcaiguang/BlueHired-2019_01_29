//
//  LPRegisteredContentVC.m
//  BlueHired
//
//  Created by iMac on 2018/11/5.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPRegisteredContentVC.h"
#import <WebKit/WebKit.h>

@interface LPRegisteredContentVC ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
{
    WKWebView *webview;
}

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic,weak) CALayer *progressLayer;
@property (nonatomic,assign) BOOL isfirst;
//返回按钮
@property (nonatomic, strong) UIBarButtonItem *backItem;
//关闭按钮
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end


@implementation LPRegisteredContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"用户协议";
    
//    [LPTools deleteWebCache];
    
     [self WebKit];
    
    

}



-(void)viewWillAppear:(BOOL)animated{
    if (_isfirst) {
        NSURL *url;
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resident/#/protocol",BaseRequestWeiXiURL]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [webview loadRequest:request];
    }
    _isfirst = YES;
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)WebKit {
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    config.selectionGranularity = WKSelectionGranularityDynamic;
    config.allowsInlineMediaPlayback = YES;
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    config.userContentController = userController;
    [userController addScriptMessageHandler:self name:@"JSToHistoryVC"];
    [userController addScriptMessageHandler:self name:@"JSToRecordVC"];
    [userController addScriptMessageHandler:self name:@"killMyself"];
    
    
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
    url = [NSURL URLWithString:[NSString stringWithFormat:@"%@resident/#/protocol",BaseRequestWeiXiURL]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webview loadRequest:request];
    
    webview.navigationDelegate = self;
    webview.UIDelegate = self;
    
    [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [webview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
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

//设置webview的title为导航栏的title
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
    }else if ([keyPath isEqualToString:@"title"])
    {
        if (object == webview)
        {
            self.navigationItem.title = webview.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}
- (void)dealloc {
    [webview removeObserver:self forKeyPath:@"estimatedProgress"];
    [webview removeObserver:self forKeyPath:@"title"];
}

//JS调用的OC回调方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"JSToHistoryVC"]) {
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        [self JSToHistoryVC];
    }else if ([message.name isEqualToString:@"JSToRecordVC"]){
        NSString *cookiesStr = message.body;
        NSLog(@"当前的cookie为： %@", cookiesStr);
        [self JSToRecordVC];
    }else if ([message.name isEqualToString:@"killMyself"]){
        
    }
}



- (void)JSToHistoryVC{
    
}
- (void)JSToRecordVC{
    
}



#pragma mark - init

- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        _backItem = [[UIBarButtonItem alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        UIImage *image = [UIImage imageNamed:@"BackBttonImage"];
        [btn setImage:image forState:UIControlStateNormal];
        [btn setTitle:@" 返回" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(backNative) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //字体的多少为btn的大小
        [btn sizeToFit];
        
        _backItem.customView = btn;
    }
    return _backItem;
}

- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        _closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeNative)];
    }
    return _closeItem;
}
//关闭H5页面，直接回到原生页面
- (void)closeNative
{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击返回的方法
- (void)backNative
{
    //判断是否有上一层H5页面
    if ([webview canGoBack]) {
        //如果有则返回
        [webview goBack];
        //同时设置返回按钮和关闭按钮为导航栏左边的按钮
        //        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    } else {
        [self closeNative];
    }
}



@end
