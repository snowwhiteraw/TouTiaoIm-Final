//
//  TagCollectionViewCell.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//由于每个标签在不同状态下会变化颜色，所以需要写一个子类写入逻辑，不然全在vc里面添加逻辑非常臃肿
@interface TagCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *titleLabel; //按钮标签上面的文本
@property (assign, nonatomic) BOOL inEditState; //是否进入编辑(未)选中状态

@end

NS_ASSUME_NONNULL_END
