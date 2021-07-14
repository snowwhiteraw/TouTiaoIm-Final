//
//  CommentModel.h
//  toutiao_Comment
//
//  Created by Admin on 2021/6/28.
//
//cell的数据模型

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface CommentModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *touXiang;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *dz_count;
@property(nonatomic,copy)NSString *comment;

@end

NS_ASSUME_NONNULL_END
