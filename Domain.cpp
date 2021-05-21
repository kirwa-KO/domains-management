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
	cout << "name		 : " << this->name << '\n';
	cout << "nameservers  :"
		 << "\n";
	for (auto x : this->get_names_servers())
		cout << "=> ns	: |" << x << "|\n";
	cout << "Admin		: " << this->get_admin() << "\n";
	cout << "Tech		 : " << this->get_tech() << "\n";
	cout << "Registrar	: " << this->get_registrar() << "\n";
	cout << "Whois		: " << this->get_whois() << "\n";
	cout << "Url		  : " << this->get_url() << "\n";
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
	string command = "ls " + g_path_of_domains_names_files;
	string domains_name_result_of_ls_command = exec_command_and_return_result(command.c_str());
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

void Domain::add_domain_to_database(Domain domain)
{
	g_stmt->execute("INSERT INTO domains(	name, ns1, ns2, ns3, ns4,mx1, mx2, www,										\
											owner, adminp, techp, billp, registrar,										\
											vpwd, expire, costperyear, sale_price, 										\
											whois, url) 																\
											SELECT * 																	\
											FROM																		\
											(SELECT '" + domain.get_name() + "' as name, '"
												+ domain.get_names_servers()[0] + "' as ns1, '"
												+ domain.get_names_servers()[1] + "' as ns2, '"
												+ domain.get_names_servers()[2] + "' as ns3, '"
												+ domain.get_names_servers()[4] + "' as ns4, '"
												+ domain.get_mx()[0] + "' as mx1, '"
												+ domain.get_mx()[1] + "' as mx2, '"
												+ domain.get_www() + "' as www, '"
												+ domain.get_owner() + "' as owner, '"
												+ domain.get_admin() + "' as admin, '"
												+ domain.get_tech() + "' as tech, '"
												+ domain.get_bill() + "' as bill, '"
												+ domain.get_registrar() + "' as registrar, '"
												+ domain.get_vpwd() + "' as vpwd, '"
												+ domain.get_expire() + "' as expire, "
												+ to_string(domain.get_cost_per_year())  + "AS cost_column, "
												+ to_string(domain.get_sale_price()) + " AS sale_price_column, '"
												+ domain.get_whois() + "' as whois, '"
												+ domain.get_url() + " as url') AS tmp_alias 	\
											WHERE tmp_alias.name  NOT IN (SELECT name from domains);");

	// cout << BOLDGREEN << "The Domain " << RESET << BOLDWHITE << domain.get_name() << RESET << BOLDGREEN << " Added To Database Successfully..!!" << RESET << '\n';
}
void Domain::add_domains_to_database(vector<Domain> domains)
{
	for (size_t i = 0; i < domains.size(); i++)
		Domain::add_domain_to_database(domains[i]);
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

void		Domain::press_enter(WINDOW * popup, vector<Domain> & domains, int & selected_domain)
{
	int		i;
	vector<pair<string, string>>	attributes_and_values;
	vector<pair<string, string>>::iterator	itr;
	stringstream temp_stream;

	attributes_and_values.push_back(pair<string, string>("Domain name  : ", domains[selected_domain].get_name()));
	attributes_and_values.push_back(pair<string, string>("name server 1: ", domains[selected_domain].get_names_servers()[0]));
	attributes_and_values.push_back(pair<string, string>("name server 2: ", domains[selected_domain].get_names_servers()[1]));
	attributes_and_values.push_back(pair<string, string>("name server 3: ", domains[selected_domain].get_names_servers()[2]));
	attributes_and_values.push_back(pair<string, string>("name server 4: ", domains[selected_domain].get_names_servers()[3]));
	attributes_and_values.push_back(pair<string, string>("admin		: ", domains[selected_domain].get_admin()));
	attributes_and_values.push_back(pair<string, string>("tech		 : ", domains[selected_domain].get_tech()));
	attributes_and_values.push_back(pair<string, string>("registrar	: ", domains[selected_domain].get_registrar()));
	attributes_and_values.push_back(pair<string, string>("whois		: ", domains[selected_domain].get_whois()));
	// attributes_and_values.push_back(pair<string, string>("url		  : ", domains[selected_domain].get_url()));
	temp_stream << fixed << setprecision(2) << domains[selected_domain].get_sale_price();
	attributes_and_values.push_back(pair<string, string>("sale price   : ", temp_stream.str()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Domains details:");
	for (itr = attributes_and_values.begin(), i = 0;itr != attributes_and_values.end();itr++, i++)
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + itr->first + itr->second).c_str());

	mvwprintw(popup, i + 2, 1, "***  Please Enter the number of attribute you want to edit or q/Q to quit : ");
	char index[20];
	string index_str;
	int	index_str_int;

	while (1)
	{
		try
		{
			wmove(popup, i + 2, 77);
			wgetstr(popup, index);
			index_str = static_cast<string>(index);
			if (index_str == "q" OR index_str == "Q")
				return ;
			index_str_int = stoi(index_str);
			break ;
		}
		catch(const std::exception& e)
		{
			continue ;
		}
	}
	
	int j;
	for(itr = attributes_and_values.begin(), j = 0;itr != attributes_and_values.end() AND j < index_str_int - 1;itr++, j++);
	
	mvwprintw(popup, i + 4, 1, ("***  Please Enter the new value of " + itr->first).c_str());
	char new_value[255];
	string new_value_str;

	wgetstr(popup, new_value);
	new_value_str = static_cast<string>(new_value);

	// need to update the domains info here
	if (index_str_int == 1)
		domains[selected_domain].update_domain_attribute_in_database("name", new_value_str);
	else if (index_str_int == 2)
		domains[selected_domain].update_domain_attribute_in_database("ns1", new_value_str);
	else if (index_str_int == 3)
		domains[selected_domain].update_domain_attribute_in_database("ns2", new_value_str);
	else if (index_str_int == 4)
		domains[selected_domain].update_domain_attribute_in_database("ns3", new_value_str);
	else if (index_str_int == 5)
		domains[selected_domain].update_domain_attribute_in_database("ns4", new_value_str);
	else if (index_str_int == 6)
		domains[selected_domain].update_domain_attribute_in_database("adminp", new_value_str);
	else if (index_str_int == 7)
		domains[selected_domain].update_domain_attribute_in_database("techp", new_value_str);
	else if (index_str_int == 8)
		domains[selected_domain].update_domain_attribute_in_database("registrar", new_value_str);
	else if (index_str_int == 9)
		domains[selected_domain].update_domain_attribute_in_database("whois", new_value_str);
	// else if (index_str_int == 10)
	// 	domains[selected_domain].update_domain_attribute_in_database("url", new_value_str);
	else if (index_str_int == 10)
		domains[selected_domain].update_domain_attribute_in_database("sale_price", new_value_str);
	domains.clear();
	domains = Domain::get_domains_from_database();
}

void	Domain::press_delete_domain(WINDOW * win, WINDOW * popup, vector<Domain> & domains, int & selected_domain)
{
	int		is_confirm;
	string	confirmation_message;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	confirmation_message = "Are you sure you want to delete the domain \"" + domains[selected_domain].get_name() + "\" [y/Y] : ";
	// mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, (width / 2) - (confirmation_message.length() / 2), confirmation_message.c_str());
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, 10, confirmation_message.c_str());
	is_confirm = wgetch(popup);

	if(is_confirm == 'y' OR is_confirm == 'Y')
	{
		g_stmt->execute("DELETE FROM domains WHERE name = '" + domains[selected_domain].get_name() + "'");
		domains.erase(domains.begin() + selected_domain);
		selected_domain -= 1;
		if (selected_domain < 0)
			selected_domain = 0;
	}
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	werase(win);
	wrefresh(win);
}

