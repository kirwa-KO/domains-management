#include "DomainsMenu.hpp"

DomainsMenu::DomainsMenu(int height, int width, int y, int x)
{
    this->win = newwin(height, width, y, x);
    this->height = height;
    this->width = width;
    this->y = y;
    this->x = x;
    getmaxyx(this->win, yMax, xMax);
    getbegyx(this->win, yBeg, xBeg);
    this->start = 0;
    this->highlight = 0;
	keypad(this->win, TRUE);
	this->popup = newwin(height, width, y, x);
	this->selected_tab = 0;
	this->domains = Domain::get_domains_from_database();
	this->registrar = Registrar::get_registrar_from_database();
	this->nservers = Nservers::get_nservers_from_database();
	// just for test
	// for (int i = 0;i < 100;i++)
	// {
	// 	Domain dm("kirwa_test->|" + to_string(i) + "|");
	// 	domains.push_back(dm);
	// }
}

// getters
WINDOW * DomainsMenu::get_win(void) { return win; }
int DomainsMenu::get_xMax(void) { return xMax; }
int DomainsMenu::get_yMax(void) { return yMax; }
int DomainsMenu::get_highlight(void) { return highlight; }
int DomainsMenu::get_xBeg(void) { return xBeg; }
int DomainsMenu::get_yBeg(void) { return yBeg; }
int DomainsMenu::get_width(void) { return width; }
int DomainsMenu::get_height(void) { return height; }
int DomainsMenu::get_x(void) { return x; }
int DomainsMenu::get_y(void) { return y; }
int DomainsMenu::get_start(void) { return start; }

// setters
void DomainsMenu::set_highlight(int highlight) { this->highlight = highlight; }
void DomainsMenu::set_start(int start) { this->start = start; }
void DomainsMenu::set_stdscr_xMax(int stdscr_xMax) { this->stdscr_xMax = stdscr_xMax; }
void DomainsMenu::set_stdscr_yMax(int stdscr_yMax) { this->stdscr_yMax = stdscr_yMax; }

// other function
void    DomainsMenu::erase() { werase(this->win); }

void    DomainsMenu::refresh() { wrefresh(this->win); }

void	DomainsMenu::top_tabs()
{
	string	tabs[TABS_NUMBER] = {"Domains", "Registries", "Persons", "Servers"};
	int		start = 9;

	for (int i = 0;i < TABS_NUMBER;i++)
	{
		if(this->selected_tab == i)
		{
			wattron(this->win, A_REVERSE);
			// dots string for selected tab
			string	dots_string(tabs[i].length(), '.');
			mvwprintw(this->win, 2, start, put_string_in_center(dots_string	, TAB_LENGTH, ' ').c_str());
		}
		mvwprintw(this->win, 1, start, put_string_in_center(tabs[i], TAB_LENGTH, ' ').c_str());
		wattroff(this->win, A_REVERSE);
		start += TAB_LENGTH;
	}
}

void	DomainsMenu::fields_name_bar(string fields[], int table_size, int start)
{
	for (int i = 0;i < table_size;i++)
	{
		if(i == 1)
			start -= 1;
		mvwprintw(this->win, 3, start + 1, fields[i].c_str());
		start += fields[i].length() + 2;;
	}
}

