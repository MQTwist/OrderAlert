//
//  ViewController.m
//  OrderAlert
//
//  Created by ma qi on 2020/8/29.
//  Copyright © 2020 Twist. All rights reserved.
//

#import "ViewController.h"
#import "MQRoomAlertOrderManager.h"

@interface ViewController ()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, assign) BOOL hadTask;

@end

@implementation ViewController

- (void)dealloc {
    [[MQRoomAlertOrderManager shareInstance] destroy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.queue = dispatch_queue_create("com.twist.orderAlert", DISPATCH_QUEUE_CONCURRENT);
    [self MQ_AddBtn];
}

- (void)MQ_AddBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 100);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"Button" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)sender {
    NSLog(@">>>begin");
    if (self.hadTask) {
        NSLog(@">>> task is executing");
        return;
    }
    self.hadTask = YES;
    //目前只有三个任务
    for (NSInteger i = 0; i < 3; i++) {
        //模拟网络请求返回数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((arc4random() % 5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[MQRoomAlertOrderManager shareInstance] setTasKWithData:@"task" taskType:(MQRoomAlertType)i];
            [self orderAlert];
        });
    }
}

- (void)orderAlert {
    MQRoomAlertOrderManager *manager = [MQRoomAlertOrderManager shareInstance];
    if (manager.isExecuting) {//正在执行任务，既有弹窗在显示
        return;
    }
    if (manager.curTask) {
        switch (manager.curTask.alertType) {
            case MQRoomAlertType_HongBao: {
                NSLog(@">>>>>>MQRoomAlertType_HongBao");
                //标记执行
                [manager execute];
                dispatch_async(self.queue, ^{
                    //模拟弹窗时间
                    sleep(arc4random() % 5 + 1);
                    //取当前任务数据
//                    id data = [MQRoomAlertOrderManager shareInstance].curTask.taskData;
                    [self nextAlert];
                });
                break;
            }case MQRoomAlertType_GrowGift: {
                NSLog(@">>>>>>MQRoomAlertType_GrowGift");
                //标记执行
                [manager execute];
                dispatch_async(self.queue, ^{
                    //模拟弹窗时间
                    sleep(arc4random() % 5 + 1);
                    //取当前任务数据
//                    id data = [MQRoomAlertOrderManager shareInstance].curTask.taskData;
                    [self nextAlert];
                });
                break;
            }case MQRoomAlertType_Addention: {
                NSLog(@">>>>>>MQRoomAlertType_Addention");
                //标记执行
                [manager execute];
                dispatch_async(self.queue, ^{
                    //模拟弹窗时间
                    sleep(arc4random() % 5 + 1);
                    //取当前任务数据
//                    id data = [MQRoomAlertOrderManager shareInstance].curTask.taskData;
                    [self nextAlert];
                });
                break;
            }
            default:
                break;
        }
    }else {
        self.hadTask = NO;
        NSLog(@">>>all task completed");
    }
}

- (void)nextAlert {
    //当前任务完成
    [[MQRoomAlertOrderManager shareInstance] complete];
    //递归执行下一任务
    [self orderAlert];
}

@end
