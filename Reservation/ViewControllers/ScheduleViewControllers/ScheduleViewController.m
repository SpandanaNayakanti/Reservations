//
//  ScheduleViewController.m
//  Reservation
//
//  Created by Spandana Nayakanti on 1/25/17.
//  Copyright © 2017 spandana. All rights reserved.
//

#import "ScheduleViewController.h"
#import "TimeForCollectionViewCell.h"
#import "CLWeeklyCalendarView.h"
#import "IonIcons.h"
#import "AppDelegate.h"

//iphone macro

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
#define IS_ZOOMED (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


@interface ScheduleViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,CLWeeklyCalendarViewDelegate>{
    NSArray *arrayForAvilableTime,*arrayForPartySize;
    UIView *pickerBackView;
    UIPickerView *pickerView;
    NSString *stringForPartySize,*stringForPartyTime;
    NSDate *dateForParty;
    NSManagedObjectContext *context;
    AppDelegate *appDelgate;
    NSMutableDictionary *dictionaryForReservation;
    NSMutableArray *arrayForReservationDictionary;
    
    IBOutlet UIButton *btnPropertyForReserve;
    IBOutlet UICollectionView *collectionViewForTime;
}
@property (nonatomic, strong) CLWeeklyCalendarView* calendarView;

@end
static CGFloat CALENDER_VIEW_HEIGHT = 110.0f;
NSInteger selectedIndex;
bool condition=NO;
@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dictionaryForReservation=[[NSMutableDictionary alloc]init];
    arrayForAvilableTime=[[NSMutableArray alloc]init];
    self.title=@"SCHEDULE";
    arrayForAvilableTime=[NSArray arrayWithObjects:@"09:00 AM",@"10:00 AM",@"11:00 AM",@"12:00 PM",@"01:0 PM",@"02:00 PM",@"03:00 PM",@"04:00 PM",@"05:00 PM",@"06:00 PM",@"07:00 PM",@"08:00 PM",nil];
    arrayForPartySize=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    
    self.txtFldForPartySize.delegate=self;
    appDelgate=[[UIApplication sharedApplication]delegate];
    context=[appDelgate managedObjectContext];
    //adding calendarview
    [self.view addSubview:self.calendarView];
    [self supportMethod];
    
    //fade a button
//    btnPropertyForReserve.alpha=0;
    btnPropertyForReserve.enabled=NO;
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SupportMethods
-(void)supportMethod
{
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *barButtonForBack = [[UIBarButtonItem alloc]initWithImage: [IonIcons imageWithIcon:ion_ios_arrow_back
                                                                                                iconColor:[UIColor whiteColor]
                                                                                                 iconSize:40.0f
                                                                                                imageSize:CGSizeMake(40.0f, 40.0f)]style:UIBarButtonItemStylePlain target:self action:@selector(previousController)];
    
    self.navigationItem.leftBarButtonItem=barButtonForBack;

}
-(void)previousController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [arrayForAvilableTime count];

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TimeForCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (cell==nil) {
        cell=[[TimeForCollectionViewCell alloc] init];
    }
    
    cell.lableForTime.text=[arrayForAvilableTime objectAtIndex:indexPath.row];
    cell.lableForTime.layer.borderWidth=1.0f;
    cell.lableForTime.layer.borderColor= [UIColor blackColor].CGColor;
    cell.lableForTime.backgroundColor=[UIColor whiteColor];
    if (selectedIndex==indexPath.row&&condition==YES)
    {
       cell.lableForTime.backgroundColor=[UIColor grayColor];
        selectedIndex=nil;
    }
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //  NSLog(@"SETTING SIZE FOR ITEM AT INDEX %ld", (long)indexPath.row);
    CGSize mElementSize;
    
    mElementSize = CGSizeMake(80, 35);
    
    
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
     minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
    
}
#pragma mark - CollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selectedIndex=indexPath.row;
    condition=YES;
    stringForPartyTime=[arrayForAvilableTime objectAtIndex:indexPath.row];
    //TimeForCollectionViewCell *updateCell = (id)[collectionViewForTime cellForItemAtIndexPath:indexPath];
    [collectionViewForTime reloadData];
    [self checkingData];
   
}



