#include "MenuAndContent.hpp"

MenuAndContent::MenuAndContent(int height, int width, int y, int x)
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
	this->registrars = Registrar::get_registrars_from_database();
	this->nservers = Nservers::get_nservers_from_database();
	this->persons = Person::get_persons_from_database();
}

// getters
WINDOW *	MenuAndContent::get_win(void) { return win; }
int			MenuAndContent::get_xMax(void) { return xMax; }
int			MenuAndContent::get_yMax(void) { return yMax; }
int			MenuAndContent::get_highlight(void) { return highlight; }
int			MenuAndContent::get_xBeg(void) { return xBeg; }
int			MenuAndContent::get_yBeg(void) { return yBeg; }
int			MenuAndContent::get_width(void) { return width; }
int			MenuAndContent::get_height(void) { return height; }
int			MenuAndContent::get_x(void) { return x; }
int			MenuAndContent::get_y(void) { return y; }
int			MenuAndContent::get_start(void) { return start; }

// setters
void MenuAndContent::set_highlight(int highlight) { this->highlight = highlight; }
void MenuAndContent::set_start(int start) { this->start = start; }
void MenuAndContent::set_stdscr_xMax(int stdscr_xMax) { this->stdscr_xMax = stdscr_xMax; }
void MenuAndContent::set_stdscr_yMax(int stdscr_yMax) { this->stdscr_yMax = stdscr_yMax; }

// other function
void    MenuAndContent::erase() { werase(this->win); }

void    MenuAndContent::refresh() { wrefresh(this->win); }

void	MenuAndContent::top_tabs()
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

void	MenuAndContent::fields_name_bar(string fields[], int table_size, int start)
{
	for (int i = 0;i < table_size;i++)
	{
		if(i == 1)
			start -= 1;
		mvwprintw(this->win, 3, start + 1, fields[i].c_str());
		start += fields[i].length() + 2;;
	}
}

void	MenuAndContent::draw_domains_tab_content()
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

void	MenuAndContent::draw_registries_tab_content()
{
	int		i;
	string	fields[3] = {	" id ", "name------------", "url------------------------"};

	this->fields_name_bar(fields, 3, 4);
	// registries data here
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->registrars.size(); i++)
	{
		string	all_info = "";
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(this->registrars[i].get_id()), 3, ' ');
		all_info += "  " + put_string_in_left(this->registrars[i].get_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->registrars[i].get_url(), 27, ' ');
		mvwprintw(this->win, i - this->start + 4, 5, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	MenuAndContent::draw_persons_tab_content()
{
	int		i;
	string	fields[7] = {	" id ", "name------------", "first name------", "last name-------", "email-----------", "phone-----------"};

	this->fields_name_bar(fields, 7, 4);
	// persons data here
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->persons.size(); i++)
	{
		string	all_info = "";
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(this->persons[i].get_id()), 3, ' ');
		all_info += "  " + put_string_in_left(this->persons[i].get_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->persons[i].get_first_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->persons[i].get_last_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->persons[i].get_email(), 16, ' ');
		all_info += "  " + put_string_in_left(this->persons[i].get_phone(), 16, ' ');
		mvwprintw(this->win, i - this->start + 4, 5, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	MenuAndContent::draw_servers_tab_content()
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

void	MenuAndContent::bottom_bar()
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

void	MenuAndContent::press_t_to_select_filter_tld_bar()
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


void	MenuAndContent::press_s_to_select_filter_size_bar()
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

void    MenuAndContent::draw()
{
	this->erase();
	this->top_tabs();
	if(this->selected_tab == 0)
		this->draw_domains_tab_content();
	else if (this->selected_tab == 1)
		this->draw_registries_tab_content();
	else if(this->selected_tab == 2)
		this->draw_persons_tab_content();
	else
		this->draw_servers_tab_content();
	this->bottom_bar();
}

void    MenuAndContent::press_up_arrow()
{
    if (this->highlight >= 1 && this->highlight > start)
		this->highlight -= 1;
	else if (this->highlight >= 1 && this->highlight == start)
	{
		this->highlight -= 1;
		this->start -= 1;
	}
}

void    MenuAndContent::press_down_arrow()
{
	if (this->highlight < this->start + DOMAIN_PER_WIN - 1 AND this->highlight < this->domains.size() - 1)
		this->highlight += 1;
	else if (this->highlight < this->domains.size() - 1)
	{
		this->highlight += 1;
		this->start += 1;
	}
}
void    MenuAndContent::press_left_arrow()
{
	this->erase();
	this->start -= DOMAIN_PER_WIN;
	if (this->start < 0)
		this->start = 0;
	this->highlight = this->start;
}

void    MenuAndContent::press_right_arrow()
{
	this->erase();
	if (start + DOMAIN_PER_WIN < this->domains.size())
		start += DOMAIN_PER_WIN;
	this->highlight = this->start;
}

void    MenuAndContent::press_esc()
{
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
}

bool	MenuAndContent::get_pressed_key(int select_domain)
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
			if (this->selected_tab == 0)
				Domain::press_delete_domain(win, popup, domains, highlight);
			else if (this->selected_tab == 1)
				Registrar::press_delete_registrar(win, popup, registrars, highlight);
			else if (this->selected_tab == 2)
				Person::press_delete_person(win, popup, persons, highlight);
			break;
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
			if (this->selected_tab == 0)
				Domain::press_enter(popup, domains, highlight);
			else if (this->selected_tab == 1)
				Registrar::press_enter(popup, registrars, highlight);
			else if (this->selected_tab == 2)
				Person::press_enter(popup, persons, highlight);
			break;
		case 'a':
		case 'A':
			if (this->selected_tab == 0)
				Domain::press_add_domain(popup, domains);
			else if (this->selected_tab == 1)
				Registrar::press_add_registrar(popup, registrars);
			else if (this->selected_tab == 2)
				Person::press_add_person(popup, persons);
			break;
		case PRESS_ESC:
			this->press_esc(); break;
		default:
			break;
	}
	return false;
}

MenuAndContent::~MenuAndContent()
{
    delwin(this->win);
	delwin(this->popup);
}