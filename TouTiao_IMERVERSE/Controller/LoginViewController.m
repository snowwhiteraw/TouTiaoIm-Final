//
//  RegisterViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import "LoginViewController.h"
#import "YYText.h"
#import "RegisterViewController.h"
#import "UserMessageModel.h"
#import <SAMKeychain/SAMKeychain.h>
#import <YYModel/YYModel.h>


@interface LoginViewController ()  <RegisterDelegate>


@end

@implementation LoginViewController



- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO; //隐藏bar
    self.navigationItem.hidesBackButton = YES;
    
    self.error = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 2 - 30, self.view.frame.size.width, 15)];
    [self.error setText:@"您输入的手机号或密码不正确"];
    self.error.textAlignment = NSTextAlignmentCenter;
    [self.error setTextColor:UIColor.redColor];
    self.error.hidden = YES;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isLoginAlive = NO;
    
    self.imageview = [[UIImageView alloc]initWithFrame: CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 , self.view.frame.size.width / 3, self.view.frame.size.width / 3)];
    [self.imageview setImage: [UIImage imageNamed:@"头条沉浸"]];
    
    self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 4, self.view.frame.size.width / 3 * 2, self.view.frame.size.width / 2, self.view.frame.size.width / 4)];
    [self.titlelabel setText:@"看见更大的世界"];
