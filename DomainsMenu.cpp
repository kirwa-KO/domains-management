#include "DomainsMenu.hpp"

DomainsMenu::DomainsMenu(int height, int width, int y, int x, sql::Statement *stmt)
{
    this->win = newwin(height, width, y, x);
    this->height = height;
    this->width = width;
    this->y = y;
    this->x = x;
	// for (size_t i = 0;i < domains.size();i++)
	// 	this->domains.push_back(domains[i]);
	this->stmt = stmt;
	this->domains = Domain::get_domains_from_database(stmt);
    getmaxyx(this->win, yMax, xMax);
    getbegyx(this->win, yBeg, xBeg);
    this->start = 0;
    this->highlight = 0;
	keypad(this->win, TRUE);
	// this->popup = newwin(DOMAIN_INFO_LENGTH + 2, width, yMax + 2, x);
	this->popup = newwin(height, width, y, x);
	this->selected_tab = 0;
	this->selected_attribute_for_edit = 0;
	this->is_in_edit_mode = false;
}

// getters
WINDOW * DomainsMenu::get_win(void) {return win;}
int DomainsMenu::get_xMax(void) {return xMax;}
int DomainsMenu::get_yMax(void) {return yMax;}
int DomainsMenu::get_highlight(void) {return highlight;}
int DomainsMenu::get_xBeg(void) {return xBeg;}
int DomainsMenu::get_yBeg(void) {return yBeg;}
int DomainsMenu::get_width(void) {return width;}
int DomainsMenu::get_height(void) {return height;}
int DomainsMenu::get_x(void) {return x;}
int DomainsMenu::get_y(void) {return y;}
int DomainsMenu::get_start(void) {return start;}

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

void	DomainsMenu::fields_name_bar()
{
	int		start = 0;
	string	fields[FIELDS_NAME_NUMBER] = {	" M ", "Name------------", "Registry--", "Expiration",
											"Cost", "ns0---------", "ns1---------", "Owner--------------"};
	for (int i = 0;i < FIELDS_NAME_NUMBER;i++)
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
	this->fields_name_bar();
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->domains.size(); i++)
	{
		string	all_info = "", temp;
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		all_info += put_string_in_right(to_string(i + 1), 3, ' ');
		all_info += " " + put_string_in_left(this->domains[i].get_name(), 16, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_registrar(), 10, ' ');
		temp = to_string(this->domains[i].get_expire());
		all_info += "  " + put_string_in_right(temp.substr(0, temp.find_last_of('.') + 3), 10, ' ');
		temp = to_string(this->domains[i].get_cost_per_year());
		all_info += "  " + put_string_in_right(temp.substr(0, temp.find_last_of('.') + 3), 4, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_names_servers()[0], 12, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_names_servers()[1], 12, ' ');
		all_info += "  " + put_string_in_left(this->domains[i].get_admin(), 19, ' ');
		mvwprintw(this->win, i - this->start + 4, 1, all_info.c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void	DomainsMenu::bottom_bar()
{
	int		index = 4;
	string	vertical_line = " V " + put_string_in_right("", 96, '-');

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

void	DomainsMenu::press_t_to_select_filter_bar()
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
		this->domains = Domain::get_domains_from_database(stmt);
	else if (chosen_tld == "c")
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, "com");
	else if (chosen_tld == "o")
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, "org");
	else if (chosen_tld == "n")
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, "net");
	else if (chosen_tld == "i")
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, "io");
	else if (chosen_tld == "m")
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, "mx");
	else
		this->domains = Domain::get_dot_tld_domains_from_database(stmt, chosen_tld);
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
}

void    DomainsMenu::press_up_arrow()
{
    if (this->highlight >= 1 && this->highlight > start)
		this->highlight -= 1;
}

void    DomainsMenu::press_down_arrow()
{
    if (this->highlight < this->start + DOMAIN_PER_WIN - 1 AND this->highlight < this->domains.size() - 1)
		this->highlight += 1;
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
	map<string, string>	attributes_and_values;
	map<string, string>::iterator	itr;

	attributes_and_values.insert(pair<string, string>("Domain name  : ", this->domains[highlight].get_name()));
	attributes_and_values.insert(pair<string, string>("name server 1: ", this->domains[highlight].get_names_servers()[0]));
	attributes_and_values.insert(pair<string, string>("name server 2: ", this->domains[highlight].get_names_servers()[1]));
	attributes_and_values.insert(pair<string, string>("name server 3: ", this->domains[highlight].get_names_servers()[2]));
	attributes_and_values.insert(pair<string, string>("name server 4: ", this->domains[highlight].get_names_servers()[3]));
	attributes_and_values.insert(pair<string, string>("admin        : ", this->domains[highlight].get_admin()));
	attributes_and_values.insert(pair<string, string>("tech         : ", this->domains[highlight].get_tech()));
	attributes_and_values.insert(pair<string, string>("registrar    : ", this->domains[highlight].get_registrar()));
	attributes_and_values.insert(pair<string, string>("whois        : ", this->domains[highlight].get_whois()));
	attributes_and_values.insert(pair<string, string>("url          : ", this->domains[highlight].get_url()));

	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Domains details:");
	for (itr = attributes_and_values.begin(), i = 0;itr != attributes_and_values.end();itr++, i++)
	{
		if (i == selected_attribute_for_edit)
			wattron(popup, A_REVERSE);
		mvwprintw(popup, i + 1, 1, (itr->first + itr->second).c_str());
		wattroff(popup, A_REVERSE);
	}
	wmove(popup, selected_attribute_for_edit + 1, 0);
	int yy = wgetch(popup);
	if(yy == KEY_UP)
	{
		endwin();
		cout << "kirwa-KO" << endl;
		exit(-1);
	}
	this->is_in_edit_mode = false;
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
			// if (this->is_in_edit_mode)
			// {
			// 	if(this->selected_attribute_for_edit > 0)
			// 		this->selected_attribute_for_edit -= 1;
			// 	this->press_enter();
			// }
			// else
				this->press_up_arrow(); break;
		case KEY_DOWN:
			// if (this->is_in_edit_mode)
			// {
			// 	this->selected_attribute_for_edit += 1;
			// 	this->press_enter();
			// }
			// else
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
			// this->press_delete_domain(stmt); break;
		case 't':
		case 'T':
			this->press_t_to_select_filter_bar(); break;
		case 'r':
		case 'R':
			this->selected_tab = 1; break;
		case 'p':
		case 'P':
			this->selected_tab = 2; break;
		case 's':
		case 'S':
			this->selected_tab = 3; break;
		// case 'e':
		// case 'E':
			// this->press_edit_domain(); break;
		case PRESS_ENTER:
			this->is_in_edit_mode = true;
			this->press_enter(); break;
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
		stmt->execute("DELETE FROM domains WHERE name = '" + domains[highlight].get_name() + "'");
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
	stmt->executeUpdate("UPDATE domains set name='" + string(new_domain_name) + "' WHERE name='" + domains[highlight].get_name()+ "';");
	domains[highlight].set_name(string(new_domain_name));
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
	this->erase();
	this->refresh();
}

DomainsMenu::~DomainsMenu()
{
    delwin(this->win);
	delwin(this->popup);
}