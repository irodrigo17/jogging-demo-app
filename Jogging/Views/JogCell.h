//
//  JogCell.h
//  Jogging
//
//  Created by Ignacio Rodrigo on 12/2/14.
//  Copyright (c) 2014 Ignacio Rodrigo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Jog.h"


extern NSString * const kJogCellReuseIdentifier;


@interface JogCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeAndDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

/**
 * Updates the reciver with the given jog by setting `timeAndDistanceLabel` and `dateLabel`'s text.
 */
- (void)updateWithJog:(Jog*)jog;

@end
