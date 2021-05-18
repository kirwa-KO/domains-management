#ifndef REGISTRAR_HPP
#define REGISTRAR_HPP
#include "domains_names.hpp"

class Registrar
{
private:
	string name;
	string url;

public:
	Registrar(string name, string url);
	// getters
	string	get_name();
	string	get_url();
	// setters
	void	set_name(string x);
	void	set_url(string x);
	// static database methods
	static	void	add_registrar_in_database(Registrar & registrar);
	~Registrar();
};

#endif
