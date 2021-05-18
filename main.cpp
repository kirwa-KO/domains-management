#include "Domain.hpp"
#include "DomainsMenu.hpp"


string				Domain::selected_domain_tld = "%";
int					Domain::selected_domain_size = 255;

int main(void)
{
    try {
        sql::Driver *driver;
        sql::Connection *con;
        sql::Statement *stmt = NULL;
        vector<Domain> domains;
        // vector<Domain> domains_from_database;
        int xMax, yMax, select_domain;
        char choice = '\0';
        bool    quit_loop = false;

        // Create a connection
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        // Connect to the MySQL domains database
        con->setSchema("domains");
        // create statement to get and update data in database
        stmt = con->createStatement();
    
        // check if the user want to add domains from directory
        // cout << BOLDYELLOW << "If you want to add domains to database press [y/Y] : " << RESET;
        // cin >> choice;
        // if (choice == 'y' OR choice == 'Y')
        // {
        //     domains = Domain::get_domains_names_from_directory();
        //     Domain::add_domains_to_database(domains, stmt);
        // }

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
        // draw_numbers_in_screen_corners(yMax, xMax);
        DomainsMenu	menu_for_domains(yMax - 2, xMax - 2, 0, 0, stmt);
        menu_for_domains.set_stdscr_xMax(xMax);
        menu_for_domains.set_stdscr_yMax(yMax);
        refresh();
        while (!quit_loop)
        {
            menu_for_domains.draw();
            select_domain = wgetch(menu_for_domains.get_win());
            quit_loop = menu_for_domains.get_pressed_key(select_domain);
        }
        endwin();
        cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
        delete stmt;
        delete con;

        // vector<Domain> domains;
        // domains = Domain::get_domains_names_from_directory();
        // for (auto x: domains)
        // {
        //     x.display_domain_info();
        // }

    }
    catch (sql::SQLException &e) {
        endwin();
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
        return EXIT_FAILURE;
    }
    catch (std::exception &e) {
        endwin();
        cout << "# ERR: in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
