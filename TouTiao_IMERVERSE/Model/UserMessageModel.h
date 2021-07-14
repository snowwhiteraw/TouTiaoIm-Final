//
//  UserMessageModel.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 "person":{
 "username":"",
 "userphone":"",
 "token":"",
 "userimageurl":"",
 "userbackimageurl":"",
 "registertime":"",
 "toutiaonum":"",
 "beingagreenum":"",
 "fansnum":"",
 "follownum":"",
 "selfintroduction":""
 }
 */

//个人登陆强相关信息
@interface UserMessageModel : NSObject

@property (strong,nonatomic) NSMutableString * username; //用户昵称

@property (strong,nonatomic) NSMutableString * userphone; //用户手机号

@property (strong,nonatomic) NSMutableString * token; //用户登陆凭证——密码

@property (strong,nonatomic) NSMutableString * userimageurl; //头像链接

@property (strong,nonatomic) NSMutableString * userbackimageurl; //背景图链接

@property (strong,nonatomic) NSMutableString * registertime; //注册日期

@property (strong,nonatomic) NSMutableString * toutiaonum; //头条数

@property (strong,nonatomic) NSMutableString * beingagreenum; //获赞数

@property (strong,nonatomic) NSMutableString * fansnum; //粉丝数

@property (strong,nonatomic) NSMutableString * follownum; //关注数

@property (strong,nonatomic) NSMutableString * selfintroduction; //个人简介

@end

NS_ASSUME_NONNULL_END
