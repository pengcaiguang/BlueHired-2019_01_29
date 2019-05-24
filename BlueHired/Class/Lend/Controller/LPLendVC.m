//
//  LPLendVC.m
//  BlueHired
//
//  Created by peng on 2018/9/25.
//  Copyright © 2018 lanpin. All rights reserved.
//

#import "LPLendVC.h"
#import "LPLendCell.h"
#import "LPQueryCheckrecordModel.h"
#import "LPLendMechanismModel.h"
#import "LPMapLocCell.h"

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>

static NSString *LPTLendAuditCellID = @"LPLendCell";
static NSString *LPMapLocCellID = @"LPMapLocCell";

@interface LPLendVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lendMoneyLabel;

@property (weak, nonatomic) IBOutlet UITextField *CompanyTextField;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *lendTextField;
@property (weak, nonatomic) IBOutlet UIButton *lendButton;
@property(nonatomic,strong) NSString *userUrl;

@property (nonatomic,strong) NSString *lendMoney;
@property (nonatomic,strong) UITableView *CompanyTableView;
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,strong) UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIView *recordView;
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UILabel *text1;
@property (weak, nonatomic) IBOutlet UILabel *text2;
@property (weak, nonatomic) IBOutlet UILabel *text3;

@property (weak, nonatomic) IBOutlet UILabel *time1;
@property (weak, nonatomic) IBOutlet UILabel *time2;
@property (weak, nonatomic) IBOutlet UILabel *time3;

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UIView *LendImageView;
@property (weak, nonatomic) IBOutlet UIButton *ImageBT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Label_Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LayoutConstraint_Label_Top;

@property (nonatomic,strong) LPQueryCheckrecordModel *model;
@property (nonatomic,strong) LPLendMechanismModel *MechanismModel;
@property(nonatomic,strong) NSMutableArray <LPLendMechanismDataModel *>*listArray;

@property(nonatomic,assign) NSInteger page;

@property(nonatomic,assign) NSInteger selectCell;
@property (nonatomic,strong) LPUserProblemModel *Pmodel;

@property(nonatomic,assign) NSInteger isShowPhone;

@end

@implementation LPLendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"借支";
    self.userUrl = @"";
    self.recordView.hidden = YES;
    self.tableview.hidden = YES;
    self.page = 1;
    self.selectCell = -1;
    self.CompanyTextField.superview.layer.cornerRadius = 6;
    self.CompanyTextField.superview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.CompanyTextField.superview.layer.borderWidth = 1;
    self.CompanyTextField.delegate = self;
 
    
    self.PhoneTextField.superview.layer.cornerRadius = 6;
    self.PhoneTextField.superview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.PhoneTextField.superview.layer.borderWidth = 1;
    self.PhoneTextField.delegate = self;
    
    self.lendTextField.superview.layer.cornerRadius = 6;
    self.lendTextField.superview.layer.borderColor = [UIColor whiteColor].CGColor;
    self.lendTextField.superview.layer.borderWidth = 1;
    
    self.LendImageView.layer.cornerRadius = 6;
    self.LendImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.LendImageView.layer.borderWidth = 1;
    
    self.lendButton.layer.cornerRadius = 4;
    
//    self.ImageBT.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.recordView);
//        make.top.mas_equalTo(140);
//        make.left.mas_equalTo(0);
//        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.CompanyTableView];
    [self.CompanyTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(335);
    }];
    self.CompanyTableView.hidden = YES;
    self.bgView.hidden = YES;
    [self requestQueryLendMoneyMechanism];
//     [self requestQueryIsLend];
    [self requestQueryLendApi];
    [self requestQueryLendMoneyType];
//    [self requestQueryGetUserProdlemList];

}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
     //返回一个BOOL值，指定是否循序文本字段开始编辑
    if (textField == self.CompanyTextField) {
        self.CompanyTableView.hidden = !self.CompanyTableView.hidden;
        self.bgView.hidden = self.CompanyTableView.hidden;
        [self.lendTextField resignFirstResponder];
        [self.PhoneTextField resignFirstResponder];

        return NO;
    }
    return YES;
}
-(void)hiddenCompanyTableView{
    self.CompanyTableView.hidden = !self.CompanyTableView.hidden;
    self.bgView.hidden = self.CompanyTableView.hidden;
    
}

