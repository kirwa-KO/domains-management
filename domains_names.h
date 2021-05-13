#ifndef DOMAINS_NAMES_H
#define DOMAINS_NAMES_H
/* include basic library of c++ */
#include <bits/stdc++.h>
/*
  Include directly the different
  headers from cppconn/ and mysql_driver.h + mysql_util.h
  (and mysql_connection.h). This will reduce your build time!
*/
#include "mysql_connection.h"

#include <cppconn/driver.h>
#include <cppconn/exception.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

using namespace std;

vector<string> get_domains_names(void);
#endif