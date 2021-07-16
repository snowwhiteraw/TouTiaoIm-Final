//
//  SQLiteManager.h
//  sqltest
//
//  Created by Admin on 2021/7/3.
//

#ifndef SQLiteManager_h
#define SQLiteManager_h
#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "CommentModel.h"
@interface SQLiteManager :NSObject

@property BOOL openning;

- (void) openDBWithPath :(NSString *)path;
- (void) closeDB;
//返回文章id对应的评论数组
- (NSMutableArray *) select:(int) articleID;
//插入评论到数据库
- (void) insert :(CommentModel *)model :(int) articleID;
//以文章id获取对应的评论数
+ (int)commentCountWithArticleID:(int)id1;
@end

#endif /* SQLiteManager_h */

