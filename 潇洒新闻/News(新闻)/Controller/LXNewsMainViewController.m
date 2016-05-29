//
//  LXNewsMainViewController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/7.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXNewsMainViewController.h"
#import "LXNewsTableViewController.h"
#import "LXNewsCollectionViewCell.h"
#import "LXLeftViewController.h"
#import "LXWeatherController.h"
#import "LXWeatherCityCell.h"
#import <SVProgressHUD.h>
#import <POP.h>


@interface LXNewsMainViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChannelCollectionViewCellDelegate>
@property (nonatomic, strong) NSMutableArray *currentChannelsArray;
@property (nonatomic, strong) NSMutableArray *remainChannelsArray;
@property (nonatomic, strong) NSMutableArray *allChannelsArray;
@property (nonatomic, strong) NSMutableDictionary *channelsUrlDictionary;
@property (nonatomic, weak) UIView *topContianerView;
@property (nonatomic, weak) UIScrollView *topScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
@property (nonatomic, weak) UIView *indicatorView;
@property (nonatomic, weak) UIButton *selectButton;
@property (nonatomic, weak) UIButton *addButton;
@property (nonatomic, assign) BOOL isAddChannelsViewShow;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGRect collectionViewFrame;

@end

static NSString * const collectionCellID = @"ChannelCollectionCell";
static NSString * const collectionViewSectionHeaderID = @"ChannelCollectionHeader";
static CGFloat titleLabelNorimalFont = 17;
static CGFloat titleLabelSelectedFont = 23;

