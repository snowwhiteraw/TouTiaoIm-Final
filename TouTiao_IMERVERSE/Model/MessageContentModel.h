//
//  MessageContentModel.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 {
 "文章ID":"12",
 "文章string":"<p>xxx<\p>",
 "文章作者":"xxx",
 "点赞数":"23",
 "评论数":"",
 "收藏数":"",
 "分享数":"",
 "作者被关注人数":"",
 "文章发布时间":"",
 "是否被当前用户关注":"" //本来是联网后台逻辑判断，但是这里没法后台逻辑判断，就客户端自己本地记着就行了
 }
 */
//文章实体类
@interface MessageContentModel : NSObject

@property NSString * messageid; //文章id，用于传给评论页
@property NSString * label;
@property NSString * contentstring;
@property NSString * author;
@property NSString * agree;
@property NSString * comment;
@property NSString * collection;
@property NSString * share;
@property NSString * fansNum;
@property NSString * time;
@property NSString * isFollowed;
@property NSArray<NSString * > * labels;
@property NSArray<NSString * > * unSelectedLabels;

@end

NS_ASSUME_NONNULL_END
