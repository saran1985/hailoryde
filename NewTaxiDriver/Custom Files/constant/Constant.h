//
//  Constant.h
//  Cabxy
//
//  Created by Immanuel Infant Raj.S on 7/27/15.
//  Copyright (c) 2015 Immanuel Infant Raj.S. All rights reserved.
//





#import <Foundation/Foundation.h>


extern int tabid;
extern int can;
extern int de;

////TEST
//#define BASE_URL @"http://testapi.canadiansaferide.ca/api/driver/"
//#define LOGIN_URL @"http://testapi.canadiansaferide.ca/"
//#define PAY @"https://checkout.payFort.com/FortAPI/paymentPage?"

//PROD
#define BASE_URL @"https://api.canadiansaferide.ca/api/driver/"
#define LOGIN_URL @"https://api.canadiansaferide.ca/"
#define PAY @"https://checkout.payFort.com/FortAPI/paymentPage?"

#define NAMEVAL @"Please enter your name"
#define NAMESTRVAL @"Name should be in alphabets only"
#define MBLEVAL @"Please enter your mobile number"
#define MBLERANVAL @"Enter 10 digit mobile number"
#define MBLENUMVAL @"Enter valid mobile number"
#define EMAILVAL @"Please enter email id"
#define EMAILSTRVAL @"Enter valid email"
#define PWDVAL @"Please enter password"
#define PWDRANVAL @"Password should be at least 6 characters"
#define CNFPWDVAL @"Please enter confirm password"
#define CNFPWDRANVAL @"Password should be at least 6 characters"
#define MAKEVAL @"Please enter make and model"
#define INSVAL @"Please enter insurance number"
#define LICVAL @"Please enter license number"
#define PLATEVAL @"Please enter plate number"
#define HSTVAL @"Please enter hst number"
#define CARVAL @"Please enter car color"
#define CITYVAL @"Please select city"
#define CABVAL @"Please select cab type"
#define UPLPLATE @"Please upload plate number"
#define UPLHST @"Please upload hst number"
#define UPLCAR @"Please upload car color"
#define UPLWORK @"Please upload work permit"
#define UPLOWN @"Please upload owner ship"
#define PWDMISMATCH @"Password mismatch"
#define OTPVAL @"Please enter otp number"
#define OTPNUMVAL @"Enter valid otp number"
#define NODRIACC @"Drivers are not accepted your ride. Please try again later."
#define CALLDRI @"Do you want to call customer?"
#define SELONEREA @"Please select any of these reasons"
#define ISSSUC @"Your issue has been recorded"
#define CANSUC @"Dear Driver, Your ride has been cancelled successfully"
#define NEWPWDVAL @"Please enter new password"
#define NEWPWDRANVAL @"Password should be at least 6 characters"
#define REPWDVAL @"Please re-enter password"
#define RATESUC @"Your rating has been recorded"
#define NETTITLE @"Unable to Connect"
#define NETMSG @"No internet connectivity detected. Please check your Network Settings."
#define LOGOUT @"Do you want to log out?"
#define LOGOUTSUC @"Dear Driver, Your profile has been updated successfully"
#define TRIPNOTACC @"Trip cannot be accepted as it is assigned to another driver."
#define ONLINE @"Do you want to go online?"
#define OFFLINE @"Do you want to go offline?"
#define SELOPT @"Please select any of these reasons"
#define SELSTAEND @"Please select the date"
#define SELEND @"Please select end date"
#define SELSTA @"Please select start date"
#define STAGRE @"Start date should be greater than today"
#define ENDGRE @"End date should be greater than today"
#define SELCRCTDATE @"Please select correct start and end date"
#define SAMEDATE @"From and To date are same"
#define ACCNOT @"Dear Customer, Your booking has been accepted"
#define PICKNOT @"Dear Customer, Your ride is arriving to your location"
#define STANOT @"Dear Customer, Your ride has been started"
#define ENDNOT @"Dear Customer, Your ride has been finished"
#define CANNOT @"Booking has been cancelled by driver"
#define APPHEA @"Taxi Driver"
#define OKBUT @"OK"
#define NONET @"No internet connection available"
#define ALERTVAL @"Alert"
#define LOGOUTHEA @"Logout"
#define NOBUT @"NO"
#define YESBUT @"YES"
#define CALL @"Call"
#define PROFIMGVAL @"Please select profile image"
#define CUSCANRIDE @"Booking has been cancelled by customer"//@"Dear driver, your ride was cancelled by customer"
#define CHNPWDSUC @"Dear Driver, Your password has been updated successfully"
#define REENTPWDRANVAL @"Password should be at least 6 characters"



