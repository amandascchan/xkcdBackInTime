//
//  ViewController.m
//  xkcd progress bar
//
//  Created by Administrator on 2014-03-20.
//  Copyright (c) 2014 amanda. All rights reserved.
//

#import "mainViewController.h"
#import <math.h>

@interface mainViewController () {
    NSCalendar *gregorian;
    NSInteger era;
    
}

@property (nonatomic, strong) NSDate *currentDate;

@end

@implementation mainViewController

- (NSString *)setDisplayStringFromDate:(NSDate *)date {
    
    NSString *displayString;
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    NSDateComponents *dateComponents = [gregorian components:NSEraCalendarUnit fromDate:date];
    NSLog(@"era: %ld", (long)[dateComponents era]);
    if(era > 0)  {
        [dateFormatter setDateStyle:NSDateFormatterFullStyle];
        displayString = [dateFormatter stringFromDate:date];
    }
    else  {
        [dateFormatter setDateFormat:@"yyyy"];
        displayString = [NSString stringWithFormat:@"%@ years ago", [dateFormatter stringFromDate:date]];
    }
    return displayString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    self.dateReturned.text = @"";
}

-(void)tap:(UIGestureRecognizer *)tap {
    [self.view endEditing:YES];
    self.currentDate = [NSDate date];
    if(self.percentCompletedText.text.length > 0){
        NSDate *dateToDisplay = [self equationPercentCompleted:([self.percentCompletedText.text doubleValue]/100.0) currentDate:self.currentDate];
        NSString *displayString = [self setDisplayStringFromDate:dateToDisplay];
        self.dateReturned.text = displayString;
        
    }
    else {
        self.dateReturned.text = @"Please enter an actual number bro";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSDate *)equationPercentCompleted:(double)percentCompleted currentDate:(NSDate *)date {
    
    double yearsToSubtract = exp(20.3444 * pow(percentCompleted, 3) + 3) - exp(3);
    
    NSDateComponents *currentDateComponents = [gregorian components:NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitYear fromDate:date];
    
    NSDateComponents *subtractedYears = [[NSDateComponents alloc] init];
    
    double totalYears = [currentDateComponents year] - yearsToSubtract;
    if(totalYears > 0) era = 1;
    else era = 0;
    
    [subtractedYears setYear:totalYears];
    [subtractedYears setDay:[currentDateComponents day]];
    [subtractedYears setMonth:[currentDateComponents month]];
    
    NSDate *finalDate = [gregorian dateFromComponents:subtractedYears];
    
    return finalDate;
    
}

@end
