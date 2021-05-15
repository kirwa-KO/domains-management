#include "Domain.hpp"

int main(void)
{
	vector<string> domains_names_from_database;
	int hightlight = 0;
	int select_domain;
	bool quit_loop = false;

	domains_names_from_database.push_back("accrounds.com");
	domains_names_from_database.push_back("aviacom.net");
	domains_names_from_database.push_back("bitmark.cc");
	domains_names_from_database.push_back("bitmark.co");
	domains_names_from_database.push_back("bitmark.guru");
	domains_names_from_database.push_back("bitmark.io");
	domains_names_from_database.push_back("bitmark.mx");
	domains_names_from_database.push_back("bitmark.one");
	domains_names_from_database.push_back("bitmarktalk.org");
	domains_names_from_database.push_back("bitsticker.com");
	domains_names_from_database.push_back("bitvex.com");
	domains_names_from_database.push_back("bitvex.net");
	domains_names_from_database.push_back("ecomoneda.money");
	domains_names_from_database.push_back("ecomoneda.shop");
	domains_names_from_database.push_back("modelrobotics.info");
	domains_names_from_database.push_back("notariodigital.pro");
	domains_names_from_database.push_back("znm.biz");

	initscr();
	noecho();

	int height = domains_names_from_database.size() + 2;
	int xMax, yMax;
	getmaxyx(stdscr, yMax, xMax);
	WINDOW *win_for_domains = newwin(height, xMax - 12, 2, 6);
	WINDOW *bottom_menu_bar = newwin(3, 90, yMax - 3, 20);
	mvwprintw(bottom_menu_bar, 1, 1, "|UP| => Prev |DOWN| => Next |E/e| => Edit |D/d| => Delete |ENTER| => All |Q/q| => Quit");
	box(bottom_menu_bar, 0, 0);
	box(win_for_domains, 0, 0);
	refresh();
	wrefresh(bottom_menu_bar);
	// wrefresh(win_for_domains);
	keypad(win_for_domains, TRUE);
	while (!quit_loop)
	{
		for (int i = 0; i < domains_names_from_database.size(); i++)
		{
			mvwprintw(win_for_domains, i + 1, 1, " * ");
			if (i == hightlight)
				wattron(win_for_domains, A_REVERSE);
			mvwprintw(win_for_domains, i + 1, 4, domains_names_from_database[i].c_str());
			wattroff(win_for_domains, A_REVERSE);
		}
		select_domain = wgetch(win_for_domains);
		switch (select_domain)
		{
			case KEY_UP:
				if (hightlight >= 1)
					hightlight -= 1;
				break;
			case KEY_DOWN:
				if (hightlight < domains_names_from_database.size() - 1)
					hightlight += 1;
				break;
			case 'Q':
			case 'q':
				quit_loop = true;
				break;
			case PRESS_ENTER:
				werase(win_for_domains);
				wrefresh(win_for_domains);
				break;
			default:
				break;
		}
	}
	delwin(bottom_menu_bar);
	delwin(win_for_domains);
	endwin();
	cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
	return (0);
}