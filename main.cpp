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

        // Create a connection
        // driver = get_driver_instance();
        // con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        // // Connect to the MySQL domains database
        // con->setSchema("domains");
        // // create statement to get and update data in database
        // stmt = con->createStatement();
    
        initscr();
        if(!has_colors())
        {
            cout << BOLDRED << "You Terminal Dont support ncurses colors" << RESET << endl;
            endwin();
            delete stmt;
            delete con;
            return (-1);
        }
        start_color();
        // make a color pair
        init_pair(1, COLOR_BLACK, COLOR_WHITE);

        getmaxyx(stdscr, yMax, xMax);
        draw_numbers_in_screen_corners(yMax, xMax);
        // domains_from_database = Domain::get_domains_from_database(stmt);
        DomainsMenu	menu_for_domains(DOMAIN_PER_WIN + 2, xMax - 12, 2, 2, domains_from_database);
        menu_for_domains.set_stdscr_xMax(xMax);
        menu_for_domains.set_stdscr_yMax(yMax);
        refresh();
        while (!quit_loop)
        {
            menu_for_domains.draw();
            select_domain = wgetch(menu_for_domains.get_win());
            quit_loop = menu_for_domains.get_pressed_key(select_domain, stmt);
        }
        // delwin(bottom_menu_bar);
        endwin();
        cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
        // delete stmt;
        // delete con;
    }
    catch (sql::SQLException &e) {
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
        return EXIT_FAILURE;
    }


    return EXIT_SUCCESS;
}