void	DomainsMenu::draw_domains_tab_content()
{
	int		i;
	string	fields[FIELDS_NAME_NUMBER] = {	" M ", "Name------------", "Registry--", "Expiration",
										"Cost", "ns0---------", "ns1---------", "Owner--------------"};

	// remove the M charactere in the first case of fields table in case we have domains above scroll
	if (this->highlight < DOMAIN_PER_WIN)
		fields[0] = "   ";


	this->fields_name_bar(fields, FIELDS_NAME_NUMBER);
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->domains.size(); i++)
	{
		string	all_info = "";
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(i + 1), 3, ' ');
		all_info += " " + put_string_in_left(this->domains[i].get_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_registrar(), 10, ' ');
		all_info += "  " + put_string_in_right(this->domains[i].get_expire().substr(0, 10), 10, ' ');
		stringstream temp_str_stream;
		temp_str_stream << fixed << setprecision(2) << this->domains[i].get_cost_per_year();
		all_info += "  " + put_string_in_right(temp_str_stream.str(), 4, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_names_servers()[0], 12, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_names_servers()[1], 12, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_admin(), 19, ' ');
		mvwprintw(this->win, i - this->start + 4, 1, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	DomainsMenu::draw_registries_tab_content()
{
	int		i;
	string	fields[3] = {	" id ", "name------------", "url------------------------"};

	this->fields_name_bar(fields, 3, 4);
	// registries data here
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->registrar.size(); i++)
	{
		string	all_info = "";
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(this->registrar[i].get_id()), 3, ' ');
		all_info += "  " + put_string_in_left(this->registrar[i].get_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->registrar[i].get_url(), 27, ' ');
		mvwprintw(this->win, i - this->start + 4, 5, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	DomainsMenu::draw_persons_tab_content()
{
	int		i;
	string	fields[7] = {	" id ", "name------------", "first name------", "last name-------", "email-----------", "phone-----------"};

	this->fields_name_bar(fields, 7);
	// persons data here
}

void	DomainsMenu::draw_servers_tab_content()
{
	int		i;
	string	fields[5] = { " id ", "name------", "ip-------------", "port-", "nickname"};

	this->fields_name_bar(fields, 5, 4);
	// servers data here
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->nservers.size(); i++)
	{
		string	all_info = "";
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(this->nservers[i].get_id()), 3, ' ');
		all_info += "  " + put_string_in_left(this->nservers[i].get_host(), 10, ' ');
		all_info += "  " + put_string_in_left(this->nservers[i].get_ip(), 15, ' ');
		all_info += "  " + put_string_in_left(to_string(this->nservers[i].get_port()), 5, ' ');
		all_info += "  " + put_string_in_left(this->nservers[i].get_usr(), 8, ' ');
		mvwprintw(this->win, i - this->start + 4, 5, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	DomainsMenu::bottom_bar()
{
	int		index = 4;
	string	vertical_line = " V " + put_string_in_right("", 96, '-');

	if (this->domains.size() < this->start + DOMAIN_PER_WIN)
		vertical_line[1] = ' ';
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 0, vertical_line.c_str());
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 66, "I");
	mvwprintw(this->win, DOMAIN_PER_WIN + index, 66, "I");
	mvwprintw(this->win, DOMAIN_PER_WIN + index, 68, "f: ALL      s:ALL");
	idm_command_index = DOMAIN_PER_WIN + index;
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 1, "idm> ");
	// mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 66, "I");
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 66, "I");
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 1, "-  -  -  -  -  -  -  -  -  -  -  -  -  -  -   -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -");
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 1, "filters");
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 1, "t-TLD  a:ALL  c:com  o:org  n:net  i:io  m:mx  or  spell");
	mvwprintw(this->win, DOMAIN_PER_WIN + (index++), 1, "s-size ## max characters");
	wmove(this->win, idm_command_index, 6);
}

void	DomainsMenu::press_t_to_select_filter_tld_bar()
{
	char	filter[10];
	string	chosen_tld;

	this->domains.clear();
	this->highlight = 0;
	mvwprintw(this->win, idm_command_index, 6, "t  f>");
	wmove(this->win, idm_command_index, 11);
	wgetstr(this->win, filter);
	chosen_tld = static_cast<string>(filter);
	if (chosen_tld == "a")
		this->domains = Domain::get_domains_from_database();
	else if (chosen_tld == "c")
		this->domains = Domain::get_dot_tld_domains_from_database("com");
	else if (chosen_tld == "o")
		this->domains = Domain::get_dot_tld_domains_from_database("org");
	else if (chosen_tld == "n")
		this->domains = Domain::get_dot_tld_domains_from_database("net");
	else if (chosen_tld == "i")
		this->domains = Domain::get_dot_tld_domains_from_database("io");
	else if (chosen_tld == "m")
		this->domains = Domain::get_dot_tld_domains_from_database("mx");
	else
		this->domains = Domain::get_dot_tld_domains_from_database(chosen_tld);
}


void	DomainsMenu::press_s_to_select_filter_size_bar()
{
	char	filter[10];
	string	chosen_size_str;

	this->domains.clear();
	this->highlight = 0;
	mvwprintw(this->win, idm_command_index, 6, "s #>");
	wmove(this->win, idm_command_index, 10);
	wgetstr(this->win, filter);
	chosen_size_str = static_cast<string>(filter);
	int	selected_size_int = stoi(chosen_size_str);
	this->domains = Domain::get_domains_where_equal_or_less_that_specfied_size_from_database(selected_size_int);
}


