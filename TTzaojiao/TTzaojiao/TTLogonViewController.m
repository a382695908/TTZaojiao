//
//  TTLogonViewController.m
//  TTzaojiao
//
//  Created by hegf on 15-4-17.
//  Copyright (c) 2015年 hegf. All rights reserved.
//

#import "TTLogonViewController.h"

@interface TTLogonViewController ()
{
    CGFloat _backBottonBarY;
}

@property (weak, nonatomic) IBOutlet UIButton *savePassworkCheckButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)backLogRegPage:(UIButton *)sender;
- (IBAction)Logon:(UIButton *)sender;
- (IBAction)savePasswordCheck:(UIButton *)sender;

@end

@implementation TTLogonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加低栏
    [self addBottomBar];
    //注册键盘通知
    [self addKeyNotification];
    //设置记住密码按钮
    [self setupSavePassworkButton];
    
    
}
#pragma mark 设置记住密码按钮
-(void)setupSavePassworkButton{
    [_savePassworkCheckButton setImage:[UIImage imageNamed:@"pic_unchecked"] forState:UIControlStateNormal];
    [_savePassworkCheckButton setImage:[UIImage imageNamed:@"pic_checked"] forState:UIControlStateSelected];
}
#pragma mark 添加低栏
-(void)addBottomBar{
    CGFloat h = self.view.frame.size.height*44/600;
    CGFloat w = self.view.frame.size.width;
    CGFloat y = self.view.frame.size.height -  h;
    CGFloat x = 0;
    _bottomBar.frame = CGRectMake(x, y, w, h);
    _backBottonBarY = y;
    [self.view addSubview:_bottomBar];
    
}
#pragma mark 注册键盘通知
-(void)addKeyNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}


//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//键盘的frame
    CGFloat offY = (self.view.frame.size.height-keyboardSize.height)-_bottomBar.frame.size.height;//屏幕总高度-键盘高度-bottomBar高度
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame =  _bottomBar.frame;
        frame.origin.y =  offY;//UITextField位置的y坐标移动到offY
        _bottomBar.frame = frame;
    }];

}
//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame =  _bottomBar.frame;
        frame.origin.y =  _backBottonBarY;
        _bottomBar.frame = frame;
    }];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];//移除观察者
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 返回登录注册页面
- (IBAction)backLogRegPage:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 登录
- (IBAction)Logon:(UIButton *)sender {
    NSString* account = _account.text;
    NSString* password = _password.text;
    if (account.length == 0 || password.length == 0) {
        [[[UIAlertView alloc]init] showWithTitle:@"友情提示" message:@"账号或密码不能为空" cancelButtonTitle:@"重新输入"];
    }else{
        NSDictionary* parameters = @{
                                     @"name": account,
                                     @"password": password
                                     };
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[AFAppDotNetAPIClient sharedClient]apiGet:LOGIN Parameters:parameters Result:^(id result_data, ApiStatus result_status, NSString *api) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (result_status == ApiStatusSuccess) {
                if ([result_data isKindOfClass:[NSMutableArray class]]) {
                    UserModel* user = result_data[0];
                    [TTUserModelTool sharedUserModelTool].logonUser = user;
                    NSLog(@"%@ %@", user.name, user.icon);
                    //保存用户名和密码
                    if(_savePassworkCheckButton.selected == YES)
                    {
                      
                    }
                }
                
            }else{
                if (result_status != ApiStatusNetworkNotReachable) {
                    [[[UIAlertView alloc]init] showWithTitle:@"友情提示" message:@"服务器好像罢工了" cancelButtonTitle:@"重试一下"];
                }
            };
        }];
    }
    
}

#pragma mark 记住密码
- (IBAction)savePasswordCheck:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)endEdit:(UITextField *)sender {
    [_password resignFirstResponder];
    [_account resignFirstResponder];
}

#pragma mark 点击背景隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_password resignFirstResponder];
    [_account resignFirstResponder];
}
@end
