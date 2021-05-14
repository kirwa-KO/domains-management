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
    expire = 0;
    cost_per_year = 0;
    whois = "";
    url = "";
    // just for testing we put empty string in mx record attribute
    mx.push_back("");
    mx.push_back("");
}

// getters
string  Domain::get_name()                      { return name; }
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
void      Domain::set_name(string x)           { this->name = trim(x, " \t");}

void      Domain::set_name_server(string ns)
{
    // change the name server to lowercase
    transform(ns.begin(), ns.end(), ns.begin(), ::tolower);
    // remove white spaces from right and left of the string
    ns = trim(ns, " \t");

    // check if the name sever already exist in the name servers vector
    for (int i = 0;i < this->names_servers.size();i++)
        if (this->names_servers[i] == ns)
          return ;
    this->names_servers.push_back(ns);
}

void      Domain::set_mx(string x)
{
    // we will add it later
}

void      Domain::set_www(string x)           { this->www = trim(x, " \t");}
void      Domain::set_owner(string x)         { this->owner = trim(x, " \t");}
void      Domain::set_admin(string x)         { this->admin = trim(x, " \t");}
void      Domain::set_tech(string x)          { this->tech = trim(x, " \t");}
void      Domain::set_bill(string x)          { this->bill = trim(x, " \t");}
void      Domain::set_registrar(string x)     { this->registrar = trim(x, " \t");}
void      Domain::set_vpwd(string x)          { this->vpwd = trim(x, " \t");}
void      Domain::set_expire(double x)        { this->expire = x;}
void      Domain::set_cost_per_year(double x) { this->cost_per_year = x;}
void      Domain::set_whois(string x)         { this->whois = trim(x, " \t");}
void      Domain::set_url(string x)           { this->url = trim(x, " \t");}

// other function
void      Domain::get_info_from_whois_query()
{
    string command;
	string result;
	string line;
	
	command = "whois " + this->name;
    // execute whois <domain> command example whois kirwako.com
    result  = exec_command_and_return_result(static_cast<const char *>(&(command[0])));
	stringstream ss(result);
	while (getline(ss, line, '\n'))
	{
		if (line.find(" ns") != string::npos OR line.find(" NS") != string::npos)
			this->set_name_server(line.erase(0, line.find_first_of(':') + 1));
		else if(line.find("Admin Name:") != string::npos)
			this->set_admin(line.erase(0, line.find_first_of(':') + 1));
		else if(line.find("Tech Name:") != string::npos)
			this->set_tech(line.erase(0, line.find_first_of(':') + 1));
		else if(line.find(" Registrar:") != string::npos)
			this->set_registrar(line.erase(0, line.find_first_of(':') + 1));
		else if(line.find(" Registrar WHOIS Server:") != string::npos)
			this->set_whois(line.erase(0, line.find_first_of(':') + 1));
		else if(line.find(" Registrar URL:") != string::npos)
			this->set_url(line.erase(0, line.find_first_of(':') + 1));
	}
    while(this->names_servers.size() != 4)
        this->names_servers.push_back("");
}

void            Domain::display_domain_info()
{
    for (int i = 0;i < 40;i++)
		cout << "=";
	cout << "\n";
	cout << "nameservers:" << "\n";
	for (auto x : this->get_names_servers())
		cout << "=> ns: |" << x << "|\n";
	cout << "Admin : " << this->get_admin() << "\n";
	cout << "Tech : " << this->get_tech() << "\n";
	cout << "Registrar : " << this->get_registrar() << "\n";
	cout << "Whois : " << this->get_whois() << "\n";
	cout << "Url : " << this->get_url() << "\n";
}

// other static function
vector<Domain> Domain::get_domains_names(void)
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
        Domain  dm(one_domain.substr(0, one_domain.length() - 3));
        // add the domain to the array of domains
        domains.push_back(dm);
    }

    return domains;
}

void             Domain::add_domains_to_database(vector<Domain> domains, sql::Statement * stmt)
{
    for (int i = 0;i < domains.size();i++)
    {
        domains[i].get_info_from_whois_query();
        // domains[i].display_domain_info();
        stmt->execute("INSERT INTO domains( name, ns1, ns2, ns3, ns4,               \
                                            mx1, mx2, www, owner, adminp,           \
                                            techp, billp, registrar, vpwd,          \
                                            expire, costperyear, whois, url)        \
                                            VALUES('" + domains[i].get_name() + "', " \
                                            "'" + domains[i].get_names_servers()[0] + "', " \
                                            "'" + domains[i].get_names_servers()[1] + "', " \
                                            "'" + domains[i].get_names_servers()[2] + "', " \
                                            "'" + domains[i].get_names_servers()[3] + "', " \
                                            "'" + domains[i].get_mx()[0] + "', " \
                                            "'" + domains[i].get_mx()[1] + "', " \
                                            "'" + domains[i].get_www() + "', " \
                                            "'" + domains[i].get_owner() + "', " \
                                            "'" + domains[i].get_admin() + "', " \
                                            "'" + domains[i].get_tech() + "', " \
                                            "'" + domains[i].get_bill() + "', " \
                                            "'" + domains[i].get_registrar() + "', " \
                                            "'" + domains[i].get_vpwd() + "', " \
                                            "'" + to_string(domains[i].get_expire()) + "', " \
                                            "'" + to_string(domains[i].get_cost_per_year()) + "', " \
                                            "'" + domains[i].get_whois() + "', " \
                                            "'" + domains[i].get_url() + "')");
        cout << BOLDGREEN << "The Domain " << RESET << BOLDWHITE << domains[i].get_name() << RESET << BOLDGREEN << " Added To Database Successfully..!!" << RESET << '\n';
    }
}

vector<string>   Domain::get_domains_names_from_database(sql::Statement * stmt)
{
    sql::ResultSet * res;
    vector<string>  domains_names;
    res = stmt->executeQuery("SELECT name FROM domains");
    while (res->next())
        domains_names.push_back(res->getString("name"));
    delete res;
    return domains_names;
}

Domain::~Domain() {}