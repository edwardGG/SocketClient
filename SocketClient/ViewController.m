//
//  ViewController.m
//  SocketClient
//
//  Created by Edward on 16/6/24.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *portTF;
@property (weak, nonatomic) IBOutlet UITextField *messageTF;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTF;
//客户端socket
@property (nonatomic) GCDAsyncSocket *clinetSocket;

@end

@implementation ViewController
#pragma mark - GCDAsynSocket Delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    [self showMessageWithStr:@"链接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP ： %@", host]];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

//收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.clinetSocket readDataWithTimeout:-1 tag:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

//开始连接
- (IBAction)connectAction:(id)sender {
    //2、连接服务器
    [self.clinetSocket connectToHost:self.addressTF.text onPort:self.portTF.text.integerValue withTimeout:-1 error:nil];
}

//发送消息
- (IBAction)sendMessageAction:(id)sender {
    NSData *data = [self.messageTF.text dataUsingEncoding:NSUTF8StringEncoding];
    //withTimeout -1 :无穷大
    //tag： 消息标记
    [self.clinetSocket writeData:data withTimeout:-1 tag:0];
}

//接收消息
- (IBAction)receiveMessageAction:(id)sender {
    [self.clinetSocket readDataWithTimeout:11 tag:0];
}

- (void)showMessageWithStr:(NSString *)str{
    self.showMessageTF.text = [self.showMessageTF.text stringByAppendingFormat:@"%@\n", str];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1、初始化
    self.clinetSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
