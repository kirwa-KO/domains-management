#include "Nservers.hpp"

Nservers::Nservers()
{
	this->host = "";
	this->ip = "";
	this->usr = "";
}

Nservers::Nservers(string host, string ip, string usr)
{
	this->host = host;
	this->ip = ip;
	this->usr = usr;
}

// getters
int     Nservers::get_id() { return id; }
string  Nservers::get_host() { return host; }
string  Nservers::get_ip() { return ip; }
string  Nservers::get_os() { return os; }
string  Nservers::get_usr() { return usr; }
string  Nservers::get_pass() { return pass; }
string  Nservers::get_status() { return status; }
double  Nservers::get_lping() { return lping; }
int		Nservers::get_port() { return port; }

void  Nservers::display_info()
{
	cout << "========================================" << endl;
	cout << "Host     :" << this->get_host() << endl;
	cout << "IP       :" << this->get_ip() << endl;
	cout << "USR      :" << this->get_usr() << endl;
	cout << "PORT     :" << this->get_port() << endl;
	cout << "========================================" << endl;
}

// setters
void  Nservers::set_id(int id) { this->id = id; }
void  Nservers::set_host(string host) { this->host = host; }
void  Nservers::set_ip(string ip) { this->ip = ip; }
void  Nservers::set_os(string os) { this->os = os; }
void  Nservers::set_usr(string usr) { this->usr = usr; }
void  Nservers::set_pass(string pass) { this->pass = pass; }
void  Nservers::set_status(string status) { this->status = status; }
void  Nservers::set_lping(double lping) { this->lping = lping; }
void  Nservers::set_port(int port) { this->port = port; }

// static class method

vector<Nservers>    Nservers::get_nservers_info_from_config_file()
{
	vector<Nservers>    nservers;
	fstream             config_file;

	config_file.open("./config", ios::in);
	if (config_file.is_open())
	{
		string line;
		while (getline(config_file, line))
		{
			line = trim(line, " \t");
			string search_for;

			// get the host
			search_for = "Host ";
			if (line.find(search_for) != string::npos)
			{
				Nservers temp_nserver;
				// get the host
				temp_nserver.set_host(trim(line.erase(0, search_for.length()), " \t\n\r"));

				// get the ip
				getline(config_file, line);
				line = trim(line, " \t");
				search_for = "HostName";
				if (line.find(search_for) != string::npos)
				{
					temp_nserver.set_ip(trim(line.erase(0, search_for.length()), " \t\n\r"));
					// get the port
					getline(config_file, line);
					line = trim(line, " \t");
					search_for = "Port";
					if (line.find(search_for) != string::npos)
					{
						// this the string that contain port
						temp_nserver.set_port(stoi(trim(line.erase(0, search_for.length()), " \t\n\r")));

						// get the user
						getline(config_file, line);
						line = trim(line, " \t");
						search_for = "User";
						if (line.find(search_for) != string::npos)
							temp_nserver.set_usr(trim(line.erase(0, search_for.length()), " \t\n\r"));
					}
				}
				nservers.push_back(temp_nserver);
			}
		}
		config_file.close();
	}
	return nservers;
}

void	Nservers::put_nservers_info_in_database(vector<Nservers> & nservers)
{
	for (int i = 0;i < nservers.size();i++)
	{
		g_stmt->execute("INSERT INTO nservers(host, ip, usr, port) VALUES(	\
									'" + nservers[i].get_host() + "', 		\
									'" + nservers[i].get_ip() + "',			\
									'" + nservers[i].get_usr() + "', 		\
									" + to_string(nservers[i].get_port()) + "			\
									);");
		cout << BOLDCYAN << "The Server " << RESET << BOLDWHITE << nservers[i].get_host() << RESET << BOLDCYAN << " Added To Database Successfully..!!" << RESET << '\n';
	}
}


vector<Nservers> Nservers::get_nservers_from_database()
{
	sql::ResultSet *	res;
	vector<Nservers>	nservers;

	res = g_stmt->executeQuery("SELECT * FROM nservers;");
	while (res->next())
	{
		Nservers temp_nserver;

		temp_nserver.set_id(res->getInt("id"));
		temp_nserver.set_host(res->getString("host"));
		temp_nserver.set_ip(res->getString("ip"));
		temp_nserver.set_usr(res->getString("usr"));
		temp_nserver.set_port(res->getInt("port"));
		nservers.push_back(temp_nserver);
	}
	delete res;
	return nservers;
}

Nservers::~Nservers()
{
}