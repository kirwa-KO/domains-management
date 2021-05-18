#ifndef DOMAIN_HPP
#define DOMAIN_HPP
#include "domains_names.hpp"

class Domain
{
private:
	string name;
	vector<string> names_servers;
	vector<string> mx;
	string www;
	string owner;
	string admin;
	string tech;
	string bill;
	string registrar;
	string vpwd;
	string expire;
	double cost_per_year;
	string whois;
	string url;

public:
	static string selected_domain_tld;
	static int selected_domain_size;
	Domain(string name);
	// getters
	string get_name();
	vector<string> get_names_servers();
	vector<string> get_mx();
	string get_www();
	string get_owner();
	string get_admin();
	string get_tech();
	string get_bill();
	string get_registrar();
	string get_vpwd();
	string get_expire();
	double get_cost_per_year();
	string get_whois();
	string get_url();
	// setters
	void set_name(string);
	void set_name_server(string);
	void set_mx(string);
	void set_www(string);
	void set_owner(string);
	void set_admin(string);
	void set_tech(string);
	void set_bill(string);
	void set_registrar(string);
	void set_vpwd(string);
	void set_expire(string);
	void set_cost_per_year(double);
	void set_whois(string);
	void set_url(string);
	// other function
	void get_info_from_whois_query();
	void display_domain_info();
	// members function for database
	void update_domain_attribute_in_database(string attribute, string &new_value, sql::Statement *stmt);
	// other static functions
	static vector<Domain> get_domains_names_from_directory(void);
	static void add_domains_to_database(vector<Domain> domains, sql::Statement *stmt);
	static vector<Domain> return_getted_domains_from_sql_query(sql::ResultSet *res);
	static vector<Domain> get_domains_from_database(sql::Statement *stmt);
	static vector<Domain> get_dot_tld_domains_from_database(sql::Statement *stmt, string tld);
	static vector<Domain> get_domains_where_equal_or_less_that_specfied_size_from_database(sql::Statement *stmt, int &select_size);
	~Domain();
};

#endif