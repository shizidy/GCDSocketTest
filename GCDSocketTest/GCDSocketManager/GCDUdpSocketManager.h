//
//  GCDUdpSocketManager.h
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/29.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GCDAsyncUdpSocket.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDUdpSocketManager : NSObject
/**
 GCDAsyncUdpSocket
 */
@property (nonatomic, strong) GCDAsyncUdpSocket *socket;
/**
 shareSocketManager管理类
 
 @return GCDAsyncUdpSocket单例
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
