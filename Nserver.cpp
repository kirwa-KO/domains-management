#include "Nserver.hpp"

Nserver::Nserver()
{
	this->host = "";
	this->ip = "";
	this->usr = "";
}

Nserver::Nserver(string host, string ip, string usr)
{
	this->host = host;
	this->ip = ip;
	this->usr = usr;
}

// getters
int     Nserver::get_id() { return id; }
string  Nserver::get_host() { return host; }
string  Nserver::get_ip() { return ip; }
string  Nserver::get_os() { return os; }
string  Nserver::get_usr() { return usr; }
string  Nserver::get_pass() { return pass; }
string  Nserver::get_status() { return status; }
double  Nserver::get_lping() { return lping; }
int		Nserver::get_port() { return port; }

void  Nserver::display_info()
{
	cout << "========================================" << endl;
	cout << "Host     :" << this->get_host() << endl;
	cout << "IP       :" << this->get_ip() << endl;
	cout << "USR      :" << this->get_usr() << endl;
	cout << "PORT     :" << this->get_port() << endl;
	cout << "========================================" << endl;
}

// setters
void	Nserver::set_id(int id) { this->id = id; }
void	Nserver::set_host(string host) { this->host = host; }
void	Nserver::set_ip(string ip) { this->ip = ip; }
void	Nserver::set_os(string os) { this->os = os; }
void	Nserver::set_usr(string usr) { this->usr = usr; }
void	Nserver::set_pass(string pass) { this->pass = pass; }
void	Nserver::set_status(string status) { this->status = status; }
void	Nserver::set_lping(string lping) { this->lping = stod(lping); }
void	Nserver::set_port(string port) { this->port = stoi(port); }

// members function for database
void	Nserver::update_nserver_attribute_in_database(string attribute, string &new_value)
{
	g_stmt->executeUpdate("UPDATE nservers SET " + attribute + "='" + new_value + "' WHERE host='" + this->host + "'");
}

// static class method

vector<Nserver>    Nserver::get_nservers_info_from_config_file()
{
	vector<Nserver>    nservers;
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
				Nserver temp_nserver;
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
						// temp_nserver.set_port(trim(line.erase(0, search_for.length(), " \t\n\r")));
						 temp_nserver.set_port(trim(line.erase(0, search_for.length()), " \t\n\r"));

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

void	Nserver::add_server_in_database(Nserver & nserver)
{
	g_stmt->execute("INSERT INTO nservers(	host, ip, usr, port) 																\
										SELECT * 																	\
										FROM																		\
										(SELECT '"	+ nserver.get_host() 			+ "' as host, '"
													+ nserver.get_ip() 	 			+ "' as ip, '"
													+ nserver.get_usr()  			+ "' as usr, '"
													+ to_string(nserver.get_port()) + "' as port) AS tmp_alias 	\
										WHERE tmp_alias.host  NOT IN (SELECT host FROM nservers);");

	cout << BOLDCYAN << "The Server " << RESET << BOLDWHITE << nserver.get_host() << RESET << BOLDCYAN << " Added To Database Successfully..!!" << RESET << '\n';
}

void	Nserver::put_nservers_info_in_database(vector<Nserver> & nservers)
{
	for (int i = 0;i < nservers.size();i++)
		Nserver::add_server_in_database(nservers[i]);
}


vector<Nserver> Nserver::get_nservers_from_database()
{
	sql::ResultSet *	res;
	vector<Nserver>	nservers;

	res = g_stmt->executeQuery(	"SELECT * FROM nservers WHERE host LIKE '%" +	\
								Nserver::selected_nserver_host +				\
								"%' AND CHAR_LENGTH(host) <= " +
								to_string(Nserver::selected_nserver_size) + ";");
	while (res->next())
	{
		Nserver temp_nserver;

		temp_nserver.set_id(res->getInt("id"));
		temp_nserver.set_host(res->getString("host"));
		temp_nserver.set_ip(res->getString("ip"));
		temp_nserver.set_usr(res->getString("usr"));
		temp_nserver.set_port(to_string(res->getInt("port")));
		nservers.push_back(temp_nserver);
	}
	delete res;
	return nservers;
}

void		Nserver::press_add_nserver(WINDOW * popup, vector<Nserver> & nservers)
{
	string					attributes_name[4] = {
												"Please type the Server host/name  : ",
												"Please type the Server ip: ",
												"Please type the Server port: ",
												"Please type the Server nickname: "
												};

	NserverFuncPointer		attributes_set_function[4] = {
												&Nserver::set_host,
												&Nserver::set_ip,
												&Nserver::set_port,
												&Nserver::set_usr
												};
	Nserver *tmp_nserver = new Nserver();

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Add Server:");

	char	attribute_value[255];
	string	attribute_value_str;

	for (int i = 0; i < 4;i++)
	{
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + attributes_name[i]).c_str());
		wgetstr(popup, attribute_value);
		attribute_value_str = static_cast<string>(attribute_value);
		(tmp_nserver->*(attributes_set_function[i]))(attribute_value);
	}
	Nserver::add_server_in_database(*tmp_nserver);

	nservers.clear();
	nservers = Nserver::get_nservers_from_database();
	delete tmp_nserver;
}

