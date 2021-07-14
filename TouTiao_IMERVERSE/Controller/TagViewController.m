//
//  TagViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/7/1.
//

#import "TagViewController.h"
#import <Masonry/Masonry.h>
#import "TagCollectionViewCell.h"
#import "TagHeaderView.h"

@interface TagViewController (){
    NSIndexPath *_currentIndexPath;
    CGPoint _deltaPoint;
}



@property (strong,nonatomic) UICollectionViewFlowLayout *flowLayout;//写在这里的是懒加载组件

@property (strong,nonatomic) UICollectionView * collView; //懒加载组件

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture; //为了实现拖拽而添加的手势，下同
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGesture;

@property (strong, nonatomic) UIView *snapedImageView;

@end

//复用标记
static NSString *const CellID = @"CellID";
static NSString *const HeaderID = @"HeaderID";

@implementation TagViewController

- (void)initwithTags:(NSMutableArray*)defaultTags :(NSMutableArray*)otherTags{
    
    self.selectedItems = [defaultTags mutableCopy]; //这里要注意加mutablecopy，否则会自动转成NSArray导致无法addObjects。
    self.unSelectedItems = [otherTags mutableCopy];
    
    //添加按钮
    NSLog(@"调用了按钮的初始方法");
    self.view.backgroundColor = UIColor.whiteColor;
    self.editBtn = [[UIButton alloc]init];
    self.editBtn.backgroundColor = UIColor.whiteColor;
    self.status = NO;
    [self.editBtn setSelected:NO];
    [self.editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editBtn setTitle:@"完成" forState:UIControlStateSelected];//按钮状态不会自动改变，需要在监听事件改变
    //隐藏边框，输入框默认显示边框；按钮则默认不显示边框
    [self.editBtn setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:UIColor.redColor forState:UIControlStateSelected];
    [self.editBtn addTarget:self action:@selector(editBtnfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside轻点
    
    //添加collectionview视图(懒加载）
    [self.view addSubview:self.collView];
    //为拖拽添加手势
    [self.collView addGestureRecognizer:self.panGesture];
    [self.collView addGestureRecognizer:self.longPressGesture];
    
    [self.view addSubview:self.editBtn];
    
    [self.editBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(100, 50)); //绝对值赋值
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"调用了viewWillAppear"); //此方法会频繁被调用，但凡页面被移动一下就会被调用
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"调用了viewDidAppear"); //此方法看起来跟viewWillAppear差别不大
}

- (void)viewDidLoad{
    NSLog(@"调用了viewDidLoad"); //此方法压根没有调用
}

- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"调用了viewDidDisappear————页面消失啦~在这里写标签生效方法");
    if (self.delegate && [self.delegate respondsToSelector:@selector(sentSelectedItems::)]) { //注意一个:代表一个参数
        [self.delegate sentSelectedItems:self.selectedItems :self.unSelectedItems]; //调用代理此类的那个类的重写代理方法，将selectedItems数据传过去
        NSLog(@"将selectedItems数据传了过去");
    }
    
}

- (void) editBtnfunc:(id)sender{
    NSLog(@"点击了编辑按钮");
    if(self.editBtn.selected == NO){ //不要用按钮.status
        [self.editBtn setSelected:YES];
        self.status = YES;
    }
    else{
        [self.editBtn setSelected:NO];
        self.status = NO;
    }
    
}


//- (BOOL)status{}是self.status的专属getter和setter。而这里只需要setter。
- (void)setStatus:(BOOL)status{
    _status = status;
    self.editBtn.selected = _status;
    [self.collView reloadData]; //状态变了整个页面都要重新加载。主要是未来触发cellAtPath这个collView的代理方法
}

