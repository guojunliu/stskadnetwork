//
//  STSKAdNetworkItems.m
//  SKAdNetwork
//
//  Created by steve on 2021/4/23.
//

#import "STSKAdNetworkItems.h"

@implementation STSKAdNetworkItems

+ (NSArray *)readAdItems:(NSString *)filePath {
    NSArray *adItems = [NSArray arrayWithContentsOfFile:filePath];
    return adItems;
}

// 转换SKAdNetworkItems 去重
+ (void)deDuplication:(NSString *)path {
    
    NSMutableString *log = [[NSMutableString alloc] init];
    NSString *s = @"";
    
    //**************************************************************************************
    //*    ____ _____   ____  _  __    _       _ _   _      _ __        __         _       *
    //*   / ___|_   _| / ___|| |/ /   / \   __| | \ | | ___| |\ \      / /__  _ __| | __   *
    //*   \___ \ | |   \___ \| ' /   / _ \ / _` |  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ /   *
    //*    ___) || |    ___) | . \  / ___ \ (_| | |\  |  __/ |_ \ V  V / (_) | |  |   <    *
    //*   |____/ |_|   |____/|_|\_\/_/   \_\__,_|_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\   *
    //*                                                                                    *
    //**************************************************************************************
    
    // 上边的字符画
    NSString *base64String = @"KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqCgogX19fXyBfX19fXyAgIF9fX18gIF8gIF9fICAgIF8gICAgICAgXyBfICAgXyAgICAgIF8gX18gICAgICAgIF9fICAgICAgICAgXyAgICAgCi8gX19ffF8gICBffCAvIF9fX3x8IHwvIC8gICAvIFwgICBfX3wgfCBcIHwgfCBfX198IHxcIFwgICAgICAvIC9fXyAgXyBfX3wgfCBfXyAKXF9fXyBcIHwgfCAgIFxfX18gXHwgJyAvICAgLyBfIFwgLyBfYCB8ICBcfCB8LyBfIFwgX19cIFwgL1wgLyAvIF8gXHwgJ19ffCB8LyAvIAogX19fKSB8fCB8ICAgIF9fXykgfCAuIFwgIC8gX19fIFwgKF98IHwgfFwgIHwgIF9fLyB8XyBcIFYgIFYgLyAoXykgfCB8ICB8ICAgPCAgCnxfX19fLyB8X3wgICB8X19fXy98X3xcX1wvXy8gICBcX1xfXyxffF98IFxffFxfX198XF9ffCBcXy9cXy8gXF9fXy98X3wgIHxffFxfXCAKCgogICAgICAgICAgICAgICAgICAgICAgICAg5bm/5ZGK6IGU55ufU0tBZE5ldHdvcmvlkIjlubblt6XlhbcgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg==";
    NSData *base64date = [[NSData alloc] initWithBase64EncodedString:base64String options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *flowersCode = [[NSString alloc] initWithData:base64date encoding:NSUTF8StringEncoding];
    [log appendFormat:@"\n\n%@",flowersCode];
    
    // 读取
    s = @"\n\n▶️  开始读取";
    [log appendFormat:@"%@",s];
    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];
    
    // 获取当前脚本的目录
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 获取当前目录下的文件列表
    NSError *error;
    NSMutableArray *plistArr = [[NSMutableArray alloc] init];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error) {
        s = [NSString stringWithFormat:@"❌ GetFileList Failed.\nPath: %@ \nError: %@ ",path,error];
        [log appendFormat:@"\n\n%@",s];
        
        NSLog(@"%@",log);
        return;
    }
    
    if (fileList.count<=0) {
        s = @"❌ No File";
        [log appendFormat:@"\n\n%@",s];
        
        s = @"\n\n*********************************  合并结束  *********************************";
        [log appendFormat:@"%@",s];
        NSLog(@"%@",log);
        return;;
    }
    
    // 筛选plist文件
    for (int i = 0; i<fileList.count; i++) {
        NSString *p = [fileList objectAtIndex:i];
        if ([p containsString:@".plist"] || [p containsString:@".plist"]) {
            [plistArr addObject:p];
        }
    }
    
    if (plistArr.count<=0) {
        s = @"❌ No Plist File";
        [log appendFormat:@"\n\n%@",s];
        
        s = @"\n\n*********************************  合并结束  *********************************";
        [log appendFormat:@"%@",s];
        NSLog(@"%@",log);
        return;;
    }
    
    // 读取Items
    NSMutableString *itemsStr = [[NSMutableString alloc] init];
    [itemsStr appendString:@"\n"];
    NSMutableArray *adItems = [[NSMutableArray alloc] init];
    for (NSString *fileName in plistArr) {
        NSArray *item = [self readAdItems:[NSString stringWithFormat:@"%@/%@",path,fileName]];
        [adItems addObjectsFromArray:item];
        
        [itemsStr appendFormat:@"%@ %i个",[self appendBlankspace:fileName max:73],(int)item.count];
        [itemsStr appendString:@"\n"];
    }
    
    NSArray *idItems = [adItems valueForKeyPath:@"SKAdNetworkIdentifier"];
    [itemsStr appendString:@"\n"];
    [itemsStr appendFormat:@"%@ %i个",[self appendBlankspace:@"共计" max:70],(int)idItems.count];
