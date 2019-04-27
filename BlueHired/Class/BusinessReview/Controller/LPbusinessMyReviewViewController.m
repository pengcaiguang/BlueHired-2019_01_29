//
//  LPbusinessMyReviewViewController.m
//  BlueHired
//
//  Created by iMac on 2018/10/9.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPbusinessMyReviewViewController.h"
#import "XHStarRateView.h"
#import "HXPhotoPicker.h"

static NSString *TEXT = @"请输入点评内容（5-150字之间）";
static const CGFloat kPhotoViewMargin = 13.0;

@interface LPbusinessMyReviewViewController ()<XHStarRateViewDelegate,UITextViewDelegate,HXPhotoViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;
@property(nonatomic,strong) NSArray <UIImage *>*imageArray;
@property(nonatomic,strong) NSArray *imageUrlArray;

@property (nonatomic,strong) UIView *ToolTextView;

@end

@implementation LPbusinessMyReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"写点评";
    [self setTextFieldView];

    _textView.layer.borderColor = [UIColor blackColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.textColor = [UIColor lightGrayColor];
    _textView.text = TEXT;
    _textView.delegate = self;
    _textView.inputAccessoryView = self.ToolTextView;

    _button.layer.cornerRadius = 20;
//    self.view.layer.contentsRect
    
    UILabel* label2 = [self.scrollView viewWithTag:1004];
    
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.lineCount = 3;
    photoView.delegate = self;
    //    photoView.showAddCell = NO;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.scrollView addSubview:photoView];
    self.photoView = photoView;
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(label2.mas_bottom).offset(20);
        make.width.mas_equalTo(SCREEN_WIDTH - kPhotoViewMargin * 2);
    }];
    [self.photoView refreshView];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    
    UIView *view = [self.scrollView viewWithTag:2000];
    
    if (view == nil) {
        for (int i =0 ; i < 5; i++) {

            UIView *view = [self.scrollView viewWithTag:i+1000];
            CGFloat viewY = view.frame.origin.y;
            
            XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, viewY, 140, 21)];
            starRateView.isAnimation = YES;
            starRateView.rateStyle = HalfStar;
            starRateView.tag = 2000+i;
            starRateView.delegate = self;
            [self.scrollView addSubview:starRateView];
            
            UILabel *label = [[UILabel alloc ]initWithFrame:CGRectMake(starRateView.frame.size.width+starRateView.frame.origin.x,
                                                                       viewY,
                                                                       50,
                                                                       21)];
            label.textColor = [UIColor redColor];
            label.text = @"0.0分";
            label.tag = 3000+i;
            [self.scrollView addSubview:label];
        }
    }
    

}



#pragma mark - 编辑view
-(void)setTextFieldView{
    //输入框编辑view
    UIView *ToolTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    self.ToolTextView = ToolTextView;
    ToolTextView.backgroundColor = [UIColor colorWithHexString:@"#E6E6E6"];
    UIButton *DoneBt = [[UIButton alloc] init];
    [ToolTextView addSubview:DoneBt];
    [DoneBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    [DoneBt setTitle:@"确定" forState:UIControlStateNormal];
    [DoneBt setTitleColor:[UIColor baseColor] forState:UIControlStateNormal];
    DoneBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    DoneBt.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [DoneBt addTarget:self action:@selector(TouchTextDone:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *CancelBt = [[UIButton alloc] init];
    [ToolTextView addSubview:CancelBt];
    [CancelBt mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.equalTo(DoneBt.mas_left).offset(0);
        make.width.equalTo(DoneBt.mas_width);
    }];
    [CancelBt setTitle:@"取消" forState:UIControlStateNormal];
    [CancelBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CancelBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    CancelBt.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [CancelBt addTarget:self action:@selector(TouchTextCancel:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)TouchTextDone:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)TouchTextCancel:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}







-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.textColor isEqual:[UIColor lightGrayColor]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = TEXT;
    }
}


#pragma mark - HXPhotoViewDelegate
- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame{
    NSSLog(@"%@",NSStringFromCGRect(frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, CGRectGetMaxY(frame) + kPhotoViewMargin + 92);
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(CGRectGetMaxY(photoView.frame)+44);
        make.height.mas_equalTo(48);
    }];
}
-(void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal{
    [self.toolManager getSelectedImageList:allList requestType:HXDatePhotoToolManagerRequestTypeOriginal success:^(NSArray<UIImage *> *imageList) {
        if (imageList.count > 0) {
            self.imageArray = imageList;
        }
    } failed:^{
        
    }];
}
#pragma mark - lazy
- (HXPhotoManager *)manager {
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        //        _manager.configuration.openCamera = NO;
        _manager.configuration.saveSystemAblum = YES;
        _manager.configuration.photoMaxNum = 6; //
        //        _manager.configuration.videoMaxNum = 1;  //
        //        _manager.configuration.maxNum = 6;
        _manager.configuration.reverseDate = YES;
        _manager.configuration.openCamera = YES;
        _manager.configuration.photoCanEdit = NO;
        _manager.configuration.changeAlbumListContentView = NO;
        [_manager preloadData];

        //        _manager.configuration.selectTogether = NO;
    }
    return _manager;
}

