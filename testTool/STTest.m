//
//  STTest.m
//  stskadnetwork
//
//  Created by steve on 2021/7/13.
//

#import "STTest.h"
#import "STNetwork.h"

@implementation STTest

+ (void)test {
    
//    // 线程测试-
//    NSLog(@"线程测试-1111");
//    dispatch_async(dispatch_queue_create(0, 0), ^{
////        NSData *dd = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://skan.mz.unity3d.com/v2/partner/skadnetworks.plist.xml"]];
////        NSLog(@"线程测试-33333");
////        // 子线程执行任务（比如获取较大数据）
//
////        NSLog(@"%@",dd);
//        NSLog(@"线程测试-44444");
//    });
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"线程测试-55555");
//        // 通知主线程刷新 神马的
//    });
//    NSLog(@"线程测试-22222");
    
//    // 创建URL对象
//    NSURL *url = [NSURL URLWithString:@"https://skan.mz.unity3d.com/v2/partner/skadnetworks.plist.xml"];
//    // 创建request对象
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//
//    // 发送异步请求
//    NSLog(@"下载测试-11111");
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        NSLog(@"下载测试-33333");
//        // 如果请求到数据
//        if (data) {
//        }
//        // 如果有错误信息，将错误信息返回
//        if (connectionError) {
//
//        }
//    }];
//    NSLog(@"下载测试-22222");
    
    [STNetwork HTTPGetWithUrl:@"https://skan.mz.unity3d.com/v3/partner/skadnetworks.plist.json" parameter:nil completion:^(id responseObject) {
    } error:^(NSError *error) {
    }];
    
//    for (int i = 0; i <= 1000; i++) {
//        NSLog(@"call");
//        usleep(1000000); //每0.1s刷新进度条
//    }
    
//    dispatch_main();
}

@end
