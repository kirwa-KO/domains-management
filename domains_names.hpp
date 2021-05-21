#ifndef DOMAINS_NAMES_H
#define DOMAINS_NAMES_H
#define AND &&
#define OR ||
//the following are UBUNTU/LINUX, and MacOS ONLY terminal color codes.
#define RESET       "\033[0m"
#define BLACK       "\033[30m"              /* Black */
#define RED         "\033[31m"              /* Red */
#define GREEN       "\033[32m"              /* Green */
#define YELLOW      "\033[33m"              /* Yellow */
#define BLUE        "\033[34m"              /* Blue */
#define MAGENTA     "\033[35m"              /* Magenta */
#define CYAN        "\033[36m"              /* Cyan */
#define WHITE       "\033[37m"              /* White */
#define BOLDBLACK   "\033[1m\033[30m"       /* Bold Black */
#define BOLDRED     "\033[1m\033[31m"       /* Bold Red */
#define BOLDGREEN   "\033[1m\033[32m"       /* Bold Green */
#define BOLDYELLOW  "\033[1m\033[33m"       /* Bold Yellow */
#define BOLDBLUE    "\033[1m\033[34m"       /* Bold Blue */
#define BOLDMAGENTA "\033[1m\033[35m"       /* Bold Magenta */
#define BOLDCYAN    "\033[1m\033[36m"       /* Bold Cyan */
#define BOLDWHITE   "\033[1m\033[37m"       /* Bold White */
#define PRESS_ENTER 10
#define PRESS_ESC 27
#define DOMAIN_PER_WIN 28
#define DOMAIN_INFO_LENGTH 10
#define TABS_NUMBER 4
#define TAB_LENGTH 16
#define FIELDS_NAME_NUMBER 8
#define ctrl(x) (x & 0x1F)
#define INDICATE_LONG_STRING '\\'

/* include basic library of c++ */
#include <bits/stdc++.h>
using namespace std;
/*
  Include directly the different
  headers from cppconn/ and mysql_driver.h + mysql_util.h
  (and mysql_connection.h). This will reduce your build time!
*/
#include "mysql_connection.h"
#include <boost/algorithm/string.hpp>

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>
#include <ncurses.h>

extern  sql::Statement *	g_stmt;
extern	string				g_database_name;
extern	string				g_database_user;
extern	string				g_database_password;
extern	string				g_path_of_domains_names_files;
extern	string				g_path_of_config_file_for_servers;
// vector<string>				get_domains_names(void);
string						exec_command_and_return_result(const char* cmd);
string&						rtrim(string& s, const char* t);
string&						ltrim(string& s, const char* t);
string&						trim(string& s, const char* t);
void						draw_bottom_bar_menu(WINDOW * bottom_menu_bar, int yMax, int xMax);
void						draw_numbers_in_screen_corners(int yMax, int xMax);
string						put_string_in_center(string & str, int number_of_case, char to_fill);
string						put_string_in_right(string str, int number_of_case, char to_fill);
string						put_string_in_left(string str, int number_of_case, char to_fill);
void						get_configuration_info_from_dot_env_file(string dot_env_file_path);
vector<string>				get_ips_of_the_domain(string domain_name);
#endif