//
//  DataManager.m
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "DataManager.h"
#import "Realm.h"

@implementation DataManager

- (void)insertDataIntoDataBaseWithId:(id)idCharaster witchName:(NSString *)nameCharaster witchAvatar:(NSString *)pathAvatar {
    ChatRLMObject *existObject = [[ChatRLMObject objectsWhere:@"idCharaster == %ld",[idCharaster longLongValue]]firstObject];
    if(existObject) {
        return;
    }
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    
    ChatRLMObject *chatObject = [ChatRLMObject new];
    chatObject.idCharaster = [idCharaster longLongValue];
    chatObject.name = nameCharaster;
    chatObject.avatarPath = pathAvatar;
    [realm addObject:chatObject];
    [realm commitWriteTransaction];
}

- (ChatRLMObject *)getDialogWithID:(long)idCharaster {
    ChatRLMObject *chatObject = [[ChatRLMObject objectsWhere:@"idCharaster == %ld",idCharaster]firstObject];
    
    return chatObject;
}

@end
