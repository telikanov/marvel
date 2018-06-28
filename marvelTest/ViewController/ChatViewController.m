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

@interface ChatViewController ()
@property (nonatomic, strong) DataManager *dataManager;
@property (nonatomic, strong) NSString *currentReplica;
@property (nonatomic, strong) NSMutableDictionary *dictionary;
@property (nonatomic, retain) NSMutableArray *charasterReplicas;
@property (nonatomic, retain) NSMutableArray *userReplicas;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataManager = [DataManager new];
    self.chatRLMObject = [self.dataManager getDialogWithID:self.idCharaster];
    
    self.dictionary = [[NSMutableDictionary alloc] init];
    self.charasterReplicas = [[NSMutableArray alloc] init];
    self.userReplicas = [[NSMutableArray alloc] init];
    
    [self.navigationItem setTitle:[NSString stringWithFormat:@"%@", self.chatRLMObject.name]];
    [self setMyReplicas];
    
    [self donwloadHistoryChatForCharacter:self.chatRLMObject.name];
    
    [self messageFromCharaster:@"" skipAdd:NO];
    
    [self performSelector:@selector(autoScrollBottom)
               withObject:self
               afterDelay:0.3];
}

- (void)autoScrollBottom {
    CGPoint bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height + self.chatScrollView.contentInset.bottom);
    [self.chatScrollView setContentOffset:bottomOffset animated:YES];
}

-(void)donwloadHistoryChatForCharacter:(NSString *)idCharaster {
    NSMutableDictionary *historyChat = [[[NSUserDefaults standardUserDefaults] objectForKey:idCharaster]mutableCopy];
    
    if(!historyChat) {
        NSString *key = [NSString stringWithFormat:@"%ld",self.chatRLMObject.idCharaster];
        [self.dictionary setValue:self.chatRLMObject.name forKey:key];
    }
    
    NSMutableArray *ch = [[historyChat objectForKey:@"charasterReplicase"] mutableCopy];
    if(ch.count >0) {
        self.charasterReplicas = [[historyChat objectForKey:@"charasterReplicase"] mutableCopy];
    }
    if([[historyChat objectForKey:@"userReplicase"] mutableCopy]) {
        self.userReplicas = [[historyChat objectForKey:@"userReplicase"] mutableCopy];
    }
    if(!(self.charasterReplicas.count)){
        return;
    }
    if(!(self.userReplicas.count)) {
        return;
    }
    
    NSArray *ch1 = [self.charasterReplicas mutableCopy];
    NSArray *us1 = [self.userReplicas mutableCopy];
    
    for(int i = 0; i < [ch1 count]; i++) {
        [self messageFromCharaster:ch1[i] skipAdd:YES];
        if(i < us1.count) {
            [self messageFromUser:us1[i] addSkip:YES];
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
            [self.charasterReplicas addObject:dialogView.textLabel.text];
        }
    } else {
        dialogView.textLabel.text = message;
    }
    [self.dialogStackView addArrangedSubview:dialogView];
    
    if (self.chatScrollView.contentSize.height + 2.5 * dialogView.frame.size.height > self.chatScrollView.frame.size.height) {
        CGPoint bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height + self.chatScrollView.contentInset.bottom + 2.5 * dialogView.frame.size.height);
        [self.chatScrollView setContentOffset:bottomOffset animated:YES];
    } else {
        CGPoint bottomOffset = CGPointMake(0, self.chatScrollView.contentSize.height - self.chatScrollView.bounds.size.height - self.chatScrollView.contentInset.bottom - 2.5 * dialogView.frame.size.height);
        [self.chatScrollView setContentOffset:bottomOffset animated:YES];
    }
    
}

- (void)setMyReplicas {
    NSArray *myReplicas = [NSArray arrayWithObjects:@"Привет, я твой создатель!", @"Ты кто такой?", @"Хочу спать", nil];
    for(NSString *replicas in myReplicas) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:replicas forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor redColor]];
        [button.layer setCornerRadius:10];
        [button setClipsToBounds:YES];
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
    [self.userReplicas addObject:button.titleLabel.text];
}

- (void)messageFromUser:(NSString *)message addSkip:(BOOL)skip {
    DialogCharasterView *dialogView = [[[NSBundle mainBundle] loadNibNamed:@"DialogCharasterView" owner:self options:nil] objectAtIndex:0];
    
    dialogView.avatarImageView.hidden = YES;
    dialogView.textLabel.text = message;
    dialogView.containerText.backgroundColor = [UIColor blueColor];
    [dialogView.containerText.layer setCornerRadius:20];
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
    [self.charasterReplicas addObject:repeatedAnswe];
}

- (void)dealloc {
    [self.dictionary setValue:self.charasterReplicas forKey:@"charasterReplicase"];
    [self.dictionary setValue:self.userReplicas forKey:@"userReplicase"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.dictionary forKey:self.chatRLMObject.name];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
