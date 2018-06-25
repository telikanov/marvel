//
//  NetworkAPI.h
//  marvelTest
//
//  Created by Алексей Теликанов on 24.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface NetworkManager : NSObject

+ (id)sharedManager;

- (void)getCharacters:(NSString *)ts limit:(NSString *)limit offset:(NSString *)offset completionHandler:(void (^)(NSArray *array))completionHandler;

@property (nonatomic, assign) NSInteger currentCharacters;
@property (nonatomic, assign) NSInteger offsetCharacters;
@property (nonatomic, assign) NSInteger limitCharacters;
@property (nonatomic, assign) NSInteger totalCharacters;

@end
