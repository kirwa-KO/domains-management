#include "Person.hpp"

Person::Person()
{
}

// getters
int		Person::get_id() { return id; }
string	Person::get_name() { return name; }
string	Person::get_first_name() { return first_name; }
string	Person::get_last_name() { return last_name; }
string	Person::get_email() { return email; }
string	Person::get_phone() { return phone; }

// setters
void	Person::set_id(int id) { this->id = id; };
void	Person::set_name(string name) { this->name = name; };
void	Person::set_first_name(string first_name) { this->first_name = first_name; };
void	Person::set_last_name(string last_name) { this->last_name = last_name; };
void	Person::set_email(string email) { this->email = email; };
void	Person::set_phone(string phone) { this->phone = phone; };

// static database methods
void	Person::add_person_in_database(Person & person)
{
	g_stmt->execute("INSERT INTO person(name, first, last, email, phone)			\
					SELECT * FROM (SELECT '" + person.get_name() + "' as name, '"	\
					+ person.get_first_name() + "', '"								\
					+ person.get_last_name() + "', '"								\
					+ person.get_email() + "', '"									\
					+ person.get_phone()	+ "') AS tmp_alias						\
					WHERE tmp_alias.name  NOT IN (SELECT name from person);");
	cout << BOLDYELLOW << "The Person " << RESET << BOLDWHITE << person.get_name() << RESET << BOLDYELLOW << " Added To Database Successfully..!!" << RESET << '\n';
}

vector<Person> Person::get_persons_from_database()
{
	sql::ResultSet *	res;
	vector<Person>	persons;

	res = g_stmt->executeQuery(	"SELECT * FROM person WHERE name LIKE '%" +	\
								Person::selected_person_name +				\
								"%' AND CHAR_LENGTH(name) <= " +			\
								to_string(Person::selected_person_size) + ";");
	while (res->next())
	{
		Person temp_person;

		temp_person.set_id(res->getInt("id"));
		temp_person.set_name(res->getString("name"));
		temp_person.set_first_name(res->getString("first"));
		temp_person.set_last_name(res->getString("last"));
		temp_person.set_email(res->getString("email"));
		temp_person.set_phone(res->getString("phone"));
		persons.push_back(temp_person);
	}
	delete res;
	return persons;
}

void    Person::press_add_person(WINDOW * popup, vector<Person> & persons)
{
	string					attributes_name[5] = {
												"Please type the Person name  : ",
												"Please type the Person first name: ",
												"Please type the Person last name: ",
												"Please type the Person email: ",
												"Please type the Person phone number: "
												};

	PersonFuncPointer		attributes_set_function[5] = {
												&Person::set_name,
												&Person::set_first_name,
												&Person::set_last_name,
												&Person::set_email,
												&Person::set_phone
												};
	Person *tmp_person = new Person();

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Add Person:");

	char	attribute_value[255];
	string	attribute_value_str;

	for (int i = 0; i < 5;i++)
	{
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + attributes_name[i]).c_str());
		wgetstr(popup, attribute_value);
		attribute_value_str = static_cast<string>(attribute_value);
		(tmp_person->*(attributes_set_function[i]))(attribute_value);
	}
	Person::add_person_in_database(*tmp_person);

	persons.clear();
	persons = Person::get_persons_from_database();
	delete tmp_person;
}

void	Person::press_delete_person(WINDOW * win, WINDOW * popup, vector<Person> & persons, int & selected_person)
{
	int		is_confirm;
	string	confirmation_message;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	confirmation_message = "Are you sure you want to delete the person \"" + persons[selected_person].get_name() + "\" [y/Y] : ";
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, 10, confirmation_message.c_str());
	is_confirm = wgetch(popup);

	if(is_confirm == 'y' OR is_confirm == 'Y')
	{
		g_stmt->execute("DELETE FROM person WHERE name = '" + persons[selected_person].get_name() + "'");
		persons.erase(persons.begin() + selected_person);
		selected_person -= 1;
		if (selected_person < 0)
			selected_person = 0;
	}
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	werase(win);
	wrefresh(win);
}

void Person::update_person_attribute_in_database(string attribute, string &new_value)
{
	g_stmt->executeUpdate("UPDATE person SET " + attribute + "='" + new_value + "' WHERE name='" + this->name + "'");
}

void	Person::press_enter(WINDOW * popup, vector<Person> & persons, int & selected_person)
{
	int		i;
	vector<pair<string, string>>	attributes_and_values;
	vector<pair<string, string>>::iterator	itr;
	stringstream temp_stream;

	attributes_and_values.push_back(pair<string, string>("Person name       : ", persons[selected_person].get_name()));
	attributes_and_values.push_back(pair<string, string>("Person first name : ", persons[selected_person].get_first_name()));
	attributes_and_values.push_back(pair<string, string>("Person last name  : ", persons[selected_person].get_last_name()));
	attributes_and_values.push_back(pair<string, string>("Person email      : ", persons[selected_person].get_email()));
	attributes_and_values.push_back(pair<string, string>("Person phone      : ", persons[selected_person].get_phone()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Person details:");
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
	// need to update the persons info here
	if (stoi(index_str) == 1)
		persons[selected_person].update_person_attribute_in_database("name", new_value_str);
	else if (stoi(index_str) == 2)
		persons[selected_person].update_person_attribute_in_database("first", new_value_str);
	else if (stoi(index_str) == 3)
		persons[selected_person].update_person_attribute_in_database("last", new_value_str);
	else if (stoi(index_str) == 4)
		persons[selected_person].update_person_attribute_in_database("email", new_value_str);
	else if (stoi(index_str) == 5)
		persons[selected_person].update_person_attribute_in_database("phone", new_value_str);
	
	persons.clear();
	persons = Person::get_persons_from_database();
}

Person::~Person()
{
}