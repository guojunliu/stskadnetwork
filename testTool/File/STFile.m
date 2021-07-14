//
//  STFile.m
//  stskadnetwork
//
//  Created by steve on 2021/7/13.
//

#import "STFile.h"
#import "STProgressBar.h"

@implementation STFile

+ (NSArray *)download:(NSString *)url name:(NSString *)name path:(NSString *)path error:(NSError **)error {
    if (url == nil || [url isEqualToString:@""]) {
        *error = [NSError errorWithDomain:@"STFile" code:0 userInfo:nil];
        return nil;
    }
    
    [STProgressBar start];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingUncached error:error];
    [STProgressBar completion];
    if (*error) {
        return nil;
    }
    id responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    if (*error) {
        return nil;
    }
    
    NSArray *array;
    if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSMutableDictionary class]]) {
        if ([[responseObject allKeys] containsObject:@"skadnetwork_ids"]) {
            array = [responseObject objectForKey:@"skadnetwork_ids"];
        }
    }
    else if ([responseObject isKindOfClass:[NSArray class]] || [responseObject isKindOfClass:[NSMutableArray class]]) {
        array = (NSArray *)responseObject;
    }
    else {
        *error = [NSError errorWithDomain:@"STFile" code:0 userInfo:nil];
        return nil;
    }
    
    NSArray *idItems = [array valueForKeyPath:@"skadnetwork_id"];
    return idItems;
}

@end
