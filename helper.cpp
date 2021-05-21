#include "Domain.hpp"

string exec_command_and_return_result(const char* cmd) {
	shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
	if (!pipe)
		return "ERROR";
	char buffer[4096];
	string result = "";
	while (!feof(pipe.get())) {
		if (fgets(buffer, 4096, pipe.get()) != NULL)
			result += buffer;
	}
	return result;
}
	
// trim from end of string (right)
string& rtrim(string& s, const char* t)
{
	s.erase(s.find_last_not_of(t) + 1);
	return s;
}

// trim from beginning of string (left)
string& ltrim(string& s, const char* t)
{
	s.erase(0, s.find_first_not_of(t));
	return s;
}

// trim from both ends of string (right then left)
string& trim(string& s, const char* t)
{
	return ltrim(rtrim(s, t), t);
}

void    draw_bottom_bar_menu(WINDOW * bottom_menu_bar, int yMax, int xMax)
{
    // bottom menu bar intialisation
    bottom_menu_bar = newwin(5, 65, yMax - 6, (xMax - 65) / 2);
    // print key that can use in domains menu
    mvwprintw(bottom_menu_bar, 1, 1, "|UP|   => Prev      |DOWN|  => Next      |Q/q|   => Quit");
    mvwprintw(bottom_menu_bar, 2, 1, "|E/e|  => Edit      |D/d|   => Delete    |ENTER| => All");
    mvwprintw(bottom_menu_bar, 3, 1, "|LEFT| => Prev Side |RIGHT| => Next Side |ESC|   => Close POPUP");
    // print bottom menu box
    box(bottom_menu_bar, 0, 0);
    refresh();
    wrefresh(bottom_menu_bar);
}

void	draw_numbers_in_screen_corners(int yMax, int xMax)
{
    int i = 0;
    int first_numbred_row = 1, second_numbred_row = 1;
    
    while (i < xMax)
    {
        mvprintw(1, i + 2, to_string(second_numbred_row).c_str());
        i +=  1;
        if(i % 10 == 0)
        {
            if(first_numbred_row >= 10)
                mvprintw(0, i, to_string(first_numbred_row).c_str());
            else
                mvprintw(0, i + 1, to_string(first_numbred_row).c_str());
            first_numbred_row += 1;
        }
        second_numbred_row = (second_numbred_row + 1) % 10;
    }
    i = 0;
    second_numbred_row = -1;
    while (i < yMax)
    {
        second_numbred_row += 1;
        if (second_numbred_row != 0 AND second_numbred_row % 10 == 0)
            mvprintw(i + 2, 0, to_string(second_numbred_row).c_str());
        else
            mvprintw(i + 2, 0, (" " + to_string(second_numbred_row % 10)).c_str());
        i += 1;
    }
}

string  put_string_in_center(string & str, int number_of_case, char to_fill)
{
    if (str.length() > number_of_case)
    {
        str = str.substr(0, number_of_case - 1);
        str += INDICATE_LONG_STRING;
        return str;
    }
    string  str_to_ret((number_of_case - str.length()) / 2, to_fill);

    str_to_ret += str;
    for (int i = str_to_ret.length();i < number_of_case;i++)
        str_to_ret += to_fill;
    return str_to_ret;
}

string  put_string_in_right(string str, int number_of_case, char to_fill)
{
    if (str.length() > number_of_case)
    {
        str = str.substr(0, number_of_case - 1);
        str += INDICATE_LONG_STRING;
        return str;
    }
    string  str_to_ret(number_of_case - str.length(), to_fill);

    str_to_ret += str;
    return str_to_ret;
}

string  put_string_in_left(string str, int number_of_case, char to_fill)
{
    if (str.length() > number_of_case)
    {
        str = str.substr(0, number_of_case - 1);
        str += INDICATE_LONG_STRING;
        return str;
    }
    string  str_to_ret(str);
    
    for (int i = str_to_ret.length();i < number_of_case;i++)
        str_to_ret += to_fill;
    return str_to_ret;
}

void	get_configuration_info_from_dot_env_file(string dot_env_file_path)
{
	fstream		_env;
	string		search_for;

	_env.open(dot_env_file_path, ios::in);
	if (_env.is_open())
	{
		string line;
		while (getline(_env, line))
		{
			line = trim(line, " \t\n\r");

			// get the database name
			if (line.find("DATABASE_NAME=") != string::npos)
			{
				search_for = "DATABASE_NAME=";
				g_database_name = trim(line.erase(0, search_for.length()), " \t\n\r");
			}
			// get the database user
			else if (line.find("DATABASE_USER=") != string::npos)
			{
				search_for = "DATABASE_USER=";
				g_database_user = trim(line.erase(0, search_for.length()), " \t\n\r");
			}
			// get the database password
			else if (line.find("DATABASE_PASSWORD=") != string::npos)
			{
				search_for = "DATABASE_PASSWORD=";
				g_database_password = trim(line.erase(0, search_for.length()), " \t\n\r");
			}
			// get the path of domains names files
			else if (line.find("PATH_OF_DOMAINS_NAMES_FILES=") != string::npos)
			{
				search_for = "PATH_OF_DOMAINS_NAMES_FILES=";
				g_path_of_domains_names_files = trim(line.erase(0, search_for.length()), " \t\n\r");
			}
			// get the path of config file for serves data
			else if (line.find("PATH_OF_CONFIG_FILE_FOR_SERVERS_DATA=") != string::npos)
			{
				search_for = "PATH_OF_CONFIG_FILE_FOR_SERVERS_DATA=";
				g_path_of_config_file_for_servers = trim(line.erase(0, search_for.length()), " \t\n\r");
			}
		}
		_env.close();
	}
	else
		cout << BOLDRED << "Please if the .env file exist...!!" << RESET << endl;
}

vector<string>	get_ips_of_the_domain(string domain_name)
{
	string result = exec_command_and_return_result(("host " + domain_name).c_str()), line;
	stringstream result_stream(result);
	vector<string> ips;

	while (getline(result_stream, line, '\n'))
	{
		line = trim(line, " \t\r\n");
		if (line.find("has address") != string::npos)
			ips.push_back(trim(line.erase(0, domain_name.length() + 13), " \t\n\r"));
	}
	return ips;
}