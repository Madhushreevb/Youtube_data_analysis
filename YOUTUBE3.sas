/** FOR CSV Files uploaded from Windows **/

FILENAME CSV "/folders/myfolders/Youtube3/Youtube3.csv" TERMSTR=CRLF;

/** Import the CSV file.  **/

PROC IMPORT DATAFILE=CSV
		    OUT=WORK.YOUTUBE3
		    DBMS=CSV
		    REPLACE;
RUN;

proc rank data = WORK.YOUTUBE3 out=output1 groups=3;
var Impressions Comments_added Shares Dislikes Likes Average_percentage_viewed____ Average_view_duration Views Watch_time__hours_ Subscribers;
ranks Impressions_new Comments_added_new Shares_new Dislikes_new Likes_new Average_percentage_viewed____new Average_view_duration_new Views_new Watch_time__hours_new Subscribers_new;
run;

proc print data = WORK.OUTPUT1;
run;

proc freq data = WORK.OUTPUT1;
tables Impressions_new Comments_added_new Shares_new Dislikes_new Likes_new Average_percentage_viewed____new Average_view_duration_new Views_new Watch_time__hours_new Subscribers_new;
run;

data WORK.OUTPUT2;
set WORK.OUTPUT1;
format Impressions_new1 $35. Comments_added_new1 $35. Shares_new1 $35. Dislikes_new1 $35. Likes_new1 $35. Average_percentage_viewed___new1 $35. Average_view_duration_new1 $35. Views_new1 $35. Watch_time__hours_new1 $35. Subscribers_new1 $35.;

* Question A: Converting the variable, “Impressions” into 3 groups with a label selected from “low”, “medium”, “high”;
if Impressions_new=0 then Impressions_new1="Low";
else if Impressions_new = 1 then Impressions_new1="Medium";
else if Impressions_new = 2 then Impressions_new1="High";

* Repeat the same procedure to convert other numerical variables(?) into 3 groups with the same order, from low to high;
if Comments_added_new=0 then Comments_added_new1="Low";
else if Comments_added_new = 1 then Comments_added_new1="Medium";
else if Comments_added_new = 2 then Comments_added_new1="High";

if Shares_new=0 then Shares_new1="Low";
else if Shares_new = 1 then Shares_new1="Medium";
else if Shares_new = 2 then Shares_new1="High";

if Dislikes_new=0 then Dislikes_new1="Low";
else if Dislikes_new = 1 then Dislikes_new1="Medium";
else if Dislikes_new = 2 then Dislikes_new1="High";

if Likes_new=0 then Likes_new1="Low";
else if Likes_new = 1 then Likes_new1="Medium";
else if Likes_new = 2 then Likes_new1="High";

if Average_percentage_viewed____new=0 then Average_percentage_viewed___new1="Low";
else if Average_percentage_viewed____new = 1 then Average_percentage_viewed___new1="Medium";
else if Average_percentage_viewed____new = 2 then Average_percentage_viewed___new1="High";

if Average_view_duration_new=0 then Average_view_duration_new1="Low";
else if Average_view_duration_new = 1 then Average_view_duration_new1="Medium";
else if Average_view_duration_new = 2 then Average_view_duration_new1="High";

if Views_new=0 then Views_new1="Low";
else if Views_new = 1 then Views_new1="Medium";
else if Views_new = 2 then Views_new1="High";

if Watch_time__hours_new=0 then Watch_time__hours_new1="Low";
else if Watch_time__hours_new = 1 then Watch_time__hours_new1="Medium";
else if Watch_time__hours_new = 2 then Watch_time__hours_new1="High";

if Subscribers_new=0 then Subscribers_new1="Low";
else if Subscribers_new = 1 then Subscribers_new1="Medium";
else if Subscribers_new = 2 then Subscribers_new1="High";

* Questions C and D;

* 1. Comparing likes vs Impressions in CHI-Square method;
proc freq data=WORK.OUTPUT2;
tables likes_new1*impressions_new1 / CHISQ nocol norow nopercent;
run;
* Likes vs Impressions correlation matrix;
proc corr data=WORK.OUTPUT2 pearson nosimple noprob plots=matrix;
	var Likes;
	with Impressions;
run;

* 2. Comparing likes vs Views;
proc freq data=WORK.OUTPUT2;
tables likes_new1*views_new1 / CHISQ nocol norow nopercent;
run;
* Likes vs Impressions correlation matrix;
proc corr data=WORK.OUTPUT2 pearson nosimple noprob plots=matrix;
	var Likes;
	with Views;
run;

* 3. Comparing views vs impresion;
proc freq data=WORK.OUTPUT2;
tables views_new1*Impressions_new1 / CHISQ nocol norow nopercent;
run;
* Views vs Impressions correlation matrix;
proc corr data=WORK.OUTPUT2 pearson nosimple noprob plots=matrix;
	var Views;
	with Impressions;
run;

* Question F: Linear Regression;
proc reg data=WORK.OUTPUT2;
model Likes=Impressions;
run;

proc reg data=WORK.OUTPUT2;
model Views=Impressions;
run;
/** Print the results. **/

PROC PRINT DATA=WORK.YOUTUBE3; RUN;

/** Unassign the file reference.  **/

FILENAME CSV;
