#include "Domain.hpp"
#include "DomainsMenu.hpp"


int main(void)
{
    try {
        sql::Driver *driver;
        sql::Connection *con;
        sql::Statement *stmt = NULL;
        vector<Domain> domains;
        vector<Domain> domains_from_database;
        int xMax, yMax, select_domain;
        bool    quit_loop = false;
        WINDOW *    bottom_menu_bar = NULL;
        // char choice = '\0';


        /* Create a connection */
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        /* Connect to the MySQL domains database */
        con->setSchema("domains");
        /* create statement to get and update data in database */
        stmt = con->createStatement();
        // check if the user want to add domains from directory
        // cout << BOLDYELLOW << "If you want to add domains to database press [y/Y] : " << RESET;
        // cin >> choice;
        // if (choice == 'y' OR choice == 'Y')
        // {
            // domains = Domain::get_domains_names_from_directory();
            // Domain::add_domains_to_database(domains, stmt);
        // }
        // initialize the screen
        initscr();
        // dont print charactere when you click it
        noecho();
        // start using colors
        start_color();
        if(!has_colors())
        {
            cout << BOLDRED << "You Terminal Dont support ncurses colors" << RESET << endl;
            endwin();
            delete stmt;
            delete con;
            return (-1);
        }
        // make a color pair
        init_pair(1, COLOR_BLACK, COLOR_WHITE);
	    getmaxyx(stdscr, yMax, xMax);

        domains_from_database = Domain::get_domains_from_database(stmt);
        DomainsMenu	menu_for_domains(DOMAIN_PER_WIN + 2, xMax - 12, 2, 6, domains_from_database);
        menu_for_domains.set_stdscr_xMax(xMax);
        menu_for_domains.set_stdscr_yMax(yMax);

        draw_bottom_bar_menu(bottom_menu_bar, yMax, xMax);

        // WINDOW *	popup = newwin(12, xMax, (0 % DOMAIN_PER_WIN) + 3, 1);
        while (!quit_loop)
        {
            menu_for_domains.draw();
            select_domain = wgetch(menu_for_domains.get_win());
            quit_loop = menu_for_domains.get_pressed_key(select_domain, stmt);
        }
        delwin(bottom_menu_bar);
        endwin();
        cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
        delete stmt;
        delete con;
    }
    catch (sql::SQLException &e) {
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }

    cout << endl;

    return EXIT_SUCCESS;
}
