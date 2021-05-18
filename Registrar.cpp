#include "Registrar.hpp"

Registrar::Registrar(string name, string url)
{
	this->name = name;
	this->url = url;
}

// getters
string	Registrar::get_name() { return name; }
string	Registrar::get_url() { return url; }

// setters
void	Registrar::set_name(string name) { this->name = name; }
void	Registrar::set_url(string url) { this->url = url; }

// static database methods
void	Registrar::add_registrar_in_database(Registrar & registrar)
{
	g_stmt->execute("INSERT INTO registrar(name, url)																			\
					SELECT * FROM (SELECT '" + registrar.get_name() + "' as name, '" + registrar.get_url() + "') AS tmp_alias	\
					WHERE tmp_alias.name  NOT IN (SELECT name from registrar);");
	cout << BOLDYELLOW << "The Registrar " << RESET << BOLDWHITE << registrar.get_name() << RESET << BOLDYELLOW << " Added To Database Successfully..!!" << RESET << '\n';
}

Registrar::~Registrar()
{
}