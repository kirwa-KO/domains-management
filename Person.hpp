#ifndef PERSON_HPP
#define PERSON_HPP
#include "domains_names.hpp"

class Person
{
private:
	int		id;
	string	name;
	string	first_name;
	string	last_name;
	string	email;
	string	phone;

public:
	Person();
	// getters
	int		get_id();
	string	get_name();
	string	get_first_name();
	string	get_last_name();
	string	get_email();
	string	get_phone();
	// setters
	void	set_id(int id);
	void	set_name(string name);
	void	set_first_name(string first_name);
	void	set_last_name(string last_name);
	void	set_email(string email);
	void	set_phone(string phone);
	// members function for database
	void						update_person_attribute_in_database(string attribute, string &new_value);
	// static database methods
	static	void				add_person_in_database(Person & person);
	static	vector<Person>		get_persons_from_database();
	static	void				press_add_person(WINDOW * popup, vector<Person> & persons);
	static	void				press_delete_person(WINDOW * win, WINDOW * popup, vector<Person> & persons, int & selected_registrar);
	static	void				press_enter(WINDOW * popup, vector<Person> & persons, int & selected_registrar);
	~Person();
};

typedef	void	(Person::*PersonFuncPointer)(std::string);

#endif
