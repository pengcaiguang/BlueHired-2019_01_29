//
//  LPEssayDetailHeadCell.m
//  BlueHired
//
//  Created by 邢晓亮 on 2018/9/1.
//  Copyright © 2018年 lanpin. All rights reserved.
//

#import "LPEssayDetailHeadCell.h"

@interface LPEssayDetailHeadCell() <WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic,assign) BOOL reloadTable;

@end

@implementation LPEssayDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.webBgView addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.webBgView);
    }];
}

-(void)setModel:(LPEssayDetailModel *)model{
    if ([_model.mj_keyValues isEqual:model.mj_keyValues]) {
        return;
    }
    _model = model;

    if (!kStringIsEmpty(model.data.essayDetails)) {
//        [self.wkWebView loadHTMLString:model.data.essayDetails baseURL:nil];
        [self.wkWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><meta content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0\" name=\"viewport\"><style type=\"text/css\">img{display: inline-block;max-width: 100%%;width:auto; height:auto;}</style></head><body>\%@</body></html>",model.data.essayDetails] baseURL: nil];
    }
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.wkWebView.scrollView.scrollEnabled = NO;
    NSString *js = [NSString stringWithFormat:@"function changeImgWH() { \
                        var imgs = document.getElementsByTagName('img'); \
                        var objs = document.getElementsByTagName('a'); \
                        for (var i = 0; i < objs.length; ++i) {\
                            objs[i].removeAttribute('style');\
                            } \
                        }   \
                        changeImgWH(); "];
    
    [webView evaluateJavaScript:js completionHandler:^(id result, NSError *_Nullable error) {
    }];
    WEAK_SELF()
    [webView evaluateJavaScript:@"document.body.scrollHeight"
              completionHandler:^(id result, NSError *_Nullable error) {
                  CGFloat documentHeight = [result doubleValue];
                  NSLog(@"%f",documentHeight);
                  weakSelf.webBgView_constraint_height.constant = documentHeight;
                  
                  weakSelf.essayNameLabel.text = weakSelf.model.data.essayName;
                  weakSelf.essayAuthorLabel.text = weakSelf.model.data.essayAuthor;
                  weakSelf.timeLabel.text = [NSString convertStringToTime:[weakSelf.model.data.time stringValue]];
                  weakSelf.viewLabel.text = weakSelf.model.data.view ? [weakSelf.model.data.view stringValue] : @"0";
                  weakSelf.commentTotalLabel.text = weakSelf.model.data.commentTotal ? [weakSelf.model.data.commentTotal stringValue] : @"0";
                  weakSelf.praiseTotalLabel.text = weakSelf.model.data.praiseTotal ? [weakSelf.model.data.praiseTotal stringValue] : @"0";
 
                  
                  
                  if (weakSelf.Block) {
                      weakSelf.Block(documentHeight);
                  }
                  
              }];
}



- (UITableView *)tableView{
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}

-(WKWebView *)wkWebView{
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        _wkWebView.opaque = NO;
        _wkWebView.userInteractionEnabled = NO;
        _wkWebView.scrollView.bounces = NO;
        _wkWebView.scrollView.delegate = self;
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
