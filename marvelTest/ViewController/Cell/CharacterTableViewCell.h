//
//  CharacterTableViewCell.h
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *charasterImageView;
@property (weak, nonatomic) IBOutlet UILabel *charasterLabel;

- (UITableViewCell *)cellFilling:(NSString *)title urlImage:(NSString *)imagePath;

@end
