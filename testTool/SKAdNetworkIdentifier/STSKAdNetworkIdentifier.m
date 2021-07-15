//
//  STSKAdNetworkItems.m
//  SKAdNetwork
//
//  Created by steve on 2021/4/23.
//

#import "STSKAdNetworkIdentifier.h"
#import "STFile.h"
#import "STPrintfDefine.h"

@implementation STSKAdNetworkIdentifier

#pragma mark - download

+ (NSMutableArray *)downLoadAdItems {
    
    // 下载
    printfG("\n\n▶️  开始下载");
    printfDivider();
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *adItems = [[NSMutableArray alloc] init];
    NSMutableDictionary *jsonPathMap = [self createJsonPathMap];
    
    for (int i = 0; i < jsonPathMap.allKeys.count; i++) {
        printf("\n");
        
        NSString *key = [[jsonPathMap allKeys] objectAtIndex:i];
        NSString *value = [jsonPathMap objectForKey:key];
        
        printf("Download %s for \"%s\"\n",key.UTF8String, value.UTF8String);
        NSError *error;
        NSArray *arr = [STFile download:value name:key path:@"" error:&error];
        if (!error) {
            if (arr != nil && arr.count > 0) {
                printf("Download %s complete\n",key.UTF8String);
                [adItems addObject:arr];
            }
            else {
                printf(RED"[ERROR] Download %s error: arr is nil\n"NONE,key.UTF8String);
            }
        }
        else {
            printf(RED"[ERROR] Download %s error: %s\n"NONE,key.UTF8String, error.localizedDescription.UTF8String);
        }
        
        [dic setValue:arr==nil?@[]:arr forKey:key];
    }
    
    printf("\n");
    int count = 0;
    for (int i = 0; i<[dic allKeys].count; i++) {
        NSString *key = [[dic allKeys] objectAtIndex:i];
        NSArray *value = [dic objectForKey:key];
        printf("\n%-70s%8i个", key.UTF8String, (int)value.count);
        count += value.count;
    }
    
    printfDivider();
    printf(GREEN"\n%-70s%8i个"NONE, "Total download", count);
    printfG("\n✅ 下载结束\n");
    
    return adItems;
}

#pragma mark - deDuplication

+ (NSArray *)deDuplication:(NSArray *)adItems {
    // 去重
    printfG("\n\n▶️  开始去重");
    printfDivider();
    
    NSArray *idArray = [[NSArray alloc] init];
    for (int i = 0; i < adItems.count; i++) {
        NSArray *arr = [adItems objectAtIndex:i];
        idArray = [idArray arrayByAddingObjectsFromArray:arr];
    }

    printf("\n%-73s%8i个", "去重前", (int)idArray.count);

    NSArray *lowercaseIdItems = [idArray valueForKeyPath:@"lowercaseString"];
    NSArray *deDuplicationIdItems = [lowercaseIdItems valueForKeyPath:@"@distinctUnionOfObjects.self"];

    printf("\n%-73s%8i个", "去重后", (int)deDuplicationIdItems.count);

    printfDivider();
    printfG("\n✅ 去重结束\n");
    return deDuplicationIdItems;
}

#pragma mark - export


