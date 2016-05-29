//
//  LXSettingController.m
//  潇洒新闻
//
//  Created by NiceForMe on 16/5/25.
//  Copyright © 2016年 NiceForMe. All rights reserved.
//

#import "LXSettingController.h"
#import "LXSettingCell.h"
#import <SVProgressHUD.h>

@interface LXSettingController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) CGFloat cacheData;
@property (nonatomic,strong) UITableView *tableView;
@end

static NSString * const tableViewID = @"tableViewID";

@implementation LXSettingController
#pragma mark - viewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBasic];
    [self setupTableView];
}
#pragma mark - setupBasic
- (void)setupBasic
{
    self.view.backgroundColor = [UIColor whiteColor];
}
#pragma mark - setupTableView
- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc]init];
    self.tableView = tableView;
    tableView.frame = self.view.bounds;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewID];
    [self.view addSubview:tableView];
}
#pragma mark - tableview datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LXSettingCell *cell = [LXSettingCell cellWithTableView:tableView];
    cell.titleLable.text = @"清理缓存";
    cell.subtitleLable.text = [NSString stringWithFormat:@"%.1f M",self.cacheData];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearCache];
}
#pragma mark - 获取缓存大小
- (void)clearCache
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    NSArray *files = [[NSFileManager defaultManager]subpathsAtPath:cachePath];
    for (NSString *p in files) {
        NSError *error = nil;
        NSString *path = [cachePath stringByAppendingPathComponent:p];
        if ([[NSFileManager defaultManager]fileExistsAtPath:path]) {
            [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
        }
    }
    [self performSelectorOnMainThread:@selector(clearSuccess) withObject:nil waitUntilDone:YES];
}
- (void)clearSuccess
{
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    NSString *title = @"恭喜您";
    NSString *message = [NSString stringWithFormat:@"您已成功清理%.1fM缓存",self.cacheData];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"success");
    }];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:^{
        
    }];
}
- (CGFloat)cacheData
{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)firstObject];
    CGFloat cacheData = [self folderSizeAtPath:cachePath];
    self.cacheData = cacheData;
    return cacheData;
}
- (CGFloat)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath]objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil]fileSize];
    }
    return 0;
}
@end
