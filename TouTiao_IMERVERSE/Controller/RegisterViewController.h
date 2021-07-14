//
//  LoginViewController.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import "UserMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RegisterDelegate <NSObject>

- (void) notification:(NSString*)userModelJSONString;

@end

@interface RegisterViewController : UIViewController

// 代理属性
@property (weak,nonatomic) id<RegisterDelegate> delegate;

@property (strong,nonatomic) UITextField * userphone;

@property (strong,nonatomic) UITextField * password;

@property (strong,nonatomic) UIButton * registerbutton;

@property (strong,nonatomic) UITextField * checkcode; //验证码框

@property (strong,nonatomic) UIButton * getcheckccode;//点击获取验证码

@property (strong,nonatomic) UILabel * titlelabel;

@property (strong,nonatomic) UILabel * error; //用于显示登陆失败时提示用户的标语

@property BOOL isRegisterAlive; //标记登陆按钮是否可点击,这里是注册按钮(我直接复制粘贴来的233）

@end

NS_ASSUME_NONNULL_END