//    [self.titlelabel setFont:[UIFont boldSystemFontOfSize:30]];
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
    
    self.login = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + self.view.frame.size.height / 2 , self.view.frame.size.width / 3, 40)];
    self.login.backgroundColor = UIColor.lightGrayColor; //tintColor是边框颜色
    [self.login setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.login.layer.cornerRadius = 20;//（该值到一定的程度，就为圆形了。）
    [self.login setTitle:@"登陆" forState:UIControlStateNormal];
    [self.login addTarget:self action:@selector(loginfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点触发事件
    
    
    self.registerbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.width / 3 + self.view.frame.size.height / 2 + 60, self.view.frame.size.width / 3, 40)];
    self.registerbutton.backgroundColor = UIColor.whiteColor; //tintColor是边框颜色
    [self.registerbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.registerbutton.layer.cornerRadius = 20;//（该值到一定的程度，就为圆形了。）
    [self.registerbutton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerbutton addTarget:self action:@selector(registerfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点触发事件
    [self.registerbutton.layer setBorderWidth: 1.0]; //显示按钮边框（默认不显示，这点跟输入框相反）
    
    self.forget = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 3, self.view.frame.size.height - 60, self.view.frame.size.width / 3, 40)];
    self.forget.backgroundColor = UIColor.whiteColor; //tintColor是边框颜色
    [self.forget setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    self.forget.layer.cornerRadius = 20;//（该值到一定的程度，就为圆形了。）
    [self.forget setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forget addTarget:self action:@selector(forgetfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点触发事件
    
    self.close = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 80, 90, 50, 30)];
    self.close.backgroundColor = UIColor.whiteColor; //tintColor是边框颜色
//    [self.close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal]; //注意按钮状态是不会主动改变的，得你自己去监听事件去改状态
    [self.close setTitle:@"跳过" forState:UIControlStateNormal];
    [self.close setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.close addTarget:self action:@selector(closefunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点触发事件

#pragma mark 隐私政策
    NSString *readme = @"登陆代表您同意“用户协议”和“隐私政策”";
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
    [self.view addSubview:self.imageview];
    [self.view addSubview:self.userphone];
    [self.view addSubview:self.password];
    [self.view addSubview:self.login];
    [self.view addSubview:self.registerbutton];
    [self.view addSubview:self.forget];
    [self.view addSubview:self.close];
    [self.view addSubview:self.error];
}

- (void)viewDidLoad { //此页面初始化时只调用一次
    [super viewDidLoad];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void) loginfunc: (id)sender{
    self.error.hidden = YES;
    if(self.isLoginAlive == YES){
        //这里将要跳转
        NSLog(@"%@ %@",self.userphone.text,self.password.text);
        if([LoginViewController checkUserAndPass:self.userphone.text :self.password.text]  == YES){
            //验证成功，数据本来应该在联网端，但是这里就假装联网加载了用户全部数据了，返回给调用这个页面的页面所需的全部数据
            UserMessageModel * usermodel = [[UserMessageModel alloc]init];
            usermodel.userphone = [self.userphone.text mutableCopy];
            usermodel.token = [self.password.text mutableCopy];
            if (self.delegate && [self.delegate respondsToSelector:@selector(getUserMessageByDelegate:)]) {
                [self.delegate getUserMessageByDelegate:usermodel.yy_modelToJSONString]; //调用代理此类的那个类的重写代理方法，将model数据传过去
                NSLog(@"调用了代理方法");
            }
            NSLog(@"登陆成功！返回继承了LoginDelegate的父页面（也即Tabsvc）这些用户数据！");
            [SAMKeychain setPassword:usermodel.yy_modelToJSONString forService:@"NowUser" account:@"toutiaoim"];   //（覆盖）当前用户本地真实库
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            //显示提示框，提示登陆失败，哪也不跳转
            self.error.hidden = NO;
        }
    }
}

//静态方法，核验账户密码是否正确，如果正确将把联网数据存入self.userMessageModel中
+ (BOOL) checkUserAndPass:(NSString*)userphone :(NSString*)password{
    //按理说这里是要联网发送用户输入的用户名和密码到活的API进行联网验证的，并获取token一直保持记忆本地用户的，但是这里意思一下，一律只能登陆这里写死的账户和注册的账户（毕竟不存在的用户给他登陆是不对的，这里应该去注册）；登陆成功就得到个人头像和服务端给的该用户token，这个token是给相当于账户密码合为一体但是客户端没法解析出其中信息的，只能给服务端验证个人信息，从而给客户端需要的这个人的信息，作用是为了减轻（不存在的）服务端压力。注册的账户
    //联网发送，这里改为验证本地数据库和固定账户
    //注意：这里数据库已经相当于真实服务器的后台数据库了，联网是不可能联网的，这辈子都不可能联网的
    
    if([userphone isEqual:@"12345"] && [password isEqual:@"12345"]){//验证后台账号
        return YES;
    }
    
    //验证注册账号————这里本应该联网核验账号密码的，这里就将就下假装核对了，如果有对应的用户表就给登陆，否则不给
    NSString * Users = [[SAMKeychain passwordForService:@"ManyUsers" account:@"toutiaoim"] mutableCopy];
    if(Users == nil){
        NSLog(@"目前尚未有用户注册过");
        return NO;
    }
    else{
        NSDictionary * usersidct = [LoginViewController TransferFromNSStringToNSDict:Users];
        for (NSString *key in usersidct) {
            if(usersidct[key] == nil){ //密码为空的账号都是非法账号，直接不给登录，继续查找下一个
                continue;
            }
            UserMessageModel * model = [UserMessageModel yy_modelWithJSON:usersidct[key]];
            if([key isEqual:userphone] && [model.token isEqual:password]){
                return YES;
            }
        }

        
        return NO;
    }
}

//接将字符串转成字典
+ (NSDictionary*) TransferFromNSStringToNSDict:(NSString*)jsonstr{
    //注意，YYModel貌似没有直接将字符串转成字典的方法
    NSLog(@"字符串转成字典输入值：%@",jsonstr);
    NSData *jsonData = [jsonstr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err; //出错信息，这里白写了
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
}

- (void) registerfunc: (id)sender{
    NSLog(@"跳转注册界面");
    RegisterViewController * rvc = [[RegisterViewController alloc]init];
    rvc.delegate = self;
    [self.navigationController pushViewController:rvc animated:YES];
    [self.navigationController setNavigationBarHidden:YES animated:YES]; //隐藏要跳转过去的二级页面的导航栏，但是不隐藏一级页面的导航栏
}

- (void) forgetfunc: (id)sender{
   NSLog(@"跳转忘记界面：%@ %@",self.userphone.text,self.password.text);
}

- (void) closefunc: (id)sender{
    NSLog(@"关闭当前界面");
    [self.navigationController popViewControllerAnimated:YES];
}

//手机号输入框内容发生改变监听事件，注意这里是textfield添加了addtarget。（我以前以为只有button才能addtarget的）。
- (void)textFieldDidChangeValue:(id)sender
{
    NSLog(@"手机号输入框内容发生改变");
    self.error.hidden = YES; //一旦输入就取消提示
    if(self.userphone.text == nil || [self.userphone.text isEqual:@""]){
        self.isLoginAlive = NO;
        self.login.backgroundColor = UIColor.lightGrayColor; //tintColor是边框颜色
        [self.login setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else{
        //激活按钮
        self.isLoginAlive = YES;
        self.login.backgroundColor = UIColor.redColor; //tintColor是边框颜色
        [self.login setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}

//自定义的RegisterDelegate协议的代理方法，注册页面注册成功的时候注册页面会回调这个方法，从而在此登录页面收到通知：用户已经注册完毕
- (void) notification:(NSString*)userModelJSONString{
    //验证成功，数据本来应该在联网端，但是这里就假装联网加载了用户全部数据了，返回给调用这个页面的页面所需的全部数据
    if (self.delegate && [self.delegate respondsToSelector:@selector(getUserMessageByDelegate:)]) {
        [self.delegate getUserMessageByDelegate:userModelJSONString]; //调用代理此类的那个类的重写代理方法，将model数据传过去
        NSLog(@"调用了登录被回调代理方法%@",userModelJSONString); //---------此方法没有被调用
    }
    else{
        NSLog(@"注册页面没有调用此登录页面实现的代理方法！");
    }
    NSLog(@"注册返回登录成功！更新用户信息存入本地数据库，并返回继承了LoginDelegate的父页面这些用户数据！此页面即将关闭。");
    [self.navigationController popViewControllerAnimated:YES];
}

@end