@implementation LXNewsMainViewController
#pragma mark - 懒加载
- (NSMutableArray *)currentChannelsArray
{
    if (!_currentChannelsArray) {
        _currentChannelsArray = [NSMutableArray array];
        NSArray *array = [[NSUserDefaults standardUserDefaults]arrayForKey:@"currentChannelsArray"];
        [_currentChannelsArray addObjectsFromArray:array];
        if (_currentChannelsArray.count == 0) {
            [_currentChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车"]];
            [self storeCurrentChannelsArray];
        }
    }
    return _currentChannelsArray;
}
- (NSMutableArray *)remainChannelsArray
{
    if (!_remainChannelsArray) {
        _remainChannelsArray = [NSMutableArray array];
        [_remainChannelsArray addObjectsFromArray:self.allChannelsArray];
        [_remainChannelsArray removeObjectsInArray:self.currentChannelsArray];
    }
    return _remainChannelsArray;
}
- (NSMutableArray *)allChannelsArray
{
    if (!_allChannelsArray) {
        _allChannelsArray = [NSMutableArray array];
        NSArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"allChannelsArray"];
        [_allChannelsArray addObjectsFromArray:tempArray];
        if (_allChannelsArray.count == 0) {
            [_allChannelsArray addObjectsFromArray:@[@"国内", @"国际", @"娱乐", @"互联网", @"体育", @"财经", @"科技", @"汽车", @"军事", @"理财", @"经济", @"房产", @"国际足球", @"国内足球", @"综合体育", @"电影", @"电视", @"游戏", @"教育", @"美容", @"情感",@"养生", @"数码", @"电脑", @"科普", @"社会", @"台湾", @"港澳"]];
            [[NSUserDefaults standardUserDefaults]setObject:_allChannelsArray forKey:@"allChannelsArray"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    return _allChannelsArray;
}
- (NSMutableDictionary *)channelsUrlDictionary
{
    if (!_channelsUrlDictionary) {
        _channelsUrlDictionary = [NSMutableDictionary dictionary];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults]dictionaryForKey:@"channelsUrlDictionary"];
        [_channelsUrlDictionary addEntriesFromDictionary:dict];
        if (_channelsUrlDictionary.count == 0) {
            _channelsUrlDictionary[@"国内"] = @"5572a109b3cdc86cf39001db";
            _channelsUrlDictionary[@"国际"] = @"5572a109b3cdc86cf39001de";
            _channelsUrlDictionary[@"娱乐"] = @"5572a10ab3cdc86cf39001eb";
            _channelsUrlDictionary[@"互联网"] = @"5572a109b3cdc86cf39001e3";
            _channelsUrlDictionary[@"体育"] = @"5572a109b3cdc86cf39001e6";
            _channelsUrlDictionary[@"财经"] = @"5572a109b3cdc86cf39001e0";
            _channelsUrlDictionary[@"科技"] = @"5572a10ab3cdc86cf39001f4";
            _channelsUrlDictionary[@"汽车"] = @"5572a109b3cdc86cf39001e5";
            _channelsUrlDictionary[@"军事"] = @"5572a109b3cdc86cf39001df";
            _channelsUrlDictionary[@"理财"] = @"5572a109b3cdc86cf39001e1";
            _channelsUrlDictionary[@"经济"] = @"5572a109b3cdc86cf39001e2";
            _channelsUrlDictionary[@"房产"] = @"5572a109b3cdc86cf39001e4";
            _channelsUrlDictionary[@"国际足球"] = @"5572a10ab3cdc86cf39001e7";
            _channelsUrlDictionary[@"国内足球"] = @"5572a10ab3cdc86cf39001e8";
            _channelsUrlDictionary[@"综合体育"] = @"5572a10ab3cdc86cf39001ea";
            _channelsUrlDictionary[@"电影"] = @"5572a10ab3cdc86cf39001ec";
            _channelsUrlDictionary[@"电视"] = @"5572a10ab3cdc86cf39001ed";
            _channelsUrlDictionary[@"游戏"] = @"5572a10ab3cdc86cf39001ee";
            _channelsUrlDictionary[@"教育"] = @"5572a10ab3cdc86cf39001ef";
            _channelsUrlDictionary[@"美容"] = @"5572a10ab3cdc86cf39001f1";
            _channelsUrlDictionary[@"情感"] = @"5572a10ab3cdc86cf39001f2";
            _channelsUrlDictionary[@"养生"] = @"5572a10ab3cdc86cf39001f3";
            _channelsUrlDictionary[@"数码"] = @"5572a10bb3cdc86cf39001f5";
            _channelsUrlDictionary[@"电脑"] = @"5572a10bb3cdc86cf39001f6";
            _channelsUrlDictionary[@"科普"] = @"5572a10bb3cdc86cf39001f7";
            _channelsUrlDictionary[@"社会"] = @"5572a10bb3cdc86cf39001f8";
            _channelsUrlDictionary[@"台湾"] = @"5572a109b3cdc86cf39001dc";
            _channelsUrlDictionary[@"港澳"] = @"5572a109b3cdc86cf39001dd";
            [[NSUserDefaults standardUserDefaults]setObject:_channelsUrlDictionary forKey:@"channelsUrlDictionary"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    return _channelsUrlDictionary;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupBasic];
    [self setupTopScrollView];
    [self setupChildController];
    [self setupContentScrollView];
    [self setupCollectionView];
}
#pragma mark - setupBasic
- (void)setupBasic
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.isAddChannelsViewShow = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"天气" style:UIBarButtonItemStylePlain target:self action:@selector(setupWeatherView)];
}
#pragma mark - setupWeatherView
- (void)setupWeatherView
{
    LXWeatherController *weatherVC = [[LXWeatherController alloc]init];
    [self.navigationController pushViewController:weatherVC animated:YES];
}
#pragma mark - setupTopScrollView
- (void)setupTopScrollView
{
    //topContainerView
    UIView *topContainerView = [[UIView alloc]init];
    topContainerView.backgroundColor = [UIColor lightGrayColor];
    self.topContianerView = topContainerView;
    topContainerView.frame = CGRectMake(0, LXStatusHeight + LXNavigationBarHeight, LXWidth, 50);
    topContainerView.alpha = 0.9;
    [self.view addSubview:topContainerView];
    //addButton
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    [addButton setImage:[UIImage imageNamed:@"home_header_add_slim"] forState:UIControlStateNormal];
    CGFloat addButtonWidth = topContainerView.frame.size.height;
    addButton.frame = CGRectMake(LXWidth - addButtonWidth, 0, addButtonWidth, addButtonWidth);
    [addButton addTarget:self action:@selector(showAddChannelsView) forControlEvents:UIControlEventTouchUpInside];
    [topContainerView addSubview:addButton];
    //topScrollView
    UIScrollView *topScrollView = [[UIScrollView alloc]init];
    self.topScrollView = topScrollView;
    topScrollView.backgroundColor = [UIColor lightGrayColor];
    topScrollView.frame = CGRectMake(0, 0, LXWidth - addButtonWidth, topContainerView.frame.size.height);
    topScrollView.showsVerticalScrollIndicator = NO;
    topScrollView.showsHorizontalScrollIndicator = NO;
    [topContainerView addSubview:topScrollView];
    //sliderView
    CGFloat sliderViewWidth = 10;
    UIImageView *sliderView = [[UIImageView alloc]init];
    sliderView.frame = CGRectMake(topScrollView.frame.size.width - sliderViewWidth, 0, sliderViewWidth, topContainerView.frame.size.height);
    sliderView.alpha = 0.9;
    sliderView.image = [UIImage imageNamed:@"slidetab_mask"];
    [topContainerView addSubview:sliderView];
    //indicatorView
    UIView *indicatorView = [[UIView alloc]init];
    self.indicatorView = indicatorView;
    indicatorView.backgroundColor = [UIColor redColor];
    [topScrollView addSubview:indicatorView];
    [self setupTopScrollViewButtons];
}
- (void)showAddChannelsView
{
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    if (self.isAddChannelsViewShow == NO) {
        [UIView animateWithDuration:0.25 animations:^{
            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, -M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectZero];
        animation.toValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetMaxY(self.topContianerView.frame), LXWidth, LXHeight)];
        self.isAddChannelsViewShow = YES;
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.addButton.transform = CGAffineTransformRotate(self.addButton.transform, M_PI_4);
        }];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, CGRectGetMaxY(self.topContianerView.frame), LXWidth, LXHeight)];
        animation.toValue = [NSValue valueWithCGRect:CGRectZero];
        self.isAddChannelsViewShow = NO;
    }
    animation.springBounciness = 5;
    animation.springSpeed = 5;
    [self.collectionView pop_addAnimation:animation forKey:nil];
}
- (void)setupTopScrollViewButtons
{
    CGFloat buttonWidth = self.topScrollView.frame.size.width / 5;
    self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count * buttonWidth, 0);
    for (NSInteger i = 0; i < self.currentChannelsArray.count; i++) {
        UIButton *button = [self createChannelButton];
        button.frame = CGRectMake(buttonWidth * i, 0, buttonWidth, self.topScrollView.frame.size.height);
        [button setTitle:self.currentChannelsArray[i] forState:UIControlStateNormal];
        [button layoutIfNeeded];
        [self.topScrollView addSubview:button];
        if (i == 0) {
            self.selectButton = button;
            [self buttonClick:button];
        }
    }
}
- (UIButton *)createChannelButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
    [button.titleLabel setFont:[UIFont systemFontOfSize:titleLabelNorimalFont]];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)buttonClick:(UIButton *)button
{
    self.selectButton.titleLabel.font = [UIFont systemFontOfSize:titleLabelNorimalFont];
    self.selectButton.enabled = YES;
    self.selectButton = button;
    self.selectButton.enabled = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [button.titleLabel setFont:[UIFont systemFontOfSize:titleLabelSelectedFont]];
        [button layoutIfNeeded];
        self.indicatorView.frame = CGRectMake(button.frame.origin.x + button.titleLabel.frame.origin.x - 5, self.topScrollView.frame.size.height - 2, button.titleLabel.frame.size.width + 10, 2);
        NSInteger index = [self.topScrollView.subviews indexOfObject:button] - 1;
        [self.contentScrollView setContentOffset:CGPointMake(index * self.contentScrollView.frame.size.width, 0) animated:YES];
        CGFloat contentOffsetX = button.center.x - 0.5 * LXWidth;
        CGFloat maxContentOffsetX = self.topScrollView.contentSize.width - self.topScrollView.frame.size.width;
        if (contentOffsetX > maxContentOffsetX) {
            contentOffsetX = maxContentOffsetX;
        }
        if (contentOffsetX < 0) {
            contentOffsetX = 0;
        }
        [self.topScrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    }];
}
#pragma mark - setupChildController
- (void)setupChildController
{
    for (NSInteger i = 0; i < self.currentChannelsArray.count; i++) {
        LXNewsTableViewController *tableVC = [[LXNewsTableViewController alloc]init];
        tableVC.channelName = self.currentChannelsArray[i];
        tableVC.channelId = self.channelsUrlDictionary[tableVC.channelName];
        [self addChildViewController:tableVC];
    }
}
#pragma mark - setupContentScrollView
- (void)setupContentScrollView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc]init];
    self.contentScrollView = contentScrollView;
    contentScrollView.frame = self.view.bounds;
    contentScrollView.contentSize = CGSizeMake(contentScrollView.frame.size.width * self.currentChannelsArray.count, 0);
    contentScrollView.delegate = self;
    contentScrollView.pagingEnabled = YES;
    [self.view insertSubview:contentScrollView atIndex:0];
    [self scrollViewDidEndScrollingAnimation:contentScrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        NSInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
        LXNewsTableViewController *tableVC = self.childViewControllers[index];
        tableVC.view.frame = CGRectMake(scrollView.contentOffset.x, 0, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height);
        tableVC.tableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.navigationController.navigationBar.frame) + self.topContianerView.frame.size.height, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:tableVC.view];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.contentScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
        NSInteger index = scrollView.contentOffset.x / self.contentScrollView.frame.size.width;
        UIButton *button = self.topScrollView.subviews[index + 1];
        [self buttonClick:button];
    }
}
#pragma mark - setupCollectionView
- (void)setupCollectionView
{
    CGFloat top = CGRectGetMaxY(self.topScrollView.frame);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(LXWidth, 35);
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame), 0, 0) collectionViewLayout:flowLayout];
    self.collectionViewFrame = CGRectMake(0, CGRectGetMaxY(self.topScrollView.frame), LXWidth, LXHeight - top);
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alpha = 0.95;
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([LXNewsCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:collectionCellID];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID];
}
#pragma mark - CollectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.currentChannelsArray.count;
    }else{
        return self.remainChannelsArray.count;
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LXNewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section == 0) {
        cell.channelName = self.currentChannelsArray[indexPath.row];
        cell.theIndexPath = indexPath;
    }else{
        cell.channelName = self.remainChannelsArray[indexPath.row];
    }
    return cell;
}
#pragma mark - flowlayout delegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat margin = 10;
    return CGSizeMake((LXWidth - 5 * margin) / 4, 35);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