- (HXDatePhotoToolManager *)toolManager {
    if (!_toolManager) {
        _toolManager = [[HXDatePhotoToolManager alloc] init];
    }
    return _toolManager;
}

-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore
{
    UILabel *label = [self.view viewWithTag:starRateView.tag + 1000];
    label.text = [NSString stringWithFormat:@"%.1f分",currentScore*2];
    NSLog(@"%ld----  %f",starRateView.tag,currentScore);
}
- (IBAction)TouchBt:(id)sender
{    
    NSString *string = self.textView.text;
    if (string.length < 1 || [self.textView.textColor isEqual:[UIColor lightGrayColor]])
    {
        [self.view showLoadingMeg:@"请输入点评内容！" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (string.length<5)
    {
        [self.view showLoadingMeg:@"点评内容字数不得低于5！" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (string.length > 150) {
        [self.view showLoadingMeg:@"点评内容字数不得高于150！" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (kArrayIsEmpty(self.imageArray)) {
        [self requestAddMood];
    }else{
        [self requestUploadImages];
    }
    
}
-(void)requestUploadImages{
    [NetApiManager requestPublishArticle:nil imageArray:self.imageArray imageNameArray:nil response:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.imageUrlArray = responseObject[@"data"];
                [self requestAddMood];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestAddMood{

    NSString *string = @"";
    if (self.imageUrlArray) {
        string = [self.imageUrlArray componentsJoinedByString:@";"];
    }
    
    UILabel *Label0 = (UILabel *)[self.scrollView viewWithTag:3000];
    UILabel *Label1 = (UILabel *)[self.scrollView viewWithTag:3001];
    UILabel *Label2 = (UILabel *)[self.scrollView viewWithTag:3002];
    UILabel *Label3 = (UILabel *)[self.scrollView viewWithTag:3003];
    UILabel *Label4 = (UILabel *)[self.scrollView viewWithTag:3004];
    
    
    NSDictionary *dic = @{
                          @"commentContent":self.textView.text,
                          @"commentUrl":string,
                          @"foodEnvironScore":[Label0.text stringByReplacingOccurrencesOfString:@"分"withString:@""],
                          @"manageEnvironScore":[Label1.text stringByReplacingOccurrencesOfString:@"分"withString:@""],
                          @"moneyEnvironScore":[Label2.text stringByReplacingOccurrencesOfString:@"分"withString:@""],
                          @"sleepEnvironScore":[Label3.text stringByReplacingOccurrencesOfString:@"分"withString:@""],
                          @"workEnvironScore":[Label4.text stringByReplacingOccurrencesOfString:@"分"withString:@""],
                          @"mechanismId":self.mechanismlistDataModel.id,
                          @"versionType":@"2.1"
                          };
    
    NSString *url = @"mechanismcomment/add_comment";
    
    [NetApiManager requestSaveOrUpdateWithParam:url withParam:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue]== 0)
            {
                if ([responseObject[@"data"] integerValue] == 2) {
                    [LPTools AlertBusinessView:@""];
                }
                [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                [self.navigationController popViewControllerAnimated:YES];
             }else{
                if ([responseObject[@"code"] integerValue] == 10045) {
                    [LPTools AlertMessageView:responseObject[@"msg"]];
                }else{
                    [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
    
}

@end
