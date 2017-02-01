//
//  SPAServiceViewController.h
//  Reservation
//
//  Created by Spandana Nayakanti on 1/25/17.
//  Copyright © 2017 spandana. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SPAServiceViewController : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UITableView *tableViewForSPAService;
}


@end