#define COUNTRIES [NSArray arrayWithObjects:@"Afghanistan", @"Albania",@"Algeria",@"American Samoa",@"Andorra",@"Angola",@"Anguilla",@"Antarctica",@"Antigua and Barbuda",@"Argentina",@"Armenia",@"Aruba",@"Australia",@"Austria",@"Azerbaijan",@"Bahamas",@"Bahrain",@"Bangladesh",@"Barbados",@"Belarus",@"Belgium",@"Belize",@"Benin",@"Bermuda",@"Bhutan",@"Bolivia",@"Bosnia and Herzegovina",@"Botswana",@"Brazil",@"British Virgin Islands",@"Brunei",@"Bulgaria",@"Burkina Faso",@"Burma (Myanmar)",@"Burundi",@"Cambodia",@"Cameroon",@"Canada",@"Cape Verde",@"Cayman Islands",@"Central African Republic",@"Chad",@"Chile",@"China",@"Christmas Island",@"Cocos (Keeling) Islands",@"Colombia",@"Comoros",@"Cook Islands",@"Costa Rica",@"Croatia",@"Cuba",@"Cyprus",@"Czech Republic",@"Democratic Republic of the Congo",@"Denmark",@"Djibouti",@"Dominica",@"Dominican Republic",@"Ecuador",@"Egypt",@"El Salvador",@"Equatorial Guinea",@"Eritrea",@"Estonia",@"Ethiopia",@"Falkland Islands",@"Faroe Islands",@"Fiji",@"Finland",@"France",@"French Polynesia",@"Gabon",@"Gambia",@"Gaza Strip",@"Georgia",@"Germany",@"Ghana",@"Gibraltar",@"Greece",@"Greenland",@"Grenada",@"Guam",@"Guatemala",@"Guinea",@"Guinea-Bissau",@"Guyana",@"Haiti",@"Holy See (Vatican City)",@"Honduras",@"Hong Kong",@"Hungary",@"Iceland",@"India",@"Indonesia",@"Iran",@"Iraq",@"Ireland",@"Isle of Man",@"Israel",@"Italy",@"Ivory Coast",@"Jamaica",@"Japan",@"Jordan",@"Kazakhstan",@"Kenya",@"Kiribati",@"Kosovo",@"Kuwait",@"Kyrgyzstan",@"Laos",@"Latvia",@"Lebanon",@"Lesotho",@"Liberia",@"Libya",@"Liechtenstein",@"Lithuania",@"Luxembourg",@"Macau",@"Macedonia",@"Madagascar",@"Malawi",@"Malaysia",@"Maldives",@"Mali",@"Malta",@"MarshallIslands",@"Mauritania",@"Mauritius",@"Mayotte",@"Mexico",@"Micronesia",@"Moldova",@"Monaco",@"Mongolia",@"Montenegro",@"Montserrat",@"Morocco",@"Mozambique",@"Namibia",@"Nauru",@"Nepal",@"Netherlands",@"Netherlands Antilles",@"New Caledonia",@"New Zealand",@"Nicaragua",@"Niger",@"Nigeria",@"Niue",@"Norfolk Island",@"North Korea",@"Northern Mariana Islands",@"Norway",@"Oman",@"Pakistan",@"Palau",@"Panama",@"Papua New Guinea",@"Paraguay",@"Peru",@"Philippines",@"Pitcairn Islands",@"Poland",@"Portugal",@"Puerto Rico",@"Qatar",@"Republic of the Congo",@"Romania",@"Russia",@"Rwanda",@"Saint Barthelemy",@"Saint Helena",@"Saint Kitts and Nevis",@"Saint Lucia",@"Saint Martin",@"Saint Pierre and Miquelon",@"Saint Vincent and the Grenadines",@"Samoa",@"San Marino",@"Sao Tome and Principe",@"Saudi Arabia",@"Senegal",@"Serbia",@"Seychelles",@"Sierra Leone",@"Singapore",@"Slovakia",@"Slovenia",@"Solomon Islands",@"Somalia",@"South Africa",@"South Korea",@"Spain",@"Sri Lanka",@"Sudan",@"Suriname",@"Swaziland",@"Sweden",@"Switzerland",@"Syria",@"Taiwan",@"Tajikistan",@"Tanzania",@"Thailand",@"Timor-Leste",@"Togo",@"Tokelau",@"Tonga",@"Trinidad and Tobago",@"Tunisia",@"Turkey",@"Turkmenistan",@"Turks and Caicos Islands",@"Tuvalu",@"Uganda",@"Ukraine",@"United Arab Emirates",@"United Kingdom",@"United States",@"Uruguay",@"US Virgin Islands",@"Uzbekistan",@"Vanuatu",@"Venezuela",@"Vietnam",@"Wallis and Futuna",@"West Bank",@"Yemen",@"Zambia",@"Zimbabwe",nil];

