//
//  main.m
//  testTool
//
//  Created by steve on 2021/6/29.
//

#import <Foundation/Foundation.h>
#import "STSKAdNetworkItems.h"
#import "STProgressBar.h"
#import "STNetwork.h"
#import "STTest.h"
#import "STPrintfDefine.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        printfFlower;
        
        NSString *path;
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i<argc; i++) {
            const char *c = argv[i];
            NSString *s = [NSString stringWithUTF8String:c];
            if (i == 0) {
                path = s;
                path = [path stringByDeletingLastPathComponent];
//                NSLog(@"Path : %@",s);
            }
            else {
//                NSLog(@"argv[%i] : %@",i,s);
            }
            [arr addObject:s];
        }
        
        if ([arr containsObject:@"-path"]) {
            NSInteger i = [arr indexOfObject:@"-path"];
            if (arr.count >= i+1) {
                NSString *p = [arr objectAtIndex:i+1];
                if (p && ![p isEqualToString:@""]) {
                    path = p;
                }
            }
        };
        

        [STSKAdNetworkItems start];
    }
    
    // 挂起
    dispatch_main();
    return 0;
}
