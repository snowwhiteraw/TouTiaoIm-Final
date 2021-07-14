//
//  Comment_ViewController.h
//  toutiao_Comment
//
//  Created by Admin on 2021/6/27.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface Comment_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>


//提供一个类函数：调用此函数，传入当前的viewcontroller，实现评论页面的pensent
+ (void)pop :(UIViewController *)vc andid:(int)articleid andmodel:(CommentModel *)user;
    
@end

NS_ASSUME_NONNULL_END
