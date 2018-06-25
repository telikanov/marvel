//
//  NetworkAPI.m
//  marvelTest
//
//  Created by Алексей Теликанов on 24.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "NetworkManager.h"
#import "NSString+MD5.h"

#define publickApiKey "39b8c2eda930d10dad23e151b728fd8d"
#define privatekApiKey "fa1009d440ca39f1bc6aee39eaae5cd5e51859ac"
#define adress "https://gateway.marvel.com/v1/public/characters"

@implementation NetworkManager

static NetworkManager *sharedManager = nil;

+ (NetworkManager*)sharedManager {
    static dispatch_once_t once;
    dispatch_once(&once, ^
                  {
                      sharedManager = [[NetworkManager alloc] init];
                  });
    return sharedManager;
}

- (void)getCharacters:(NSString *)ts limit:(NSString *)limit offset:(NSString *)offset completionHandler:(void (^)(NSArray *array))completionHandler {
    NSString *rawHash = [NSString stringWithFormat:@"%@%s%s", ts,privatekApiKey,publickApiKey];
    NSString *hash = [rawHash MD5String];
    hash = [hash lowercaseString];
    
    NSURL *URL = [NSURL URLWithString:@"http://gateway.marvel.com/v1/public/characters"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *parametrs = @{@"limit":limit,
                                @"offset":offset,
                                @"ts":ts,
                                 @"apikey":@publickApiKey,
                                 @"hash":hash};
    [manager GET:URL.absoluteString parameters:parametrs progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionHandler(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);

    }];
}

@end
