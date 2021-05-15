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
void    DomainsMenu::draw(vector<string> domains)
{
    int     i;

    this->domains_size = domains.size();
    box(this->win, 0, 0);
	for (i = this->start; i < this->start + DOMAIN_PER_WIN; i++)
	{
		mvwprintw(this->win, i - this->start + 1, 1, " * ");
		if (i == this->highlight)
			wattron(this->win, A_REVERSE);
		mvwprintw(this->win, i - this->start + 1, 4, " %-*s", this->stdscr_xMax - 18, domains[i].c_str());
		wattroff(this->win, A_REVERSE);
	}
}

void    DomainsMenu::press_up_arrow()
{
    if (this->highlight >= 1)
		this->highlight -= 1;
}

void    DomainsMenu::press_down_arrow()
{
    if (this->highlight < this->start + DOMAIN_PER_WIN - 1)
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
	start += DOMAIN_PER_WIN;
	if (this->start + DOMAIN_PER_WIN >= domains_size)
		this->start = domains_size - DOMAIN_PER_WIN;
	this->highlight = this->start;
}

void    DomainsMenu::press_enter()
{
	this->erase();
	this->refresh();
}

DomainsMenu::~DomainsMenu()
{
    delwin(this->win);
}