//
//  TagViewController.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TagDelegate <NSObject>
//实现此页面消失时返回用户选中的selectedItems给调用者（也即TabsVC)
- (void) sentSelectedItems:(NSMutableArray*)selectedItems :(NSMutableArray*)unSelectItems;
//传给Tabs页面应该显示SelectedItems的第几个标签
- (void) sentSelectedLabelIndex:(NSInteger) index;

@end

//标签编辑页(尝试懒加载、masonry自动布局、CollectionView）
@interface TagViewController : UIViewController

// 代理属性
@property (weak,nonatomic) id<TagDelegate> delegate;

@property (strong,nonatomic) NSMutableArray * tags;

@property (strong, nonatomic) UIView *tagView; //除开editButton外的剩下部分

@property (strong, nonatomic) UIButton *editBtn;

@property (nonatomic) BOOL status; //编辑状态

@property (strong,nonatomic) NSMutableArray * selectedItems;

@property (strong,nonatomic) NSMutableArray * unSelectedItems;

- (void)initwithTags:(NSMutableArray*)defaultTags :(NSMutableArray*)otherTags;

@end

NS_ASSUME_NONNULL_END
