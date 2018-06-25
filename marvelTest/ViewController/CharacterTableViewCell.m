//
//  CharacterTableViewCell.m
//  marvelTest
//
//  Created by Алексей Теликанов on 25.06.2018.
//  Copyright © 2018 Алексей Теликанов. All rights reserved.
//

#import "CharacterTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CharacterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (UITableViewCell *)cellFilling:(NSString *)title urlImage:(NSString *)imagePath {
    self.charasterLabel.text = title;
    [self.charasterImageView sd_setImageWithURL:[NSURL URLWithString:imagePath]
                               placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    return self;
}

@end
