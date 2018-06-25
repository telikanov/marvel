//
//  NSString+MD5.h
//  marvelTest
//
//  Created by Алексей Теликанов on 24.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonCrypto/CommonDigest.h"

@interface NSString (MD5)

- (NSString *)MD5String;

@end