#pragma mark collectionView懒加载
//使用self.collView就会调用这个方法获得其值，而调用_collView则会直接取得其值，有可能为Nil，而这里做了处理。所以本类一律调用self.collView，只在这方法里面调用_collView
- (UICollectionView*) collView{
    if(_collView == nil){
        UICollectionView * collView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 10+50+10, self.view.frame.size.width, self.view.frame.size.height - (10+50+10)) collectionViewLayout:self.flowLayout];// flowLayout 懒加载 //初始一个collectionView必须继承他的delegate、dataSource、layout。
       
        
        collView.delegate = self; //一些回调方法，比如定义cell大小
        collView.dataSource = self;//真正放cell数据是在这里放
        
        //注册。其实就是往collectionView里面添加cell类型,，用到了class方法，貌似是单例模式页间传值？
        [collView registerClass:[TagCollectionViewCell class] forCellWithReuseIdentifier:CellID]; //根据CellID添加cell
        [collView registerClass:[TagHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderID]; //根据HeaderID添加头视图
        
        collView.backgroundColor = [UIColor whiteColor];
        
        _collView = collView;
    }
    return _collView;
}

//代理方法，定义头视图大小（cell上面的视图）
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGSizeMake(100, 44);; //如果是return CGSizeZero;就表示第一组没有头视图
    }
    else {
        return CGSizeMake(100, 44);
    }
}


//collectionview代理方法，定义头尾视图（尾视图我不知道怎么返回，这里只有头视图）
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderID forIndexPath:indexPath]; //withReuseIdentifier:@"HeaderID"这个是复用ID
    if (indexPath.section == 0) {
        UILabel * title = [[UILabel alloc]initWithFrame:header.bounds]; //注意只是init而没有指定大小方位的一律不显示
        [title setTextColor:UIColor.lightGrayColor];
        [title setBackgroundColor:UIColor.whiteColor];
        [title setText:@"   我的频道（长按可以拖动标签）"];
        [header addSubview:title];
    }
    else {
        UILabel * title = [[UILabel alloc]initWithFrame:header.bounds];
        [title setTextColor:UIColor.lightGrayColor];
        [title setBackgroundColor:UIColor.whiteColor];
        [title setText:@"   更多频道（点击添加标签）"];
        [header addSubview:title];
    }
    return header;
}

//对视图的每个cell做设置
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath]; //CellID是复用标志
    if (indexPath.section == 0) { //分为两组，一组是我的标签，一组是更多标签
        cell.titleLabel.text = _selectedItems[indexPath.row]; //懒加载调用了，使用记得写setXXX或者同名初始化方法
    }
    else {
        cell.titleLabel.text = _unSelectedItems[indexPath.row];
    }
    // cell是否进入编辑状态 set方法中会改变cell的样式；也就是说，此方法会触发TagCollectionViewController的- (void)setInEditState:(BOOL)inEditState方法
    cell.inEditState = self.status;
    return cell;
}

//点击了该collectionViewcell后的操作
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.status == YES) {//默认是NO，长按手势会导致为YES，表示进入编辑状态 || 对于没有懒加载的status要记得做好初始化！改初始化我卸载了Init方法里面。
        //添删标签
        if (indexPath.section == 0) {// 删除第一组的
            if (indexPath.row == 0) return; // 不能编辑第一个
            // 添加新数据
            [self.unSelectedItems addObject: self.selectedItems[indexPath.row]];
            // 删除旧数据
            [self.selectedItems removeObjectAtIndex:indexPath.row];
            // 在第二组最后增加一个
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.unSelectedItems.count-1 inSection:1]; //这个方法表示得到一个位置，这个位置是第1组(未选中标签组)的最后一“行”（也就是最后一个位置，因为上面已经将这个item添加到了self.unselectedItems）。
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];//开始正式移动，动画由collectionviewe负责
        }
        else { // 添加第一组的
            // 添加新数据
            [self.selectedItems addObject: self.unSelectedItems[indexPath.row]];
            // 删除旧数据
            [self.unSelectedItems removeObjectAtIndex:indexPath.row];
            // 在第一组最后增加一个
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedItems.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];

        }
        
    }
    else {
        //未进入编辑状态
        if (indexPath.section == 0) {//点击的是第一组
            NSLog(@"点击了第一组的第%ld个cell，页面将跳转到Tabs页面的那个标签去，此页面将消失",(long)indexPath.row);
            if (_delegate && [_delegate respondsToSelector:@selector(sentSelectedLabelIndex:)]) {
                NSLog(@"dismiss页面%@",self.navigationController);
                [_delegate sentSelectedLabelIndex:indexPath.row];
                [self dismissViewControllerAnimated:YES completion:nil];//不用pop是因为当前页面是present过来的，对应的是dismiss
            }
        }
        else {
            // 添加新数据
            [self.selectedItems addObject: self.unSelectedItems[indexPath.row]];
            // 删除旧数据
            [self.unSelectedItems removeObjectAtIndex:indexPath.row];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.selectedItems.count-1 inSection:0];
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
        }

    }


}


