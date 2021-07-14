//
//  LoginViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import "RegisterViewController.h"
#import "UserMessageModel.h"
#import <YYModel/YYModel.h>
#import "LoginViewController.h"
#import <SAMKeychain/SAMKeychain.h>
#import "YYText.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view setBackgroundColor:UIColor.whiteColor];
    UIImageView* imageview = [[UIImageView alloc]initWithFrame: CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 , self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
    [imageview setImage: [UIImage imageNamed:@"头条沉浸"]];
    [self.view addSubview:imageview];
    
    self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3 * 2, self.view.frame.size.width / 2, self.view.frame.size.width / 4)];
    [self.titlelabel setText:@"欢迎注册"];
    [self.titlelabel setFont:[UIFont fontWithName:@"Courier-Bold" size:30]];
    [self.titlelabel setTextColor:UIColor.redColor];
    self.titlelabel.textAlignment = NSTextAlignmentCenter;
    
    self.userphone = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height / 2, self.view.frame.size.width / 2, 40)];
    self.userphone.borderStyle = UITextBorderStyleRoundedRect; //边框样式
    self.userphone.backgroundColor = [UIColor whiteColor];
    self.userphone.placeholder = @" 手机号";
    self.userphone.clearButtonMode = UITextFieldViewModeWhileEditing; //编辑时的叉号
    self.userphone.keyboardType = UIKeyboardTypeNamePhonePad;
    self.userphone.returnKeyType = UIReturnKeyNext;
    self.userphone.delegate = self;//用于声明代理，实现return按钮变成焦点转移按钮，代理方法是textFieldShouldReturn
//    self.userphone.layer.borderWidth = 1;//边框宽度,设置成0.01并不能隐藏边框
    //画出下划线
    UIView * userphoneLine=[[UIView alloc]initWithFrame:CGRectMake(0,self.userphone.frame.size.height-2, self.userphone.frame.size.width, 1)];
    userphoneLine.backgroundColor=[UIColor blackColor];
    [self.userphone addSubview:userphoneLine];
    //隐藏边框，输入框默认显示边框；按钮则默认不显示边框
    self.userphone.borderStyle = UITextBorderStyleNone;
    [self.userphone setBackgroundColor:[UIColor clearColor]];
    [self.userphone addTarget:self
              action:@selector(textFieldDidChangeValue:)
    forControlEvents:UIControlEventEditingChanged]; //触发框内容变化监听方法：textFieldDidChangeValue
    //userphone文本框左侧图片
    UIImageView * uimage=[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"person"]];
    [uimage setTintColor:UIColor.blackColor];
    self.userphone.leftView=uimage;
    self.userphone.leftViewMode = UITextFieldViewModeAlways;
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.height / 2 + 65, self.view.frame.size.width / 2, 40)];
    self.password.borderStyle = UITextBorderStyleRoundedRect;
    self.password.backgroundColor = [UIColor whiteColor];
    self.password.placeholder = @" 密码";
    self.password.clearsOnBeginEditing = YES; //再次编辑就清空
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.password.keyboardType = UIKeyboardTypeDefault;
    self.password.secureTextEntry = YES;
    self.password.delegate = self; //用于声明代理，实现return按钮变成隐藏键盘按钮
