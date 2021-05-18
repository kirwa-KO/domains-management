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
	cout << BOLDYELLOW << "The Registrar " << RESET << BOLDWHITE << registrar.get_name() << RESET << BOLDYELLOW << " Added To Database Successfully..!!" << RESET << '\n';
}


vector<Registrar> Registrar::get_registrar_from_database()
{
	sql::ResultSet *	res;
	vector<Registrar>	registrars;

	res = g_stmt->executeQuery("SELECT * FROM registrar;");
	while (res->next())
	{
		Registrar temp_registrar(res->getString("name"), res->getString("url"));

		temp_registrar.set_id(res->getInt("id"));
		registrars.push_back(temp_registrar);
	}
	delete res;
	return registrars;
}

Registrar::~Registrar()
{
}