//    [itemsStr appendString:@"\n"];
    s = itemsStr;
    [log appendFormat:@"%@",s];
    
    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];
    s = @"\n✅ 读取结束\n";
    [log appendFormat:@"%@",s];
    
    
    // 去重
    s = @"\n\n▶️  开始去重";
    [log appendFormat:@"%@",s];
    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];

    s = [NSString stringWithFormat:@"\n%@ %i个",[self appendBlankspace:@"去重前" max:69],(int)idItems.count];
    [log appendFormat:@"%@",s];
    
    NSArray *lowercaseIdItems = [idItems valueForKeyPath:@"lowercaseString"];
    NSArray *deDuplicationIdItems = [lowercaseIdItems valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    s = [NSString stringWithFormat:@"\n%@ %i个",[self appendBlankspace:@"去重后" max:69],(int)deDuplicationIdItems.count];
    [log appendFormat:@"%@",s];

    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];
    s = @"\n✅ 去重结束\n";
    [log appendFormat:@"%@",s];
    
    // 去重后SKAdNetworkIdentifier列表
    NSMutableArray *deDuplicationAdItems = [[NSMutableArray alloc] init];
    for (int i = 0; i<deDuplicationIdItems.count; i++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[deDuplicationIdItems objectAtIndex:i], @"SKAdNetworkIdentifier", nil];
        [deDuplicationAdItems addObject:dic];
    }
    
    if (deDuplicationAdItems.count<=0) {
        return;
    }
    
    // 准备导出 导出路径
    NSString *exportPath = [path stringByAppendingPathComponent:@"export"];
    if(![fileManager fileExistsAtPath:exportPath]) {
        [fileManager createDirectoryAtPath:exportPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    s = @"\n\n▶️  开始导出";
    [log appendFormat:@"%@",s];
    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];
    
    // 导出plist
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setValue:deDuplicationAdItems forKey:@"SKAdNetworkItems"];
    NSString *infoFilePath = [exportPath stringByAppendingPathComponent:@"Info_copy.plist"];
    [infoDic writeToURL:[NSURL fileURLWithPath:infoFilePath] atomically:YES];
    
    [log appendFormat:@"%@",@"\n"];
    s = [NSString stringWithFormat:@"plist导出目录: %@",infoFilePath];
    [log appendFormat:@"%@",s];
    
    // 导出txt
    NSMutableString *text = [[NSMutableString alloc] init];
    for (int i = 0; i<deDuplicationIdItems.count; i++) {
        NSString *adid = [deDuplicationIdItems objectAtIndex:i];
        [text appendString:@"\""];
        [text appendString:adid];
        [text appendString:@"\""];
        if (i != deDuplicationIdItems.count-1) {
            [text appendString:@",\n"];
        }
    }
    NSString *txtFilePath = [exportPath stringByAppendingPathComponent:@"SKAdNetworkIdentifier.txt"];
    NSError *error1;
    [text writeToURL:[NSURL fileURLWithPath:txtFilePath] atomically:YES encoding:NSUTF8StringEncoding error:&error1];
    [log appendFormat:@"%@",@"\n\n"];
    s = [NSString stringWithFormat:@"txt  导出目录: %@",txtFilePath];
    [log appendFormat:@"%@",s];
    
    s = @"\n------------------------------------------------------------------------------";
    [log appendFormat:@"%@",s];
    s = @"\n✅ 导出结束\n";
    [log appendFormat:@"%@",s];
    
    s = @"\n\n*********************************  合并结束  *********************************";
    [log appendFormat:@"%@",s];
    
    NSLog(@"%@",log);
}

+ (NSString *)appendBlankspace:(NSString *)str max:(NSUInteger)max{
    NSUInteger append = max - str.length;
    if (append<=0) {
        return str;
    }
    for (int i = 0; i<append; i++) {
        str = [NSString stringWithFormat:@"%@ ",str];
    }
    return str;
}

@end

