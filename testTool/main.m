//
//  main.m
//  testTool
//
//  Created by steve on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "STManager.h"
#import "STPrintfDefine.h"
#import "BRLOptionParser.h"

int main(int argc, const char * argv[])
{
    @autoreleasepool {
        NSString *version = @"1.0.2";
        BOOL haveVersion = NO;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:@"" forKey:@"facebook"];
        [dic setValue:@"" forKey:@"admob"];
        [dic setValue:@"https://skan.mz.unity3d.com/v3/partner/skadnetworks.plist.json" forKey:@"unity"];
        [dic setValue:@"https://vungle.com/skadnetworkids.json" forKey:@"vungle"];
        [dic setValue:@"" forKey:@"ironsource"];
        [dic setValue:@"" forKey:@"applovin"];
        [dic setValue:@"https://a3.chartboost.com/skadnetworkids.json" forKey:@"chartboost"];
        [dic setValue:@"https://raw.githubusercontent.com/AdColony/AdColony-iOS-SDK/master/skadnetworkids.json" forKey:@"adcolony"];
        [dic setValue:@"https://www.inmobi.com/skadnetworkids.json" forKey:@"inmobi"];
        [dic setValue:@"" forKey:@"pangle"];
        [dic setValue:@"https://raw.githubusercontent.com/mopub/mopub-skadnetwork-ids/main/partners/mopub_marketplace.json" forKey:@"mopub"];
        [dic setValue:@"https://dev.mintegral.com/skadnetworkids.json" forKey:@"mintegral"];
        
        NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"jsonStr is %@",jsonStr);

        BRLOptionParser *options = [BRLOptionParser new];

        [options setBanner:@"usage: %s [-p] [-x <path>] [-t <path>]", argv[0]];
        [options addOption:"plist" flag:'p' description:@"将SKAdNetworkIdentifier导出到当前路径下的Info.plist中" block:^{
            [STManager exportToInfoPlist];
            exit(EXIT_SUCCESS);
        }];
        [options addSeparator];
        [options addOption:"xml" flag:'x' description:@"将SKAdNetworkIdentifier以XML格式导出到当前路径" blockWithArgument:^(NSString *value) {
            [STManager exportToNewPlist:value];
            exit(EXIT_SUCCESS);
        }];
        [options addOption:"txt" flag:'t' description:@"将SKAdNetworkIdentifier以TXT格式导出到当前路径" blockWithArgument:^(NSString *value) {
            [STManager exportToString:value];
            exit(EXIT_SUCCESS);
        }];
        
        [options addSeparator];
        [options addOption:"version" flag:'v' description:@"当前版本号" value:&haveVersion];
        __weak typeof(options) weakOptions = options;
        [options addOption:"help" flag:'h' description:@"使用帮助" block:^{
            printf("%s", [[weakOptions description] UTF8String]);
            exit(EXIT_SUCCESS);
        }];

        NSError *error = nil;
        if (![options parseArgc:argc argv:argv error:&error]) {
            const char * message = error.localizedDescription.UTF8String;
            fprintf(stderr, "%s: %s\n", argv[0], message);
            exit(EXIT_FAILURE);
        }

        if (haveVersion) {
            printf(GREEN"stskadnetwork version %s\n"NONE, version.UTF8String);
        }
    }

    return EXIT_SUCCESS;
}


//int aa() {
//    NSString *path;
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for (int i = 0; i<argc; i++) {
//        const char *c = argv[i];
//        NSString *s = [NSString stringWithUTF8String:c];
//        if (i == 0) {
//            path = s;
//            path = [path stringByDeletingLastPathComponent];
////                NSLog(@"Path : %@",s);
//        }
//        else {
////                NSLog(@"argv[%i] : %@",i,s);
//        }
//        [arr addObject:s];
//    }
//
//    if ([arr containsObject:@"-path"]) {
//        NSInteger i = [arr indexOfObject:@"-path"];
//        if (arr.count >= i+1) {
//            NSString *p = [arr objectAtIndex:i+1];
//            if (p && ![p isEqualToString:@""]) {
//                path = p;
//            }
//        }
//    };
//}
