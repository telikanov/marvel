//
//  ChatRLMObject.h
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "Realm.h"
#import "Dialog.h"

@interface ChatRLMObject : RLMObject

@property long idCharaster;
@property NSString *name;
@property NSString *avatarPath;
@property RLMArray <Dialog> *dialog;

@end
