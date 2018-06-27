//
//  ChatViewController.m
//  marvelTest
//
//  Created by Алексей Теликанов on 26.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatRLMObject.h"
#import "DataManager.h"
#import "DialogCharasterView.h"
#import "Dialog.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChatViewController () {
    DataManager *dataManager;
    NSString *currentReplica;
    NSMutableDictionary *dictionary;
    NSMutableArray *charasterReplicas;
    NSMutableArray *userReplicas;
}
@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataManager = [DataManager new];
    self.chatRLMObject = [dataManager getDialogWithID:self.idCharaster];
    
    dictionary = [[NSMutableDictionary alloc] init];
    charasterReplicas = [[NSMutableArray alloc] init];
    userReplicas = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", self.chatRLMObject.name]];
    [self setMyReplicas];
    
    NSString *key = [NSString stringWithFormat:@"%ld",self.chatRLMObject.idCharaster];
    [dictionary setValue:self.chatRLMObject.name forKey:key];
    
    [self donwloadHistoryChatForCharacter:self.chatRLMObject.name];
    
    [self messageFromCharaster:@"" skipAdd:NO];
}

-(void)donwloadHistoryChatForCharacter:(NSString *)idCharaster {
    NSMutableDictionary *historyChat = [[[NSUserDefaults standardUserDefaults] objectForKey:idCharaster]mutableCopy];
    NSMutableArray *ch = [[historyChat objectForKey:@"charasterReplicase"] mutableCopy];
    if(ch.count >0) {
        charasterReplicas = [[historyChat objectForKey:@"charasterReplicase"] mutableCopy];
    }
    if([[historyChat objectForKey:@"userReplicase"] mutableCopy]) {
        userReplicas = [[historyChat objectForKey:@"userReplicase"] mutableCopy];
    }
    if(!(charasterReplicas.count)){
        return;
    }
    if(!(userReplicas.count)) {
        return;
    }
    
    NSArray *ch1 = [charasterReplicas mutableCopy];
    NSArray *us1 = [userReplicas mutableCopy];
    
    for(int i = 0; i < [ch1 count]; i++) {
        [self messageFromCharaster:ch1[i]skipAdd:YES];
        if (i >= 1) {
            for(int j = 0; j < [us1 count]; j++) {
                [self messageFromUser:us1[j] addSkip:YES];
            }
        }
    }
}

- (void)messageFromCharaster:(NSString *)message skipAdd:(BOOL)skip{
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    SDImageCache* myCache = [SDImageCache sharedImageCache];
    UIImage* avatar = [myCache imageFromDiskCacheForKey:self.chatRLMObject.avatarPath];
    dialogView.avatarImageView.image = avatar;
    if([message isEqualToString:@""]){
        dialogView.textLabel.text = [NSString stringWithFormat:@"Привет,герой, меня зовут %@",self.chatRLMObject.name];
        if (!skip) {
            [charasterReplicas addObject:dialogView.textLabel.text];
        }
    } else {
        dialogView.textLabel.text = message;
    }
    [self.dialogStackView addArrangedSubview:dialogView];
}

- (void)setMyReplicas {
    NSArray *myReplicas = [NSArray arrayWithObjects:@"Привет, я твой создатель!", @"Ты кто такой?", @"Хочу спать", nil];
    for(NSString *replicas in myReplicas) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:replicas forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button addTarget:self
                   action:@selector(touchDown:)
         forControlEvents:UIControlEventTouchUpInside];
        CGRect      buttonFrame = button.frame;
        buttonFrame.size = CGSizeMake(150, 70);
        button.frame = buttonFrame;
        [self.variantsAnswersStackView addArrangedSubview:button];
    }
}

- (IBAction)touchDown:(id)sender {
    UIButton *button = (UIButton*)sender;
    [self messageFromUser:button.titleLabel.text addSkip:NO];
    [userReplicas addObject:button.titleLabel.text];
}

- (void)messageFromUser:(NSString *)message addSkip:(BOOL)skip {
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    dialogView.avatarImageView.hidden = YES;
    dialogView.textLabel.text = message;
    dialogView.containerText.backgroundColor = [UIColor grayColor];
    [dialogView.containerText.layer setCornerRadius:9];
    dialogView.layer.cornerRadius = 10;
    dialogView.clipsToBounds = true;
    
    [self.dialogStackView addArrangedSubview:dialogView];
    if(!skip) {
        [self sendAnswerCharaster:message];
    }
}

- (void)sendAnswerCharaster:(NSString *)userReplic {
    NSString *repeatedAnswe;
    if ([userReplic isEqualToString:@"Привет, я твой создатель!"]) {
        repeatedAnswe = @"Мой прородитель ВЕЛИКИЙ Мартин Гудмен! а ты ios-разработчик";
    } else if ([userReplic isEqualToString:@"Ты кто такой?"]) {
        repeatedAnswe = [NSString stringWithFormat: @"Я же представлялся! Я %@ ! О моих приключениях можешь почитать в комиксах",self.chatRLMObject.name];
    } else {
        repeatedAnswe =@"Тут еще одна геройская фраза";
    }
    [self messageFromCharaster:repeatedAnswe skipAdd:NO];
    [charasterReplicas addObject:repeatedAnswe];
}

- (void)dealloc {
    [dictionary setValue:charasterReplicas forKey:@"charasterReplicase"];
    [dictionary setValue:userReplicas forKey:@"userReplicase"];
    
    [[NSUserDefaults standardUserDefaults] setObject:dictionary forKey:self.chatRLMObject.name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
