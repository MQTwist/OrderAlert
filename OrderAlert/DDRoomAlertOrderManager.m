//
//  MQRoomAlertOrderManager.m
//  samael
//
//  Created by ma qi on 2020/8/27.
//  Copyright © 2020 Twist. All rights reserved.
//

#import "MQRoomAlertOrderManager.h"

@implementation MQRoomAlertOrderTask


@end

#define MAX_COUNT 3

@interface MQRoomAlertOrderManager ()

@property (nonatomic, strong) NSMutableArray *taskArr;

@end

@implementation MQRoomAlertOrderManager
@synthesize curTask = _curTask, isExecuting = _isExecuting;

static MQRoomAlertOrderManager *manager = nil;

+ (instancetype)shareInstance {
    manager = [[MQRoomAlertOrderManager alloc] init];
    return manager;
}

static dispatch_once_t onceToken;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
        [manager initData];
    });
    return manager;
}

- (void)initData {
    [self taskArr];
}

- (void)setTasKWithData:(id)data taskType:(DDRoomAlertType)alertType {
    NSLog(@">>>set data:%@ alertType:%zd", data, alertType);
    NSInteger index = MIN(MAX_COUNT - 1, alertType);
    MQRoomAlertOrderTask *task = self.taskArr[index];
    task.taskType = DDRoomAlertTaskType_Runnable;
    task.taskData = data;
    task.alertType = alertType;
    [self.taskArr replaceObjectAtIndex:index withObject:task];
    if (_isExecuting) {//有任务正在执行，则当前任务不更新
        return;
    }
    [self getCurTask];
}

- (void)getCurTask {
    _curTask = nil;
    for (NSInteger i = 0; i < self.taskArr.count; i++) {
        MQRoomAlertOrderTask *task = self.taskArr[i];
        if (task.taskType == DDRoomAlertTaskType_Runnable) {
            _curTask = task;
            break;
        }
    }
}

- (void)execute {
    self.curTask.taskType = DDRoomAlertTaskType_Running;
    _isExecuting = YES;
    NSLog(@">>>execute alertType:%zd taskType:%zd",self.curTask.alertType, self.curTask.taskType);
}

///** 是否正在执行 */
- (BOOL)executing {
    return _isExecuting;
}

- (void)complete {
    self.curTask.taskType = DDRoomAlertTaskType_end;
    _isExecuting = NO;
    [self getCurTask];
    NSLog(@">>>curTask complete");
}

/** 清空 */
- (void)clear {
    _curTask = nil;
    for (NSInteger i = 0; i < self.taskArr.count; i++) {
        MQRoomAlertOrderTask *task = self.taskArr[i];
        task.taskType = DDRoomAlertTaskType_end;
    }
}

- (MQRoomAlertOrderTask *)getTaskWithAlertType:(DDRoomAlertType)alertType {
    NSInteger index = MIN(alertType, self.taskArr.count - 1);
    return self.taskArr[index];
}

/** 销毁单例 */
- (void)destroy {
    manager = nil;
    onceToken = 0;
    NSLog(@">>>DDRoomAlertOrderManager Destroy");
}

#pragma mark -
#pragma mark - getter ---> data

- (NSMutableArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [NSMutableArray array];
        for (NSInteger i = 0; i < MAX_COUNT; i++) {
            MQRoomAlertOrderTask *task = [MQRoomAlertOrderTask new];
            task.taskType = DDRoomAlertTaskType_end;
            task.alertType = (DDRoomAlertType)i;
            [_taskArr addObject:task];
        }
    }
    return _taskArr;
}

@end