#pragma mark - PickerViewForPartySize
-(void)pickerViewSelectPartySize{


    pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 260)];
    pickerBackView.backgroundColor=[UIColor whiteColor];



    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];


    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                               style:UIBarButtonItemStyleBordered
                                                              target:self
                                                                  action:@selector(updateData)];


    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(cancelData)];


    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                          target:self
                                                                          action:nil];




    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, flexible, doneButton, nil]];


    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.bounds.size.width, 216.0f)];

    pickerView.showsSelectionIndicator = YES;
    pickerView.delegate=self;

    [pickerBackView addSubview:pickerView];

    [pickerBackView addSubview:toolBar];
    
    [self.view addSubview:pickerBackView];


}
#pragma mark PickerView DataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return arrayForPartySize.count;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [arrayForPartySize objectAtIndex:row];
    return title;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    stringForPartySize = [arrayForPartySize objectAtIndex:row];

}
#pragma mark - Support Methods For Pickerview
-(void)updateData{
    if ([stringForPartySize isEqualToString:@"" ] || stringForPartySize.length<=0) {
        self.txtFldForPartySize.text=@"1";
        stringForPartySize=@"1";
   
    }else{
    self.txtFldForPartySize.text=stringForPartySize;
    }
    [self checkingData];

    pickerBackView.hidden=YES;
    
}
-(void)cancelData{
    pickerBackView.hidden=YES;

    
}
#pragma mark - UITextFiled Delegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.view endEditing:YES];
    [self pickerViewSelectPartySize];
}


//Initialize calendar view
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        if (IS_IPHONE_6) {
            _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 150)];
            _heightConstraint.constant=150;
            
        }
        else if (IS_IPHONE_6P){
            _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 170)];
            _heightConstraint.constant=200;
            
            
        }
        else{
            _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, CALENDER_VIEW_HEIGHT)];
        }
        _calendarView.delegate = self;
    }
    return _calendarView;
}




#pragma mark - CLWeeklyCalendarViewDelegate
-(NSDictionary *)CLCalendarBehaviorAttributes
{
    return @{
             CLCalendarWeekStartDay : @2,                 //Start Day of the week, from 1-7 Mon-Sun -- default 1
             //             CLCalendarDayTitleTextColor : [UIColor yellowColor],
             //             CLCalendarSelectedDatePrintColor : [UIColor greenColor],
             };
}



-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    dateForParty=date;
    [self checkingData];
    //You can do any logic after the view select the date
}
-(void)checkingData{
    
    if (stringForPartyTime.length>0 && stringForPartySize.length>0 && dateForParty!=nil) {
        btnPropertyForReserve.enabled=YES;
    }
    
}
#pragma mark save data to coredata
- (IBAction)actnForReserveHotstonemassage:(UIButton *)sender
{
 
    NSError *error;
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Reserve" inManagedObjectContext:context];
    
    NSManagedObject *saveRecord=[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:context];
    [saveRecord setValue:stringForPartyTime forKey:@"partytime"];
    [saveRecord setValue:dateForParty forKey:@"partydate"];
    [saveRecord setValue:stringForPartySize forKey:@"partysize"];
    [context save:&error];
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    NSArray *fetchedObjects;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Reserve"  inManagedObjectContext: context];
    [fetch setEntity:entityDescription];
    
 
    fetchedObjects = [context executeFetchRequest:fetch error:&error];
    NSLog(@"%lu rows from core data=",fetchedObjects.count);
   
    for (NSManagedObject * obj in fetchedObjects)
        {
           
            [arrayForReservationDictionary addObject: [obj valueForKey:@"partytime"]];
        }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
  

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