void		Nserver::press_delete_nserver(WINDOW * win, WINDOW * popup, vector<Nserver> & nservers, int & selected_nserver)
{

	int		is_confirm;
	string	confirmation_message;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	confirmation_message = "Are you sure you want to delete the server \"" + nservers[selected_nserver].get_host() + "\" [y/Y] : ";
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, 10, confirmation_message.c_str());
	is_confirm = wgetch(popup);

	if(is_confirm == 'y' OR is_confirm == 'Y')
	{
		g_stmt->execute("DELETE FROM nservers WHERE host = '" + nservers[selected_nserver].get_host() + "'");
		nservers.erase(nservers.begin() + selected_nserver);
		selected_nserver -= 1;
		if (selected_nserver < 0)
			selected_nserver = 0;
	}
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	werase(win);
	wrefresh(win);
}

void		Nserver::press_enter(WINDOW * popup, vector<Nserver> & nservers, int & selected_server)
{
	int		i;
	vector<pair<string, string>>			attributes_and_values;
	vector<pair<string, string>>::iterator	itr;
	stringstream temp_stream;

	attributes_and_values.push_back(pair<string, string>("Server host/name  : ", nservers[selected_server].get_host()));
	attributes_and_values.push_back(pair<string, string>("Server ip         : ", nservers[selected_server].get_ip()));
	attributes_and_values.push_back(pair<string, string>("Server port       : ", to_string(nservers[selected_server].get_port())));
	attributes_and_values.push_back(pair<string, string>("Server nickname   : ", nservers[selected_server].get_usr()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Nserver details:");
	for (itr = attributes_and_values.begin(), i = 0;itr != attributes_and_values.end();itr++, i++)
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + itr->first + itr->second).c_str());

	mvwprintw(popup, i + 2, 1, "***  Please Enter the number of attribute you want to edit or q/Q to quit : ");
	char index[20];
	string index_str;
	wgetstr(popup, index);
	index_str = static_cast<string>(index);
	if (index_str == "q" OR index_str == "Q")
		return ;
	int j;
	for(itr = attributes_and_values.begin(), j = 0;itr != attributes_and_values.end() AND j < stoi(index_str) - 1;itr++, j++);
	mvwprintw(popup, i + 4, 1, ("***  Please Enter the new value of " + itr->first).c_str());
	char new_value[255];
	string new_value_str;
	wgetstr(popup, new_value);
	new_value_str = static_cast<string>(new_value);
	// need to update the nservers info here
	if (stoi(index_str) == 1)
		nservers[selected_server].update_nserver_attribute_in_database("host", new_value_str);
	else if (stoi(index_str) == 2)
		nservers[selected_server].update_nserver_attribute_in_database("ip", new_value_str);
	else if (stoi(index_str) == 3)
		nservers[selected_server].update_nserver_attribute_in_database("port", new_value_str);
	else if (stoi(index_str) == 4)
		nservers[selected_server].update_nserver_attribute_in_database("usr", new_value_str);
	
	nservers.clear();
	nservers = Nserver::get_nservers_from_database();
}

Nserver::~Nserver()
{
}
