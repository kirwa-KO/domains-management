#include "DomainsMenu.hpp"

DomainsMenu::DomainsMenu(int height, int width, int y, int x, vector<Domain> domains)
{
    this->win = newwin(height, width, y, x);
    this->height = height;
    this->width = width;
    this->y = y;
    this->x = x;
	for (size_t i = 0;i < domains.size();i++)
		this->domains.push_back(domains[i]);
    getmaxyx(this->win, yMax, xMax);
    getbegyx(this->win, yBeg, xBeg);
    this->start = 0;
    this->highlight = 0;
	keypad(this->win, TRUE);
	this->popup = newwin(DOMAIN_INFO_LENGTH + 2, width, yMax + 2, x);;
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
void    DomainsMenu::draw()
{
    int     i;

    this->domains_size = domains.size();
    box(this->win, 0, 0);
	for (i = this->start; i < this->start + DOMAIN_PER_WIN && i < this->domains_size; i++)
	{
		mvwprintw(this->win, i - this->start + 1, 1, " * ");
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		mvwprintw(this->win, i - this->start + 1, 4, " %-*s", this->stdscr_xMax - 18, this->domains[i].get_name().c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void    DomainsMenu::press_up_arrow()
{
    if (this->highlight >= 1 && this->highlight > start)
		this->highlight -= 1;
}

void    DomainsMenu::press_down_arrow()
{
    if (this->highlight < this->start + DOMAIN_PER_WIN - 1 && this->highlight < domains_size - 1)
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
	if (start + DOMAIN_PER_WIN < domains_size)
		start += DOMAIN_PER_WIN;
	this->highlight = this->start;
}

void    DomainsMenu::press_enter()
{
	wbkgd(popup, COLOR_PAIR(1));
	box(popup, 0, 0);
	werase(popup);
	mvwprintw(popup, 0, 1, "Domains details:");
	mvwprintw(popup, 1, 1, ("Domain name  : " + this->domains[highlight].get_name()).c_str());
	mvwprintw(popup, 2, 1, ("name server 1: " + this->domains[highlight].get_names_servers()[0]).c_str());
	mvwprintw(popup, 3, 1, ("name server 2: " + this->domains[highlight].get_names_servers()[1]).c_str());
	mvwprintw(popup, 4, 1, ("name server 3: " + this->domains[highlight].get_names_servers()[2]).c_str());
	mvwprintw(popup, 5, 1, ("name server 4: " + this->domains[highlight].get_names_servers()[3]).c_str());
	mvwprintw(popup, 6, 1, ("admin        : " + this->domains[highlight].get_admin()).c_str());
	mvwprintw(popup, 6, 1, ("tech         : " + this->domains[highlight].get_tech()).c_str());
	mvwprintw(popup, 7, 1, ("registrar    : " + this->domains[highlight].get_registrar()).c_str());
	mvwprintw(popup, 8, 1, ("whois        : " + this->domains[highlight].get_whois()).c_str());
	mvwprintw(popup, 9, 1, ("url          : " + this->domains[highlight].get_url()).c_str());
	wrefresh(stdscr);
	wrefresh(popup);
}

void    DomainsMenu::press_esc()
{
	wbkgd(popup, A_NORMAL);
	werase(popup);
	wrefresh(popup);
}

bool	DomainsMenu::get_pressed_key(int select_domain, sql::Statement * stmt)
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
		case 'Q':
		case 'q':
			return true;
		case 'd':
		case 'D':
			this->press_delete_domain(stmt); break;
		case 'e':
		case 'E':
			this->press_edit_domain(stmt); break;
		case PRESS_ENTER:
			this->press_enter(); break;
		case PRESS_ESC:
			this->press_esc(); break;				
		default:
			break;
	}
	return false;
}

void    DomainsMenu::press_delete_domain(sql::Statement * stmt)
{
	int		is_confirm;

	werase(popup);
	wbkgd(popup, COLOR_PAIR(1));
	mvwprintw(popup, 0, 1, "Delete Confirmation :");
	mvwprintw(popup, (DOMAIN_INFO_LENGTH + 2) / 2, (width / 2) - 26, "Are you sure you want to delete the domain [y/Y] : ");
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

void    DomainsMenu::press_edit_domain(sql::Statement * stmt)
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