#define CODES [NSArray arrayWithObjects:@"+93",@"+355",@"+213",@"+1684",@"+376",@"+244",@"+1264",@"+672",@"+1268",@"+54",@"+374",@"+297",@"+61",@"+43",@"+994",@"+1242",@"+973",@"+880",@"+1246",@"+375",@"+32",@"+501",@"+229",@"+1441",@"+975",@"+591",@"+387",@"+267",@"+55",@"+1284",@"+673",@"+359",@"+226",@"+95",@"+257",@"+855",@"+237",@"+1",@"+238",@"+1345",@"+236",@"+235",@"+56",@"+86",@"+61",@"+61",@"+57",@"+269",@"+682",@"+506",@"+385",@"+53",@"+357",@"+420",@"+243",@"+45",@"+253",@"+1767",@"+1809",@"+593",@"+20",@"+503",@"+240",@"+291",@"+372",@"+251",@"+500",@"+298",@"+679",@"+358",@"+33",@"+689",@"+241",@"+220",@"+970",@"+995",@"+49",@"+233",@"+350",@"+30",@"+299",@"+1473",@"+1671",@"+502",@"+224",@"+245",@"+592",@"+509",@"+39",@"+504",@"+852",@"+36",@"+354",@"+91",@"+62",@"+98",@"+964",@"+353",@"+44",@"+972",@"+39",@"+225",@"+1876",@"+81",@"+962",@"+7",@"+254",@"+686",@"+381",@"+965",@"+996",@"+856",@"+371",@"+961",@"+266",@"+231",@"+218",@"+423",@"+370",@"+352",@"+853",@"+389",@"+261",@"+265",@"+60",@"+960",@"+223",@"+356",@"+692",@"+222",@"+230",@"+262",@"+52",@"+691",@"+373",@"+377",@"+976",@"+382",@"+1664",@"+212",@"+258",@"+264",@"+674",@"+977",@"+31",@"+599",@"+687",@"+64",@"+505",@"+227",@"+234",@"+683",@"+672",@"+850",@"+1670",@"+47",@"+968",@"+92",@"+680",@"+507",@"+675",@"+595",@"+51",@"+63",@"+870",@"+48",@"+351",@"+1",@"+974",@"+242",@"+40",@"+7",@"+250",@"+590",@"+290",@"+1869",@"+1758",@"+1599",@"+508",@"+1784",@"+685",@"+378",@"+239",@"+966",@"+221",@"+381",@"+248",@"+232",@"+65",@"+421",@"+386",@"+677",@"+252",@"+27",@"+82",@"+34",@"+94",@"+249",@"+597",@"+268",@"+46",@"+41",@"+963",@"+886",@"+992",@"+255",@"+66",@"+670",@"+228",@"+690",@"+676",@"+1868",@"+216",@"+90",@"+993",@"+1649",@"+688",@"+256",@"+380",@"+971",@"+44",@"+1",@"+598",@"+1340",@"+998",@"+678",@"+58",@"+84",@"+681",@"+970",@"+967",@"+260",@"+263", nil];




@interface Constant : NSObject


+ (Constant *) sharedConstants;











@end
