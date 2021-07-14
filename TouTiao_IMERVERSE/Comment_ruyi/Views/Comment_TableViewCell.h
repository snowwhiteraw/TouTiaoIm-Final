//
//  Comment_TableViewCell.h
//  toutiao_Comment
//
//  Created by Admin on 2021/6/27.
//
//  评论页的cell
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Comment_TableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *name,*time,*dz_count;
@property(nonatomic,strong)UIImageView *touXiang;
@property(nonatomic,strong)UITextView *comment;
@property(nonatomic,strong)UIButton *dianzan,*reply,*menu;


//获得主页面的输入框的地址
@property(nonatomic,strong)UITextView *textview;
@property(nonatomic,strong)NSString *pername;
@property(nonatomic,strong)UIViewController *vc;
- (void)sentMSG:(UITextView *)tv andName:(NSString *)name;

//点赞按钮按下次数
@property(nonatomic)BOOL clicking;



@end

NS_ASSUME_NONNULL_END
