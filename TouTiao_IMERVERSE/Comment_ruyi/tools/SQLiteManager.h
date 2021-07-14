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
- (NSMutableArray *) select:(int) articleID;
- (void) insert :(CommentModel *)model :(int) articleID;
//- (void) update :(CommentModel *)model;

+ (int)commentCountWithpath:(NSString *)path andArticleID:(int)id1;
@end

#endif /* SQLiteManager_h */