void    Domain::press_add_domain(WINDOW * popup, vector<Domain> & domains)
{
	string				attributes_name[10] = {
												"Please type the Domain name  : ",
												"Please type the name server 1: ",
												"Please type the name server 2: ",
												"Please type the name server 3: ",
												"Please type the name server 4: ",
												"Please type the admin        : ",
												"Please type the tech         : ",
												"Please type the registrar    : ",
												"Please type the whois        : ",
												"Please type the url          : "
												};

	DomainFuncPointer	attributes_set_function[10] = {
												&Domain::set_name,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_admin,
												&Domain::set_tech,
												&Domain::set_registrar,
												&Domain::set_whois,
												&Domain::set_url
												};
	Domain *tmp_domain = new Domain("");

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Add Domain:");

	char attribute_value[255];
	string attribute_value_str;

	for (int i = 0; i < 10;i++)
	{
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + attributes_name[i]).c_str());
		wgetstr(popup, attribute_value);
		attribute_value_str = static_cast<string>(attribute_value);
		(tmp_domain->*(attributes_set_function[i]))(attribute_value);
	}
	Domain::add_domain_to_database(*tmp_domain);

	domains.clear();
	domains = Domain::get_domains_from_database();
	delete tmp_domain;
}

Domain::~Domain() {}
