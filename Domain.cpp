#include "Domain.hpp"

Domain::Domain(string name) : name(name)
{
	www = "";
	owner = "";
	admin = "";
	tech = "";
	bill = "";
	registrar = "";
	vpwd = "";
	expire = "";
	cost_per_year = 9.99;
	whois = "";
	url = "";
	sale_price = -1;
	// just for testing we put empty string in mx record attribute
	mx.push_back("");
	mx.push_back("");
}

// getters
string Domain::get_name() { return name; }
vector<string> Domain::get_names_servers() { return names_servers; }
vector<string> Domain::get_mx() { return mx; }
string Domain::get_www() { return www; }
string Domain::get_owner() { return owner; }
string Domain::get_admin() { return admin; }
string Domain::get_tech() { return tech; }
string Domain::get_bill() { return bill; }
string Domain::get_registrar() { return registrar; }
string Domain::get_vpwd() { return vpwd; }
string Domain::get_expire() { return expire; }
double Domain::get_cost_per_year() { return cost_per_year; }
double Domain::get_sale_price() { return sale_price; }
string Domain::get_whois() { return whois; }
string Domain::get_url() { return url; }

// setters
void Domain::set_name(string x) { this->name = trim(x, " \t"); }

void Domain::set_name_server(string ns)
{
	// change the name server to lowercase
	transform(ns.begin(), ns.end(), ns.begin(), ::tolower);
	// remove white spaces from right and left of the string
	ns = trim(ns, " \t");

	// check if the name sever already exist in the name servers vector
	for (size_t i = 0; i < this->names_servers.size(); i++)
		if (this->names_servers[i] == ns)
			return;
	this->names_servers.push_back(ns);
}

void Domain::set_mx(string x)
{
	// we will add it later
	(void)x;
}

void Domain::set_www(string x) { this->www = trim(x, " \t"); }
void Domain::set_owner(string x) { this->owner = trim(x, " \t"); }
void Domain::set_admin(string x) { this->admin = trim(x, " \t"); }
void Domain::set_tech(string x) { this->tech = trim(x, " \t"); }
void Domain::set_bill(string x) { this->bill = trim(x, " \t"); }
void Domain::set_registrar(string x) { this->registrar = trim(x, " \t"); }
void Domain::set_vpwd(string x) { this->vpwd = trim(x, " \t"); }
void Domain::set_expire(string x) { this->expire = trim(x, " \t"); }
void Domain::set_cost_per_year(double x) { this->cost_per_year = x; }
void Domain::set_sale_price(double x) { this->sale_price = x; }
void Domain::set_whois(string x) { this->whois = trim(x, " \t"); }
void Domain::set_url(string x) { this->url = trim(x, " \t"); }

// other function
void Domain::get_info_from_whois_query()
{
	string command;
	string result;
	string line;
	string registrar_name;
	string registrar_url;

	command = "whois " + this->name;
	// execute whois <domain> command example whois kirwako.com
	result = exec_command_and_return_result(static_cast<const char *>(&(command[0])));
	stringstream ss(result);
	while (getline(ss, line, '\n'))
	{
		this->set_url("https://" + this->name);
		if (line.find(" ns") != string::npos OR line.find(" NS") != string::npos OR line.find("Name Server:") != string::npos)
			this->set_name_server(line.erase(0, line.find_first_of(':') + 1));
		else if (line.find("Admin Name:") != string::npos)
			this->set_admin(line.erase(0, line.find_first_of(':') + 1));
		else if (line.find("Tech Name:") != string::npos)
			this->set_tech(line.erase(0, line.find_first_of(':') + 1));
		else if (line.find(" Registrar:") != string::npos OR(line.find("Registrar:") != string::npos AND this->get_registrar() == ""))
		{
			this->set_registrar(line.erase(0, line.find_first_of(':') + 1));
			registrar_name = trim(line.erase(0, line.find_first_of(':') + 1), " \t");
		}
		else if (line.find(" Registrar WHOIS Server:") != string::npos OR(line.find("Registrar WHOIS Server:") != string::npos AND this->get_registrar() == ""))
			this->set_whois(line.erase(0, line.find_first_of(':') + 1));
		else if (line.find(" Registrar URL:") != string::npos OR(line.find("Registrar URL:") != string::npos AND this->get_url() == ""))
			registrar_url = trim(line.erase(0, line.find_first_of(':') + 1), " \t");
		else if (line.find("Registry Expiry") != string::npos OR(line.find("Expiration Date:") != string::npos AND this->get_expire() == ""))
			this->set_expire(line.erase(0, line.find_first_of(':') + 1));
		if (registrar_name != "" AND find(Domain::registrar_names.begin(), Domain::registrar_names.end(), registrar_name) == Domain::registrar_names.end())
		{
			Registrar registrar(registrar_name, registrar_url);
			Registrar::add_registrar_in_database(registrar);
		}
		Domain::registrar_names.push_back(registrar_name);
	}
	while (this->names_servers.size() != 4)
		this->names_servers.push_back("");
}

void Domain::display_domain_info()
{
	for (int i = 0; i < 40; i++)
		cout << "=";
	cout << "\n";
	cout << "name         : " << this->name << '\n';
	cout << "nameservers  :"
		 << "\n";
	for (auto x : this->get_names_servers())
		cout << "=> ns    : |" << x << "|\n";
	cout << "Admin        : " << this->get_admin() << "\n";
	cout << "Tech         : " << this->get_tech() << "\n";
	cout << "Registrar    : " << this->get_registrar() << "\n";
	cout << "Whois        : " << this->get_whois() << "\n";
	cout << "Url          : " << this->get_url() << "\n";
	cout << "Expiration   : " << this->get_expire() << "\n";
	for (int i = 0; i < 40; i++)
		cout << "=";
	cout << "\n";
}

