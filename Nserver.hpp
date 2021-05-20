#ifndef NSERVER_HPP
#define NSERVER_HPP
#include "domains_names.hpp"

class Nserver
{
private:
	int id;
	string host;
	string ip;
	string os;
	string usr;
	string pass;
	string status;
	double lping;
	int port;

public:
	Nserver();
	Nserver(string host, string ip, string usr);
	// static member
	static string selected_nserver_host;
	static int selected_nserver_size;
	// getters
	int get_id();
	string get_host();
	string get_ip();
	string get_os();
	string get_usr();
	string get_pass();
	string get_status();
	double get_lping();
	int get_port();
	void diplay_info();

	// setters
	void set_id(int id);
	void set_host(string host);
	void set_ip(string ip);
	void set_os(string os);
	void set_usr(string usr);
	void set_pass(string pass);
	void set_status(string status);
	void set_lping(string lping);
	void set_port(string port);
	void display_info();

	// members function for database
	void						update_nserver_attribute_in_database(string attribute, string &new_value);

	// static class method
	static	void				add_server_in_database(Nserver & nserver);
	static vector<Nserver>		get_nservers_info_from_config_file();
	static void					put_nservers_info_in_database(vector<Nserver> & nserver);
	static vector<Nserver>		get_nservers_from_database();
	static	void				press_add_nserver(WINDOW * popup, vector<Nserver> & nservers);
	static	void				press_delete_nserver(WINDOW * win, WINDOW * popup, vector<Nserver> & nservers, int & selected_registrar);
	static	void				press_enter(WINDOW * popup, vector<Nserver> & nservers, int & selected_server);

	~Nserver();
};

typedef	void	(Nserver::*NserverFuncPointer)(std::string);

#endif
