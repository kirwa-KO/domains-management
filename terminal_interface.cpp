#include "Domain.hpp"
#include "DomainsMenu.hpp"

int main(void)
{
	vector<string> domains_names_from_database;
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

	int xMax, yMax;
	getmaxyx(stdscr, yMax, xMax);

	DomainsMenu	menu_for_domains(DOMAIN_PER_WIN + 2, xMax - 12, 2, 6);
	menu_for_domains.set_stdscr_xMax(xMax);
	menu_for_domains.set_stdscr_yMax(yMax);

	WINDOW *bottom_menu_bar = newwin(5, 58, yMax - 6, (xMax - 58) / 2);
	mvwprintw(bottom_menu_bar, 1, 1, "|UP|   => Prev      |DOWN|  => Next      |Q/q|   => Quit");
	mvwprintw(bottom_menu_bar, 2, 1, "|E/e|  => Edit      |D/d|   => Delete    |ENTER| => All");
	mvwprintw(bottom_menu_bar, 3, 1, "        |LEFT| => Prev Side |RIGHT| => Next Side");
	box(bottom_menu_bar, 0, 0);
	refresh();
	wrefresh(bottom_menu_bar);

	while (!quit_loop)
	{
		menu_for_domains.draw(domains_names_from_database);
		select_domain = wgetch(menu_for_domains.get_win());
		switch (select_domain)
		{
			case KEY_UP:
				menu_for_domains.press_up_arrow();
				break;
			case KEY_DOWN:
				menu_for_domains.press_down_arrow();
				break;
			case KEY_RIGHT:
				menu_for_domains.press_right_arrow();
				break;
			case KEY_LEFT:
				menu_for_domains.press_left_arrow();
				break;
			case 'Q':
			case 'q':
				quit_loop = true;
				break;
			case PRESS_ENTER:
				menu_for_domains.press_enter();
				break;
			default:
				break;
		}
	}
	delwin(bottom_menu_bar);
	// delwin(win_for_domains);
	endwin();
	cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
	return (0);
}