//返回collectionView组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

//返回第几组分别有多少个cell
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return self.selectedItems.count;
    }
    else {
        return self.unSelectedItems.count;
    }
}


- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(100, 44); //每个的大小
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);  //间隔
        flowLayout.headerReferenceSize = CGSizeMake(100, 44); //头视图
        _flowLayout = flowLayout;
    }
    return _flowLayout;
}


//还是懒加载
- (NSMutableArray<TagCollectionViewCell*> *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [[NSMutableArray alloc]init];
    }
    return _selectedItems;
}

//还是懒加载
- (NSMutableArray<TagCollectionViewCell*> *)unSelectedItems {
    if (!_unSelectedItems) {
        _unSelectedItems = [[NSMutableArray alloc]init];
    }
    return _unSelectedItems;
}

//懒加载两个手势
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
        _panGesture.delegate = self;
        // 优先执行collectionView系统的手势
//        [_panGesture requireGestureRecognizerToFail:self.collectionView.panGestureRecognizer];
    }
    return _panGesture;
}

- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) { //懒加载，不肯在初始方法里面加载
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)]; //手势触发监听事件，这事件将编辑状态设置为YES
        longPressGesture.delegate = self; //接受长按手势被动回调，重写代理方法
        _longPressGesture = longPressGesture;
    }
    return _longPressGesture;
}

//长按手势(longpress)和拖拽手势(pab)的delegate代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // 手指的位置
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    // 获取手指所在的位置的cell的indexPath -- 位置不在cell上时为nil
    NSIndexPath *indexPath = [self.collView indexPathForItemAtPoint:location];
    if (gestureRecognizer == _panGesture) {
        if (indexPath) { // indexPath不为nil 说明手指开始的位置是在cell上面
            if (indexPath.section == 0 && indexPath.row != 0 && _status) {
                // 只允许第一个section里面的cell响应手势
                // 并且不允许拖动第一个cell, 当然你可以自定义不能拖动的cell
                _currentIndexPath = indexPath;
                return YES;
            }
        }
        return NO;
        
    }
    
    if (gestureRecognizer == _longPressGesture) {
        if (!_status && indexPath.section == 0) return YES;
        else return NO;
    }
    return YES;

}

//长按手势代理方法
- (void)longPressHandler:(UILongPressGestureRecognizer *)longPressGesture {
    // 设置为进入编辑状态, 改变cell的状态
    self.status = YES;
    self.editBtn.selected = YES;
}

