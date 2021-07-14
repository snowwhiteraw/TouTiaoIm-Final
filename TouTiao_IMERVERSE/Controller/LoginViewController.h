//
//  RegisterViewController.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import <UIKit/UIKit.h>
#import "UserMessageModel.h"

NS_ASSUME_NONNULL_BEGIN

//协议就是这个类调用这个方法，可以做一些事情，然后做一些事情、传数据过去，给那个继承了这个delegate并重写该方法的类
//A类继承了B类的协议，重写了该协议的方法，然后B类自己在某个时机调用了这些协议方法，就会调用A类重写的这些具体方法。而且因为代理时调用的是B类的delegate给A类的self，所以不会触发代理冲突的问题。代理方法传值通过参数传值而不是返回值。
@protocol LoginDelegate <NSObject>

- (void)getUserMessageByDelegate:(NSString*)userMessageModelJSONString;

@end

@interface LoginViewController : UIViewController

// 代理属性
@property (weak,nonatomic) id<LoginDelegate> delegate;

@property (strong,nonatomic) UIImageView * imageview;

@property (strong,nonatomic) UILabel * titlelabel;

@property (strong,nonatomic) UITextField * userphone;

@property (strong,nonatomic) UITextField * password;

@property (strong,nonatomic) UIButton * login;

@property (strong,nonatomic) UIButton * registerbutton;

@property (strong,nonatomic) UIButton * forget;

@property (strong,nonatomic) UIButton * close;

@property BOOL isLoginAlive; //标记登陆按钮是否可点击

@property (strong,nonatomic) UserMessageModel * userMessageModel; //联网成功就有数据，用于登陆成功页面销毁返回代理数据的

@property (strong,nonatomic) UILabel * error; //用于显示登陆失败时提示用户的标语

+ (BOOL) checkUserAndPass:(NSString*)userphone :(NSString*)password;

- (void)getUserMessageByDelegate:(UserMessageModel*)userMessageModel;

+ (NSDictionary*) TransferFromNSStringToNSDict:(NSString*)jsonstr;

@end

NS_ASSUME_NONNULL_END