//    self.password.layer.borderWidth = 1;
    //边框变成下划线
    UIView * passwordLine=[[UIView alloc]initWithFrame:CGRectMake(0,self.password.frame.size.height-2, self.password.frame.size.width, 1)];
    passwordLine.backgroundColor=[UIColor blackColor];
    [self.password addSubview:passwordLine];
    self.password.borderStyle = UITextBorderStyleNone;
    [self.password setBackgroundColor:[UIColor clearColor]];
    //左侧图片
    UIImageView * pimage=[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"key"]];
    [pimage setTintColor:UIColor.blackColor];
    self.password.leftView=pimage;
    self.password.leftViewMode = UITextFieldViewModeAlways;
    
    self.registerbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + self.view.frame.size.height / 2 , self.view.frame.size.width / 3, 40)];
    self.registerbutton.backgroundColor = UIColor.lightGrayColor; //tintColor是边框颜色
    [self.registerbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.registerbutton.layer.cornerRadius = 20;//（该值到一定的程度，就为圆形了。）
    [self.registerbutton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerbutton addTarget:self action:@selector(registerfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点触发事件
    
#pragma mark 隐私政策
    NSString *readme = @"注册代表您同意“用户协议”和“隐私政策”";
    NSMutableAttributedString *readmeAttr = [[NSMutableAttributedString alloc] initWithString: readme];
    NSRange range1 = [readme rangeOfString:@"用户协议"];
    [readmeAttr yy_setTextHighlightRange:range1 color:UIColor.blueColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"跳转navigation超链接-用户协议");
    }];
    NSRange range2 = [readme rangeOfString:@"隐私政策"];
    [readmeAttr yy_setTextHighlightRange:range2 color:UIColor.blueColor backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        NSLog(@"跳转navigation超链接-隐私政策");
    }];
    YYLabel *label = [[YYLabel alloc] init];
    label.attributedText = readmeAttr;
    label.frame = CGRectMake(0,self.view.frame.size.height - 60 - 20, self.view.frame.size.width, 15);
    label.textAlignment = NSTextAlignmentCenter;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 1;
    label.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:label];
    [self.view addSubview:self.userphone];
    [self.view addSubview:self.password];
    [self.view addSubview:self.registerbutton];
    [self.view addSubview:self.error];
    [self.view addSubview:imageview];
    [self.view addSubview:self.titlelabel];
}




//代理方法，调用此方法能将键盘往下收
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if(textField == self.userphone){
        [self.password becomeFirstResponder]; //手机号输完回车就是跳到密码框
    }
    if(textField == self.password){
        [self.password resignFirstResponder]; //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    }
    return YES;

}

//手机号输入框内容发生改变监听事件，注意这里是textfield添加了addtarget。（我以前以为只有button才能addtarget的）。
- (void)textFieldDidChangeValue:(id)sender
{
    NSLog(@"手机号输入框内容发生改变");
    self.error.hidden = YES; //一旦输入就取消提示
    if(self.userphone.text == nil || [self.userphone.text isEqual:@""]){
        self.isRegisterAlive = NO;
        self.registerbutton.backgroundColor = UIColor.lightGrayColor; //tintColor是边框颜色
        [self.registerbutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        //激活按钮
        self.isRegisterAlive = YES;
        self.registerbutton.backgroundColor = UIColor.redColor; //tintColor是边框颜色
        [self.registerbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}


- (void) registerfunc: (id)sender{
    NSLog(@"点击了注册，存入用户名和密码进入keychain，此页面将消失，调用代理方法给登录页面传值/通知登录页面已经有数据了，登录页面再通知调用登录页面的页面");
    UserMessageModel * usermodel = [[UserMessageModel alloc]init];
    usermodel.userphone = [self.userphone.text mutableCopy];
    usermodel.token = [self.password.text mutableCopy];
    //注册目前只存入用户名和密码
    
    NSString * Users = [[SAMKeychain passwordForService:@"ManyUsers" account:@"toutiaoim"] mutableCopy];
    NSMutableDictionary * usersdict;//dict就是JSON
    if(Users == nil){
        usersdict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"hello",@"world",
                                                                      usermodel.yy_modelToJSONString,self.userphone.text, nil
                     ]; //存入key:world;value:hello
    }
    else{
        usersdict = [[LoginViewController TransferFromNSStringToNSDict:Users] mutableCopy];
        [usersdict setValue:usermodel.yy_modelToJSONString forKey:self.userphone.text]; //添加当前账号密码进入ManyUsers这个模拟远程库,手机号唯一不能重复，否则覆盖
    }
    [SAMKeychain setPassword:usersdict.yy_modelToJSONString forService:@"ManyUsers" account:@"toutiaoim"]; //模拟远程库用户表喜加一
    
    [SAMKeychain setPassword:usermodel.yy_modelToJSONString forService:@"NowUser" account:@"toutiaoim"];   //（覆盖）当前用户本地真实库
    
    //通知已经注册完毕
    if (self.delegate && [self.delegate respondsToSelector:@selector(notification:)]) {
        [self.delegate notification:usermodel.yy_modelToJSONString]; //调用代理此类的那个类的重写代理方法，将model数据传过去
        NSLog(@"注册页面调用了代理方法%@",usermodel.yy_modelToJSONString);
    }
    else{
        NSLog(@"注册页面没有调用此登陆页面实现的回调方法");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
