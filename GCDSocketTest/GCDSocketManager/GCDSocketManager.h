//
//  GCDSocketManager.h
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/28.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncSocket.h>
NS_ASSUME_NONNULL_BEGIN

@interface GCDSocketManager : NSObject
/**
 GCDAsyncSocket
 */
@property (nonatomic, strong) GCDAsyncSocket *socket;
/**
 shareSocketManager管理类

 @return GCDAsyncSocket单例
 */
+ (instancetype)shareManager;
/**
 连接
 */
- (void)connectToServer;
/**
 发送数据
 */
- (void)sendDataToServer;
/**
 断开
 */
- (void)cutOffSocket;

@end

NS_ASSUME_NONNULL_END
