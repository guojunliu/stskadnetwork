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

+ (NSMutableArray *)downLoadAdItems:(NSDictionary *)sourceDic {
    
    // 下载
    printfG("\n▶️  开始下载");
    printfDivider();
    printf("\n");
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSMutableArray *adItems = [[NSMutableArray alloc] init];
    NSDictionary *jsonPathMap = sourceDic;
    
    for (int i = 0; i < jsonPathMap.allKeys.count; i++) {
        
        NSString *key = [[jsonPathMap allKeys] objectAtIndex:i];
        NSString *value = [jsonPathMap objectForKey:key];
        
//        printf("Download [%s] for url: \"%s\"",key.UTF8String, value.UTF8String);
        NSError *error;
        NSArray *arr = [STFile download:value name:key path:@"" error:&error];
        if (!error) {
            if (arr != nil && arr.count > 0) {
                printf("✅[SUCCE] Download [%s] complete\n",key.UTF8String);
                [adItems addObject:arr];
            }
            else {
                printf(RED"❌[ERROR] Download [%s] error: arr is nil; url: %s"NONE,key.UTF8String, value.UTF8String);
            }
        }
        else {
            printf(RED"❌[ERROR] Download [%s] error: %s; url: %s\n"NONE,key.UTF8String, error.localizedDescription.UTF8String, value.UTF8String);
        }
        
        [dic setValue:arr==nil?@[]:arr forKey:key];
    }
    
    printf("\n");
    int count = 0;
    for (int i = 0; i<[dic allKeys].count; i++) {
        NSString *key = [[dic allKeys] objectAtIndex:i];
        NSArray *value = [dic objectForKey:key];
        if (count == 0) {
            printf("\n⚠️%-70s%8i个", key.UTF8String, (int)value.count);
        }
        else {
            printf("\n✅%-70s%8i个", key.UTF8String, (int)value.count);
        }
        
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

@end

