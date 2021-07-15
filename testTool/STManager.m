//
//  STManager.m
//  stskadnetwork
//
//  Created by steve on 2021/7/15.
//

#import "STManager.h"
#import "STSKAdNetworkIdentifier.h"
#import "STExport.h"

@implementation STManager

+ (void)exportToInfoPlist {
    NSMutableArray *adItems = [STSKAdNetworkIdentifier downLoadAdItems];
    NSArray *deDuplicationadItems = [STSKAdNetworkIdentifier deDuplication:adItems];
    [STExport exportToInfoPlist:deDuplicationadItems];
}

+ (void)exportToNewPlist:(NSString *)path {
    NSMutableArray *adItems = [STSKAdNetworkIdentifier downLoadAdItems];
    NSArray *deDuplicationadItems = [STSKAdNetworkIdentifier deDuplication:adItems];
    [STExport exportToNewPlist:deDuplicationadItems path:path];
}

+ (void)exportToString:(NSString *)path {
    NSMutableArray *adItems = [STSKAdNetworkIdentifier downLoadAdItems];
    NSArray *deDuplicationadItems = [STSKAdNetworkIdentifier deDuplication:adItems];
    [STExport exportToString:deDuplicationadItems path:path];
}

@end
