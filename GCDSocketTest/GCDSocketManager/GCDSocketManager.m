//
//  GCDSocketManager.m
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/28.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "GCDSocketManager.h"

static NSString *const SocketHost = @"127.0.0.1";
static uint16_t const SocketPort = 12345;

@interface GCDSocketManager () <GCDAsyncSocketDelegate>
/**
 断开重连定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 握手次数
 */
@property (nonatomic, assign) NSInteger pushCount;
/**
 重连次数
 */
@property (nonatomic, assign) NSInteger reconnectCount;
@end

@implementation GCDSocketManager
//单例实现
+ (instancetype)shareManager {
    static GCDSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        //
    }
    return self;
}

- (void)connectToServer {
    //初始化握手次数
    self.pushCount = 0;
    //初始化socket
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //
    NSError *error = nil;
    //连接
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    //如果连接失败
    if (error) {
        NSLog(@"SocketConnectError:%@", error);
    }
}

- (void)reconnectServer {
    self.pushCount = 0;
    self.reconnectCount = 0;
    //连接失败重新连接
    NSError *error = nil;
    //连接
    [self.socket connectToHost:SocketHost onPort:SocketPort error:&error];
    //如果连接失败
    if (error) {
        NSLog(@"SocketConnectError:%@", error);
    }
}

- (void)cutOffSocket {
    NSLog(@"断开连接");
    self.pushCount = 0;
    self.reconnectCount = 0;
    [self timerInvalidate];
    [self.socket disconnect];
}

- (void)timerInvalidate {
    [self.timer invalidate];
    _timer = nil;
}

#pragma mark ========== GCDAsyncSocketDelegate ==========
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(nonnull NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功");
    NSLog(@"服务器IP:%@=========端口号:%d", host, port);
    [self timerInvalidate];
//    [self sendDataToServer];
}

- (void)sendDataToServer {
    NSString *msg = @"发送数据: 你好\r\n";
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    // withTimeout -1 : 无穷大,一直等
    // tag : 消息标记
    //发送数据
    [self.socket writeData:data withTimeout:-1 tag:0];
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"发送数据 tag = %ld", tag);
    //读取数据
    [self.socket readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    //服务器推送次数
    self.pushCount++;
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"读取数据 data = %@ tag = %zi",str,tag);
    // 读取到服务端数据值后,能再次读取
    [sock readDataWithTimeout:-1 tag:tag];
    //此处进行校验服务器给定的格式
}

//连接失败回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"连接失败");
//    //握手次数置0
//    self.pushCount = 0;
//    //程序进入前台、后台时，分别记录当前程序处于什么状态
//    //如果处于前台，连接失败进行重连 如果处于后台，连接失败不再重连
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *currentStatus = [userDefaults valueForKey:@"status"];
//    //程序进入前台进行重连
//    if ([currentStatus isEqualToString:@"foreground"]) {
//        //重连次数
//        self.reconnectCount++;
//        //如果连接失败，累加1s重新连接
//        self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
//        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    }
    
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(reconnectServer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


@end