void    DomainsMenu::draw()
{
	this->erase();
	this->top_tabs();
	if(this->selected_tab == 0)
	{
		this->draw_domains_tab_content();
		this->bottom_bar();
	}
	else if (this->selected_tab == 1)
		this->draw_registries_tab_content();
	else if(this->selected_tab == 2)
		this->draw_persons_tab_content();
	else
		this->draw_servers_tab_content();
}

void    DomainsMenu::press_up_arrow()
{
    if (this->highlight >= 1 && this->highlight > start)
		this->highlight -= 1;
	else if (this->highlight >= 1 && this->highlight == start)
	{
		this->highlight -= 1;
		this->start -= 1;
	}
}

void    DomainsMenu::press_down_arrow()
{
    // if (this->highlight < this->start + DOMAIN_PER_WIN - 1 AND this->highlight < this->domains.size() - 1)
	// 	this->highlight += 1;
	if (this->highlight < this->start + DOMAIN_PER_WIN - 1 AND this->highlight < this->domains.size() - 1)
		this->highlight += 1;
	else if (this->highlight < this->domains.size() - 1)
	{
		this->highlight += 1;
		this->start += 1;
	}
}
void    DomainsMenu::press_left_arrow()
{
	this->erase();
	this->start -= DOMAIN_PER_WIN;
	if (this->start < 0)
		this->start = 0;
	this->highlight = this->start;
}

void    DomainsMenu::press_right_arrow()
{
	this->erase();
	if (start + DOMAIN_PER_WIN < this->domains.size())
		start += DOMAIN_PER_WIN;
	this->highlight = this->start;
}

