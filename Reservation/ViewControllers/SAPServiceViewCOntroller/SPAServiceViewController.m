//
//  SPAServiceViewController.m
//  Reservation
//
//  Created by Spandana Nayakanti on 1/25/17.
//  Copyright © 2017 spandana. All rights reserved.
//


#import "SPAServiceViewController.h"
#import  "QuartzCore/QuartzCore.h"
#import "ScheduleViewController.h"


#define SCROLLWIDTH     [UIScreen mainScreen].bounds.size.width


@interface SPAServiceViewController ()
{
    NSArray *arrayForServiceTableData;
    UIImageView *imageView;
    uint page;
}

@end

@implementation SPAServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //hides the back button
    
    self.navigationItem.hidesBackButton = YES;
    self.edgesForExtendedLayout=UIRectEdgeNone;

    self.title=@"SPA SERVICE";
    [self cretaingScrollingPages];
   
    //intialize service table data
    arrayForServiceTableData=[NSArray arrayWithObjects:@"Swedish Massage",@"Deep Tissue massage",@"Hot Stone massage",@"Reflexology",@"Trigger Point Therapy", nil];
    
    //rounded corner for tableview
    
    tableViewForSPAService.layer.cornerRadius = 5;
    tableViewForSPAService.layer.masksToBounds = YES;



    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CreatingPagination

-(void)cretaingScrollingPages{
    //
    scrollView.contentSize=CGSizeMake(SCROLLWIDTH*3, scrollView.frame.size.height);
    scrollView.delegate = self;
    
    for (int i =0; i<3; i++)
    {
       imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCROLLWIDTH*i, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        if (i==0)
        {
            imageView.image=[UIImage imageNamed:@"mothersdaymassage"];
            
        }
        else if (i==1)
        {
            imageView.image=[UIImage imageNamed:@"hotstonemassage"];

            
        }
        else
        {
            imageView.image=[UIImage imageNamed:@"deeptissue"];

        }
        [scrollView addSubview:imageView];
    }
}


#pragma mark changePage

-(IBAction)changePage:(id)sender
{
    [scrollView scrollRectToVisible:CGRectMake(SCROLLWIDTH*pageControl.currentPage, scrollView.frame.origin.y, SCROLLWIDTH, scrollView.frame.size.height) animated:YES];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    
    [self setIndiactorForCurrentPage];
    
}

-(void)setIndiactorForCurrentPage
{
   page = scrollView.contentOffset.x / SCROLLWIDTH;
    [pageControl setCurrentPage:page];
    
}
#pragma mark -TableView DataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    static NSString *simpleTableIdentifier = @"servicecell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [arrayForServiceTableData objectAtIndex:indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark -TableViewDelegate
#pragma mark - Move To Schedule Controller For Reserve HotStoneMassage

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==2) {
        
        ScheduleViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"schedule"];
        [self.navigationController pushViewController:SVC animated:YES];
        
    }
}

#pragma mark - Move To Schedule Controller For Reserve HotStoneMassage

- (IBAction)actnForReserve:(id)sender {
    if (page==1) {
        
    
    
    ScheduleViewController *SVC=[self.storyboard instantiateViewControllerWithIdentifier:@"schedule"];
    [self.navigationController pushViewController:SVC animated:YES];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
