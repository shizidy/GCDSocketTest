//
//  GCDUdpSocketManager.m
//  GCDSocketTest
//
//  Created by Macmini on 2019/8/29.
//  Copyright © 2019 Macmini. All rights reserved.
//

#import "GCDUdpSocketManager.h"
#import <MBProgressHUD.h>
#define UseGCDUdpSocket
//static NSString *const SocketHost = @"192.168.1.65";
static uint16_t const SocketPort = 12345;

@interface GCDUdpSocketManager () <GCDAsyncUdpSocketDelegate>
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

@implementation GCDUdpSocketManager

+ (instancetype)shareManager {
    static GCDUdpSocketManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [[super class] shareManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[super class] shareManager];
}

- (instancetype)init {
    if (self = [super init]) {
        //
    }
    return self;
}

- (void)connectToServer {
#ifdef UseGCDUdpSocket
    [self initGCDSocket];
#else
    [self initCSocket];
#endif
}

- (void)initGCDSocket {
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    //
    NSError *error = nil;
    //连接
    [self.socket bindToPort:SocketPort error:&error];
    //如果连接失败
    if (error) {
        NSLog(@"SocketConnectError:%@", error);
    } else {
        [self.socket beginReceiving:nil];
    }
}

- (void)initCSocket {
//    char receiveBuffer[1024];
//
//    __uint32_t nSize = sizeof(struct sockaddr);
//
//    if ((_listenfd = socket(AF_INET, SOCK_DGRAM, 0)) == -1)
//    {
//        /* handle exception */
//        perror("socket() error. Failed to initiate a socket");
//    }
//
//    bzero(&_addr, sizeof(_addr));
//
//    _addr.sin_family = AF_INET;
//
//    _addr.sin_port = htons(_destPort);
//
//    if(bind(_listenfd, (struct sockaddr *)&_addr, sizeof(_addr)) == -1)
//    {
//        perror("Bind() error.");
//    }
//
//    _addr.sin_addr.s_addr = inet_addr([_destHost UTF8String]);//ip可是是本服务器的ip，也可以用宏INADDR_ANY代替，代表0.0.0.0，表明所有地址
//
//    while(true){
//
//        long strLen = recvfrom(_listenfd, receiveBuffer, sizeof(receiveBuffer), 0, (struct sockaddr *)&_addr, &nSize);
//
//        NSString * message = [[NSString alloc] initWithBytes:receiveBuffer length:strLen encoding:NSUTF8StringEncoding];
//
//        _destPort = ntohs(_addr.sin_port);
//
//        _destHost = [[NSString alloc] initWithUTF8String:inet_ntoa(_addr.sin_addr)];
//
//        NSLog(@"来自%@---%zd:%@",_destHost,_destPort,message);
//
//        [self.messageArray addObject:[[MessageModel alloc] initWithMessage:message role:0]];
//
//        if (_receiveBlock) _receiveBlock();
//    }
}

- (void)sendDataToServer {
    NSString *msg = @"";
    if (TARGET_OS_SIMULATOR) {
        msg = @"你好！";
    } else {
        msg = @"谢谢！";
    }
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
#ifdef UseGCDUdpSocket
    // 该函数只是启动一次发送 它本身不进行数据的发送, 而是让后台的线程慢慢的发送 也就是说这个函数调用完成后,数据并没有立刻发送,异步发送
    NSString *host = @"";
    if (TARGET_OS_SIMULATOR) {
        host = @"192.168.2.2";
    } else {
        host = @"192.168.1.65";
    }
    [self.socket sendData:data toHost:host port:SocketPort withTimeout:-1 tag:0];
#else
//    sendto(_listenfd, [data bytes], [data length], 0, (struct sockaddr *)&_addr, sizeof(struct sockaddr));
#endif
}

- (void)cutOffSocket {
    [self.socket close];
}

#pragma mark ========== GCDAsyncUdpSocketDelegate ==========
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"发送信息成功");
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"发送信息失败");
}
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"来自%@---%hu:%@",[GCDAsyncUdpSocket hostFromAddress:address], [GCDAsyncUdpSocket portFromAddress:address], message);
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:[GCDAsyncUdpSocket hostFromAddress:address] message:[NSString stringWithFormat:@"%@", message] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
    NSLog(@"断开连接");
}

@end