void    DomainsMenu::press_enter()
{
	int		i;
	vector<pair<string, string>>	attributes_and_values;
	vector<pair<string, string>>::iterator	itr;
	stringstream temp_stream;

	attributes_and_values.push_back(pair<string, string>("Domain name  : ", this->domains[highlight].get_name()));
	attributes_and_values.push_back(pair<string, string>("name server 1: ", this->domains[highlight].get_names_servers()[0]));
	attributes_and_values.push_back(pair<string, string>("name server 2: ", this->domains[highlight].get_names_servers()[1]));
	attributes_and_values.push_back(pair<string, string>("name server 3: ", this->domains[highlight].get_names_servers()[2]));
	attributes_and_values.push_back(pair<string, string>("name server 4: ", this->domains[highlight].get_names_servers()[3]));
	attributes_and_values.push_back(pair<string, string>("admin        : ", this->domains[highlight].get_admin()));
	attributes_and_values.push_back(pair<string, string>("tech         : ", this->domains[highlight].get_tech()));
	attributes_and_values.push_back(pair<string, string>("registrar    : ", this->domains[highlight].get_registrar()));
	attributes_and_values.push_back(pair<string, string>("whois        : ", this->domains[highlight].get_whois()));
	attributes_and_values.push_back(pair<string, string>("url          : ", this->domains[highlight].get_url()));
	temp_stream << fixed << setprecision(2) << this->domains[highlight].get_sale_price();
	attributes_and_values.push_back(pair<string, string>("sale price   : ", temp_stream.str()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Domains details:");
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
	// need to update the domains info here
	if (stoi(index_str) == 1)
		this->domains[highlight].update_domain_attribute_in_database("name", new_value_str);
	else if (stoi(index_str) == 2)
		this->domains[highlight].update_domain_attribute_in_database("ns1", new_value_str);
	else if (stoi(index_str) == 3)
		this->domains[highlight].update_domain_attribute_in_database("ns2", new_value_str);
	else if (stoi(index_str) == 4)
		this->domains[highlight].update_domain_attribute_in_database("ns3", new_value_str);
	else if (stoi(index_str) == 5)
		this->domains[highlight].update_domain_attribute_in_database("ns4", new_value_str);
	else if (stoi(index_str) == 6)
		this->domains[highlight].update_domain_attribute_in_database("adminp", new_value_str);
	else if (stoi(index_str) == 7)
		this->domains[highlight].update_domain_attribute_in_database("techp", new_value_str);
	else if (stoi(index_str) == 8)
		this->domains[highlight].update_domain_attribute_in_database("registrar", new_value_str);
	else if (stoi(index_str) == 9)
		this->domains[highlight].update_domain_attribute_in_database("whois", new_value_str);
	else if (stoi(index_str) == 10)
		this->domains[highlight].update_domain_attribute_in_database("url", new_value_str);
	else if (stoi(index_str) == 11)
		this->domains[highlight].update_domain_attribute_in_database("sale_price", new_value_str);
	this->domains.clear();
	this->domains = Domain::get_domains_from_database();
}

void    DomainsMenu::press_esc()
{
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
}

bool	DomainsMenu::get_pressed_key(int select_domain)
{
	switch (select_domain)
	{
		case KEY_UP:
				this->press_up_arrow(); break;
		case KEY_DOWN:
				this->press_down_arrow(); break;
		case KEY_RIGHT:
			this->press_right_arrow(); break;
		case KEY_LEFT:
			this->press_left_arrow(); break;
		case KEY_DC:
			this->press_delete_domain(); break;
		case 'Q':
		case 'q':
			return true;
		case 'd':
		case 'D':
			this->selected_tab = 0; break;
		case 't':
		case 'T':
			this->press_t_to_select_filter_tld_bar(); break;
		case 's':
		case 'S':
			this->press_s_to_select_filter_size_bar(); break;
		case 'r':
		case 'R':
			this->selected_tab = 1; break;
		case 'p':
		case 'P':
			this->selected_tab = 2; break;
		case 'x':
		case 'X':
			this->selected_tab = 3; break;
		case PRESS_ENTER:
			this->press_enter(); break;
		case 'a':
		case 'A':
			this->press_add_domain(); break;
		case PRESS_ESC:
			this->press_esc(); break;
		default:
			break;
	}
	return false;
}

void    DomainsMenu::press_delete_domain()
{
	int		is_confirm;
	string	confirmation_message;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	confirmation_message = "Are you sure you want to delete the domain \"" + domains[highlight].get_name() + "\" [y/Y] : ";
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, (width / 2) - (confirmation_message.length() / 2), confirmation_message.c_str());
	is_confirm = wgetch(popup);

	if(is_confirm == 'y' OR is_confirm == 'Y')
	{
		g_stmt->execute("DELETE FROM domains WHERE name = '" + domains[highlight].get_name() + "'");
		domains.erase(domains.begin() + highlight);
		highlight -= 1;
		if (highlight < 0)
			highlight = 0;
	}
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	this->erase();
	this->refresh();
}

void    DomainsMenu::press_edit_domain()
{
	// we use array of 254 because the maximun length of domain name is 253 and we add 1 case for '\0'
	char	new_domain_name[254];

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Edit Domain :");
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, (width / 2) - 13, "Put the name domain name : ");
	wgetstr(popup, new_domain_name);
	g_stmt->executeUpdate("UPDATE domains set name='" + string(new_domain_name) + "' WHERE name='" + domains[highlight].get_name()+ "';");
	domains[highlight].set_name(string(new_domain_name));
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	this->erase();
	this->refresh();
}

void    DomainsMenu::press_add_domain()
{
	string				attributes_name[10] = {
												"Please type the Domain name  : ",
												"Please type the name server 1: ",
												"Please type the name server 2: ",
												"Please type the name server 3: ",
												"Please type the name server 4: ",
												"Please type the admin        : ",
												"Please type the tech         : ",
												"Please type the registrar    : ",
												"Please type the whois        : ",
												"Please type the url          : "
												};

	DomainFuncPointer	attributes_set_function[10] = {
												&Domain::set_name,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_name_server,
												&Domain::set_admin,
												&Domain::set_tech,
												&Domain::set_registrar,
												&Domain::set_whois,
												&Domain::set_url
												};
	Domain *tmp_domain = new Domain("");

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Add Domain:");

	char attribute_value[255];
	string attribute_value_str;

	for (int i = 0; i < 10;i++)
	{
		mvwprintw(popup, i + 1, 1, (put_string_in_right(to_string(i + 1), 2, ' ') + " - " + attributes_name[i]).c_str());
		wgetstr(popup, attribute_value);
		attribute_value_str = static_cast<string>(attribute_value);
		(tmp_domain->*(attributes_set_function[i]))(attribute_value);
	}
	Domain::add_domain_to_database(*tmp_domain);

	this->domains.clear();
	this->domains = Domain::get_domains_from_database();
	delete tmp_domain;
}

DomainsMenu::~DomainsMenu()
{
    delwin(this->win);
	delwin(this->popup);
}
