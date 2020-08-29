//
//  MQRoomAlertOrderManager.h
//  samael
//
//  Created by ma qi on 2020/8/27.
//  Copyright © 2020 Twist. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MQRoomAlertTaskType) {
    MQRoomAlertTaskType_Runnable = 0,       //就绪
    MQRoomAlertTaskType_Running,            //执行中
    MQRoomAlertTaskType_end,                //完成
    
};

typedef NS_ENUM(NSInteger, MQRoomAlertType) {
    MQRoomAlertType_HongBao = 0,        //红包
    MQRoomAlertType_GrowGift,           //成长礼包
    MQRoomAlertType_Addention,          //关注
};


@interface MQRoomAlertOrderTask : NSObject

@property (nonatomic, assign) MQRoomAlertType alertType;
@property (nonatomic, strong) id taskData;
@property (nonatomic, assign) MQRoomAlertTaskType taskType;


@end


@interface MQRoomAlertOrderManager : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, strong, readonly, nullable) MQRoomAlertOrderTask *curTask;
/** 是否正在执行 */
@property (nonatomic, assign, readonly) BOOL isExecuting;

/** 缓存 */
- (void)setTasKWithData:(id)data taskType:(MQRoomAlertType)alertType;
/** 执行 */
- (void)execute;
/** 是否正在执行 */
- (BOOL)executing;
/** 完成 */
- (void)complete;
/** 清空 */
- (void)clear;
/** 根据任务类型获取任务 */
- (MQRoomAlertOrderTask *)getTaskWithAlertType:(MQRoomAlertType)alertType;

/** 销毁单例 */
- (void)destroy;

@end

NS_ASSUME_NONNULL_END
