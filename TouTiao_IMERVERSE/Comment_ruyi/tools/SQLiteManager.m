//
//  SQLiteManager.m
//  sqltest
//
//  Created by Admin on 2021/7/3.
//


#import "SQLiteManager.h"

static sqlite3 * dbPoint = Nil;

@implementation SQLiteManager

- (void) openDBWithPath :(NSString *)path{
    if(sqlite3_open([path UTF8String], &dbPoint) == SQLITE_OK){
        self.openning = YES;
        NSLog(@"成功打开数据库");
    }else{
        NSLog(@"打开数据库失败啦啦啦啦啦");
    }
}
    
- (void) closeDB{
    if(sqlite3_close(dbPoint) == SQLITE_OK){
    self.openning = NO;
    }
}
    
- (NSMutableArray *) select:(int) articleID{
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];

    //根据文章id查询评论数据
    NSString *sql = [NSString stringWithFormat:@"select name,touXiang,comment,time,dzCount from comment where articleID = %d order by dzCount desc;",articleID];
    sqlite3_stmt *statment = nil;
    int res = sqlite3_prepare_v2(dbPoint,[sql UTF8String], -1, &statment, NULL);
    if (res == SQLITE_OK) {
    while (sqlite3_step(statment) == SQLITE_ROW) {
        CommentModel *model = [[CommentModel alloc]init];
        model.name = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statment, 0) encoding:NSUTF8StringEncoding];
        model.touXiang = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statment, 1) encoding:NSUTF8StringEncoding];
        model.comment = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statment, 2) encoding:NSUTF8StringEncoding];
        model.time = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statment, 3) encoding:NSUTF8StringEncoding];
        model.dz_count = [[NSString alloc]initWithCString:(char *)sqlite3_column_text(statment, 4) encoding:NSUTF8StringEncoding];
        
        [arr addObject:model];
        }
    }
    if (arr) {
        NSLog(@"数据库查询成功");
    }else{
        NSLog(@"数据库查询失败");
    }
    return arr;
    
    
}

- (void) insert :(CommentModel *)model :(int) articleID{
    
    char *error;
    int commentid = 0;
    NSString *sql = [NSString stringWithFormat:@"select max(commentID) from comment where articleID = %d;",articleID];
    sqlite3_stmt *statment = nil;
    int res = sqlite3_prepare_v2(dbPoint,[sql UTF8String], -1, &statment, NULL);
    if (res == SQLITE_OK) {
    while (sqlite3_step(statment) == SQLITE_ROW) {
        commentid = sqlite3_column_int(statment, 0);
        }
    }
    commentid++;
    NSString *sql1 = [NSString stringWithFormat:@"insert into comment values(%d,%d,'%@','%@','%@','%@',%@);",articleID,commentid,model.name,model.touXiang,model.comment,model.time,model.dz_count];
    if (sqlite3_exec(dbPoint, [sql1 UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"已插入数据到数据库");
    }else{
        NSLog(@"插入数据失败：%s",error);
    }
}






@end
