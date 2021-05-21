#include "Registrar.hpp"

Registrar::Registrar(string name, string url)
{
	this->name = name;
	this->url = url;
}

// getters
int		Registrar::get_id() { return id; }
string	Registrar::get_name() { return name; }
string	Registrar::get_url() { return url; }

// setters
void	Registrar::set_id(int id) { this->id = id; }
void	Registrar::set_name(string name) { this->name = name; }
void	Registrar::set_url(string url) { this->url = url; }

// static database methods
void	Registrar::add_registrar_in_database(Registrar & registrar)
{
	g_stmt->execute("INSERT INTO registrar(name, url)																			\
					SELECT * FROM (SELECT '" + registrar.get_name() + "' as name, '" + registrar.get_url() + "') AS tmp_alias	\
					WHERE tmp_alias.name  NOT IN (SELECT name from registrar);");
	// cout << BOLDYELLOW << "The Registrar " << RESET << BOLDWHITE << registrar.get_name() << RESET << BOLDYELLOW << " Added To Database Successfully..!!" << RESET << '\n';
}

vector<Registrar> Registrar::get_registrars_from_database()
{
	sql::ResultSet *	res;
	vector<Registrar>	registrars;

	res = g_stmt->executeQuery(	"SELECT * FROM registrar WHERE name LIKE '%" +	\
								Registrar::selected_registrar_name +			\
								"%' AND CHAR_LENGTH(name) <= " +				\
								to_string(Registrar::selected_registrar_size) + ";");
	while (res->next())
	{
		Registrar temp_registrar(res->getString("name"), res->getString("url"));

		temp_registrar.set_id(res->getInt("id"));
		registrars.push_back(temp_registrar);
	}
	delete res;
	return registrars;
}

void    Registrar::press_add_registrar(WINDOW * popup, vector<Registrar> & registrars)
{
	string					attributes_name[2] = {
												"Please type the Registrar name  : ",
												"Please type the Registrar url: "
												};

	RegistrarFuncPointer	attributes_set_function[2] = {
												&Registrar::set_name,
												&Registrar::set_url
												};
	Registrar *tmp_registrar = new Registrar("", "");

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Add Registrar:");

	char attribute_value[255];
	string attribute_value_str;

	for (int i = 0; i < 2;i++)
	{
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + attributes_name[i]).c_str());
		wgetstr(popup, attribute_value);
		attribute_value_str = static_cast<string>(attribute_value);
		(tmp_registrar->*(attributes_set_function[i]))(attribute_value);
	}
	Registrar::add_registrar_in_database(*tmp_registrar);

	registrars.clear();
	registrars = Registrar::get_registrars_from_database();
	delete tmp_registrar;
}

void	Registrar::press_delete_registrar(WINDOW * win, WINDOW * popup, vector<Registrar> & registrars, int & selected_registrar)
{
	int		is_confirm;
	string	confirmation_message;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	confirmation_message = "Are you sure you want to delete the registrar \"" + registrars[selected_registrar].get_name() + "\" [y/Y] : ";
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, 10, confirmation_message.c_str());
	is_confirm = wgetch(popup);

	if(is_confirm == 'y' OR is_confirm == 'Y')
	{
		g_stmt->execute("DELETE FROM registrar WHERE name = '" + registrars[selected_registrar].get_name() + "'");
		registrars.erase(registrars.begin() + selected_registrar);
		selected_registrar -= 1;
		if (selected_registrar < 0)
			selected_registrar = 0;
	}
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	werase(win);
	wrefresh(win);
}

void Registrar::update_registrar_attribute_in_database(string attribute, string &new_value)
{
	g_stmt->executeUpdate("UPDATE registrar SET " + attribute + "='" + new_value + "' WHERE name='" + this->name + "'");
}

void	Registrar::press_enter(WINDOW * popup, vector<Registrar> & registrars, int & selected_registrar)
{
	int		i;
	vector<pair<string, string>>	attributes_and_values;
	vector<pair<string, string>>::iterator	itr;
	stringstream temp_stream;

	attributes_and_values.push_back(pair<string, string>("Registrar name : ", registrars[selected_registrar].get_name()));
	attributes_and_values.push_back(pair<string, string>("Registrar url  : ", registrars[selected_registrar].get_url()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Registrar details:");
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
	// need to update the registrars info here
	if (stoi(index_str) == 1)
		registrars[selected_registrar].update_registrar_attribute_in_database("name", new_value_str);
	else if (stoi(index_str) == 2)
		registrars[selected_registrar].update_registrar_attribute_in_database("url", new_value_str);
	
	registrars.clear();
	registrars = Registrar::get_registrars_from_database();
}

Registrar::~Registrar()
{
}
