//
//  ReservationsTableViewCell.h
//  Reservation
//
//  Created by Spandana Nayakanti on 1/27/17.
//  Copyright © 2017 spandana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lableForDate;
@property (strong, nonatomic) IBOutlet UILabel *lableForTime;
@property (strong, nonatomic) IBOutlet UILabel *lableForPartySize;

@end
