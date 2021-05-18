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

double  Nservers::display_info()
{
	cout << "========================================" << endl;
	cout << "Host     :" << this->get_host() << endl;
	cout << "IP       :" << this->get_ip() << endl;
	cout << "USR      :" << this->get_usr() << endl;
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
				temp_nserver.set_host(trim(line.erase(0, search_for.length()), " \t\n"));

				// get the ip
				getline(config_file, line);
				line = trim(line, " \t");
				search_for = "HostName";
				if (line.find(search_for) != string::npos)
				{
					temp_nserver.set_ip(trim(line.erase(0, search_for.length()), " \t\n"));
					// get the port
					getline(config_file, line);
					line = trim(line, " \t");
					search_for = "Port";
					if (line.find(search_for) != string::npos)
					{
						// this the string that contain port
						trim(line.erase(0, search_for.length()), " \t\n");

						// get the user
						getline(config_file, line);
						line = trim(line, " \t");
						search_for = "User";
						if (line.find(search_for) != string::npos)
							temp_nserver.set_usr(trim(line.erase(0, search_for.length()), " \t\n"));
					}
				}
				nservers.push_back(temp_nserver);
			}
		}
		config_file.close();
	}
	return nservers;
}

Nservers::~Nservers()
{
}