//拖动手势代理方法
- (void)panGestureHandler:(UIPanGestureRecognizer *)panGes {
    CGPoint location = [panGes locationInView:self.collView];
    
    switch (panGes.state) {

        case UIGestureRecognizerStateBegan: {
            // 获取当前手指所在的cell
            UICollectionViewCell *cell = [self.collView cellForItemAtIndexPath:_currentIndexPath];
            // 截取当前cell 保存为snapedImageView
            self.snapedImageView = [cell snapshotViewAfterScreenUpdates:NO];
            // 设置初始位置和当前cell一样
            self.snapedImageView.center = cell.center;
            // 隐藏当前cell
            cell.alpha = 0.f;
            // 记录当前手指的位置的x和y距离cell的x,y的间距, 便于同步截图的位置
            _deltaPoint = CGPointMake(location.x - cell.frame.origin.x, location.y - cell.frame.origin.y);
            // 放大截图
            self.snapedImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            // 添加截图到collectionView上
            [self.collView addSubview:self.snapedImageView];

        }
            break;
            
        case UIGestureRecognizerStateChanged: {
            // 这种设置并不精准, 效果不好, 开始移动的时候有跳跃现象
//            self.snapedImageView.center = location;
            CGRect snapViewFrame = self.snapedImageView.frame;
            snapViewFrame.origin.x =  location.x - _deltaPoint.x;
            snapViewFrame.origin.y =  location.y - _deltaPoint.y;
            self.snapedImageView.frame = snapViewFrame;
            
            // 获取当前手指的位置对应的indexPath
            NSIndexPath *newIndexPath = [self.collView indexPathForItemAtPoint:location];
            if (newIndexPath &&  // 不为nil的时候
                newIndexPath.section == _currentIndexPath.section && // 只在同一个section中移动
                newIndexPath.row != 0 // 第一个不要移动
                ) {
                
                // 更新数据
               // 同一个section中, 需要将两个下标之间的所有的数据改变位置(前移或者后移)
                NSMutableArray *oldRows = [self.selectedItems mutableCopy];
                // 当手指所在的cell在截图cell的后面的时候
                if (newIndexPath.row > _currentIndexPath.row) {
                    // 将这个区间的数据都前后交换, 就能够达到 数组中这两个下标之间所有的数据都向前移动一位 并且currentIndexPath.row的元素移动到了newIndexPath.row的位置
                    for (NSInteger index = _currentIndexPath.row; index<newIndexPath.row; index++) {
                        [oldRows exchangeObjectAtIndex:index withObjectAtIndex:index+1];
                    }
                    
                    // 或者可以像下面这样来处理
                    // 缓存最初的元素
                    id tempFirst = oldRows[_currentIndexPath.row];
                    for (NSInteger index = _currentIndexPath.row; index<newIndexPath.row; index++) {
                        if (index != newIndexPath.row - 1) {
                            // 这之间的所有的元素前移一位
                            oldRows[index] = oldRows[index++];
                        }
                        else {
                            // 第一个元素移动到这个区间的最后
                            oldRows[index] = tempFirst;
                        }
                    }

                }
                if (newIndexPath.row < _currentIndexPath.row) {

                    for (NSInteger index = _currentIndexPath.row; index>newIndexPath.row; index--) {
                        [oldRows exchangeObjectAtIndex:index withObjectAtIndex:index-1];
                    }
                }
                // 先更新数据设置为交换后的数据
                self.selectedItems = oldRows;
                // 再移动cell
                [self.collView moveItemAtIndexPath:_currentIndexPath toIndexPath:newIndexPath];
                
                // 获取到新位置的cell
                UICollectionViewCell *cell = [self.collView cellForItemAtIndexPath:newIndexPath];
                // 设置为移动后的新的indexPath
                _currentIndexPath = newIndexPath;
                // 隐藏新的cell
                cell.alpha = 0.f;
            }
        }
            
            break;
        case UIGestureRecognizerStateEnded: {
            // 获取当前的cell
            UICollectionViewCell *cell = [self.collView cellForItemAtIndexPath:_currentIndexPath];
            // 显示隐藏的cell
            cell.alpha = 1.f;
            // 删除cell的截图
            [self.snapedImageView removeFromSuperview];
            _currentIndexPath = nil;
        }
            
            break;
        default:
            break;
    }
}


@end
