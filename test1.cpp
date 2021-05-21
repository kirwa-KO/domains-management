// #include "domains_names.hpp"

// #include <bits/stdc++.h>
// #include <boost/algorithm/string.hpp>
// using namespace std;


// bool main() 
// {
// 	string expire_date_string = "2022-03-29T16:20:59Z";
// 	vector<string> expire_date_vector;
// 	vector<string> year_mounth_day_strings;
// 	int expire_year, current_year;
// 	int expire_month, current_month;
// 	int expire_day, current_day;
// 	time_t now = time(0);

// 	tm *ltm = localtime(&now);
// 	boost::split(expire_date_vector, expire_date_string, boost::is_any_of("T"));
// 	boost::split(year_mounth_day_strings, expire_date_vector[0], boost::is_any_of("-"));

// 	// expiration date
// 	expire_year = year_mounth_day_strings[0];
// 	expire_month = year_mounth_day_strings[1];
// 	expire_day = year_mounth_day_strings[2];
	
// 	// current date
// 	current_year = 1900 + ltm->tm_year;
// 	current_month = 1 + ltm->tm_mon;
// 	current_day = ltm->tm_mday;



//    // print various components of tm structure.
//    cout << "Year  :" << 1900 + ltm->tm_year<<endl;
//    cout << "Month : "<< 1 + ltm->tm_mon<< endl;
//    cout << "Day   : "<< ltm->tm_mday << endl;
// }

#include <iostream>
#include <sstream>
#include <locale>
#include <iomanip>

int main()
{
    std::tm t = {};
    std::istringstream ss("2010-11-04T23:23:01Z");

    if (ss >> std::get_time(&t, "%Y-%m-%dT%H:%M:%S"))
    {
        std::cout << std::mktime(&t) << "\n";
    }
    else
    {
        std::cout << "Parse failed\n";
    }
    return 0;
}