#pragma mark - collectionview delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [self.currentChannelsArray addObject:self.remainChannelsArray[indexPath.row]];
        [self.remainChannelsArray removeObjectAtIndex:indexPath.row];
        [self storeCurrentChannelsArray];
        LXNewsTableViewController *tableView = [[LXNewsTableViewController alloc]init];
        tableView.channelName = self.currentChannelsArray.lastObject;
        tableView.channelId = self.channelsUrlDictionary[tableView.channelName];
        [self addChildViewController:tableView];
        CGFloat buttonWidth = self.topScrollView.frame.size.width / 5;
        self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count * buttonWidth, 0);
        //新增按钮
        UIButton *button = [self createChannelButton];
        button.frame = CGRectMake(self.topScrollView.contentSize.width - buttonWidth, 0, buttonWidth, self.topScrollView.frame.size.height);
        [button setTitle:self.currentChannelsArray.lastObject forState:UIControlStateNormal];
        [self.topScrollView addSubview:button];
        self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.currentChannelsArray.count, 0);
        [self.collectionView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
        [self showAddChannelsView];
        [self buttonClick:button];
    }
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionViewSectionHeaderID forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor lightGrayColor];
    UILabel *lable = [[UILabel alloc]init];
    lable.frame = CGRectMake(20, 0, LXWidth - 20, headerView.frame.size.height);
    if (indexPath.section == 0) {
        lable.text = @"已添加栏目(长按可进行删除)";
    }else{
        lable.text = @"可添加栏目(点击可添加到已有栏目)";
    }
    [headerView.subviews.firstObject removeFromSuperview];
    [headerView addSubview:lable];
    return headerView;
}
- (void)deleteTheCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self.remainChannelsArray addObject:self.currentChannelsArray[indexPath.row]];
    [self.currentChannelsArray removeObjectAtIndex:indexPath.row];
    [self storeCurrentChannelsArray];
    [self.childViewControllers[indexPath.row]removeFromParentViewController];
    [self.collectionView reloadData];
    [self.topScrollView.subviews.lastObject removeFromSuperview];
    for (NSInteger i = 1; i < self.topScrollView.subviews.count; i++) {
        UIButton *button = self.topScrollView.subviews[i];
        [button setTitle:self.currentChannelsArray[i - 1] forState:UIControlStateNormal];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.frame.size.width * self.currentChannelsArray.count, 0);
    CGFloat buttonWidth = self.topScrollView.frame.size.width / 5;
    self.topScrollView.contentSize = CGSizeMake(self.currentChannelsArray.count * buttonWidth, 0);
}

#pragma mark - storeCurrentChannelsArray
- (void)storeCurrentChannelsArray
{
    [[NSUserDefaults standardUserDefaults]setObject:self.currentChannelsArray forKey:@"currentChannelsArray"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
