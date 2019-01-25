//
//  AMKViewController.m
//  AMKDispatcher
//
//  Created by AndyM129 on 01/25/2019.
//  Copyright (c) 2019 AndyM129. All rights reserved.
//

#import "AMKViewController.h"
#import <AMKDispatcher/AMKDispatcher.h>

// 测试
@interface AMKTargetActionModel : NSObject
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *targetName;
@property(nonatomic, strong) NSString *actionName;
@property(nonatomic, strong) NSDictionary *params;
@property(nonatomic, assign) BOOL shouldCache;
@end
@implementation AMKTargetActionModel
- (instancetype)initWithTitle:(NSString *)title targetName:(NSString *)targetName actionName:(NSString *)actionName params:(NSDictionary *)params shouldCache:(BOOL)shouldCache {
    if (self = [super init]) {
        self.title = title;
        self.targetName = targetName;
        self.actionName = actionName;
        self.params = params;
        self.shouldCache = shouldCache;
    }
    return self;
}
@end


@interface AMKViewController () <UITableViewDelegate , UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<AMKTargetActionModel *> *dataSource;
@end

@implementation AMKViewController

#pragma mark - Init Methods

#pragma mark - Life Circle

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AMKDispatcher 分发演示";
    self.view.backgroundColor = [UIColor whiteColor];
    [AMKDispatcher sharedInstance].targetPrefix = @"AMKTarget_";

    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Data & Networking

#pragma mark - Layout Subviews

#pragma mark - Properties

- (NSMutableArray<AMKTargetActionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Goto ViewController（页面跳转）" targetName:@"Demo" actionName:@"gotoViewControllerWithParams:" params:@{} shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Alert Without Params (分发没有参数的Action)" targetName:@"Demo" actionName:@"alertWithoutParams" params:@{} shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Alert Dispatcher Result (返回对象)" targetName:@"Demo" actionName:@"alertDispatcherResult:" params:@{@"text":@"andy test"} shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Alert Dispatcher Result (返回基础数据类型)" targetName:@"Demo" actionName:@"alertDispatcherResult2:" params:nil shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Action Forward（未识别方法）" targetName:@"Demo" actionName:@"xxxxx" params:@{} shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Target Forward（未识别Target）" targetName:@"XXX" actionName:@"gotoViewControllerWithParams:" params:@{} shouldCache:YES]];
        [_dataSource addObject:[[AMKTargetActionModel alloc] initWithTitle:@"Target&Action Forward（未识别Target和Action）" targetName:@"XXX" actionName:@"xxxxxxx" params:@{} shouldCache:YES]];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

#pragma mark - Actions

#pragma mark - Override

#pragma mark - Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row].title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AMKTargetActionModel *model = [self.dataSource objectAtIndex:indexPath.row];
    id object = [[AMKDispatcher sharedInstance] performTarget:model.targetName action:model.actionName params:model.params shouldCacheTarget:model.shouldCache];
    if (object) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Dispatcher Result" message:[object description] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}]];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];;
    }
}

#pragma mark - Helper Methods


@end