//// 转换SKAdNetworkItems 去重
//+ (void)deDuplicationaa:(NSString *)path {
//
//    // 获取当前脚本的目录
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//
//    // 获取当前目录下的文件列表
//    NSError *error;
//    NSMutableArray *plistArr = [[NSMutableArray alloc] init];
//    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
//    if (error) {
//        printf("%s",[NSString stringWithFormat:@"\n\n❌ GetFileList Failed.\nPath: %@ \nError: %@ ",path,error].UTF8String);
//        return;
//    }
//
//    if (fileList.count<=0) {
//        printf("\n\n❌ No File");
//        printf("\n\n*********************************  合并结束  *********************************");
//        return;;
//    }
//
//    // 筛选plist文件
//    for (int i = 0; i<fileList.count; i++) {
//        NSString *p = [fileList objectAtIndex:i];
//        if ([p containsString:@".plist"] || [p containsString:@".plist"]) {
//            [plistArr addObject:p];
//        }
//    }
//
//    if (plistArr.count<=0) {
//        printf("\n\n❌ No Plist File");
//        printf("\n\n*********************************  合并结束  *********************************");
//        return;;
//    }
//
//    // 读取Items
//    NSMutableString *itemsStr = [[NSMutableString alloc] init];
//    [itemsStr appendString:@"\n"];
//    NSMutableArray *adItems = [[NSMutableArray alloc] init];
//    for (NSString *fileName in plistArr) {
//        NSArray *item = [self readAdItems:[NSString stringWithFormat:@"%@/%@",path,fileName]];
//        [adItems addObjectsFromArray:item];
//
//        [itemsStr appendFormat:@"%@ %i个",[self appendBlankspace:fileName max:73],(int)item.count];
//        [itemsStr appendString:@"\n"];
//    }
//
//    NSArray *idItems = [adItems valueForKeyPath:@"SKAdNetworkIdentifier"];
//    [itemsStr appendString:@"\n"];
//    [itemsStr appendFormat:@"%@ %i个",[self appendBlankspace:@"共计" max:70],(int)idItems.count];
//    printf("%s",itemsStr.UTF8String);
//
//    printfG("\n------------------------------------------------------------------------------");
//    printfG("\n✅ 下载结束\n");
//
//
//    // 去重
//    printf("\n\n▶️  开始去重");
//    printf("\n------------------------------------------------------------------------------");
//
//    NSString *s = [NSString stringWithFormat:@"\n%@ %i个",[self appendBlankspace:@"去重前" max:69],(int)idItems.count];
//    printf("%s",s.UTF8String);
//
//    NSArray *lowercaseIdItems = [idItems valueForKeyPath:@"lowercaseString"];
//    NSArray *deDuplicationIdItems = [lowercaseIdItems valueForKeyPath:@"@distinctUnionOfObjects.self"];
//
//    s = [NSString stringWithFormat:@"\n%@ %i个",[self appendBlankspace:@"去重后" max:69],(int)deDuplicationIdItems.count];
//    printf("%s",s.UTF8String);
//
//    printf("\n------------------------------------------------------------------------------");
//    printf("\n✅ 去重结束\n");
//
//    // 去重后SKAdNetworkIdentifier列表
//    NSMutableArray *deDuplicationAdItems = [[NSMutableArray alloc] init];
//    for (int i = 0; i<deDuplicationIdItems.count; i++) {
//        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[deDuplicationIdItems objectAtIndex:i], @"SKAdNetworkIdentifier", nil];
//        [deDuplicationAdItems addObject:dic];
//    }
//
//    if (deDuplicationAdItems.count<=0) {
//        return;
//    }
//
//    // 准备导出 导出路径
//    NSString *exportPath = [path stringByAppendingPathComponent:@"export"];
//    if(![fileManager fileExistsAtPath:exportPath]) {
//        [fileManager createDirectoryAtPath:exportPath withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//
//    printf("\n\n▶️  开始导出");
//    printf("\n------------------------------------------------------------------------------");
//
//    // 导出plist
//    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
//    [infoDic setValue:deDuplicationAdItems forKey:@"SKAdNetworkItems"];
//    NSString *infoFilePath = [exportPath stringByAppendingPathComponent:@"Info_copy.plist"];
//    [infoDic writeToURL:[NSURL fileURLWithPath:infoFilePath] atomically:YES];
//
//    printf("\n");
//    printf("%s",[NSString stringWithFormat:@"plist导出目录: %@",infoFilePath].UTF8String);
//
//    // 导出txt
//    NSMutableString *text = [[NSMutableString alloc] init];
//    for (int i = 0; i<deDuplicationIdItems.count; i++) {
//        NSString *adid = [deDuplicationIdItems objectAtIndex:i];
//        [text appendString:@"\""];
//        [text appendString:adid];
//        [text appendString:@"\""];
//        if (i != deDuplicationIdItems.count-1) {
//            [text appendString:@",\n"];
//        }
//    }
//    NSString *txtFilePath = [exportPath stringByAppendingPathComponent:@"SKAdNetworkIdentifier.txt"];
//    NSError *error1;
//    [text writeToURL:[NSURL fileURLWithPath:txtFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error1];
//    printf("\n\n");
//    printf("%s",[NSString stringWithFormat:@"txt  导出目录: %@",txtFilePath].UTF8String);
//
//    printf("\n------------------------------------------------------------------------------");
//    printf("\n✅ 导出结束\n");
//
//    printf("\n\n*********************************  合并结束  *********************************");
//}

// 创建xml map
+ (NSMutableDictionary *)createJsonPathMap {
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
    
    return dic;
}

@end