// members function for database
void Domain::update_domain_attribute_in_database(string attribute, string &new_value)
{
	g_stmt->executeUpdate("UPDATE domains SET " + attribute + "='" + new_value + "' WHERE name='" + this->name + "'");
}

// other static function
vector<Domain> Domain::get_domains_names_from_directory(void)
{
	// get the output of ls command in a string
	string domains_name_result_of_ls_command = exec_command_and_return_result("ls named_dev");
	// change from string to stringstream to easy split it with newline
	stringstream domains_name_from_string_to_stream(domains_name_result_of_ls_command);
	vector<Domain> domains;
	string one_domain;
	// store domains name in domains array
	while (getline(domains_name_from_string_to_stream, one_domain, '\n'))
	{
		// substr from 0 to length of string -3 to remove .db part
		// create one domain from the one_domain string
		Domain dm(one_domain.substr(0, one_domain.length() - 3));
		// get domain info with whois query
		dm.get_info_from_whois_query();
		// add the domain to the array of domains
		domains.push_back(dm);
	}

	return domains;
}

void Domain::add_domains_to_database(vector<Domain> domains)
{
	for (size_t i = 0; i < domains.size(); i++)
	{
		g_stmt->execute("INSERT INTO domains( name, ns1, ns2, ns3, ns4,               \
                                            mx1, mx2, www, owner, adminp,           \
                                            techp, billp, registrar, vpwd,          \
                                            expire, costperyear, sale_price, whois, url)        \
                                            VALUES('" +
						domains[i].get_name() + "', "
												"'" +
						domains[i].get_names_servers()[0] + "', "
															"'" +
						domains[i].get_names_servers()[1] + "', "
															"'" +
						domains[i].get_names_servers()[2] + "', "
															"'" +
						domains[i].get_names_servers()[3] + "', "
															"'" +
						domains[i].get_mx()[0] + "', "
												 "'" +
						domains[i].get_mx()[1] + "', "
												 "'" +
						domains[i].get_www() + "', "
											   "'" +
						domains[i].get_owner() + "', "
												 "'" +
						domains[i].get_admin() + "', "
												 "'" +
						domains[i].get_tech() + "', "
												"'" +
						domains[i].get_bill() + "', "
												"'" +
						domains[i].get_registrar() + "', "
													 "'" +
						domains[i].get_vpwd() + "', "
												"'" +
						domains[i].get_expire() + "', "
												  "'" +
						to_string(domains[i].get_cost_per_year()) + "', "
																	"'" +
						to_string(domains[i].get_sale_price()) + "', "
																	"'" +
						domains[i].get_whois() + "', "
												 "'" +
						domains[i].get_url() + "')");
		cout << BOLDGREEN << "The Domain " << RESET << BOLDWHITE << domains[i].get_name() << RESET << BOLDGREEN << " Added To Database Successfully..!!" << RESET << '\n';
	}
}

vector<Domain> Domain::return_getted_domains_from_sql_query(sql::ResultSet *res)
{
	vector<Domain> domains;

	while (res->next())
	{
		Domain temp_domain("");

		temp_domain.set_name(res->getString("name"));
		temp_domain.set_name_server(res->getString("ns1"));
		temp_domain.set_name_server(res->getString("ns2"));
		temp_domain.set_name_server(res->getString("ns3"));
		temp_domain.set_name_server(res->getString("ns4"));
		temp_domain.set_mx(res->getString("mx1"));
		temp_domain.set_mx(res->getString("mx2"));
		temp_domain.set_www(res->getString("www"));
		temp_domain.set_owner(res->getString("owner"));
		temp_domain.set_admin(res->getString("adminp"));
		temp_domain.set_tech(res->getString("techp"));
		temp_domain.set_bill(res->getString("billp"));
		temp_domain.set_registrar(res->getString("registrar"));
		temp_domain.set_vpwd(res->getString("vpwd"));
		temp_domain.set_expire(res->getString("expire"));
		temp_domain.set_cost_per_year(res->getDouble("costperyear"));
		temp_domain.set_whois(res->getString("whois"));
		temp_domain.set_url(res->getString("url"));
		temp_domain.set_sale_price(res->getDouble("sale_price"));

		domains.push_back(temp_domain);
	}
	return domains;
}

vector<Domain> Domain::get_domains_from_database()
{
	sql::ResultSet *res;
	vector<Domain> domains;

	Domain::selected_domain_tld = "%";
	res = g_stmt->executeQuery("SELECT * FROM domains");
	domains = Domain::return_getted_domains_from_sql_query(res);
	delete res;
	return domains;
}

vector<Domain> Domain::get_dot_tld_domains_from_database(string tld)
{
	sql::ResultSet *res;
	vector<Domain> domains;

	Domain::selected_domain_tld = tld;
	res = g_stmt->executeQuery("SELECT * FROM domains WHERE name LIKE '%." + tld + "' AND POSITION('.' IN name) - 1 <= " + to_string(Domain::selected_domain_size) + ";");

	domains = Domain::return_getted_domains_from_sql_query(res);
	delete res;
	return domains;
}

vector<Domain> Domain::get_domains_where_equal_or_less_that_specfied_size_from_database(int &select_size)
{
	sql::ResultSet *res;
	vector<Domain> domains;

	Domain::selected_domain_size = select_size;
	res = g_stmt->executeQuery("SELECT * FROM domains WHERE name LIKE '%." + Domain::selected_domain_tld + "' AND POSITION('.' IN name) - 1 <= " + to_string(select_size) + ";");

	domains = Domain::return_getted_domains_from_sql_query(res);
	delete res;
	return domains;
}

Domain::~Domain() {}
