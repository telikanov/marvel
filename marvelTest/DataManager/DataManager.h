//
//  DataManager.h
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

- (void)insertDataIntoDataBaseWithId:(id)idCharaster witchName:(NSString *)nameCharaster witchAvatar:(NSString *)pathAvatar;

@end
