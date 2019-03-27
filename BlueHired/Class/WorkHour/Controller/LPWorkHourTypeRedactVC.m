//
//  LPWorkHourTypeRedactVC.m
//  BlueHired
//
//  Created by iMac on 2019/2/27.
//  Copyright © 2019 lanpin. All rights reserved.
//

#import "LPWorkHourTypeRedactVC.h"

@interface LPWorkHourTypeRedactVC ()<UITextFieldDelegate>
@property (nonatomic,strong) UILabel *Label1;
@property (nonatomic,strong) UILabel *Label2;

@property (nonatomic,strong) UIImageView *Image;
@property (nonatomic,strong) UIImageView *Image2;

@property (nonatomic,strong) UITextField *TextField;
@property (nonatomic,strong) UITextField *TextField2;

@property (nonatomic,strong) UILabel *TitleLabel;

//@property (nonatomic,strong) UIView *LineView;

@end


@implementation LPWorkHourTypeRedactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 禁用返回手势
    self.rt_disableInteractivePop = true;
    self.rt_navigationController.rt_disableInteractivePop = true;

    [self setViewUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)setViewUI{
    
    //输入框编辑view
    UIView *ToolTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
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

    if (self.ClassType == 0) {              //企业底薪编辑
        self.navigationItem.title = @"企业底薪编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取企业底薪";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"企业底薪(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.Image = imageView;
        [self.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.enabled = NO;
        textField.delegate = self;

        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前获取的是您已设置好的企业底薪";
        
        
        
        
    }else if (self.ClassType == 1){     //加班工资编辑
        self.navigationItem.title = @"加班工资编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        self.Label1 = Label1;
        [self.view addSubview:Label1];
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取加班工资";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"加班工资合计(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.enabled = NO;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前显示的加班工资是根据您记录的加班数据计算得出的";
        
        
        
    }else if (self.ClassType == 2){     //所得税编辑
        self.navigationItem.title = @"所得税编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"自动计算个人所得税";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"个人所得税合计(元)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.enabled = NO;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前显示的个人所得税是按照最新税法计算得出的";
        
        
    }else if (self.ClassType == 3){     //事假编辑
        self.navigationItem.title = @"事假编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取事假小时数";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"事假金额(元/时)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label3 = [[UILabel alloc] init];
        [self.view addSubview:Label3];
        [Label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label3.font = [UIFont systemFontOfSize:16];
        Label3.text = @"本月事假小时数(时)";
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [self.view addSubview:imageView2];
        self.Image2 = imageView2;
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label3);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView2.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        
        UITextField *textField2 = [[UITextField alloc] init];
        [self.view addSubview:textField2];
        self.TextField2 = textField2;
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(imageView2);
            make.right.equalTo(imageView2.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.textAlignment = NSTextAlignmentRight;
        textField2.inputAccessoryView = ToolTextView;
        textField2.enabled = NO;
        textField2.delegate = self;
        
        UIView *lineView3 = [[UIView alloc] init];
        [self.view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label3.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView3.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前获取的是您已记录的事假小时数";
        
    }else if (self.ClassType == 4){     //调休假编辑
        self.navigationItem.title = @"调休假编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取调休假小时数";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"调休假金额(元/时)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label3 = [[UILabel alloc] init];
        [self.view addSubview:Label3];
        [Label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label3.font = [UIFont systemFontOfSize:16];
        Label3.text = @"本月调休假小时数(时)";
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [self.view addSubview:imageView2];
        self.Image2 = imageView2;
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label3);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView2.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField2 = [[UITextField alloc] init];
        [self.view addSubview:textField2];
        self.TextField2 = textField2;
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(imageView2);
            make.right.equalTo(imageView2.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.textAlignment = NSTextAlignmentRight;
        textField2.inputAccessoryView = ToolTextView;
        textField2.enabled = NO;
        textField2.delegate = self;
        
        UIView *lineView3 = [[UIView alloc] init];
        [self.view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label3.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView3.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前获取的是您已记录的调休假小时数";
        
        
    }else if (self.ClassType == 5){     //病假编辑
        self.navigationItem.title = @"病假编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取病假小时数";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"病假金额(元/时)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label3 = [[UILabel alloc] init];
        [self.view addSubview:Label3];
        [Label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label3.font = [UIFont systemFontOfSize:16];
        Label3.text = @"本月病假小时数(时)";
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [self.view addSubview:imageView2];
        self.Image2 = imageView2;
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label3);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView2.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField2 = [[UITextField alloc] init];
        [self.view addSubview:textField2];
        self.TextField2 = textField2;
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(imageView2);
            make.right.equalTo(imageView2.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.textAlignment = NSTextAlignmentRight;
        textField2.inputAccessoryView = ToolTextView;
        textField2.enabled = NO;
        textField2.delegate = self;
        
        UIView *lineView3 = [[UIView alloc] init];
        [self.view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label3.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView3.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前获取的是您已记录的病假小时数";
        
        
    }else if (self.ClassType == 6){     //其他假编辑
        self.navigationItem.title = @"其他假编辑";
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = @"获取其他假小时数";
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"其他假金额(元/时)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label3 = [[UILabel alloc] init];
        [self.view addSubview:Label3];
        [Label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label3.font = [UIFont systemFontOfSize:16];
        Label3.text = @"本月其他假小时数(时)";
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [self.view addSubview:imageView2];
        self.Image2 = imageView2;
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label3);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView2.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        
        UITextField *textField2 = [[UITextField alloc] init];
        [self.view addSubview:textField2];
        self.TextField2 = textField2;
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(imageView2);
            make.right.equalTo(imageView2.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.textAlignment = NSTextAlignmentRight;
        textField2.inputAccessoryView = ToolTextView;
        textField2.enabled = NO;
        textField2.delegate = self;
        
        UIView *lineView3 = [[UIView alloc] init];
        [self.view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label3.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView3.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：当前获取的是您已记录的其他假小时数";
        
        
    }else if (self.ClassType == 7){     //白班补贴编辑
        self.navigationItem.title = [NSString stringWithFormat:@"%@补贴编辑",self.ShiftAllowance];
        UILabel *Label1 = [[UILabel alloc] init];
        [self.view addSubview:Label1];
        self.Label1 = Label1;
        [Label1 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label1.font = [UIFont systemFontOfSize:16];
        Label1.text = [NSString stringWithFormat:@"获取已记录的%@天数",self.ShiftAllowance];
        
        UISwitch *Switch = [[UISwitch alloc] init];
        [self.view addSubview:Switch];
        [Switch mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label1);
            make.right.mas_equalTo(-13);
        }];
        Switch.onTintColor = [UIColor baseColor];
        Switch.on = YES;
        [Switch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label1.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = [NSString stringWithFormat:@"%@补贴金额(元/天)",self.ShiftAllowance];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];
        
        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *Label3 = [[UILabel alloc] init];
        [self.view addSubview:Label3];
        [Label3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label3.font = [UIFont systemFontOfSize:16];
        Label3.text = [NSString stringWithFormat:@"本月%@天数(天)",self.ShiftAllowance];
        
        UIImageView *imageView2 = [[UIImageView alloc] init];
        [self.view addSubview:imageView2];
        self.Image2 = imageView2;
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label3);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(0);
        }];
        imageView2.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        UITextField *textField2 = [[UITextField alloc] init];
        [self.view addSubview:textField2];
        self.TextField2 = textField2;
        [textField2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(imageView2);
            make.right.equalTo(imageView2.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField2.keyboardType = UIKeyboardTypeDecimalPad;
        textField2.textAlignment = NSTextAlignmentRight;
        textField2.inputAccessoryView = ToolTextView;
        textField2.enabled = NO;
        textField2.delegate = self;
        
        UIView *lineView3 = [[UIView alloc] init];
        [self.view addSubview:lineView3];
        [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label3.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView3.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView3.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = [NSString stringWithFormat:@"提示：请输入该企业%@补贴金额",self.ShiftAllowance];
        
        
    }else if (self.ClassType == 8){     //餐费补贴编辑
        self.navigationItem.title = @"餐费补贴编辑";
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"餐费补贴(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：请输入该企业餐费补贴金额";
        
        
    }else if (self.ClassType == 9){     //其他扣款编辑
        self.navigationItem.title = @"其他扣款编辑";
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"其他扣款(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"";
        
        
    }else if (self.ClassType == 10){     //公积金编辑
        self.navigationItem.title = @"公积金编辑";
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"公积金(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：请输入您需要缴纳的公积金金额";
        
        
    }else if (self.ClassType == 11){     //社保编辑
        self.navigationItem.title = @"社保编辑";
        
        UILabel *Label2 = [[UILabel alloc] init];
        [self.view addSubview:Label2];
        self.Label2 = Label2;
        [Label2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.mas_offset(0);
            make.left.mas_equalTo(13);
            make.height.mas_equalTo(46);
        }];
        Label2.font = [UIFont systemFontOfSize:16];
        Label2.text = @"社保金额(元/月)";
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.view addSubview:imageView];
        self.Image = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.mas_equalTo(-13);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(16);
        }];
        imageView.image = [UIImage imageNamed:@"WorkHourRedactimage"];

        UITextField *textField = [[UITextField alloc] init];
        [self.view addSubview:textField];
        self.TextField = textField;
        [textField mas_makeConstraints:^(MASConstraintMaker *make){
            make.centerY.equalTo(Label2);
            make.right.equalTo(imageView.mas_left).offset(-8);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo(100);
        }];
        textField.keyboardType = UIKeyboardTypeDecimalPad;
        textField.textAlignment = NSTextAlignmentRight;
        textField.inputAccessoryView = ToolTextView;
        textField.delegate = self;
        
        UIView *lineView2 = [[UIView alloc] init];
        [self.view addSubview:lineView2];
        [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(Label2.mas_bottom).offset(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        lineView2.backgroundColor =[UIColor colorWithHexString:@"#E6E6E6"];
        
        
        UILabel *TitleLabel = [[UILabel alloc] init];
        [self.view addSubview:TitleLabel];
        self.TitleLabel = TitleLabel;
        [TitleLabel mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(lineView2.mas_bottom).offset(10);
            make.left.right.mas_equalTo(13);
            make.right.right.mas_equalTo(-13);
        }];
        TitleLabel.font = [UIFont systemFontOfSize:13];
        TitleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        TitleLabel.numberOfLines = 0;
        TitleLabel.text = @"提示：请输入您需要缴纳的社保金额";
    }
    

}



-(void)TouchTextDone:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)TouchTextCancel:(UIButton *)sender{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

-(void)switchAction:(UISwitch *)sender
{
    NSLog(@"%d",sender.isOn);
    if (self.ClassType == 0) {
        [self.Image mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前获取的是您已设置好的企业底薪":@"提示：请自定义输入您本月的企业底薪";
        self.TextField.enabled = !sender.isOn;
    }else if (self.ClassType == 1){
        [self.Image mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前显示的加班工资是根据您记录的加班数据计算得出的":@"提示：请自定义输入您本月的加班工资";
        self.TextField.enabled = !sender.isOn;
    }else if (self.ClassType == 2){
        [self.Image mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示:当前显示的个人所得税是按照最新税法计算得出的":@"提示:请自定义输入您的个人所得税";
        self.TextField.enabled = !sender.isOn;
    }else if (self.ClassType == 3){
        [self.Image2 mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前获取的是您已记录的事假小时数":@"提示：当前获取的是您已记录的事假小时数";
        self.TextField2.enabled = !sender.isOn;
    }else if (self.ClassType == 4){
        [self.Image2 mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前获取的是您已记录的调休假小时数":@"提示：当前获取的是您已记录的调休假小时数";
        self.TextField2.enabled = !sender.isOn;
    }else if (self.ClassType == 5){
        [self.Image2 mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前获取的是您已记录的病假小时数":@"提示：当前获取的是您已记录的病假小时数";
        self.TextField2.enabled = !sender.isOn;
    }else if (self.ClassType == 6){
        [self.Image2 mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?@"提示：当前获取的是您已记录的其他假小时数":@"提示：当前获取的是您已记录的其他假小时数";
        self.TextField2.enabled = !sender.isOn;
    }else if (self.ClassType == 7){
        [self.Image2 mas_updateConstraints:^(MASConstraintMaker *make){
            make.width.mas_equalTo(sender.isOn?0:16);
        }];
        self.TitleLabel.text = sender.isOn?[NSString stringWithFormat:@"提示：请输入该企业%@补贴金额",self.ShiftAllowance]:[NSString stringWithFormat:@"提示：请输入该企业%@补贴金额以及本月%@天数",self.ShiftAllowance,self.ShiftAllowance];
        self.TextField2.enabled = !sender.isOn;
    }
}




#pragma mark - tagter
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
    if (range.length == 1 && string.length == 0) {
        return YES;
    }
    if (textField == self.TextField || textField == self.TextField2) {
        NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];
        //匹配以0开头的数字
        NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];
        //匹配两位小数、整数
        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
        return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] && str.length <=7? YES : NO;
    }
    return YES;
}

@end
