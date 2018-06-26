//
//  ChatViewController.h
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatRLMObject.h"

@interface ChatViewController : UIViewController

@property (nonatomic, strong) ChatRLMObject *chatRLMObject;
@property (nonatomic, assign) long idCharaster;

@end
