#include "Domain.hpp"

Domain::Domain()
{
    www = "";
    owner = "";
    admin = "";
    tech = "";
    bill = "";
    registrar = "";
    vpwd = "";
    expire = 0;
    cost_per_year = 0;
    whois = "";
    url = "";
}

// getters
vector<string>  Domain::get_names_servers()     { return names_servers; }
vector<string>  Domain::get_mx()                { return mx; }
string Domain::get_www()                        { return www; }
string Domain::get_owner()                      { return owner; }
string Domain::get_admin()                      { return admin; }
string Domain::get_tech()                       { return tech; }
string Domain::get_bill()                       { return bill; }
string Domain::get_registrar()                  { return registrar; }
string Domain::get_vpwd()                       { return vpwd; }
double Domain::get_expire()                     { return expire; }
double Domain::get_cost_per_year()              { return cost_per_year; }
string Domain::get_whois()                      { return whois; }
string Domain::get_url()                        { return url; }

// setters
void      Domain::set_name_server(string & ns)
{
    transform(ns.begin(), ns.end(), ns.begin(), ::tolower);
    ns = trim(ns, " ");

    for (int i = 0;i < this->names_servers.size();i++)
        if (this->names_servers[i] == ns)
          return ;
    this->names_servers.push_back(ns);
}

void      Domain::set_mx(string &x)
{
    // we will add it later
}

void      Domain::set_www(string & x)           { this->www = x;}
void      Domain::set_owner(string & x)         { this->owner = x;}
void      Domain::set_admin(string & x)         { this->admin = x;}
void      Domain::set_tech(string & x)          { this->tech = x;}
void      Domain::set_bill(string & x)          { this->bill = x;}
void      Domain::set_registrar(string & x)     { this->registrar = x;}
void      Domain::set_vpwd(string & x)          { this->vpwd = x;}
void      Domain::set_expire(double & x)        { this->expire = x;}
void      Domain::set_cost_per_year(double & x) { this->cost_per_year = x;}
void      Domain::set_whois(string & x)         { this->whois = x;}
void      Domain::set_url(string & x)           { this->url = x;}

Domain::~Domain() {}