#ifndef REGISTRAR_HPP
#define REGISTRAR_HPP
#include "domains_names.hpp"

class Registrar
{
private:
	string	name;
	string	url;
	int		id;

public:
	Registrar(string name, string url);
	// getters
	int		get_id();
	string	get_name();
	string	get_url();
	// setters
	void	set_id(int x);
	void	set_name(string x);
	void	set_url(string x);
	// members function for database
	void				update_registrar_attribute_in_database(string attribute, string &new_value);
	// static database methods
	static	void				add_registrar_in_database(Registrar & registrar);
	static	vector<Registrar>	get_registrars_from_database();
	static	void				press_add_registrar(WINDOW * popup, vector<Registrar> & registrars);
	static	void				press_delete_registrar(WINDOW * win, WINDOW * popup, vector<Registrar> & registrars, int & selected_registrar);
	static	void				press_enter(WINDOW * popup, vector<Registrar> & registrars, int & selected_registrar);
	~Registrar();
};

typedef	void	(Registrar::*RegistrarFuncPointer)(std::string);

#endif
