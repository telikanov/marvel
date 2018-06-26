//
//  Dialog.h
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "RLMObject.h"

@interface Dialog : RLMObject

@property NSString *message;
@property NSDate *date;

@end

RLM_ARRAY_TYPE(Dialog)