#pragma mark - textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.PhoneTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.PhoneTextField.text.length >= 11) {
            self.PhoneTextField.text = [textField.text substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

#pragma mark - TableViewDelegate & Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.CompanyTableView) {
        return self.listArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableview) {

        CGFloat str1H = [LPTools calculateRowHeight:@"借支金额%@元，我们将在1-3个工作日内完成审核" fontSize:13.0 Width:SCREEN_WIDTH- 66.0];
        
        CGFloat remarksH = [LPTools calculateRowHeight:self.model.data.remarks fontSize:13.0 Width:SCREEN_WIDTH- 66.0];
        
        CGFloat timeW = [LPTools widthForString:[self.model.data.set_time stringValue] fontSize:11.0 andHeight:20.0];
        
        CGFloat str2H = [LPTools calculateRowHeight:self.model.data.status.integerValue == 2?@"失败":@"审核通过，系统已转账，请注意查收" fontSize:17.0 Width:SCREEN_WIDTH-timeW-13];
        return 364+str1H+remarksH+str2H;
        
    }
    return 60;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.CompanyTableView) {
        LPMapLocCell *cell = [tableView dequeueReusableCellWithIdentifier:LPMapLocCellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(cell == nil){
            cell = [[LPMapLocCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPMapLocCellID];
        }
        LPLendMechanismDataModel *model = self.listArray[indexPath.row];
        cell.AddName.text = model.mechanismName;
        cell.AddDetail.text = @"";
        cell.SelectBt.hidden = YES;
        [cell.SelectBt setImage:[UIImage imageNamed:@"select_slices"] forState:UIControlStateNormal];

        if (self.selectCell == indexPath.row) {
            cell.AddName.textColor = [UIColor baseColor];
            cell.SelectBt.hidden = NO;
        }else{
            cell.AddName.textColor = [UIColor blackColor];
            cell.SelectBt.hidden = YES;
        }
        
        return cell;
    }
    
    LPLendCell *cell = [tableView dequeueReusableCellWithIdentifier:LPTLendAuditCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(cell == nil){
        cell = [[LPLendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LPTLendAuditCellID];
    }
    
    cell.model = self.model;
    WEAK_SELF()
    cell.Block = ^(void) {
        [weakSelf touchBottomButton:nil];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.CompanyTableView) {
        self.selectCell = indexPath.row;
        [self.CompanyTableView reloadData];
        self.CompanyTextField.text = self.listArray[indexPath.row].mechanismName;
        self.CompanyTextField.tag = self.listArray[indexPath.row].id.integerValue;
        [self requestQueryLendApi];
        [self hiddenSelect];
    }
}


-(void)setModel:(LPQueryCheckrecordModel *)model{
    _model = model;
     if (model.data) {
        self.recordView.hidden = NO;
         self.tableview.hidden = NO;
         [self.tableview reloadData];
    }
    
    self.text1.text = @"";
    self.text2.text = @"";
    self.text3.text = @"";
    self.time1.text = @"";
    self.time2.text = @"";
    self.time3.text = @"";

    if (model.data.status.integerValue == 0) {
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_normal"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney];
        [self.bottomButton setTitle:@"返回" forState:UIControlStateNormal];

    }else if (model.data.status.integerValue == 1){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"add_ record_selected"];
        
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.set_time stringValue]];

//        self.text3.text = @"借支金额将在1个工作日内发放至您的工资卡，如遇节假日时间顺延。";
        self.text3.text = [NSString stringWithFormat:@"%@",model.data.remarks];

        [self.bottomButton setTitle:@"再借一笔" forState:UIControlStateNormal];
    }else if (model.data.status.integerValue == 2){
        self.img1.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img2.image = [UIImage imageNamed:@"add_ record_selected"];
        self.img3.image = [UIImage imageNamed:@"deleteCard"];
        self.text1.text = [NSString stringWithFormat:@"借支金额%@元，我们将在1-3个工作日内完成审核",model.data.lendMoney?model.data.lendMoney:@"0"];
        self.text3.text = [NSString stringWithFormat:@"%@",model.data.remarks];
        self.time1.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time2.text = [NSString convertStringToTime:[model.data.time stringValue]];
        self.time3.text = [NSString convertStringToTime:[model.data.set_time stringValue]];
        [self.bottomButton setTitle:@"重新申请" forState:UIControlStateNormal];
    }
 
}


