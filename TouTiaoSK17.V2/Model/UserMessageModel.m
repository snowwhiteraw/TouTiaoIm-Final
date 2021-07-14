//
//  UserMessageModel.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/26.
//

#import "UserMessageModel.h"

@implementation UserMessageModel

-(instancetype)init{
    self = [super init];
    self.username = [@"沉浸版小白用户" mutableCopy];
    self.userphone = [@"1234567890" mutableCopy];
    self.token = [@"登陆凭证（没有后台就只能存密码啦）" mutableCopy];
    self.userimageurl = [@"https://pic.imgdb.cn/item/607834e78322e6675c32d96c.png" mutableCopy];
    self.userbackimageurl = [@"https://pic.imgdb.cn/item/60858147d1a9ae528ffe1fc2.jpg" mutableCopy];
    self.registertime = [@"2021-06-27 15:56:43" mutableCopy];
    self.toutiaonum = [@"233" mutableCopy];
    self.beingagreenum = [@"1w+" mutableCopy];
    self.fansnum = [@"6.7w" mutableCopy];
    self.follownum = [@"5" mutableCopy];
    self.selfintroduction = [@"你好，这里是自我介绍！" mutableCopy];
    return self;
}

@end
