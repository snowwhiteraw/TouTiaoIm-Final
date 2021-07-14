//
//  TabsbarViewController.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/20.
//

#import <Foundation/Foundation.h>
#import "FSScrollContentView.h"
#import <WebKit/WebKit.h>
#import "MessageContentModel.h"
#import <AFNetworking.h>
#import <YYModel.h>

NS_ASSUME_NONNULL_BEGIN


//首页viewcontroller，是一切数据的根基，也在这里最开始联网请求数据和加载固定标签框架
@interface TabsbarViewController : UIViewController

# pragma mark 联网相关
//一次联网加载到APP的几十条h5文章相关格式的
@property (strong, nonatomic) NSMutableArray<MessageContentModel *> * Contentarray;
@property (strong, nonatomic) NSMutableString * api;

@property NSInteger selectedItemsIndex;//当前页面要展示的是SelectedItems第几个标签

+ (UIImage *) getImageFromURL:(NSString *)fileURL;

+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

@end

NS_ASSUME_NONNULL_END