-(void)setMechanismModel:(LPLendMechanismModel *)MechanismModel{
    _MechanismModel = MechanismModel;
    if ([self.MechanismModel.code integerValue] == 0) {
        self.listArray = [NSMutableArray array];
        [self.listArray addObjectsFromArray:self.MechanismModel.data];
        [self.CompanyTableView reloadData];
        
//        if (self.page == 1) {
//            self.listArray = [NSMutableArray array];
//        }
//        if (self.MechanismModel.data.count > 0) {
//            self.page += 1;
//            [self.listArray addObjectsFromArray:self.MechanismModel.data];
//            [self.CompanyTableView reloadData];
//
//        }else{
//            if (self.page == 1) {
//                [self.CompanyTableView reloadData];
//            }else{
//                [self.CompanyTableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        }
        
        if (self.listArray.count == 0) {
//            [self addNodataViewHidden:NO];
        }else{
//            [self addNodataViewHidden:YES];
        }
    }else{
        [self.view showLoadingMeg:NETE_ERROR_MESSAGE time:MESSAGE_SHOW_TIME];
    }
}


- (IBAction)touchLendButton:(UIButton *)sender {
    
    self.PhoneTextField.text = [self.PhoneTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    if (self.CompanyTextField.text.length <= 0) {
        [self.view showLoadingMeg:@"请选择企业！" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.lendTextField.text.floatValue==0.0) {
        [self.view showLoadingMeg:@"请输入借支金额" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.lendTextField.text.integerValue > self.lendMoney.integerValue) {
        [self.view showLoadingMeg:@"输入的金额应不大于借支额度" time:MESSAGE_SHOW_TIME];
        return;
    }
    
    if (self.isShowPhone == 1) {
        if (self.PhoneTextField.text.length <= 0 || ![NSString isMobilePhoneNumber:self.PhoneTextField.text]) {
            [self.view showLoadingMeg:@"请输入正确的手机号" time:MESSAGE_SHOW_TIME];
            return;
        }
    }
   
    

    [self requestQueryAddLendApi];
    
}
- (IBAction)touchBottomButton:(UIButton *)sender {
    if (self.model.data.status.integerValue == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self requestQueryGetRefuseLendDay];
    }
}

- (IBAction)TouchImageBT:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
#if (TARGET_IPHONE_SIMULATOR)
                                                          
#else
                                                          [self takePhoto];
#endif
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选择"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          [self choosePhoto];
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          
                                                      }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - UIImagePickerControllerDelegate
-(void)takePhoto{
    
    //#if (TARGET_IPHONE_SIMULATOR)
    //
    //#else
    //    [self startDevice];
    //#endif
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请进入设置-隐私-相机-中打开相机权限"
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        return;
    }
    
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)choosePhoto{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePicker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}


- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"headImage.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *headImage = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    [self updateHeadImage:headImage];
}
// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark - updateImage
-(void)updateHeadImage:(UIImage *)image{
    [NetApiManager avartarChangeWithParamDict:nil singleImage:image singleImageName:@"file" withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if (responseObject[@"data"]) {
                self.userUrl = responseObject[@"data"];
                [self.ImageBT yy_setImageWithURL:[NSURL URLWithString:self.userUrl] forState:UIControlStateNormal options:YYWebImageOptionProgressive];
             }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


#pragma mark - request
-(void)requestQueryIsLend{
    [NetApiManager requestQueryIsLendWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] isKindOfClass:[NSDictionary class]]) {
                    if (responseObject[@"data"][@"res_code"]) {
                        if ([responseObject[@"data"][@"res_code"] integerValue] != 0) {
                            GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"data"][@"res_msg"] message:nil backDismiss:NO textAlignment:0 buttonTitles:@[@"确定"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }];
                            [alert show];
                        }
                        if ([responseObject[@"data"][@"res_code"] integerValue] == 0) {
                            if (responseObject[@"data"][@"lendMoney"]) {
                                self.lendMoneyLabel.text = [NSString stringWithFormat:@"借支额度：%@",responseObject[@"data"][@"lendMoney"]];
                                self.lendMoney = responseObject[@"data"][@"lendMoney"];
                                [self requestQueryCheckrecord];
                            }
                        }
                    }
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}
-(void)requestQueryCheckrecord{
    [NetApiManager requestQueryCheckrecordWithParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.model = [LPQueryCheckrecordModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestAddLendmoney{
    NSString *url = [NSString stringWithFormat:@"lendmoney/add_lendmoney?lendMoney=%@",self.lendTextField.text];
    [NetApiManager requestSaveOrUpdateWithParam:url withParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"] integerValue]== 1)
                {
                    [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
                    [self requestQueryIsLend];
                }else{
                    [self.view showLoadingMeg:@"发送失败" time:MESSAGE_SHOW_TIME];
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }

        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
 
}

-(void)requestQueryAddLendApi{
    
    
    NSString *url = [NSString stringWithFormat:@"lendmoney/add_lendmoney_api?lendMoney=%@&mechanismId=%ld&teacherTel=%@&userWorkImage=%@",self.lendTextField.text,(long)self.CompanyTextField.tag,self.PhoneTextField.text,self.userUrl];

    [NetApiManager requestQueryAddLendApi:url withParam:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue]== 0)
            {
                if ([responseObject[@"data"] integerValue]== 1) {
                    [self.view showLoadingMeg:@"发送成功" time:MESSAGE_SHOW_TIME];
//                    [self requestQueryLendApi];
                    [self requestQueryCheckrecord];

                }else{
                    [self.view showLoadingMeg:@"申请借支失败，请稍后再试" time:MESSAGE_SHOW_TIME];
                }
                
            }else{
                 [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];

}

-(void)requestQueryLendApi{
    NSDictionary *dic = @{@"mechanismId":self.CompanyTextField.tag?[NSString stringWithFormat:@"%ld",(long)self.CompanyTextField.tag]:@""};
    
    [NetApiManager requestQueryLendApi:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                if ([responseObject[@"data"][@"res_code"] integerValue] != 0) {
                    GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:responseObject[@"data"][@"res_msg"]
                                                                         message:nil
                                                                     backDismiss:NO
                                                                   textAlignment:0
                                                                    buttonTitles:@[@"确定"]
                                                                    buttonsColor:@[[UIColor baseColor]]
                                                         buttonsBackgroundColors:@[[UIColor whiteColor]]
                                                                     buttonClick:^(NSInteger buttonIndex) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert show];
                }else{
                    if (self.CompanyTextField.tag == 0) {
                        self.lendMoneyLabel.text = @"借支额度：***";
                        [self requestQueryCheckrecord];
                        self.lendMoney = 0;
                    }else{
                        self.lendMoneyLabel.text = [NSString stringWithFormat:@"借支额度：%ld",[responseObject[@"data"][@"lendMoney"] integerValue]];
                        self.lendMoney = [NSString stringWithFormat:@"%ld",[responseObject[@"data"][@"lendMoney"] integerValue]];
                    }
                   
                }
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
         }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryLendMoneyMechanism{
    NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%ld",(long)self.page]};
    [NetApiManager requestQueryLendMoneyMechanism:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        [self.CompanyTableView.mj_header endRefreshing];
        [self.CompanyTableView.mj_footer endRefreshing];
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.MechanismModel = [LPLendMechanismModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

-(void)requestQueryGetRefuseLendDay{
    [NetApiManager requestQueryGetRefuseLendDay:nil withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"data"] integerValue] == 1 && [responseObject[@"code"] integerValue] == 0) {
                self.recordView.hidden = YES;
                self.tableview.hidden = YES;
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

- (void)setPmodel:(LPUserProblemModel *)Pmodel{
    _Pmodel = Pmodel;
    if (Pmodel.data.count == 0) {
        NSString *str1 = @"为了您的账号安全，请先设置密保问题。";
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:str1];
        WEAK_SELF()
        GJAlertMessage *alert = [[GJAlertMessage alloc]initWithTitle:str message:nil IsShowhead:YES textAlignment:0 buttonTitles:@[@"去设置"] buttonsColor:@[[UIColor baseColor]] buttonsBackgroundColors:@[[UIColor whiteColor]] buttonClick:^(NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                LPSetSecretVC *vc = [[LPSetSecretVC alloc] init];
                //                [self.navigationController pushViewController:vc animated:YES];
                NSMutableArray *naviVCsArr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
                for (UIViewController *vc in naviVCsArr) {
                    if ([vc isKindOfClass:[weakSelf class]]) {
                        [naviVCsArr removeObject:vc];
                        break;
                    }
                }
                [naviVCsArr addObject:vc];
                vc.hidesBottomBarWhenPushed = YES;
                
                [weakSelf.navigationController  setViewControllers:naviVCsArr animated:YES];
                
            }
        }];
        [alert show];
    }else{
    }
}


-(void)requestQueryGetUserProdlemList{
    
    NSDictionary *dic = @{};
    [NetApiManager requestQueryGetUserProdlemList:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                self.Pmodel = [LPUserProblemModel mj_objectWithKeyValues:responseObject];
            }else{
                [self.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [self.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}


-(void)requestQueryLendMoneyType{
    
    NSDictionary *dic = @{};
    WEAK_SELF()
    [NetApiManager requestQueryLendMoneyType:dic withHandle:^(BOOL isSuccess, id responseObject) {
        NSLog(@"%@",responseObject);
        if (isSuccess) {
            if ([responseObject[@"code"] integerValue] == 0) {
                weakSelf.isShowPhone = [responseObject[@"data"] integerValue];
                if ([responseObject[@"data"] integerValue] == 1) {
                    weakSelf.LayoutConstraint_Label_Height.constant = 15;
                    weakSelf.LayoutConstraint_Height.constant = 40;
                    weakSelf.LayoutConstraint_Label_Top.constant = 34;
                }else if ([responseObject[@"data"] integerValue] == 2){
                    weakSelf.LayoutConstraint_Label_Height.constant = 0;
                    weakSelf.LayoutConstraint_Height.constant = 0;
                    weakSelf.LayoutConstraint_Label_Top.constant = 0;

                }else{
                    [weakSelf.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
                }
            }else{
                [weakSelf.view showLoadingMeg:responseObject[@"msg"] time:MESSAGE_SHOW_TIME];
            }
        }else{
            [weakSelf.view showLoadingMeg:NETE_REQUEST_ERROR time:MESSAGE_SHOW_TIME];
        }
    }];
}

#pragma mark lazy
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = [[UIView alloc]init];
        _tableview.rowHeight = UITableViewAutomaticDimension;
        _tableview.estimatedRowHeight = 0;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.separatorColor = [UIColor colorWithHexString:@"#F1F1F1"];
        _tableview.backgroundColor = [UIColor whiteColor];
        [_tableview registerNib:[UINib nibWithNibName:LPTLendAuditCellID bundle:nil] forCellReuseIdentifier:LPTLendAuditCellID];
 
    }
    return _tableview;
}

- (UITableView *)CompanyTableView{
    if (!_CompanyTableView) {
        _CompanyTableView = [[UITableView alloc]init];
        _CompanyTableView.delegate = self;
        _CompanyTableView.dataSource = self;
        _CompanyTableView.tableFooterView = [[UIView alloc]init];
        _CompanyTableView.rowHeight = UITableViewAutomaticDimension;
        _CompanyTableView.estimatedRowHeight = 0;
        _CompanyTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _CompanyTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_CompanyTableView registerNib:[UINib nibWithNibName:LPMapLocCellID bundle:nil] forCellReuseIdentifier:LPMapLocCellID];
//        _CompanyTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                    [self requestQueryLendMoneyMechanism];
//                }];
    }
    return _CompanyTableView;
}

-(void)hiddenSelect{
     self.CompanyTableView.hidden = YES;
     self.bgView.hidden = YES;
}
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.5;
        _bgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelect)];
        [_bgView addGestureRecognizer:tap];
    }
    return _bgView;
}

@end
